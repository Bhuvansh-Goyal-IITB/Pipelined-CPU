library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
	port (
		a, b: in std_logic_vector(15 downto 0);
		alu_control: in std_logic_vector(2 downto 0);
		c_in: in std_logic;
		alu_out: out std_logic_vector(15 downto 0);
		c_out, z_out: out std_logic
	);
end entity alu;

architecture bhv of alu is
	signal adder_carry: std_logic;
	signal adder_output: std_logic_vector(15 downto 0);
	signal b_compliment: std_logic_vector(15 downto 0);
	signal b_mux_out: std_logic_vector(15 downto 0);
	signal nand_output: std_logic_vector(15 downto 0);
	signal final_output: std_logic_vector(15 downto 0);
begin
	b_compliment <= not b;
	adder_carry <= alu_control(1) and c_in;
	
	b_mux: entity work.mux_2x1 port map (
		alu_control(0),
		b, b_compliment, 
		b_mux_out
	);
	
	adder_block: entity work.adder port map (
		a, b_mux_out, 
		adder_carry,
		adder_output,
		c_out
	);
	
	nand_output <= not (a and b_mux_out);
	
	output_mux: entity work.mux_2x1 port map (
		alu_control(2),
		adder_output, nand_output, 
		final_output
	);
	
	alu_out <= final_output;
	
	z_proc: process(final_output)
	begin
		if (final_output = x"0000") then
			z_out <= '1';
		else 
			z_out <= '0';
		end if;
	end process z_proc;
end architecture bhv;
