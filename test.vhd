library IEEE;
use IEEE.std_logic_1164.all;

entity test is
end entity test;

architecture bhv of test is
	signal input: std_logic_vector(7 downto 0);
	signal output: std_logic_vector(2 downto 0);
begin
	input <= "10100101", "00110011" after 10 ns;
	
	dut: entity work.forwarding port map (
		input, output
	);
end architecture bhv;