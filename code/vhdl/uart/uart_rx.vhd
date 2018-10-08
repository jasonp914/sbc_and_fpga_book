library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
  generic(g_baudRate : integer := 115200;
          g_clkRate  : integer := 50000000);
  port(
      i_clk           : in    std_logic;
      i_rx            : in    std_logic;
      o_rx_data       : out   std_logic_vector(7 downto 0);
      o_rx_data_rdy   : out   std_logic
      );
end entity uart_rx;

architecture rtl of uart_rx is
  constant k_timeperbit   : real := real(1)/real(g_baudRate);
  constant k_clkperiod    : real := real(1)/real(g_clkRate);
  constant k_clksPerBit   : integer := integer(real(g_clkRate)/real(g_baudRate));
  constant k_clksPerBitd2 : integer := integer(real(k_clksPerBit)/real(2));
  constant k_TBits        : unsigned(3 downto 0) := to_unsigned(10,4);

  -- Outputs 
  signal f_rx_data     : std_logic_vector(7 downto 0) := (others => '0');
  signal f_rx_data_rdy : std_logic := '0';
  
  type sm_rxUart is (s_idle, s_cfmLow, s_rxStartBit, s_rx8bits, s_parity, s_stop, s_reset);
  signal f_cState : sm_rxUart := s_idle;
  
  signal f_clkCount : integer := 0;
  signal f_rxBits   : unsigned(3 downto 0) := (others => '0');
  
begin
  p_rxctrl : process(i_clk) 
  begin
    if rising_edge(i_clk) then
      o_rx_data_rdy <= f_rx_data_rdy;
      o_rx_data <= f_rx_data;
      case f_cState is
        when s_idle => 
          f_rx_data_rdy <= '0';
          f_rx_data <= (others => '0');
          if i_rx = '0' then
            f_cState <= s_cfmLow;
          end if;
        when s_cfmLow =>
          if f_clkCount = k_clksPerBitd2 then
            if i_rx = '0' then
              f_cState <= s_rxStartBit;
              f_clkCount <= 0;  
            else 
              f_cState <= s_idle; -- if rx line isn't still low during start bit.
              f_clkCount <= 0;
            end if;
          else
            f_clkCount <= f_clkCount + 1;
          end if;
        when s_rxStartBit =>
          if f_clkCount = k_clksPerBit then
            f_cState <= s_rx8bits;
            f_rx_data(to_integer(f_rxBits)) <= i_rx;
            f_rxBits <= f_rxBits + 1;
            f_clkCount <= 0;
          else 
            f_clkCount <= f_clkCount + 1;
          end if;        
        when s_rx8bits =>
          if f_rxBits = 8 then
            f_cState <= s_parity;
          elsif f_clkCount = k_clksPerBit then 
            f_clkCount <= 0;
            f_rx_data(to_integer(f_rxBits)) <= i_rx;
            f_rxBits <= f_rxBits + 1;
          else 
            f_clkCount <= f_clkCount + 1;
          end if;
        when s_parity =>
          if f_clkCount = k_clksPerBit then
            f_rxBits <= (others => '0');
            f_clkCount <= 0;
            if i_rx = '1' then
              f_cState <= s_stop;
            else
              f_cState <= s_idle;
            end if;
          else
            f_clkCount <= f_clkCount + 1;
          end if;
        when s_stop => 
          if f_clkCount = k_clksPerBit then
            f_clkCount <= 0;
            if i_rx = '1' then
              f_cState <= s_reset;
            else
              f_cState <= s_idle;
            end if;
          else
            f_clkCount <= f_clkCount + 1;
          end if;
        when s_reset =>
          if f_clkCount = k_clksPerBitd2 then
            f_rx_data_rdy <= '1';
            f_cState <= s_idle;
            f_rxBits <= (others => '0');
          else
            f_clkCount <= f_clkCount + 1;
          end if;
      end case; 
    end if;
  end process;
end rtl;