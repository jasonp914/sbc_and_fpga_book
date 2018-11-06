-- spi_master.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity spi_master is
	generic(g_sclkrate  : integer;
			g_word_size : integer)
	port(i_clk      : in    std_logic;
		 i_rst      : in    std_logic;
		 
		 o_spi_clk  :   out std_logic;
		 o_spi_mosi :   out std_logic;
		 i_spi_miso : in    std_logic;
		 o_spi_ncs  :   out std_logic;
		
		 i_rd_nwr   : in    std_logic;
		 i_wrdataen : in    std_logic;
		 i_wr_data  : in    std_logic_vector(g_word_size-1 downto 0);
		
		 o_rd_data  :   out std_logic_vector(g_word_size-1 downto 0);
		 o_rd_dv    :   out std_logic;
		 o_busy     :   out std_logic	
	);
end entity spi_master;

architecture rtl of spi_master is
	signal f_clk_counter : unsigned(31 downto 0);
	signal f_o_sclk      : std_logic := '0';
	signal f_o_mosi      : std_logic := '0';
	signal f_o_ncs       : std_logic := '0';
	
	signal f_o_rd_dv     : std_logic := '0';
	signal f_rd_data     : std_logic_vector(g_word_size-1 downto 0);
	
	type sm_spi is (s_idle, s_transfer, s_end);
	signal s_spi         : sm_spi := s_idle;
	
	signal f_wr_data     : std_logic_vector(g_word_size-1 downto 0);
	signal f_rx_data     : std_logic_vector(g_word_size-1 downto 0);
	
	signal f_data_c      : unsigned(7 downto 0);
	signal f_data_rd_c   : unsigned(7 downto 0);
	
	
begin

	o_busy      <= f_busy;
	o_spi_clk   <= f_o_sclk; 
    o_spi_mosi  <= f_o_mosi;
    o_spi_ncs   <= f_o_ncs; 
	
	o_rd_data <= f_o_rd_dv;
	o_rd_dv   <= f_rd_data;

	p_gen_sclk : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				f_clk_counter <= (others => '0');
			else
				f_clk_counter <= f_clk_counter + 1;
				if f_clk_counter = g_sclkrate then
					f_o_sclk <= '0';
					f_clk_counter <= (others => '0');
				elsif f_clk_counter = g_sclkrate/2 then
					f_o_sclk <= '1';
				end if;
			end if;		
		end if;
	end process;

	p_launch_data : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				s_spi <= s_idle;
				f_busy <= '0';
				f_o_ncs <= '1';
			else
				ff_o_sclk <= f_o_sclk;
				case s_spi is
					when idle =>
						f_busy <= '0';
						f_o_ncs <= '1';
						f_o_rd_dv <= '1';
						if i_wrdataen = '1' then
							s_spi <= s_transfer;
							f_wr_data <= i_wr_data;
							f_busy <= '1';
							f_rd_nwr <= i_rd_nwr;
							f_data_c <= to_unsigned(f_wr_data'high,f_data_c'length);
							f_data_rd_c <= (others => '0');
						end if;
					when s_transfer => 
						-- Falling Edge of SCLK
						if ff_o_sclk = '1' and f_o_sclk = '0' then
							f_o_ncs <= '0';
							f_o_mosi <= f_wr_data(to_integer(f_data_c));
							f_data_c <= f_data_c - 1;
							if f_data_c = 0 then
								f_data_c <= to_unsigned(f_wr_data'high,f_data_c'length);
								s_spi <= s_end;
							end if;
						end if;					

						-- Rising Edge of SCLK
						if ff_o_sclk = '0' and f_o_sclk = '1' then
							f_rx_data(to_integer(f_data_rd_c)) <= i_spi_miso;
							f_data_rd_c <= f_data_rd_c + 1;
						end if;
					when s_end => 
						s_spi <= s_idle;
						if f_rd_nwr = '1' then
							-- Reading data from slave
							f_o_rd_dv <= '1';
							f_rd_data <= f_rx_data;
						end if;				
				end case;
			end if;
		end if;	
	end process;


end rtl;