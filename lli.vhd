library IEEE;
use IEEE.std_logic_1164.all;

entity lli is
	port (
		imm9: in std_logic_vector(8 downto 0);
		lli_out: out std_logic_vector(15 downto 0)
	);
end entity lli;

architecture bhv of lli is
begin
	lli_out <= "0000000" & imm9;
end architecture bhv;
