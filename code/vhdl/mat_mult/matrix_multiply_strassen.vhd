-- matrix_multiply_strassen.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity matrix_multiply_strassen is
	generic(g_bitwidth : integer)
	port(i_clk    : in    std_logic;
		 i_rst    : in    std_logic;
		 
		 i_dv     : in    std_logic;
		 i_a_11   : in    signed(g_bitwidth-1 downto 0);
		 i_a_12   : in    signed(g_bitwidth-1 downto 0);
		 i_a_21   : in    signed(g_bitwidth-1 downto 0);
		 i_a_22   : in    signed(g_bitwidth-1 downto 0);
		
		 i_b_11   : in    signed(g_bitwidth-1 downto 0);
		 i_b_12   : in    signed(g_bitwidth-1 downto 0);
		 i_b_21   : in    signed(g_bitwidth-1 downto 0);
		 i_b_22   : in    signed(g_bitwidth-1 downto 0);
		 
		 o_dv     :   out std_logic;
		 o_c_11   :   out signed(2*g_bitwidth-1 downto 0);
		 o_c_12   :   out signed(2*g_bitwidth-1 downto 0);
		 o_c_21   :   out signed(2*g_bitwidth-1 downto 0);
		 o_c_22   :   out signed(2*g_bitwidth-1 downto 0)	
	);
end entity matrix_multiply_strassen;

architecture rtl of matrix_multiply_strassen is

	signal f_i_dv : std_logic_vector(5 downto 0);
	
	-- Stage 1 : Register Inputs
	signal f_a_11 : signed(g_bitwidth-1 downto 0);
	signal f_a_12 : signed(g_bitwidth-1 downto 0);
	signal f_a_21 : signed(g_bitwidth-1 downto 0);
	signal f_a_22 : signed(g_bitwidth-1 downto 0);
	signal f_b_11 : signed(g_bitwidth-1 downto 0);
	signal f_b_12 : signed(g_bitwidth-1 downto 0);
	signal f_b_21 : signed(g_bitwidth-1 downto 0);
	signal f_b_22 : signed(g_bitwidth-1 downto 0);
	
	-- Stage 2 : Term Calculations
	signal ff_p_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_p_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_q_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_q_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_r_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_r_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_s_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_s_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_t_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_t_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_u_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_u_t2 : signed(g_bitwidth-1 downto 0);
	signal ff_v_t1 : signed(g_bitwidth-1 downto 0);
	signal ff_v_t2 : signed(g_bitwidth-1 downto 0);
	
	-- Stage 3 : P,Q,R,S,T,U,V Calculations
	signal fff_p   : signed(2*g_bitwidth-1 downto 0);
	signal fff_q   : signed(2*g_bitwidth-1 downto 0);
	signal fff_r   : signed(2*g_bitwidth-1 downto 0);
	signal fff_s   : signed(2*g_bitwidth-1 downto 0);
	signal fff_t   : signed(2*g_bitwidth-1 downto 0);
	signal fff_u   : signed(2*g_bitwidth-1 downto 0);
	signal fff_v   : signed(2*g_bitwidth-1 downto 0);
	
	-- Stage 4 : C term calculations
	signal f4_c11_t1 : signed(2*g_bitwidth-1 downto 0);
	signal f4_c11_t2 : signed(2*g_bitwidth-1 downto 0);
	signal f4_c12_t1 : signed(2*g_bitwidth-1 downto 0);
	signal f4_c21_t1 : signed(2*g_bitwidth-1 downto 0);
	signal f4_c22_t1 : signed(2*g_bitwidth-1 downto 0);
	signal f4_c22_t2 : signed(2*g_bitwidth-1 downto 0);
	               
	-- Stage 5 : Output calculations
	signal f5_c11    : signed(2*g_bitwidth-1 downto 0);
	signal f5_c12    : signed(2*g_bitwidth-1 downto 0);
	signal f5_c21    : signed(2*g_bitwidth-1 downto 0);
	signal f5_c22    : signed(2*g_bitwidth-1 downto 0);

begin

	-- Assign Outputs
	o_dv   <= f_i_dv(5);
	o_c_11 <= f5_c11;
    o_c_12 <= f5_c12;
    o_c_21 <= f5_c21;
	o_c_22 <= f5_c22;
	
	p_s1 : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				f_i_dv <= (others => '0');
			else
				f_i_dv <= f_i_dv(f_i_dv'high-1 downto 0) & i_dv;
				
				if i_dv = '1' then
					f_a_11  <= i_a_11;
				    f_a_12  <= i_a_12;
				    f_a_21  <= i_a_21;
				    f_a_22  <= i_a_22;
				    f_b_11  <= i_b_11;
				    f_b_12  <= i_b_12;
				    f_b_21  <= i_b_21;
				    f_b_22  <= i_b_22;
				end if;
			end if;
		end if;
	end process;

	p_s2 : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if f_i_dv(0) = '1' then
				ff_p_t1 <= f_a_11 + f_a_22;
				ff_p_t2 <= f_b_11 + f_b_22;
				ff_q_t1 <= f_a_21 + f_a_22;
				ff_q_t2 <= f_b_11;
				ff_r_t1 <= f_a_11;
				ff_r_t2 <= f_b_12 - f_b_22;
				ff_s_t1 <= f_a_22;
				ff_s_t2 <= f_b_21 - f_b_11;
				ff_t_t1 <= f_a_11 + f_a_12;
				ff_t_t2 <= f_b_22;
				ff_u_t1 <= f_a_21 - f_a_11;
				ff_u_t2 <= f_b_11 + f_b_12;
				ff_v_t1 <= f_a_12 - f_a_22;
				ff_v_t2	<= f_b_21 + f_b_22;
			end if;
		end if;
	end process;
	
	p_s3 : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if f_i_dv(1) = '1' then
				fff_p <= ff_p_t1 * ff_p_t2;
				fff_q <= ff_q_t1 * ff_q_t2;
				fff_r <= ff_r_t1 * ff_r_t2;
				fff_s <= ff_s_t1 * ff_s_t2;
				fff_t <= ff_t_t1 * ff_t_t2;
				fff_u <= ff_u_t1 * ff_u_t2;
				fff_v <= ff_v_t1 * ff_v_t2;
			end if;
		end if;
	end process;
	
	p_s4 : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if f_i_dv(2) = '1' then
				f4_c11_t1 <= fff_p + fff_s;
			    f4_c11_t2 <= fff_t + fff_v;
			    f4_c12_t1 <= fff_r + fff_t;
			    f4_c21_t1 <= fff_q + fff_s;
			    f4_c22_t1 <= fff_p + fff_r;
			    f4_c22_t2 <= fff_q + fff_u;
			
			end if;
		end if;
	end process;
	
	
	p_s5 : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if f_i_dv(3) = '1' then
				f5_c11 <= f4_c11_t1 - f4_c11_t2;
			    f5_c12 <= f4_c12_t1;
			    f5_c21 <= f4_c21_t1;
			    f5_c22 <= f4_c22_t1 - f4_c22_t2;
			end if;
		end if;
	end process;
	
	
	
end rtl;