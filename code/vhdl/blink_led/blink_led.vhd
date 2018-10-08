library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity blink_led is
generic(gTOGGLECOUNT : integer)
port(i_clk   : in    std_logic;
	 i_rst   : in    std_logic;
	 i_en    : in    std_logic;
	 o_led   :   out std_logic	
)
end entity blink_led;

architecture rtl of blink_led is
	-- Output Register
	signal f_led   : std_logic := '0';

	-- Duration Counter
	signal f_count : unsigned(31 downto 0) := (others => '0');
begin

	-- Assign Outputs
	o_led <= f_led;

	p_count : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				f_count <= (others => '0');
			elsif i_en = '1' then
				f_count <= f_count + 1;
			end if;	

			if f_count = gTOGGLECOUNT then
				f_led <= not f_led;
				f_count <= (others => '0');
			end if;			
		end if;
	end process;
end rtl;
