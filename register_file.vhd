library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
	port (
		clock, enable, reset: in std_logic;
		read_a_in, read_b_in, write_reg_in: in std_logic_vector(2 downto 0);
		write_data_in: in std_logic_vector(15 downto 0);
		out_data_a, out_data_b: out std_logic_vector(15 downto 0)
	);
end entity register_file;

architecture bhv of register_file is
	type reg_array is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal registers: reg_array := (others => x"0000");
begin
	out_data_a <= registers(to_integer(unsigned(read_a_in)));
	out_data_b <= registers(to_integer(unsigned(read_b_in)));

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			registers <= (others => x"0000");
		elsif (clock'event and clock = '1' and enable = '1') then
			registers(to_integer(unsigned(write_reg_in))) <= write_data_in;
		end if;
	end process clock_proc;
end architecture bhv;
