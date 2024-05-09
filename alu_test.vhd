library IEEE;
use IEEE.std_logic_1164.all;

entity alu_test is
end entity alu_test;

architecture bhv of alu_test is
	signal a, b: std_logic_vector(15 downto 0);
	signal alu_control: std_logic_vector(2 downto 0);
	signal alu_out: std_logic_vector(15 downto 0);
	signal c, z: std_logic;
begin
	a <= x"0034";
	b <= x"0023";
	
	alu_control <= "100";

	dut: entity work.alu port map (
		a, b, 
		alu_control,
		'0',
		alu_out,
		c, z
	);
end architecture bhv;
