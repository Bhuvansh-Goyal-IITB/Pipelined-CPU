library IEEE;
use IEEE.std_logic_1164.all;

entity adder is
	generic (
		n: integer := 16
	);
	port (
	 a, b: in std_logic_vector(n - 1 downto 0);
	 c_in: in std_logic;
	 sum: out std_logic_vector(n - 1 downto 0);
	 c_out: out std_logic
	);
end entity adder;

architecture bhv of adder is	
	signal carry_array: std_logic_vector(n - 2 downto 0);
begin
	fa_0: entity work.full_adder port map (a(0), b(0), c_in, sum(0), carry_array(0));
	
	fa_gen: for i in 1 to n - 2 generate
		fa_i: entity work.full_adder port map (a(i), b(i), carry_array(i - 1), sum(i), carry_array(i)); 
	end generate fa_gen;
	
	fa_last: entity work.full_adder port map (a(n - 1), b(n - 1), carry_array(n - 2), sum(n - 1), c_out);
end architecture bhv;
