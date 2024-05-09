library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity im_memory is
	port (
		address_in: in std_logic_vector(5 downto 0);
		data_out: out std_logic_vector(15 downto 0)
	);
end entity im_memory;

architecture bhv of im_memory is
	type reg_array is array(63 downto 0) of std_logic_vector(15 downto 0);
	signal mem_array: reg_array := 
	(
	0 => "0011001001000101",
	1 => "0011010110100100",
	2 => x"E000",
	3 => x"E000",
	4 => x"E000",
	5 => "0001010001000000",
	others => x"E000");
begin
	data_out <= mem_array(to_integer(unsigned(address_in)));
end architecture bhv;