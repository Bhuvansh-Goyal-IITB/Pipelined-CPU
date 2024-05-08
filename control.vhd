library IEEE;
use IEEE.std_logic_1164.all;

entity control is
	port (
		instruction_in: in std_logic_vector(15 downto 0);
		is_empty: in std_logic;
		wb_control_out: out std_logic_vector(1 downto 0);
		wb_dest_out: out std_logic_vector(2 downto 0);
		is_wb_out: out std_logic;
		is_mem_store_out: out std_logic;
		alu_control_out: out std_logic_vector(4 downto 0);
		imm_control_out: out std_logic_vector(2 downto 0);
		branch_control_out: out std_logic_vector(2 downto 0)
	);
end entity control;

-- wb_control_out --> alu_out (00), mem_out (01), pc+1 (10), lli (11)
-- alu_control_out --> add (0) or nand (1) | with carry | carry condition | zero condition | compliment

architecture bhv of control is
begin
	control_process: process(instruction_in, is_empty)
	begin
		-- INSTRUCTION IS FLUSHED
		if (is_empty = '1') then
			is_wb_out <= '0';
			is_mem_store_out <= '0';
			branch_control_out <= "000";
		
		-- ADD
		elsif (instruction_in(15 downto 12) = "0001") then
			wb_control_out <= "00";
			wb_dest_out <= instruction_in(5 downto 3);
			is_wb_out <= '1';
			
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
			wb_control_out <= "00";
			wb_dest_out <= instruction_in(5 downto 3);
			is_wb_out <= '1';
			
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
			wb_control_out <= "00";
			wb_dest_out <= instruction_in(8 downto 6);
			is_wb_out <= '1';
			
			is_mem_store_out <= '0';
		
		-- LLI
		elsif (instruction_in(15 downto 12) = "0011") then
			wb_control_out <= "11";
			wb_dest_out <= instruction_in(11 downto 9);
			is_wb_out <= '1';
			
			is_mem_store_out <= '0';
		
		-- LW
		elsif (instruction_in(15 downto 12) = "0100") then
			wb_control_out <= "01";
			wb_dest_out <= instruction_in(11 downto 9);
			is_wb_out <= '1';
			
			is_mem_store_out <= '0';
		
		-- SW
		elsif (instruction_in(15 downto 12) = "0101") then
			is_wb_out <= '0';
			is_mem_store_out <= '1';
		
		-- BEQ
		elsif (instruction_in(15 downto 12) = "1000") then
			is_wb_out <= '0';
			is_mem_store_out <= '0';
			
		-- BLT
		elsif (instruction_in(15 downto 12) = "1001") then
			is_wb_out <= '0';
			is_mem_store_out <= '0';
			
		-- BLE (wrong opcode in handout)
		elsif (instruction_in(15 downto 12) = "1010") then
			is_wb_out <= '0';
			is_mem_store_out <= '0';
			
		-- JAL
		elsif (instruction_in(15 downto 12) = "1100") then
			wb_control_out <= "10";
			wb_dest_out <= instruction_in(11 downto 9);
			is_wb_out <= '1';
			
			is_mem_store_out <= '0';
		
		-- JLR
		elsif (instruction_in(15 downto 12) = "1101") then
			wb_control_out <= "10";
			wb_dest_out <= instruction_in(11 downto 9);
			is_wb_out <= '1';
			
			is_mem_store_out <= '0';
			
		-- JRI
		elsif (instruction_in(15 downto 12) = "1111") then
			is_wb_out <= '0';
			is_mem_store_out <= '0';
		
		end if;
		
		
	end process control_process;
	
end architecture bhv;
