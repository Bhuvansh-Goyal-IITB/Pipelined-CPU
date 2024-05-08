library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1 is
	generic (
		n: integer := 16
	);
	port (
		s: in std_logic;
		input_0, input_1: in std_logic_vector(n - 1 downto 0);
		output: out std_logic_vector(n - 1 downto 0)
	);
end entity mux_2x1;

architecture bhv of mux_2x1 is
begin
	mux_process: process(s, input_0, input_1)
	begin
		if (s = '0') then
			output <= input_0;
		else 
			output <= input_1;
		end if;
	end process mux_process;
end architecture bhv;
