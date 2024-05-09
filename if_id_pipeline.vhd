library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		pc_in: in std_logic_vector(15 downto 0);
		instruction_in: in std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0);
		instruction_out: out std_logic_vector(15 downto 0);
		is_empty_out: out std_logic
	);
end entity if_id_pipeline;

architecture bhv of if_id_pipeline is
	signal instruction: std_logic_vector(15 downto 0);
	signal pc: std_logic_vector(15 downto 0);
	signal is_empty: std_logic;
begin
	flush_proc: process(flush, is_empty, pc, instruction)
	begin 	
		if (flush = '1') then
			is_empty_out <= '1';
			instruction_out <= (others => '0');
			pc_out <= (others => '0');
		else 
			is_empty_out <= '0';
			instruction_out <= instruction;
			pc_out <= pc;
		end if;
	end process flush_proc;

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			is_empty <= '1';
			instruction <= (others => '0');
			pc <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			is_empty <= '0';
			instruction <= instruction_in;
			pc <= pc_in;
		end if;
	end process clock_proc;
end architecture bhv;
