library IEEE;
use IEEE.std_logic_1164.all;

entity read_hazard is
	port (
		is_read_a, is_read_b: in std_logic;
		wb_ex: in std_logic_vector(4 downto 0);
		reg_a_address, reg_b_address: in std_logic_vector(2 downto 0);
		hazard_out: out std_logic
	);
end entity read_hazard;

architecture bhv of read_hazard is
	signal comp_a_out, comp_b_out: std_logic;
begin
	comp_a: entity work.comparator port map (
		wb_ex(3 downto 1), reg_a_address,
		comp_a_out
	);
	
	comp_b: entity work.comparator port map (
		wb_ex(3 downto 1), reg_b_address,
		comp_b_out
	);
	
	hazard_out <= wb_ex(4) and wb_ex(0) and ((is_read_a and comp_a_out) or (is_read_b and comp_b_out));
end architecture bhv;