library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
	port (
		pc_in: in std_logic_vector(5 downto 0);
		enable, clock, reset: in std_logic;
		pc_out: out std_logic_vector(5 downto 0)
	);
end entity program_counter;

architecture bhv of program_counter is
	signal pc_reg: std_logic_vector(5 downto 0) := (others => '0');
begin
	pc_out <= pc_reg;
  
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			pc_reg <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then 
			pc_reg <= pc_in;
		end if;
	end process clock_proc;
end architecture bhv;
