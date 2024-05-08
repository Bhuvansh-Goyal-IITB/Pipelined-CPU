library IEEE;
use IEEE.std_logic_1164.all;

entity decode is
	port (
		instruction_in: in std_logic_vector(15 downto 0);
		read_a_out, read_b_out: out std_logic_vector(2 downto 0);
		imm6: out std_logic_vector(5 downto 0);
		imm9: out std_logic_vector(8 downto 0)
	);
end entity decode;

architecture bhv of decode is
begin
	read_a_out <= instruction_in(11 downto 9);
	read_b_out <= instruction_in(8 downto 6);
	imm6 <= instruction_in(5 downto 0);
	imm9 <= instruction_in(8 downto 0);
end architecture bhv;
