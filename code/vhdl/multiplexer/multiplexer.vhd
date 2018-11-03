library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity multiplexer is
port(i_clk  : in    std_logic;
	 i_sel  : in    std_logic;
	 i_data : in    std_logic_vector(1 downto 0);
     o_data :   out std_logic
);
end entity multiplexer;

architecture rtl of multiplexer is
	signal f_odata : std_logic;
	signal f_sel   : std_logic;
begin
	o_data <= f_odata;
	p_mux : process(i_clk)
	begin
		if rising_edge(i_clk) then
				f_sel <= i_sel;
				f_idata <= i_data;
				case f_sel is
					when "0" =>    f_odata <= f_idata(0);
					when "1" =>    f_odata <= f_idata(1);
					when others => f_odata <= '0';
				end case;		
		end if;
	end process;
end rtl;