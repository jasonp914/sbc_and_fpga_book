library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity decoder_onehot is
port(a : in    std_logic_vector(1 downto 0);
     b :   out std_logic_vector(3 downto 0)
);
end entity decoder_onehot;

architecture rtl of decoder_onehot is
begin
	p_enc : process(a)
	begin
		case a is	
			when "00" => 
				b <= "0001";
			when "01" => 
				b <= "0010";
			when "0011" => 
				b <= "0100";
			when "10" => 
				b <= "1000";
		end case;
	end process;
end rtl;