-- halfbandLPF.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity halfbandLPF is 
	generic(g_bitwidth : integer := 16;
	        g_ncoeffs  : integer := 35);
	port(
			i_clk      : in    std_logic;
			i_reset    : in    std_logic;
			i_data     : in    std_logic_vector(g_bitwidth-1 downto 0);
			i_dv       : in    std_logic;
			o_data     :   out std_logic_vector(2*g_bitwidth-1 downto 0);
			o_dv       :   out std_logic	
	);
end entity halfbandLPF;

architecture rtl of halfbandLPF is 
	type T_Sbw is array (natural range<>) of signed(g_bitwidth-1 downto 0);
	type T_S2bw is array (natural range<>) of signed(2*g_bitwidth-1 downto 0);
	signal f_x_mix    : T_Sbw(0 to g_ncoeffs-1) := (others => (others => '0'));
	signal f_dv_shift : std_logic_vector(0 to g_ncoeffs-1) := (others => '0');
	
	-- Length of this vector is Ceil((g_ncoeffs-1)/4)+1
	-- These coefficients need to be loaded externally
	signal f_h_uni      : T_Sbw(0 to 9) := (x"0026",x"FFA6",x"00BD",x"FEA0",x"0261",x"FC05",x"06BC",x"F350",x"2870",x"4000");

	signal ff_mix_add   : T_Sbw(0 to 9) := (others => (others => '0'));
	signal fff_add_mult : T_S2bw(0 to 9) := (others => (others => '0'));
	
	signal f4_sum_s1    : T_S2bw(0 to 4) := (others => (others => '0'));
	signal f5_sum_s2    : T_S2bw(0 to 2) := (others => (others => '0'));
	signal f6_sum_s3    : T_S2bw(0 to 1) := (others => (others => '0'));
	signal f7_sum_s4    : signed(2*g_bitwidth-1 downto 0) := (others => '0');
begin
	o_data <= std_logic_vector(f7_sum_s4);
	o_dv <= f_dv_shift(6);

	p_calc : process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_reset = '1' then
				f_dv_shift <= (others => '0');
			elsif i_dv = '1' then
				-- Shift Register Data
				f_x_mix(34) <= signed(i_data);
				f_x_mix(0 to g_ncoeffs-2) <= f_x_mix(1 to g_ncoeffs-1);
				
				-- Shift Register Data Valid
				f_dv_shift(0) <= i_dv;
				f_dv_shift(1 to g_ncoeffs-1) <= f_dv_shift(0 to g_ncoeffs-2);
				
				-- Take advantage of symmetric filter. 
				ff_mix_add(0) <= f_x_mix(0) + f_x_mix(34);
				ff_mix_add(1) <= f_x_mix(2) + f_x_mix(32);
				ff_mix_add(2) <= f_x_mix(4) + f_x_mix(30);
				ff_mix_add(3) <= f_x_mix(6) + f_x_mix(28);
				ff_mix_add(4) <= f_x_mix(8) + f_x_mix(26);
				ff_mix_add(5) <= f_x_mix(10) + f_x_mix(24);
				ff_mix_add(6) <= f_x_mix(12) + f_x_mix(22);
				ff_mix_add(7) <= f_x_mix(14) + f_x_mix(20);
				ff_mix_add(8) <= f_x_mix(16) + f_x_mix(18);
				ff_mix_add(9) <= f_x_mix(17);
				
				-- Multiply Impulse response. 
				for i in 0 to 9 loop
					fff_add_mult(i) <= ff_mix_add(i) * f_h_uni(i);
				end loop;				
				
				-- Start of the adder tree.
				for i in 0 to 4 loop
					f4_sum_s1(i) <= fff_add_mult(2*i) + fff_add_mult(2*i+1);
				end loop;
				
				f5_sum_s2(2) <= f4_sum_s1(4);
				for i in 0 to 1 loop
					f5_sum_s2(i) <= f4_sum_s1(2*i) + f4_sum_s1(2*i+1);
				end loop;
				
				f6_sum_s3(0) <= f5_sum_s2(0) + f5_sum_s2(1);
				f6_sum_s3(1) <= f5_sum_s2(2);
								
				-- Result of adder tree.
				f7_sum_s4 <= f6_sum_s3(0) + f6_sum_s3(1);
			end if;			
		end if;
	end process;


end rtl;