library IEEE;
use IEEE.std_logic_1164.all;

entity control is
	port (
		instruction_in: in std_logic_vector(15 downto 0);
		wb_out: out std_logic_vector(4 downto 0);
		mem_out: out std_logic;
		is_read_a, is_read_b: out std_logic;
		ex_out: out std_logic_vector(13 downto 0)
	);
end entity control;


architecture bhv of control is
begin
	control_process: process(instruction_in)
	begin
		-- NO OP
		if (instruction_in(15 downto 12) = "1110") then
			is_read_a <= '0';
			is_read_b <= '0';
			wb_out <= (others => '0');
			mem_out <= '0';
			ex_out <= (others => '0');
		-- ADD
		elsif (instruction_in(15 downto 12) = "0001") then
			wb_out <= '0' & instruction_in(5 downto 3) & '1';
			is_read_a <= '1';
			is_read_b <= '1';
			mem_out <= '0';
			
			if (instruction_in(2) = '0') then
				-- ADA
				if (instruction_in(1 downto 0) = "00") then
					ex_out <= "00000000000001";
				-- ADZ
				elsif (instruction_in(1 downto 0) = "01") then
					ex_out <= "00000010000001";
				-- ADC
				elsif (instruction_in(1 downto 0) = "10") then
					ex_out <= "00000100000001";
				-- AWC
				else
					ex_out <= "00010000000001";
				end if;
			else 
				-- ACA
				if (instruction_in(1 downto 0) = "00") then
					ex_out <= "00001000000001";
				-- ACZ
				elsif (instruction_in(1 downto 0) = "01") then
					ex_out <= "00001010000001";
				-- ACC
				elsif (instruction_in(1 downto 0) = "10") then
					ex_out <= "00001100000001";
				-- ACW
				else
					ex_out <= "00011000000001";
				end if;
			end if;
			
		-- NAND
		elsif (instruction_in(15 downto 12) = "0010") then
			wb_out <= '0' & instruction_in(5 downto 3) & '1';
			is_read_a <= '1';
			is_read_b <= '1';
			mem_out <= '0';
			
			if (instruction_in(2) = '0') then
				-- NDU
				if (instruction_in(1 downto 0) = "00") then
					ex_out <= "00100000000001";
				-- NDZ
				elsif (instruction_in(1 downto 0) = "01") then
					ex_out <= "00100010000001";
				-- NDC
				else
					ex_out <= "00100100000001";
				end if;
			else 
				-- NCU
				if (instruction_in(1 downto 0) = "00") then
					ex_out <= "00101000000001";
				-- NCZ
				elsif (instruction_in(1 downto 0) = "01") then
					ex_out <= "00101010000001";
				-- NCC
				else
					ex_out <= "00101100000001";
				end if;
			end if;
			
		-- ADI
		elsif (instruction_in(15 downto 12) = "0000") then
			wb_out <= '0' & instruction_in(8 downto 6) & '1';
			is_read_a <= '1';
			is_read_b <= '0';
			mem_out <= '0';
			ex_out <= "00000000110001";
		
		-- LLI
		elsif (instruction_in(15 downto 12) = "0011") then
			wb_out <= '0' & instruction_in(11 downto 9) & '1';
			is_read_a <= '0';
			is_read_b <= '0';
			mem_out <= '0';
			ex_out <= "10000000000000";
		
		-- LW
		elsif (instruction_in(15 downto 12) = "0100") then
			wb_out <= '1' & instruction_in(11 downto 9) & '1';
			is_read_a <= '0';
			is_read_b <= '1';
			mem_out <= '0';
			ex_out <= "00000000100000";
		
		-- SW
		elsif (instruction_in(15 downto 12) = "0101") then
			wb_out <= (others => '0');
			is_read_a <= '0';
			is_read_b <= '1';
			mem_out <= '1';
			ex_out <= "00000000100000";
		
		-- BEQ
		elsif (instruction_in(15 downto 12) = "1000") then
			wb_out <= (others => '0');
			is_read_a <= '1';
			is_read_b <= '1';
			mem_out <= '0';
			ex_out <= "00000000010010";
			
		-- BLT
		elsif (instruction_in(15 downto 12) = "1001") then
			wb_out <= (others => '0');
			is_read_a <= '1';
			is_read_b <= '1';
			mem_out <= '0';
			ex_out <= "00000000010100";
		-- BLE
		elsif (instruction_in(15 downto 12) = "1010") then
			wb_out <= (others => '0');
			is_read_a <= '1';
			is_read_b <= '1';
			mem_out <= '0';
			ex_out <= "00000000010110";
		-- JAL
		elsif (instruction_in(15 downto 12) = "1100") then
			wb_out <= '0' & instruction_in(11 downto 9) & '1';
			is_read_a <= '0';
			is_read_b <= '0';
			mem_out <= '0';
			ex_out <= "01000001011000";
		-- JLR
		elsif (instruction_in(15 downto 12) = "1101") then
			wb_out <= '0' & instruction_in(11 downto 9) & '1';
			is_read_a <= '0';
			is_read_b <= '1';
			mem_out <= '0';
			ex_out <= "01000000001010";
		-- JRI
		elsif (instruction_in(15 downto 12) = "1111") then
			wb_out <= (others => '0');
			is_read_a <= '1';
			is_read_b <= '0';
			mem_out <= '0';
			ex_out <= "00000001111100";
		end if;
	end process control_process;
end architecture bhv;
