library IEEE;
use IEEE.std_logic_1164.all;

entity id_rr_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		
		wb_in: in std_logic_vector(5 downto 0);
		wb_out: out std_logic_vector(5 downto 0);
		
		is_mem_store_in: in std_logic;
		is_mem_store_out: out std_logic;
		
		ex_in: in std_logic_vector(11 downto 0);
		ex_out: out std_logic_vector(11 downto 0);
		
		read_a_in, read_b_in: in std_logic_vector(2 downto 0);
		imm6_in: in std_logic_vector(5 downto 0);
		imm9_in: in std_logic_vector(8 downto 0);
		
		read_a_out, read_b_out: out std_logic_vector(2 downto 0);
		imm6_out: out std_logic_vector(5 downto 0);
		imm9_out: out std_logic_vector(8 downto 0);
		
		pc_in, pc_update_in: in std_logic_vector(5 downto 0);
		pc_out, pc_update_out: out std_logic_vector(5 downto 0)
	);
end entity id_rr_pipeline;

architecture bhv of id_rr_pipeline is
	signal read_a, read_b: std_logic_vector(2 downto 0);
	signal imm6: std_logic_vector(5 downto 0);
	signal imm9: std_logic_vector(8 downto 0);
	signal pc, pc_update: std_logic_vector(5 downto 0);
begin
	wb_block: entity work.wb_pipeline 
		port map (
			clock, enable, reset, flush,
			wb_in,
			wb_out
		);
	
	mem_block: entity work.mem_pipeline 
		port map (
			clock, enable, reset, flush,
			is_mem_store_in,
			is_mem_store_out
		);
	
	ex_block: entity work.ex_pipeline
		port map (
			clock, enable, reset, flush,
			ex_in, 
			ex_out
		);

	flush_proc: process(flush, read_a, read_b, imm6, imm9, pc, pc_update)
	begin
		if (flush = '1') then 
			read_a_out <= (others => '0');
			read_b_out <= (others => '0');
			imm6_out <= (others => '0');
			imm9_out <= (others => '0');
			pc_out <= (others => '0');
			pc_update_out <= (others => '0');
		else 
			read_a_out <= read_a;
			read_b_out <= read_b;
			imm6_out <= imm6;
			imm9_out <= imm9;
			pc_out <= pc;
			pc_update_out <= pc_update;
		end if;
	end process flush_proc;
		
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			read_a <= (others => '0');
			read_b <= (others => '0');
			imm6 <= (others => '0');
			imm9 <= (others => '0');
			pc <= (others => '0');
			pc_update <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			read_a <= read_a_in;
			read_b <= read_b_in;
			imm6 <= imm6_in;
			imm9 <= imm9_in;
			pc <= pc_in;
			pc_update <= pc_update_in;
		end if;
	end process clock_proc;
end architecture bhv;
	