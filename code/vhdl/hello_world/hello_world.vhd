library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity hello_world is
end entity hello_world;

architecture tb of hello_world is
begin
	process
	begin
		report("Hello World!");
	end process;
end tb;