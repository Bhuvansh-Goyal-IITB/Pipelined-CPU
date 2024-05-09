library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
	port (
		clock, enable, reset: in std_logic;
		debug_rf_address: in std_logic_vector(2 downto 0);
		reg_a_address, reg_b_address, write_reg_address: in std_logic_vector(2 downto 0);
		write_data: in std_logic_vector(15 downto 0);
		debug_rf_data: out std_logic_vector(15 downto 0);
		reg_a_data, reg_b_data: out std_logic_vector(15 downto 0)
	);
end entity register_file;

architecture bhv of register_file is
	type reg_array is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal registers: reg_array := (others => x"0000");
begin
	debug_rf_data <= registers(to_integer(unsigned(debug_rf_address)));
	reg_a_data <= registers(to_integer(unsigned(reg_a_address)));
	reg_b_data <= registers(to_integer(unsigned(reg_b_address)));

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			registers <= (others => x"0000");
		elsif (clock'event and clock = '1' and enable = '1') then
			registers(to_integer(unsigned(write_reg_address))) <= write_data;
		end if;
	end process clock_proc;
end architecture bhv;
