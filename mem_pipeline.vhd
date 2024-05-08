library IEEE;
use IEEE.std_logic_1164.all;

entity mem_pipeline is
	port (
		clock, enable, reset: in std_logic;
		is_mem_store_in: in std_logic;
		is_mem_store_out: out std_logic
	);
end entity mem_pipeline;

architecture bhv of mem_pipeline is
begin
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			is_mem_store_out <= '0';
		elsif (clock'event and clock = '1' and enable = '1') then
			is_mem_store_out <= is_mem_store_in;
		end if;
	end process clock_proc;
end architecture bhv;
