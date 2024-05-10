library IEEE;
use IEEE.std_logic_1164.all;

entity rr_ex_pipeline is
	port (
		clock, enable, reset, flush: in std_logic;
		
		wb_in: in std_logic_vector(4 downto 0);
		wb_out: out std_logic_vector(4 downto 0);
		
		mem_in: in std_logic;
		mem_out: out std_logic;
		
		ex_in: in std_logic_vector(13 downto 0);
		ex_out: out std_logic_vector(13 downto 0);
		
		reg_a_in, reg_b_in, se6_in, se9_in, lli_in, pc_in: in std_logic_vector(15 downto 0);
		reg_a_out, reg_b_out, se6_out, se9_out, lli_out, pc_out: out std_logic_vector(15 downto 0)
	);
end entity rr_ex_pipeline;

architecture bhv of rr_ex_pipeline is
	signal reg_a, reg_b, se6, se9, lli, pc: std_logic_vector(15 downto 0);
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
	
	ex_block: entity work.ex_pipeline
		port map (
			clock, enable, reset, flush,
			ex_in, 
			ex_out
		);
		
	reg_a_out <= reg_a;
	reg_b_out <= reg_b;
	se6_out <= se6;
	se9_out <= se9;
	lli_out <= lli;
	pc_out <= pc;
		
	clock_proc: process(clock, enable, reset, flush)
	begin
		if (reset = '1') then
			reg_a <= (others => '0');
			reg_b <= (others => '0');
			se6 <= (others => '0');
			se9 <= (others => '0');
			lli <= (others => '0');
			pc <= (others => '0');
		elsif (clock'event and clock = '1' and enable = '1') then
			if (flush = '1') then
				reg_a <= (others => '0');
				reg_b <= (others => '0');
				se6 <= (others => '0');
				se9 <= (others => '0');
				lli <= (others => '0');
				pc <= (others => '0');
			else 
				reg_a <= reg_a_in;
				reg_b <= reg_b_in;
				se6 <= se6_in;
				se9 <= se9_in;
				lli <= lli_in;
				pc <= pc_in;
			end if;
		end if;
	end process clock_proc;
end architecture bhv;
	