library IEEE;
use IEEE.std_logic_1164.all;

entity mem_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		mem_in: in std_logic;
		mem_out: out std_logic
	);
end entity mem_pipeline;

architecture bhv of mem_pipeline is
	signal mem: std_logic;
begin
	flush_proc: process(flush, mem)
	begin
		if (flush ='1') then
			mem_out <= '0';
		else
			mem_out <= mem;
		end if;
	end process flush_proc;

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			mem <= '0';
		elsif (clock'event and clock = '1' and enable = '1') then
			mem <= mem_in;
		end if;
	end process clock_proc;
end architecture bhv;
