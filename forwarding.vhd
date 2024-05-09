library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding is
	port (
		ex_wb, mem_wb, wb_wb: in std_logic;
		ex_wb_dest, mem_wb_dest, wb_wb_dest: in std_logic_vector(2 downto 0);
		ex_is_alu_out, mem_is_load: in std_logic;
		ex_out, mem_out, mem_address_out, wb_out: in std_logic_vector(15 downto 0);
		reg_a_address, reg_b_address: in std_logic_vector(2 downto 0);
		reg_a_out, reg_b_out: in std_logic_vector(15 downto 0);
		out_a, out_b: out std_logic_vector(15 downto 0)
	);
end entity forwarding;

architecture bhv of forwarding is
begin
	a_output_proc: process(ex_wb, mem_wb, wb_wb, ex_wb_dest, mem_wb_dest, wb_wb_dest, ex_is_alu_out, mem_is_load, ex_out, mem_out, mem_address_out, wb_out, reg_a_out, reg_a_address) 
	begin
		if (ex_wb = '1' and ex_wb_dest = reg_a_address) then
			if (ex_is_alu_out = '1') then
				out_a <= ex_out;
			else 
				out_a <= reg_a_out;
			end if;
		elsif (mem_wb = '1' and mem_wb_dest = reg_a_address) then
			if (mem_is_load = '1') then
				out_a <= mem_out;
			else 
				out_a <= mem_address_out;
			end if;
		elsif (wb_wb = '1' and wb_wb_dest = reg_a_address) then
			out_a <= wb_out;
		else 
			out_a <= reg_a_out;
		end if;
	end process a_output_proc;
	
	b_output_proc: process(ex_wb, mem_wb, wb_wb, ex_wb_dest, mem_wb_dest, wb_wb_dest, ex_is_alu_out, mem_is_load, ex_out, mem_out, mem_address_out, wb_out, reg_b_out, reg_b_address) 
	begin
		if (ex_wb = '1' and ex_wb_dest = reg_b_address) then
			if (ex_is_alu_out = '1') then
				out_b <= ex_out;
			else 
				out_b <= reg_b_out;
			end if;
		elsif (mem_wb = '1' and mem_wb_dest = reg_b_address) then
			if (mem_is_load = '1') then
				out_b <= mem_out;
			else 
				out_b <= mem_address_out;
			end if;
		elsif (wb_wb = '1' and wb_wb_dest = reg_b_address) then
			out_b <= wb_out;
		else 
			out_b <= reg_b_out;
		end if;
	end process b_output_proc;
end architecture bhv;