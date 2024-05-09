library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4x1 is
	generic (
		n: integer := 16
	);
	port (
		s: in std_logic_vector(1 downto 0);
		input_0, input_1, input_2, input_3: in std_logic_vector(n - 1 downto 0);
		output: out std_logic_vector(n - 1 downto 0)
	);
end entity mux_4x1;

architecture bhv of mux_4x1 is
begin
	mux_process: process(s, input_0, input_1)
	begin
		if (s = "00") then
			output <= input_0;
		elsif (s = "01") then
			output <= input_1;
		elsif (s = "10") then
			output <= input_2;
		else 
			output <= input_3;
		end if;
	end process mux_process;
end architecture bhv;
