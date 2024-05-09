library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
	port (
		clock, reset: in std_logic;
		debug_rf_address: in std_logic_vector(2 downto 0);
		debug_dm_address: in std_logic_vector(5 downto 0);
		debug_rf_data: out std_logic_vector(15 downto 0);
		debug_dm_data: out std_logic_vector(15 downto 0);
		c, z: out std_logic
	);
end entity cpu;

architecture bhv of cpu is
	-- IF stage signals
	signal pc_adder_out_if: std_logic_vector(15 downto 0);
	signal pc_mux_out: std_logic_vector(15 downto 0);
	signal pc_out_if: std_logic_vector(15 downto 0);
	
	signal im_memory_out_if: std_logic_vector(15 downto 0);
	
	-- ID stage signals
	signal im_memory_out_id: std_logic_vector(15 downto 0);
	signal pc_out_id: std_logic_vector(15 downto 0);
	
	signal read_a_id, read_b_id: std_logic_vector(2 downto 0);
	signal imm6_id: std_logic_vector(5 downto 0);
	signal imm9_id: std_logic_vector(8 downto 0);
	
	signal wb_id: std_logic_vector(4 downto 0);
	signal mem_id: std_logic;
	signal ex_id: std_logic_vector(13 downto 0);
	
	-- RR stage signals
	signal is_load: std_logic;
	signal read_hazard_out: std_logic;
	
	signal forward_a_out_rr, forward_b_out_rr: std_logic_vector(15 downto 0);
	
	signal read_a_rr, read_b_rr: std_logic_vector(2 downto 0);
	signal imm6_rr: std_logic_vector(5 downto 0);
	signal imm9_rr: std_logic_vector(8 downto 0);
	
	signal reg_a_rr, reg_b_rr: std_logic_vector(15 downto 0);
	signal se6_rr, se9_rr, lli_rr: std_logic_vector(15 downto 0);
	
	signal pc_out_rr: std_logic_vector(15 downto 0);
	
	signal wb_rr: std_logic_vector(4 downto 0);
	signal mem_rr: std_logic;
	signal ex_rr: std_logic_vector(13 downto 0);
	
	-- EX signals
	signal wb_ex: std_logic_vector(4 downto 0);
	signal mem_ex: std_logic;
	signal ex_ex: std_logic_vector(13 downto 0);
	
	signal reg_a_ex, reg_b_ex: std_logic_vector(15 downto 0);
	signal se6_ex, se9_ex, lli_ex: std_logic_vector(15 downto 0);
	
	signal pc_out_ex: std_logic_vector(15 downto 0);
	signal pc_update_out_ex: std_logic_vector(15 downto 0);
	
	signal imm_mux_out_ex: std_logic_vector(15 downto 0);
	
	signal alu_c_out, alu_z_out: std_logic;
	signal flag_c_out, flag_z_out: std_logic;
	
	signal alu_out: std_logic_vector(15 downto 0);
	signal alu_a_in, alu_b_in: std_logic_vector(15 downto 0);
	
	signal modify_c, wb_condition: std_logic;
	
	signal wb_ex_modified: std_logic_vector(4 downto 0);
	
	signal branch_address_mux: std_logic;
	
	signal branch_taken: std_logic;
	signal branch_address: std_logic_vector(15 downto 0);
	
	signal dm_address_ex: std_logic_vector(15 downto 0);
	
	-- MEM signals
	signal wb_mem: std_logic_vector(4 downto 0);
	signal mem_mem: std_logic;
	signal dm_address_mem: std_logic_vector(15 downto 0);
	
	signal reg_a_mem: std_logic_vector(15 downto 0);
	
	signal dm_data_mem: std_logic_vector(15 downto 0);
	
	-- WB signals 
	signal wb_wb: std_logic_vector(4 downto 0);
	signal wb_data: std_logic_vector(15 downto 0);
	
	signal dm_data_wb, dm_address_wb: std_logic_vector(15 downto 0);
	
