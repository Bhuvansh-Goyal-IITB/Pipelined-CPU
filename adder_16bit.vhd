library IEEE;
use IEEE.std_logic_1164.all;

entity adder_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
	 c_in: in std_logic;
    sum: out std_logic_vector(15 downto 0);
	 c_out: out std_logic
  );
end entity adder_16bit;

architecture bhv of adder_16bit is
	component full_adder is
	  port (
		 a, b, c_in: in std_logic;
		 sum, c_out: out std_logic
	  );
	end component full_adder;
	
	signal carry_array: std_logic_vector(14 downto 0);
begin
	fa_0: full_adder port map (a(0), b(0), c_in, sum(0), carry_array(0));
	
	fa_gen: for i in 1 to 14 generate
		fa_i: full_adder port map (a(i), b(i), carry_array(i - 1), sum(i), carry_array(i)); 
	end generate fa_gen;
	
	fa_last: full_adder port map (a(15), b(15), carry_array(14), sum(15), c_out);
end architecture bhv;
