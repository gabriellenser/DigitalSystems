library ieee;
use ieee.std_logic_1164.all;

entity SEA is
	port(
		e   : in  std_logic_vector(2 downto 0);
		dev, cof, disp, rec : out std_logic
	);
	
end SEA;

architecture est of SEA is
begin 

dev  <= e(2) and e(1);
cof  <= e(2) and not(e(1));
disp <= e(2) and not(e(1));
rec  <= not(e(2));


end architecture; 


