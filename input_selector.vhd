library IEEE;
use IEEE.std_logic_1164.all;

entity input_selector is
	port (
		reg_a, reg_b, pc, imm: in std_logic_vector(15 downto 0);
		select_control: in std_logic_vector(1 downto 0);
		out_a, out_b: out std_logic_vector(15 downto 0)
	);
end entity input_selector;

-- select_control --> a+b (00), pc+imm (01), imm+b (10), a+imm (11)

architecture bhv of input_selector is
begin
	select_proc: process(select_control, reg_a, reg_b, pc, imm)
	begin
		if (select_control = "00") then
			out_a <= reg_a;
			out_b <= reg_b;
		elsif (select_control = "01") then
			out_a <= pc;
			out_b <= imm;
		elsif (select_control = "10") then
			out_a <= imm;
			out_b <= reg_b;
		else
			out_a <= reg_a;
			out_b <= imm;
		end if;
	end process select_proc;
end architecture bhv;
