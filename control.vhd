library IEEE;
use IEEE.std_logic_1164.all;

entity control is
	port (
		instruction_in: in std_logic_vector(15 downto 0);
		is_empty: in std_logic;
		wb_out: out std_logic_vector(5 downto 0);
		is_mem_store_out: out std_logic;
		ex_out: out std_logic_vector(11 downto 0)
	);
end entity control;


architecture bhv of control is
begin
	control_process: process(instruction_in, is_empty)
	begin
		-- INSTRUCTION IS FLUSHED
		if (is_empty = '1') then
			wb_out <= (others => '0');
			is_mem_store_out <= '0';
			ex_out <= (others => '0');
		
		-- ADD
		elsif (instruction_in(15 downto 12) = "0001") then
			wb_out <= "00" & instruction_in(5 downto 3) & '1';
			is_mem_store_out <= '0';
			
			if (instruction_in(2) = '0') then
				if (instruction_in(1 downto 0) = "00") then
				elsif (instruction_in(1 downto 0) = "01") then
				elsif (instruction_in(1 downto 0) = "10") then
				else
				end if;
			else 
				if (instruction_in(1 downto 0) = "00") then
				elsif (instruction_in(1 downto 0) = "01") then
				elsif (instruction_in(1 downto 0) = "10") then
				else
				end if;
			end if;
			
		-- NAND
		elsif (instruction_in(15 downto 12) = "0010") then
			wb_out <= "00" & instruction_in(5 downto 3) & '1';
			is_mem_store_out <= '0';
			
			if (instruction_in(2) = '0') then
				if (instruction_in(1 downto 0) = "00") then
				elsif (instruction_in(1 downto 0) = "01") then
				else

				end if;
			else 
				if (instruction_in(1 downto 0) = "00") then
				elsif (instruction_in(1 downto 0) = "01") then
				else
				end if;
			end if;
			
		-- ADI
		elsif (instruction_in(15 downto 12) = "0000") then
			wb_out <= "00" & instruction_in(8 downto 6) & '1';
			is_mem_store_out <= '0';
		
		-- LLI
		elsif (instruction_in(15 downto 12) = "0011") then
			wb_out <= "11" & instruction_in(11 downto 9) & '1';
			is_mem_store_out <= '0';
		
		-- LW
		elsif (instruction_in(15 downto 12) = "0100") then
			wb_out <= "01" & instruction_in(11 downto 9) & '1';
			is_mem_store_out <= '0';
		
		-- SW
		elsif (instruction_in(15 downto 12) = "0101") then
			wb_out <= (others => '0');
			is_mem_store_out <= '1';
		
		-- BEQ
		elsif (instruction_in(15 downto 12) = "1000") then
			wb_out <= (others => '0');
			is_mem_store_out <= '0';
			
		-- BLT
		elsif (instruction_in(15 downto 12) = "1001") then
			wb_out <= (others => '0');
			is_mem_store_out <= '0';
			
		-- BL
		elsif (instruction_in(15 downto 12) = "1010") then
			wb_out <= (others => '0');
			is_mem_store_out <= '0';
			
		-- JAL
		elsif (instruction_in(15 downto 12) = "1100") then
			wb_out <= "10" & instruction_in(11 downto 9) & '1';
			is_mem_store_out <= '0';
		
		-- JLR
		elsif (instruction_in(15 downto 12) = "1101") then
			wb_out <= "10" & instruction_in(11 downto 9) & '1';
			is_mem_store_out <= '0';
			
		-- JRI
		elsif (instruction_in(15 downto 12) = "1111") then
			wb_out <= (others => '0');
			is_mem_store_out <= '0';
		end if;
	end process control_process;
end architecture bhv;
