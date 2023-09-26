library ieee;
use ieee.std_logic_1164.all;

entity mux2x8 is
  port (
             c0: in std_logic_vector (7 downto 0);
             c1 : in std_logic_vector (7 downto 0);
             op : in std_logic;
             S : out std_logic_vector (7 downto 0)
             
       );
       end entity;
       
  architecture comuta of mux2x8 is
  begin 
  
  S <= c0 when op = '0' else c1;
  
  end architecture;
