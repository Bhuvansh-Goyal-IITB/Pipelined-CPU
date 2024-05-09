library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dm_memory is
	port (
		clock, enable, reset: in std_logic;
		debug_dm_address: in std_logic_vector(5 downto 0);
		address: in std_logic_vector(5 downto 0);
		write_data: in std_logic_vector(15 downto 0);
		debug_dm_data: out std_logic_vector(15 downto 0);
		read_data: out std_logic_vector(15 downto 0)
	);
end entity dm_memory;

architecture bhv of dm_memory is
	type reg_array is array(63 downto 0) of std_logic_vector(15 downto 0);
	signal mem_array: reg_array := (others => x"0000");
begin
	read_data <= mem_array(to_integer(unsigned(address)));
	debug_dm_data <= mem_array(to_integer(unsigned(debug_dm_address)));
	
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			mem_array <= (others => x"0000");
		elsif (clock'event and clock = '1' and enable = '1') then 
			mem_array(to_integer(unsigned(address))) <= write_data; 
		end if;
	end process clock_proc;
end architecture bhv;
