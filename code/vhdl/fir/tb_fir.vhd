-- tb_fir.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity tb_fir is
end entity tb_fir;

architecture tb of tb_fir is
	constant k_fni : string := "input.txt";
	constant k_fno : string := "output.txt";
	constant k_bw  : integer := 16;

    signal w_clk   : std_logic := '0';
    signal w_en    : std_logic := '0';
    signal w_dv    : std_logic := '0';
    signal w_data  : std_logic_vector(k_bw-1 downto 0);	
    
	signal w_rst   : std_logic := '0';
	signal w_odv   : std_logic := '0';
	signal w_odata : std_logic_vector(k_bw-1 downto 0);	
	
	signal w_tdv   : std_logic := '0';
    signal w_tdata : std_logic_vector(k_bw-1 downto 0);	
    
begin

    u_textfileread : entity work.textfileread
	generic map(g_fn => k_fni
	            g_bw => k_bw)
	port map(i_clk => w_clk,
	         i_en  => w_en,
			 o_dv  => w_dv,
			 o_data=> w_data	
	);
	
	u_fir : entity work.fir
	generic map(g_bw => k_bw)
	port map(i_clk => w_clk,
			 i_rst => w_rst,
			 i_dv  => w_dv,
			 i_data=> w_data,
			 o_dv  => w_odv,
			 o_data=> w_odata	
	);

	u_textfileread : entity work.textfileread
	generic map(g_fn => k_fno
	            g_bw => k_bw)
	port map(i_clk => w_clk,
	         i_en  => w_en,
			 o_dv  => w_tdv,
			 o_data=> w_tdata	
	);
	
	p_check : process
	begin
		wait for rising_edge(w_clk);
		if w_tdv = '1' and w_odv '1' then
			assert w_odata = w_tdata
			report "Signals not equal"
			severity failure;
		end if;
	end process;
	
	p_clk : process
	begin	
		w_clk <= not w_clk;
		wait for 5 ns;
	end process;
end tb;