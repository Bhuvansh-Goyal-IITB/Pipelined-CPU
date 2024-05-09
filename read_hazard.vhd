library IEEE;
use IEEE.std_logic_1164.all;

entity read_hazard is
	port (
		is_load: in std_logic;
		wb_address: in std_logic_vector(2 downto 0);
		reg_a_address, reg_b_address: in std_logic_vector(2 downto 0);
		hazard_out: out std_logic
	);
end entity read_hazard;

architecture bhv of read_hazard is
begin
	output_proc: process(is_load, wb_address, reg_a_address, reg_b_address)
	begin
		if (is_load = '1' and ((wb_address = reg_a_address) or (wb_address = reg_b_address))) then 
			hazard_out <= '1';
		else 
			hazard_out <= '0';
		end if;
	end process;
end architecture bhv;