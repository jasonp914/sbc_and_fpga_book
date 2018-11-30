-- nco.vhd

library ieee;
	ieee.std_logic_1164.all;
	ieee.numeric_std.all;
	
entity nco is
generic(g_phinc_width : integer;
	    g_bitwidth    : integer;);
port(i_clk        : in    std_logic;
	 i_rst        : in    std_logic;
	 i_enable     : in    std_logic;
	 i_phz_init   : in    unsigned(g_phinc_width-1 downto 0);
	 i_phz_dv     : in    std_logic;
	 i_phinc_init : in    unsigned(g_phinc_width-1 downto 0);
	 i_phinc_dv   : in    std_logic;
	 o_nco_data   :   out unsigned(g_bitwidth-1 downto 0);
	 o_nco_dv     :   out std_logic
);
end 

architecture rtl of nco is
	type t_us_g is array (natural range <>) of unsigned(g_bitwidth-1 downto 0);
	signal f_bram       : t_us_g(0 to 2**g_phinc_width-1);
	signal f_phz_accum  : unsigned(g_phinc_width-1 downto 0);
	signal f_phinc      : unsigned(g_phinc_width-1 downto 0);
	signal f_nco_data   : unsigned(g_bitwidth-1 downto 0);
	signal f_nco_dv     : std_logic := '0';
	signal ff_nco_dv    : std_logic := '0';
begin

	o_nco_data <= f_nco_data; 
	o_nco_dv   <= ff_nco_dv;
	
	p_init : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				f_phz_accum <= (others => '0');
				f_nco_dv <= '0';
			else
				if i_phz_dv = '1' then
					f_phz_accum <= i_phz_init;
				end if;
				
				if i_phinc_dv = '1' then
					f_phinc <= i_phinc_init;
				end if;
				
				f_nco_dv <= i_enable;
				ff_nco_dv <= f_nco_dv;
				f_nco_data <= f_bram(to_integer(f_phz_accum));
				if i_enable = '1' then
					f_phz_accum <= f_phz_accum + f_phinc;
				end if;				
			end if;
		end if;	
	end process;
end rtl;