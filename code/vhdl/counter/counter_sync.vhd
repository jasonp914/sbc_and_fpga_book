library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity counter_sync is
port(i_clk   : in    std_logic;
	 i_rst   : in    std_logic;
	 i_en    : in    std_logic;
	 o_count :   out unsigned(7 downto 0)	
)
end entity counter_sync;

architecture rtl of counter_sync is
	-- Output Register
	signal f_count : unsigned(7 downto 0) := (others => '0');
begin

	-- Assign Outputs
	o_count <= f_count;

	p_count : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				f_count <= (others => '0');
			elsif i_en = '1' then
				f_count <= f_count + 1;
			end if;		
		end if;
	end process;
end rtl;
