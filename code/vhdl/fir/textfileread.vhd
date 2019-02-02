-- textfileread.vhd

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use std.textio.all;
	
entity textfileread is
generic(g_fn : string;
        g_bw : integer);
port(i_clk  : in    std_logic;
     i_en   : in    std_logic;
     o_dv   : in    std_logic;
     o_data : in    std_logic_vector(g_bw-1 downto 0)	
	);
end entity textfileread;

architecture tb of textfileread is
begin
    p_read : process
        file f : TEXT open READ_MODE is g_fn;
        variable l : LINE;
    begin
        loop
            exit when endfile(f);
            wait for rising_edge(i_clk);
            if i_en = '1' then
                readline(f,l);
                o_data <= to_signed(l,g_bw);
                o_dv <= '1';
            else
                o_dv <= '0';
            end if;
        end loop;
        wait;
    end process;
end tb;