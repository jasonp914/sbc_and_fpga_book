library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity tb_blink_led is
end entity tb_blink_led;

architecture tb of tb_blink_led is
	constant k_TOGGLECOUNT : integer := 100000000;

	signal w_clk : std_logic := '0';
	signal w_rst : std_logic := '0';
	signal w_en  : std_logic := '0';
	signal w_led : std_logic := '0';
begin

	p_gen_stim : process
	begin
		w_rst <= '1';
		wait for 34 ns;
		w_rst <= '0';
		
		wait for 15 ns;
		w_en <= '1';
		
		wait;
	end process;

	u_blink_led : entity work.blink_led
	generic map(gTOGGLECOUNT => k_TOGGLECOUNT)
	port map(i_clk   => w_clk,
		     i_rst   => w_rst,
		     i_en    => w_en ,
		     o_led   => w_led
	);

	p_clk : process
	begin
		wait for 5 ns;
		w_clk <= not w_clk;
	end process;	
end tb;