begin
	-- IF stage
	pc_mux: entity work.mux_2x1 port map (
		branch_taken,
		pc_adder_out_if, branch_address,
		pc_mux_out
	);

	pc_block: entity work.program_counter port map (
		clock, not read_hazard_out, reset,
		pc_mux_out,
		pc_out_if
	);
	
	pc_adder_block: entity work.adder port map (
		pc_out_if, x"0001",
		'0',
		pc_adder_out_if
	);
	
	im_memory_block: entity work.im_memory port map (
		pc_out_if(5 downto 0),
		im_memory_out_if
	);
	
	-- IF-ID pipeline block
	
	if_id_pipeline_block: entity work.if_id_pipeline port map (
		clock, not read_hazard_out, reset, branch_taken,
		pc_out_if, 
		im_memory_out_if,
		pc_out_id,
		im_memory_out_id
	);
	
	-- ID stage
	
	decode_block: entity work.decode port map (
		im_memory_out_id,
		read_a_id, read_b_id, 
		imm6_id,
		imm9_id
	);
	
	control_block: entity work.control port map (
		im_memory_out_id,
		wb_id,
		mem_id,
		ex_id
	);
	
	-- ID-RR pipeline block
	
	id_rr_pipeline_block: entity work.id_rr_pipeline port map (
		clock, not read_hazard_out, reset, branch_taken,
		wb_id,
		wb_rr,
		mem_id,
		mem_rr,
		ex_id,
		ex_rr,
		read_a_id, read_b_id,
		imm6_id,
		imm9_id,
		read_a_rr, read_b_rr,
		imm6_rr,
		imm9_rr,
		pc_out_id,
		pc_out_rr
	);
	
	-- RR stage
	
	register_file_block: entity work.register_file port map (
		clock, wb_wb(0), reset,
		debug_rf_address,
		read_a_rr, read_b_rr,
		wb_wb(3 downto 1),
		wb_data,
		debug_rf_data,
		reg_a_rr, reg_b_rr
	);
	
	lli_block: entity work.lli port map (
		imm9_rr,
		lli_rr
	);
	
	se6_block: entity work.se6 port map (
		imm6_rr,
		se6_rr
	);
	
	se9_block: entity work.se9 port map (
		imm9_rr,
		se9_rr
	);
	
	forwarding_block: entity work.forwarding port map (
		wb_ex(0), wb_mem(0), wb_wb(0),
		wb_ex(3 downto 1), wb_mem(3 downto 1), wb_wb(3 downto 1),
		not wb_ex(4), wb_mem(4),
		dm_address_ex, dm_data_mem, dm_address_mem, wb_data,
		read_a_rr, read_b_rr,
		reg_a_rr, reg_b_rr,
		forward_a_out_rr, forward_b_out_rr
	);
	
	-- RR-EX pipeline block
	
	rr_ex_pipeline_block: entity work.rr_ex_pipeline port map (
		clock, '1', reset, read_hazard_out,
		wb_rr,
		wb_ex,
		mem_rr,
		mem_ex,
		ex_rr,
		ex_ex,
		forward_a_out_rr, forward_b_out_rr, se6_rr, se9_rr, lli_rr, pc_out_rr,
		reg_a_ex, reg_b_ex, se6_ex, se9_ex, lli_ex, pc_out_ex
	);
	
	is_load <= wb_ex(0) and wb_ex(4);
	
	read_hazard_block: entity work.read_hazard port map (
		is_load,
		wb_ex(3 downto 1),
		read_a_rr, read_b_rr, 
		read_hazard_out
	);
	
	-- EX stage
	
	imm_mux_block: entity work.mux_2x1 port map (
		ex_ex(6),
		se6_ex, se9_ex,
		imm_mux_out_ex
	);
	
	pc_adder_ex_block: entity work.adder port map (
		pc_out_ex, x"0001",
		'0',
		pc_update_out_ex
	);
	
	modify_c <= (not ex_ex(11)) and ex_ex(0);
	
	flag_block: entity work.flag port map (
		clock, '1', reset,
		alu_c_out, alu_z_out,
		modify_c, ex_ex(0),
		flag_c_out, flag_z_out
	);
	
	c <= flag_c_out;
	z <= flag_z_out;
	
	wb_condition <= (ex_ex(8) and flag_c_out) or (ex_ex(7) and flag_z_out);
	
	wb_ex_mux_block: entity work.mux_2x1
	generic map (5)
	port map (
		wb_condition,
		wb_ex, "00000",
		wb_ex_modified
	);
	
	input_selector_block: entity work.input_selector port map (
		reg_a_ex, reg_b_ex, pc_out_ex, imm_mux_out_ex,
		ex_ex(5 downto 4),
		alu_a_in, alu_b_in
	);
	
	alu_block: entity work.alu port map (
		alu_a_in, alu_b_in, 
		ex_ex(11 downto	9),
		flag_c_out, 
		alu_out, 
		alu_c_out, alu_z_out
	);
	
	branch_decider_block: entity work.branch_decider port map (
		reg_a_ex, reg_b_ex, 
		ex_ex(3 downto 1),
		branch_address_mux,
		branch_taken
	);
	
	branch_address_mux_block: entity work.mux_2x1 port map (
		branch_address_mux,
		alu_out, reg_b_ex,
		branch_address
	);
	
	dm_address_mux_block: entity work.mux_4x1 port map (
		ex_ex(13 downto 12),
		alu_out, pc_update_out_ex, lli_ex, x"0000",
		dm_address_ex
	);
	
	-- EX-MEM pipeline block
	
	ex_mem_pipeline_block: entity work.ex_mem_pipeline port map (
		clock, '1', reset, '0',
		wb_ex_modified, 
		wb_mem,
		mem_ex,
		mem_mem,
		reg_a_ex,
		dm_address_ex,
		reg_a_mem,
		dm_address_mem
	);
	
	-- MEM stage
	
	dm_memory_block: entity work.dm_memory port map (
		clock, mem_mem, reset,
		debug_dm_address,
		dm_address_mem(5 downto 0),
		reg_a_mem,
		debug_dm_data,
		dm_data_mem
	);
	
	-- MEM-WB pipeline block
	
	mem_wb_pipeline_block: entity work.mem_wb_pipeline port map (
		clock, '1', reset, '0', 
		wb_mem, 
		wb_wb,
		dm_data_mem,dm_address_mem, 
		dm_data_wb,dm_address_wb
	);
	
	-- WB stage
	
	wb_mux_block: entity work.mux_2x1 port map (
		wb_wb(4),
		dm_address_wb, dm_data_wb,
		wb_data
	);
	
end architecture bhv;
	