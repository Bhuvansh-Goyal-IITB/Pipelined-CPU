library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		pc_in: in std_logic_vector(15 downto 0);
		instruction_in: in std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0);
		instruction_out: out std_logic_vector(15 downto 0)
	);
end entity if_id_pipeline;

architecture bhv of if_id_pipeline is
	signal instruction: std_logic_vector(15 downto 0);
	signal pc: std_logic_vector(15 downto 0);
begin
	instruction_out <= instruction;
	pc_out <= pc;
	
	clock_proc: process(clock, enable, reset, flush)
	begin
		if (reset = '1') then
			instruction <= x"E000";
			pc <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then
				instruction <= x"E000";
				pc <= (others => '0');
			else 
				instruction <= instruction_in;
				pc <= pc_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
