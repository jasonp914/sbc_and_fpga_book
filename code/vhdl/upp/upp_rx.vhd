-- upp_rx.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity upp_rx is
	generic(g_dma_size : integer := 4096)
	port(i_clk           : in    std_logic;
	     i_rst          : in    std_logic;
		 
		 -- uPP IO
		 i_upp_clk       : in    std_logic; 
		 i_upp_start     : in    std_logic;
		 i_upp_enable    : in    std_logic;
		 o_upp_wait      :   out std_logic;
		 
		 i_upp_data      : in    std_logic_vector(15 downto 0);
		 
		 -- App interface
		 o_upp_busy      :   out std_logic;
		 o_rx_data_empty :   out std_logic;
		 i_rx_data_rden  : in    std_logic;
		 o_rx_data_dv    :   out std_logic;
		 o_rx_data       :   out std_logic_vector(15 downto 0)	
	);
end entity upp_rx;


architecture rtl of upp_rx is
	
	signal f_rx_data_dv   : std_logic;
	signal f_rx_data      : std_logic_vector(15 downto 0);
	signal w_rx_fifo_full : std_logic;
	signal f_upp_busy     : std_logic;
	
	signal f_dma_count    : unsigned(log2(g_dma_size)-1 downto 0);
	
begin

	o_upp_wait <= w_rx_fifo_full;
	o_upp_busy <= f_upp_busy; 

	u_rx_fifo : entity work.rx_fifo
	port map(i_rst => i_rst,
			 wrclk => i_upp_clk, 
			 wren  => f_rx_fifo_wren,
			 din   => f_rx_fifo_data,
			 full  => w_rx_fifo_full,
	
			 rdclk => i_clk,
			 rden  => i_rx_data_rden,
			 dout  => o_rx_data,
			 rddv  => o_rx_data_dv,
			 empty => o_rx_data_empty	
	);

	p_rx_data : process(i_upp_clk, i_arst)
	begin
		if rising_edge(i_upp_clk) then
			if i_rst = '1' then
				f_dma_count <= (others => '0');
				f_rx_data_dv <= '0';
				f_upp_busy <= '0';
			else
				f_upp_start <= i_upp_start;
				if f_upp_start = '0' and i_upp_start = '1' then	
					-- Start DMA transfer
					f_upp_busy <= '1';
				end if;
				
				if f_dma_count = g_dma_size-1 then
					-- DMA Transfer Complete
					f_dma_count <= (others => '0');
					f_upp_busy <= '0';
				end if;
			
				if i_upp_enable = '1' then
					-- Load uPP data into rx fifo
					f_dma_count <= f_dma_count + 1;
					f_rx_fifo_data <= i_upp_data;
					f_rx_fifo_wren <= '1';
				else
					-- uPP Transfer Stalled.
					f_rx_fifo_wren <= '0';
				end if;
			end if;
		end if;
	end process;

	
end rtl;