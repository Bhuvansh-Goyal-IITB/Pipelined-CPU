library IEEE;
use IEEE.std_logic_1164.all;

entity ex_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		alu_control_in: in std_logic_vector(4 downto 0);
		imm_control_in: in std_logic_vector(2 downto 0);
		branch_control_in: in std_logic_vector(2 downto 0);
		alu_control_out: out std_logic_vector(4 downto 0);
		imm_control_out: out std_logic_vector(2 downto 0);
		branch_control_out: out std_logic_vector(2 downto 0)
	);
end entity ex_pipeline;

architecture bhv of ex_pipeline is
	signal alu_control: std_logic_vector(4 downto 0);
	signal imm_control: std_logic_vector(2 downto 0);
	signal branch_control: std_logic_vector(2 downto 0);
begin	
	flush_proc: process(flush, alu_control, imm_control, branch_control)
	begin
		if (flush = '1') then 
			alu_control_out <= (others => '0');
			imm_control_out <= (others => '0');
			branch_control_out <= (others => '0');
		else
			alu_control_out <= alu_control;
			imm_control_out <= imm_control;
			branch_control_out <= branch_control;
		end if;
	end process flush_proc;
	
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			alu_control <= (others => '0');
			imm_control <= (others => '0');
			branch_control <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			alu_control <= alu_control_in;
			imm_control <= imm_control_in;
			branch_control <= branch_control_in;
		end if;
	end process clock_proc;
end architecture bhv;
