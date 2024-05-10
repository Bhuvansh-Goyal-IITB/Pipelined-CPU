library IEEE;
use IEEE.std_logic_1164.all;

entity comparator is
	generic (n: integer := 3);
	port (
		a, b: in std_logic_vector(n-1 downto 0);
		output: out std_logic
	);
end entity comparator;

architecture bhv of comparator is
begin
	output_proc: process(a, b)
	begin
		if (a = b) then 
			output <= '1';
		else 
			output <= '0';
		end if;
	end process output_proc;
end architecture bhv;