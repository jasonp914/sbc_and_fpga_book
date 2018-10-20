library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity encoder_onehot is
port(a : in    std_logic_vector(3 downto 0);
     b :   out std_logic_vector(1 downto 0)
);
end entity encoder_onehot;

architecture rtl of encoder_onehot is
begin
	p_enc : process(a)
	begin
		case a is	
			when "0001" => 
				b <= "00";
			when "0010" => 
				b <= "01";
			when "0100" => 
				b <= "10";
			when "1000" => 
				b <= "11";
		end case;
	end process;
end rtl;