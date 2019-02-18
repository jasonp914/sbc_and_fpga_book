-- upp_tx.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity upp_tx is
    generic(g_dma_size      : integer := 4096;
            g_upp_clk_ratio : integer := 200)
    port(i_clk           : in    std_logic;
          -- Used async | release sync
          i_rst           : in    std_logic;
          
          -- uPP IO
          o_upp_clk       :   out std_logic; 
          o_upp_start     :   out std_logic;
          o_upp_enable    :   out std_logic;
          i_upp_wait      : in    std_logic;
          
          o_upp_data      :   out std_logic_vector(15 downto 0);
          
          -- App Interface
          i_tx_data       : in    std_logic_vector(15 downto 0);
          i_tx_data_dv    : in    std_logic	
          o_tx_fifo_full  :   out std_logic	
    );
end entity upp_tx;

architecture rtl of upp_tx is
    constant k_upp_clk_ratio_half : integer := g_upp_clk_ratio/2;
    signal w_tx_fifo_full : std_logic;
    
    signal f_clk_count      : unsigned(log2(g_upp_clk_ratio)-1 downto 0);
    signal f_tx_word_count  : unsigned(log2(g_dma_size)-1 downto 0);
    signal f_upp_clk        : std_logic;
    signal ff_upp_clk       : std_logic;
    signal f_upp_clk_strobe : std_logic;
    signal f_upp_start      : std_logic;
    signal f_upp_enable     : std_logic;
    signal f_upp_data       : std_logic_vector(15 downto 0);
                            
    signal f_fifo_rden      : std_logic;
    signal w_fifo_dout      : std_logic_vector(15 downto 0);
    signal w_fifo_rddv      : std_logic;
    signal w_fifo_empty     : std_logic;
    
    type sm_upptx is (s_idle, s_transfer);
    signal s_curr_state : sm_upptx := s_idle;

begin

    o_tx_fifo_full <= w_tx_fifo_full;
    o_upp_clk      <= f_upp_clk;
    o_upp_start    <= f_upp_start ;
    o_upp_enable   <= f_upp_enable;
    o_upp_data     <= f_upp_data;
    
    p_tx_data : process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                s_curr_state <= s_idle;
                f_upp_start <= '0';
                f_upp_enable <= '0';
                f_tx_word_count <= (others => '0');
            else
                case s_curr_state is
                    when s_idle => 
                        f_upp_start <= '0';
                        f_upp_enable <= '0';
                        f_tx_word_count <= (others => '0');
                        
                        if w_fifo_empty = '0' then
                            s_curr_state <= s_transfer;
                            f_fifo_rden <= '1';
                        end if;					
                    when s_transfer => 
                        if w_fifo_rddv = '1' then
                            f_upp_data <= w_fifo_dout;
                        end if;
                        
                        if f_upp_clk_strobe = '1' then
                            -- Rising Edge of upp clk
                            if i_upp_wait = '0' then
                                f_upp_enable <= '1';
                                f_fifo_rden <= '1';
                                f_tx_word_count <= f_tx_word_count + 1;
                                
                                case f_tx_word_count is
                                    when 0 => 
                                        f_upp_start <= '1';
                                    when g_dma_size => 
                                        s_curr_state <= s_idle;
                                    when others =>
                                        f_upp_start <= '0';
                                end case;			
                            else
                                -- Transfer is stalled
                                f_upp_enable <= '0';
                                f_fifo_rden <= '0';
                            end if;							
                        else
                            f_fifo_rden <= '0';
                        end if;				
                end case;
            end if;
        end if;
    end process;
    
    
    u_tx_fifo : entity work.tx_fifo
    port map(wrclk => i_clk, 
             wren  => i_tx_data_dv,
             din   => i_tx_data,
             full  => w_tx_fifo_full,
            
             rdclk => f_upp_clk,
             rden  => f_fifo_rden,
             dout  => w_fifo_dout,
             rddv  => w_fifo_rddv,
             empty => w_fifo_empty	
    );
    
    p_gen_upp_clk : process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                f_clk_count <= (others => '0');
                f_upp_clk <= '0';
            else
                ff_upp_clk <= f_upp_clk;
                
                f_clk_count <= f_clk_count + 1;
                if f_clk_count = k_upp_clk_ratio_half then
                    -- Toggle UPP Clk
                    f_upp_clk <= not f_clk_count;
                    f_clk_count <= (others => '0');
                end if;
                
                if ff_upp_clk = '0' and f_upp_clk = '1' then
                    -- Generate upp clock strobe
                    f_upp_clk_strobe <= '1';
                else
                    f_upp_clk_strobe <= '0';
                end if;
            end if;
        end if;	
    end process;	