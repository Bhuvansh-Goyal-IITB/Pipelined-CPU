library IEEE;
use IEEE.std_logic_1164.all;

entity id_rr_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		
		wb_in: in std_logic_vector(4 downto 0);
		wb_out: out std_logic_vector(4 downto 0);
		
		mem_in: in std_logic;
		mem_out: out std_logic;
		
		ex_in: in std_logic_vector(13 downto 0);
		ex_out: out std_logic_vector(13 downto 0);
		
		is_read_a_in, is_read_b_in: in std_logic;
		is_read_a_out, is_read_b_out: out std_logic;
		
		read_a_in, read_b_in: in std_logic_vector(2 downto 0);
		imm6_in: in std_logic_vector(5 downto 0);
		imm9_in: in std_logic_vector(8 downto 0);
		
		read_a_out, read_b_out: out std_logic_vector(2 downto 0);
		imm6_out: out std_logic_vector(5 downto 0);
		imm9_out: out std_logic_vector(8 downto 0);
		
		pc_in: in std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0)
	);
end entity id_rr_pipeline;

architecture bhv of id_rr_pipeline is
	signal is_read_a, is_read_b: std_logic;
	signal read_a, read_b: std_logic_vector(2 downto 0);
	signal imm6: std_logic_vector(5 downto 0);
	signal imm9: std_logic_vector(8 downto 0);
	signal pc: std_logic_vector(15 downto 0);
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
			mem_in,
			mem_out
		);
	
	ex_block: entity work.ex_pipeline
		port map (
			clock, enable, reset, flush,
			ex_in, 
			ex_out
		);

	read_a_out <= read_a;
	read_b_out <= read_b;
	imm6_out <= imm6;
	imm9_out <= imm9;
	pc_out <= pc;
	is_read_a_out <= is_read_a;
	is_read_b_out <= is_read_b;
		
	clock_proc: process(clock, enable, reset, flush)
	begin
		if (reset = '1') then
			read_a <= (others => '0');
			read_b <= (others => '0');
			imm6 <= (others => '0');
			imm9 <= (others => '0');
			pc <= (others => '0');
			is_read_a <= '0';
			is_read_b <= '0';
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then 
				read_a <= (others => '0');
				read_b <= (others => '0');
				imm6 <= (others => '0');
				imm9 <= (others => '0');
				pc <= (others => '0');
				is_read_a <= '0';
				is_read_b <= '0';
			else 
				read_a <= read_a_in;
				read_b <= read_b_in;
				imm6 <= imm6_in;
				imm9 <= imm9_in;
				pc <= pc_in;
				is_read_a <= is_read_a_in;
				is_read_b <= is_read_b_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
	