library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
	port (
		clock, reset: in std_logic
	);
end entity cpu;

architecture bhv of cpu is
	-- Branching signals
	signal branch_taken: std_logic;
	signal branch_address: std_logic_vector(15 downto 0);
	
	-- IF stage signals
	signal pc_adder_out_if: std_logic_vector(15 downto 0);
	signal pc_mux_out: std_logic_vector(15 downto 0);
	signal pc_out_if: std_logic_vector(15 downto 0);
	
	signal im_memory_out_if: std_logic_vector(15 downto 0);
	
	-- ID stage signals
	signal is_empty_id: std_logic;
	signal im_memory_out_id: std_logic_vector(15 downto 0);
	signal pc_out_id: std_logic_vector(15 downto 0);
	
	signal read_a_id, read_b_id: std_logic_vector(2 downto 0);
	signal imm6_id: std_logic_vector(5 downto 0);
	signal imm9_id: std_logic_vector(8 downto 0);
begin
	-- IF stage
	pc_mux: entity work.mux_2x1 port map (
		branch_taken,
		pc_adder_out_if, branch_address,
		pc_mux_out
	);

	pc_block: entity work.program_counter port map (
		clock, '1', reset,
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
		clock, '1', reset, branch_taken,
		pc_out_if, 
		im_memory_out_if,
		pc_out_id,
		im_memory_out_id,
		is_empty_id
	);
	
	-- ID stage
	
	decode_block: entity work.decode port map (
		im_memory_out_id,
		read_a_id, read_b_id, 
		imm6_id,
		imm9_id
	);
end architecture bhv;
