library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity branch_decider is
	port (
		read_a, read_b: in std_logic_vector(15 downto 0);
		branch_control_in: in std_logic_vector(2 downto 0);
		branch_dest_mux_out: out std_logic_vector(1 downto 0);
		is_branch_taken: out std_logic
	);
end entity branch_decider;

-- branch_control_in --> none (000), beq (001), blt (010), ble (011), jal (100), jlr (101), jra (110)
-- branch_dest_mux_out --> pc+imm (00), read_b (01), read_a+imm (10)

architecture bhv of branch_decider is
begin
	branch_proc: process(read_a, read_b, branch_control_in)
	begin
		if (branch_control_in = "001") then
			if (read_a = read_b) then
				branch_dest_mux_out <= "00";
				is_branch_taken <= '1';
			else 
				is_branch_taken <= '0';
			end if;
		elsif (branch_control_in = "010") then
			if (signed(read_a) < signed(read_b)) then
				branch_dest_mux_out <= "00";
				is_branch_taken <= '1';
			else 
				is_branch_taken <= '0';
			end if;
		elsif (branch_control_in = "011") then
			if (signed(read_a) <= signed(read_b)) then
				branch_dest_mux_out <= "00";
				is_branch_taken <= '1';
			else 
				is_branch_taken <= '0';
			end if;
		elsif (branch_control_in = "100") then
			branch_dest_mux_out <= "00";
			is_branch_taken <= '1';
		elsif (branch_control_in = "101") then
			branch_dest_mux_out <= "01";
			is_branch_taken <= '1';
		elsif (branch_control_in = "110") then
			branch_dest_mux_out <= "10";
			is_branch_taken <= '1';
		elsif (branch_control_in = "000") then
			is_branch_taken <= '0';
		end if;
	end process branch_proc;
end architecture bhv;
