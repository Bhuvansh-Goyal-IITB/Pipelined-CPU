library IEEE;
use IEEE.std_logic_1164.all;

entity ex_mem_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		
		wb_in: in std_logic_vector(4 downto 0);
		wb_out: out std_logic_vector(4 downto 0);
		
		mem_in: in std_logic;
		mem_out: out std_logic;
		
		reg_a_in, dm_address_in: in std_logic_vector(15 downto 0);
		reg_a_out, dm_address_out: out std_logic_vector(15 downto 0)
	);
end entity ex_mem_pipeline;

architecture bhv of ex_mem_pipeline is
	signal reg_a, dm_address: std_logic_vector(15 downto 0);
begin
	wb_block: entity work.wb_pipeline 
		port map (
			clock, enable, reset, flush,
			wb_in,
			wb_out
		);
	
	mem_block: entity work.mem_pipeline 
		port map (
			clock, enable, reset, flush,
			mem_in,
			mem_out
		);

	reg_a_out <= reg_a;
	dm_address_out <= dm_address;
		
	clock_proc: process(clock, enable, reset, flush)
	begin
		if (reset = '1') then
			reg_a <= (others => '0');
			dm_address <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then
				reg_a <= (others => '0');
				dm_address <= (others => '0');
			else 
				reg_a <= reg_a_in;
				dm_address <= dm_address_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
	