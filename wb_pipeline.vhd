library IEEE;
use IEEE.std_logic_1164.all;

entity wb_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		wb_control_in: in std_logic_vector(1 downto 0);
		wb_dest_in: in std_logic_vector(2 downto 0);
		is_wb_in: in std_logic;
		wb_control_out: out std_logic_vector(1 downto 0);
		wb_dest_out: out std_logic_vector(2 downto 0);
		is_wb_out: out std_logic
	);
end entity wb_pipeline;

architecture bhv of wb_pipeline is
	signal wb_control: std_logic_vector(1 downto 0);
	signal wb_dest: std_logic_vector(2 downto 0);
	signal is_wb: std_logic;
begin
	flush_proc: process(flush, is_wb, wb_dest, wb_control) 
	begin
		if (flush = '1') then
			is_wb_out <= '0';
			wb_control_out <= (others => '0');
			wb_dest_out <= (others => '0');
		else 
			is_wb_out <= is_wb;
			wb_control_out <= wb_control;
			wb_dest_out <= wb_dest;
		end if;
	end process flush_proc;

	clock_proc: process(clock, enable, reset)
	begin
		if (reset = '1') then
			is_wb <= '0';
			wb_control <= (others => '0');
			wb_dest <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			is_wb <= is_wb_in;
			wb_control <= wb_control_in;
			wb_dest <= wb_dest_in;
		end if;
	end process clock_proc;
end architecture bhv;
