library IEEE;
use IEEE.std_logic_1164.all;

entity ex_pipeline is
	port (
		clock, enable, reset: in std_logic;
		alu_control_in: in std_logic_vector(4 downto 0);
		imm_control_in: in std_logic_vector(2 downto 0);
		branch_control_in: in std_logic_vector(2 downto 0);
		alu_control_out: out std_logic_vector(4 downto 0);
		imm_control_out: out std_logic_vector(2 downto 0);
		branch_control_out: out std_logic_vector(2 downto 0)
	);
end entity ex_pipeline;

architecture bhv of ex_pipeline is
begin
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			branch_control_out <= "000";
		elsif (clock'event and clock = '1' and enable = '1') then
			alu_control_out <= alu_control_in;
			imm_control_out <= imm_control_in;
			branch_control_out <= branch_control_in;
		end if;
	end process clock_proc;
end architecture bhv;
