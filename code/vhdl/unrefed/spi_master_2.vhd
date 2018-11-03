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
		 o_busy     :   out std_logic	
	);
end entity spi_master;

architecture rtl of spi_master is

begin




end rtl;