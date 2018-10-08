--+----------------------------------------------------------------------------
--|
--| © COPYRIGHT 2011 Air Force Institute of Technology All rights reserved.
--|                                             ___    ________________
--| Air Force Institute of Technology          /   |  / ____/  _/_  __/         
--| 2950 Hobson Way                           / /| | / /_   / /  / /   
--| Wright-Patterson AFB, OH 45433-7765      / ___ |/ __/ _/ /  / /                
--| 937.255.6565                            /_/  |_/_/   /___/ /_/     
--|                                                                    
--+----------------------------------------------------------------------------
--|
--|                                 NOTICE
--|
--|
--+----------------------------------------------------------------------------
--|
--| FILE    : uart_tx.vhd
--| AUTHOR  : Pennington, Jason
--| RELEASE :
--| CREATED : 
--| UPDATED : 
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : 
--|    Packages  : 
--|    Files     : 
--|    Used in   : 
--|
--+----------------------------------------------------------------------------
--|
--| Description : 
--|        
--|
-------------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  
entity uart_tx is
  generic(g_baudRate : integer := 115200;
          g_clkRate  : integer := 50000000);
  port(
      i_clk        : in    std_logic;
      i_sclr       : in    std_logic;
      i_tx_data    : in    std_logic_vector(7 downto 0);
      i_tx_data_dv : in    std_logic;
      o_tx         :   out std_logic;
      o_tx_busy    :   out std_logic
      );
end uart_tx;
architecture rtl of uart_tx is 
  constant k_timeperbit : real := real(1)/real(g_baudRate);
  constant k_clkperiod  : real := real(1)/real(g_clkRate);
  constant k_clksPerBit : integer := integer(real(g_clkRate)/real(g_baudRate)); 
  constant k_TBits      : unsigned(3 downto 0) := to_unsigned(10,4);
  
  type sm_uarttx_ctrl is (s_idle, s_txing, s_reset);
  signal f_cState : sm_uarttx_ctrl := s_idle;
  
  signal f_data2Tx : std_logic_vector(10 downto 0) := (others => '0');
  signal f_clkCount: integer := 0;
  signal f_bitCount: unsigned(3 downto 0) := (others => '0');
  
  -- Register Outs
  signal f_tx : std_logic := '1';
  signal f_tx_busy : std_logic := '0';
begin
  p_ctrl : process(i_clk) 
  begin
    if i_sclr = '1' then
        f_data2Tx <= (others => '0');
    elsif rising_edge(i_clk) then
      o_tx <= f_tx;
      o_tx_busy <= f_tx_busy;
      case f_cState is  
        when s_idle =>
          if i_tx_data_dv = '1' then
            f_data2Tx(8 downto 1) <= i_tx_data;
            f_data2Tx(10 downto 9) <= b"11";
            f_tx <= '0';
            f_tx_busy <= '1';
            f_cState <= s_txing;
            f_bitCount <= f_bitCount + 1;
          end if;
        when s_txing => 
          if f_clkCount = k_clksPerBit then
            f_clkCount <= 0;
            f_tx <= f_data2Tx(to_integer(f_bitCount));
            f_bitCount <= f_bitCount + 1;
            if f_bitCount = k_TBits then
              f_cState <= s_reset;
            end if;
          else
            f_clkCount <= f_clkCount + 1;
          end if;
        when s_reset => 
          f_tx <= '1';
          f_tx_busy <= '0';
          f_cState <= s_idle;
          f_bitCount <= (others => '0');
      end case;
    end if;
  end process;
end rtl;