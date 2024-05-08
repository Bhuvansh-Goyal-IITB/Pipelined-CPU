library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
	port (
		data_in: in std_logic_vector(15 downto 0);
		enable, clock, reset: in std_logic;
		data_out: out std_logic_vector(15 downto 0)
	);
end entity program_counter;

architecture bhv of program_counter is
	signal pc_reg: std_logic_vector(15 downto 0) := x"0000";
begin
	data_out <= pc_reg;
  
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			pc_reg <= x"0000";
		elsif (clock'event and clock = '1' and enable = '1') then 
			pc_reg <= data_in;
		end if;
	end process clock_proc;
end architecture bhv;
