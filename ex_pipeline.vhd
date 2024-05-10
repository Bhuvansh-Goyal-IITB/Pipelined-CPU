library IEEE;
use IEEE.std_logic_1164.all;

entity ex_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		ex_in: in std_logic_vector(13 downto 0);
		ex_out: out std_logic_vector(13 downto 0)
	);
end entity ex_pipeline;

-- alu_control --> add (0) or nand (1) | with carry | compliment
-- input_control --> leftmost bit 0 -> imm6 1 -> imm9, next 2 bits 00 -> a+b, 01 --> pc+imm, 10 --> b+imm, 11 --> a+imm
-- ex --> leftmost 2 bits alu_out (00) pc+1 (01) lli (10), next 3 bits alu_control, next 2 bits condition bits, next 3 bits input_control, next 3 bits branch_control, next bit modify_flag


architecture bhv of ex_pipeline is
	signal ex: std_logic_vector(13 downto 0);
begin	
	ex_out <= ex;
	
	clock_proc: process(clock, enable, reset, flush)
	begin
		if (reset = '1') then
			ex <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then 
				ex <= (others => '0');
			else 
				ex <= ex_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
