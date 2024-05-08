library IEEE;
use IEEE.std_logic_1164.all;

entity se6 is
	port (
		imm6: in std_logic_vector(5 downto 0);
		se6_out: out std_logic_vector(15 downto 0)
	);
end entity se6;

architecture bhv of se6 is
begin
	se6_out <= "0000000000" & imm6 when (imm6(5) = '0') else "1111111111" & imm6;
end architecture bhv;
