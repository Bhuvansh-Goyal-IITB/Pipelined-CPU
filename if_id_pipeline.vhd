library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_pipeline is
	port (
		clock, enable, reset: in std_logic;
		pc_in, pc_update_in: in std_logic_vector(15 downto 0);
		instruction_in: in std_logic_vector(15 downto 0);
		pc_out, pc_update_out: out std_logic_vector(15 downto 0);
		instruction_out: out std_logic_vector(15 downto 0)
	);
end entity if_id_pipeline;

architecture bhv of if_id_pipeline is
	signal is_empty: std_logic;
begin
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			is_empty <= '1';
		elsif (clock'event and clock = '1' and enable = '1') then
			is_empty <= '0';
			instruction_out <= instruction_in;
			pc_out <= pc_in;
			pc_update_out <= pc_update_in;
		end if;
	end process clock_proc;
end architecture bhv;
