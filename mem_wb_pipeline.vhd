library IEEE;
use IEEE.std_logic_1164.all;

entity mem_wb_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		
		wb_in: in std_logic_vector(4 downto 0);
		wb_out: out std_logic_vector(4 downto 0);
		
		dm_data_in, dm_address_in: in std_logic_vector(15 downto 0);
		dm_data_out, dm_address_out: out std_logic_vector(15 downto 0)
	);
end entity mem_wb_pipeline;

architecture bhv of mem_wb_pipeline is
	signal dm_data, dm_address: std_logic_vector(15 downto 0);
begin
	wb_block: entity work.wb_pipeline 
		port map (
			clock, enable, reset, flush,
			wb_in,
			wb_out
		);
		
	dm_data_out <= dm_data;
	dm_address_out <= dm_address;
		
	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			dm_data <= (others => '0');
			dm_address <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then
				dm_data <= (others => '0');
				dm_address <= (others => '0');
			else 
				dm_data  <= dm_data_in;
				dm_address <= dm_address_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
	