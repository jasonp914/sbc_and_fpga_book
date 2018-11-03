--=============================================================================
--
--  Author : Ben Ott
--  Date   : 05/25/16
--  
--  Component : spi_master.vhd
--
--  Description: Implements a spi master device with configurable parameters.
--
--=============================================================================


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity spi_master is
  generic(
    CLKS_PER_SCLK : integer := 10); 
  port(
    Clk  : in std_logic;
    Rst  : in std_logic;

    SPI_Clk  : out std_logic;
    SPI_Dout : out std_logic;
    SPI_Din  : in  std_logic;
    SPI_nCS  : out std_logic;

    Rd_nWr        : in std_logic;
    bits_per_word : in std_logic_vector(4 downto 0); --1-32
    Wr_Data       : in std_logic_vector(31 downto 0);
    Enable        : in std_logic;
    Rd_Data       : out std_logic_vector(31 downto 0);
    Busy          : out std_logic
    --+ Control signals
  );
end spi_master;

architecture rtl of spi_master is

  type spi_state is (s_idle, s_clk_high, s_clk_low);
  signal state : spi_state;
  signal bits_per_word_l : std_logic_vector(5 downto 0);
  signal bits_proc : integer range 0 to 32;
  signal wr_data_l : std_logic_vector(31 downto 0);
  signal rd_data_w : std_logic_vector(31 downto 0);
  signal clk_cnt   : integer range 0 to CLKS_PER_SCLK;

begin

  proc_spi : process(Clk, Rst) is
  begin
    if (Rst = '1') then
      state   <= s_idle;
    elsif (Clk'event and Clk='1') then
      case state is
        when s_idle =>
          if (Enable = '1') then
            state   <= s_clk_low;
            bits_per_word_l <= '0' & bits_per_word;
            bits_proc       <= 0;
            wr_data_l <= Wr_Data;
            clk_cnt <= 0;
          end if;

        when s_clk_low =>
          if (clk_cnt < (CLKS_PER_SCLK - 1)) then
            clk_cnt <= clk_cnt + 1;
          else
            if (bits_proc = unsigned(bits_per_word_l)+1) then
              state <= s_idle;
              Rd_Data <= rd_data_w;
            else
              state <= s_clk_high;
              clk_cnt <= 0;
            end if;
          end if;

        when s_clk_high =>
          if (clk_cnt < (CLKS_PER_SCLK - 1)) then
            clk_cnt <= clk_cnt + 1;
          else
            state <= s_clk_low;
            clk_cnt <= 0;
            bits_proc <= bits_proc + 1;
            wr_data_l <= wr_data_l(30 downto 0) & '0';
          end if;
          if clk_cnt = 0 then
            rd_data_w <= rd_data_w(30 downto 0) & SPI_Din;
          end if;
      end case;
    end if;
  end process proc_spi;

  SPI_Clk  <= '1' when (state = s_clk_high) else '0';
  SPI_nCS  <= '1' when (state = s_idle) else '0';
  SPI_Dout <= wr_data_l(31);
  Busy     <= '1' when (state /= s_idle) else '0';

end rtl;
