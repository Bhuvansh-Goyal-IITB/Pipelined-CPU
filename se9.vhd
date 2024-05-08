library IEEE;
use IEEE.std_logic_1164.all;

entity se9 is
	port (
		imm9: in std_logic_vector(8 downto 0);
		se9_out: out std_logic_vector(15 downto 0)
	);
end entity se9;

architecture bhv of se9 is
begin
	se9_out <= "0000000" & imm9 when (imm9(8) = '0') else "1111111" & imm9; 
end architecture bhv;
