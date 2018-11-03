-- i2c_write.vhd
-- Jason Pennington
-- implements I2C write communication protocol
-- 15 May 2018

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;


entity i2c_write is
    port(i_clk        : in    std_logic;
         i_rst        : in    std_logic;
         -- I2C Ports 
         b_sda        : inout std_logic;
         o_scl        :   out std_logic;
         -- App 
         i_data       : in    std_logic_vector(31 downto 0);
         i_dv         : in    std_logic;
         o_busy       :   out std_logic
    );
end entity i2c_write;

architecture rtl of i2c_write is 
    constant k_start_cond     : integer := 20;
    constant k_clks_per_scl_h : integer := 15;
    constant k_clks_per_scl   : integer := k_clks_per_scl_h*2;

    -- Input Regs
    signal f_data    : std_logic_vector(31 downto 0) := (others => '0');
    	
    -- Output Regs
    signal f_busy    : std_logic := '0';
    signal f_sda     : std_logic := '1';
    signal f_scl     : std_logic := '1';

	constant k_n_data_frames : integer := 3;
    signal f_cc      : unsigned(7 downto 0) := (others => '0');
    signal f_os      : unsigned(7 downto 0) := (others => '0');
	signal f_ndframes: unsigned(3 downto 0) := (others => '0');
    signal f_ack_bit : std_logic := '1';
	signal f_done    : std_logic := '0';

    type sm_states is (s_idle, s_init_frame, s_addr_frame, s_ack_bit, s_write_data_frame, s_read_data_frame);
    signal s_i2c  : sm_states := s_idle;
begin

    o_busy <= f_busy;

    b_sda <= f_sda;
    o_scl <= f_scl;

    p_i2c : process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                s_i2c <= s_idle;
            else
                case s_i2c is
                    when s_idle => 
                        f_sda <= '1';
                        f_scl <= '1';
						f_done <= '0';
                        if i_dv = '1' then
                            f_data <= i_data;
                            s_i2c <= s_init_frame;
                            f_sda <= '0'; -- Assumes point to point I2C
                            f_busy <= '1';
                        end if;
                    when s_init_frame => 
                        -- Start Condition deassert SDA
                        f_cc <= f_cc + 1;
                        if f_cc = k_start_cond then
                            f_cc <= (others => '0');
                            f_scl <= '0';
                            f_os <= to_unsigned(31,8);
                            s_i2c <= s_write_data_frame;
                        end if;
                    when s_ack_bit => 
                        f_cc <= f_cc + 1;
                        if f_cc = k_clks_per_scl_h then
                            f_scl <= not f_scl;
                            f_ack_bit <= b_sda;
                        end if; 
                        if f_cc = k_clks_per_scl_h+1 then
                            f_sda <= '1';
                            if f_ack_bit = '0' then
                                -- Success?
                                s_i2c <= s_write_data_frame;
                            else
                                -- Fail -- Reset
                                s_i2c <= s_idle;
                            end if;
                        end if;
                    when s_write_data_frame => 
                        f_cc <= f_cc + 1;
                        if f_cc = k_clks_per_scl_h then
                            f_scl <= not f_scl;
                            f_sda <= f_data(to_integer(f_os));
                            if f_os = 23 then
								f_sda <= 'Z';
								s_i2c <= s_ack_bit;
                            elsif f_os = 15 then
								f_sda <= 'Z';
								s_i2c <= s_ack_bit;
                            elsif f_os = 7 then
								f_sda <= 'Z';
								s_i2c <= s_ack_bit;
                            elsif f_os = 0 then
                                s_i2c <= s_idle;
                            end if;
                        end if; 
                        if f_cc = k_clks_per_scl then
                            f_os <= f_os - 1; 
                            f_scl <= not f_scl;
                            f_cc <= (others => '0');
                        end if;
                end case;
            end if;
        end if;
    end process;
end rtl;
