library IEEE;
use IEEE.std_logic_1164.all;

entity flag is
	port (
		clock, enable, reset: in std_logic;
		c_in, z_in: in std_logic;
		modify_c, modify_z: in std_logic;
		c_out, z_out: out std_logic
	);
end entity flag;

architecture bhv of flag is
	signal c, z: std_logic;
begin
	c_out <= c;
	z_out <= z;

	clock_proc: process(clock, enable, reset) 
	begin
		if (reset = '1') then
			c <= '0';
			z <= '0';
		elsif (clock'event and clock = '1' and enable = '1') then
			if (modify_c = '1') then
				c <= c_in;
			end if;
			
			if (modify_z = '1') then
				z <= z_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
