library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity encoder_gray is
port(a : in    std_logic_vector(3 downto 0);
     b :   out std_logic_vector(1 downto 0)
);
end entity encoder_gray;

architecture rtl of encoder_gray is
begin
	p_enc : process(a)
	begin
		case a is	
			when "0000" => 
				b <= "00";
			when "0001" => 
				b <= "01";
			when "0011" => 
				b <= "10";
			when "0010" => 
				b <= "11";
		end case;
	end process;
end rtl;