library IEEE;
use IEEE.std_logic_1164.all;

entity ex_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		ex_in: in std_logic_vector(11 downto 0);
		ex_out: out std_logic_vector(11 downto 0)
	);
end entity ex_pipeline;

-- alu_control --> add (0) or nand (1) | with carry | compliment
-- ex --> leftmost 3 bits alu_control, next 2 bits condition bits, next 3 bits imm_control, next 3 bits branch_control, next bit modify_flag


architecture bhv of ex_pipeline is
	signal ex: std_logic_vector(11 downto 0);
begin	
	flush_proc: process(flush, ex)
	begin
		if (flush = '1') then 
			ex_out <= (others => '0');
		else
			ex_out <= ex;
		end if;
	end process flush_proc;
	
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			ex <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			ex <= ex_in;
		end if;
	end process clock_proc;
end architecture bhv;
