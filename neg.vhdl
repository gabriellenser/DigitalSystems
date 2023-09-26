library ieee;
use ieee.std_logic_1164.all;

entity neg is 
    port (
             y : in std_logic_vector ( 7 downto 0);
             s : out std_logic_vector (7 downto 0)
          );
          
end entity;

architecture comuta of neg is
begin 

S <= not(y);

end architecture;
