library IEEE;
use IEEE.std_logic_1164.all;

entity wb_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		wb_in: in std_logic_vector(4 downto 0);
		wb_out: out std_logic_vector(4 downto 0)
	);
end entity wb_pipeline;

-- wb_control --> alu_out (0), mem_dest (1)
-- wb --> leftmost bit => wb_control, next 3 bits wb_dest, next bit is_wb

architecture bhv of wb_pipeline is
	signal wb: std_logic_vector(4 downto 0);
begin
	flush_proc: process(flush, wb) 
	begin
		if (flush = '1') then
			wb_out <= (others => '0');
		else 
			wb_out <= wb;
		end if;
	end process flush_proc;

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			wb <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			wb <= wb_in;
		end if;
	end process clock_proc;
end architecture bhv;
