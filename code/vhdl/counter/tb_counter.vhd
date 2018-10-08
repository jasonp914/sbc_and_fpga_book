library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity tb_counter is
end entity tb_counter;

architecture tb of tb_counter is
	signal w_clk         : std_logic := '0';
	signal w_rst         : std_logic := '0';
	signal w_en          : std_logic := '0';
	signal w_count_sync  : unsigned(7 downto 0):=(others => '0');
	signal w_count_async : unsigned(7 downto 0):=(others => '0');

begin
	p_gen_stim : process
	begin
		w_rst <= '1';
		wait for 37.9 ns;
		w_rst <= '0';
		
		wait for 10 ns;
		w_en <= '1';
		wait for 50 ms;	
	end process;
	
	u_counter_sync : entity work.counter_sync
	port map(i_clk    => w_clk,
			 i_rst    => w_rst,
			 i_en     => w_en,
			 o_count  => w_count_sync
	);
	
	u_counter_async : entity work.counter_async
	port map(i_clk    => w_clk,
			 i_arst   => w_rst,
			 i_en     => w_en,
			 o_count  => w_count_async
	);
	
	p_clk : process
	begin
		wait for 5 ns;
		w_clk <= not w_clk;
	end process;
end tb;