library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity encoder_onecold is
port(a : in    std_logic_vector(3 downto 0);
     b :   out std_logic_vector(1 downto 0)
);
end entity encoder_onecold;

architecture rtl of encoder_onecold is
begin
	p_enc : process(a)
	begin
		case a is	
			when "1110" => 
				b <= "00";
			when "1101" => 
				b <= "01";
			when "1011" => 
				b <= "10";
			when "0111" => 
				b <= "11";
		end case;
	end process;
end rtl;