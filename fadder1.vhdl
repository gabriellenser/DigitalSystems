library ieee;
use ieee.std_logic_1164.all;

entity fadder1 is
port (
           x : in std_logic;
           y : in std_logic;
           Cin : in std_logic;
           S : out std_logic;
           Cout : out std_logic
                 
      );
      
      end entity;
      
      architecture comuta of fadder1 is
      begin 
      S <= ( x xor y) xor Cin after 4 ns;
      Cout <= (x and Cin) or (y and Cin) or (x and y) after 8 ns;
      
      end architecture;
                 
