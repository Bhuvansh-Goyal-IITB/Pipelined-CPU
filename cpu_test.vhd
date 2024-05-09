library IEEE;
use IEEE.std_logic_1164.all;

entity cpu_test is
end entity cpu_test;

architecture bhv of cpu_test is
	signal clock, reset: std_logic := '1';
	signal debug_rf_address: std_logic_vector(2 downto 0);
	signal debug_dm_address: std_logic_vector(5 downto 0);
	signal debug_dm_data: std_logic_vector(15 downto 0);
	signal debug_rf_data: std_logic_vector(15 downto 0);
	signal test_output: std_logic_vector(13 downto 0);
	signal c, z: std_logic;
begin
	clock <= not clock after 10 ns;
	reset <= '1', '0' after 100 ns;

	debug_rf_address <= "000";
	debug_dm_address <= "000000";
	
	dut: entity work.cpu port map (
		clock, reset,
		debug_rf_address,
		debug_dm_address,
		debug_rf_data,
		debug_dm_data,
		test_output,
		c, z
	);
end architecture bhv;
