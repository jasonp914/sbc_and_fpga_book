-- spi_slave.vhd
-- Jason Pennington
-- 2/11/2018

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity spi_slave is
    generic(CLKS_PER_SCLK : integer := 10;
            BITS_PER_WORD : integer := 8;
            RAM_ADDR_SIZE : integer := 8);
    port(i_clk     : in    std_logic;
         i_rst     : in    std_logic;
         -- SPI Data Ports
         i_sclk    : in    std_logic;
         i_mosi    : in    std_logic;
         o_miso    :   out std_logic;
         i_cs      : in    std_logic;
         -- RAM Access for FPGA 
         i_rd_en   : in    std_logic;
         i_rd_addr : in    std_logic_vector((2**RAM_ADDR_SIZE)-1 downto 0);
         o_data_dv :   out std_logic;
         o_ram_data:   out std_logic_vector(BITS_PER_WORD downto 0)
   );
end entity spi_slave;

architecture rtl of spi_slave is 
    signal f_rx_data : std_logic_vector(BITS_PER_WORD downto 0);

    signal f_sclk    : std_logic := '0';
    signal f_rx_bit_count : unsigned(5 downto 0) := (others => '0');
    signal f_ram_data     : std_logic_vector(BITS_PER_WORD downto 0);
    signal f_data_out     : std_logic_vector(BITS_PER_WORD downto 0):= (others => '1');
    signal f_data_out_1   : std_logic_vector(BITS_PER_WORD downto 0):= (others => '1');
    signal f_data_out_2   : std_logic_vector(BITS_PER_WORD downto 0):= (others => '1');
    signal f_ram_data_dv  : std_logic_vector(5 downto 0) := (others => '0'); 
    signal f_miso         : std_logic := '0'; 

    signal f_read_write   : std_logic := '0';
    signal f_rx_length    : std_logic_vector(1 downto 0) := (others => '0');
    signal f_address      : std_logic_vector(RAM_ADDR_SIZE-1 downto 0) := (others => '0');
    signal f_data2ram     : std_logic_vector(15 downto 0) := (others => '0');
    type t_slv16 is array (natural range <>) of std_logic_vector(15 downto 0);
    signal f_mem          : t_slv16(0 to 2**RAM_ADDR_SIZE-1);
begin
    o_ram_data <= f_ram_data;
    o_data_dv <= f_ram_data_dv(0);
    o_miso <= f_miso;
    p_spi : process(i_clk)
    begin
        if rising_edge(i_clk) then
            f_sclk <= i_sclk;
            --f_ram_data_dv <= '0';
            f_ram_data_dv <= f_ram_data_dv(4 downto 0) & '0';
            if i_rst = '1' then
                f_rx_data <= (others => '0');
            elsif i_cs = '0' and f_sclk = '0' and i_sclk = '1' then
                -- Receive Data - MSB is rx'd first
                f_rx_data <= f_rx_data(BITS_PER_WORD-1 downto 0) & i_mosi;
                f_rx_bit_count <= f_rx_bit_count + 1;
                if f_rx_bit_count = BITS_PER_WORD then
                    f_rx_data <= f_rx_data(BITS_PER_WORD-1 downto 0) & i_mosi;
                    f_ram_data_dv(0) <= '1';
                    f_rx_bit_count <= (others => '0');
                end if;

                -- Transmit Data - MSB is tx'd first
                f_miso <= f_data_out(BITS_PER_WORD);
                f_data_out <= f_data_out(BITS_PER_WORD-1 downto 0) & '0';
            end if;

            if f_ram_data_dv(1) = '1' then
                f_read_write <= f_rx_data(31);
                f_rx_length  <= f_rx_data(30 downto 29); 
                f_address <= f_rx_data(28 downto 16);
                f_data2ram <= f_rx_data(15 downto 0);--f_rx_data;

            elsif f_ram_data_dv(2) = '1' then
                if f_read_write = '0' then
                    -- Write Data to Address
                    f_mem(to_integer(unsigned(f_address))) <= f_data2ram(15 downto 0);
                    f_data_out <= (others => '0');
                else
                    -- Read Data from ram @Address
                    f_data_out(31 downto 16) <= f_mem(to_integer(unsigned(f_address)));
                    f_address <= std_logic_vector(unsigned(f_address) + 1);
                end if;
            elsif f_ram_data_dv(3) = '1' then
                if f_read_write = '1' then
                    f_data_out(15 downto 0) <= f_mem(to_integer(unsigned(f_address)));
                end if;
            end if;
        end if;
    end process;
end rtl;
