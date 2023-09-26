library ieee;
use ieee.std_logic_1164.all;

entity fadder8 is
     port (
     
     x : in std_logic_vector (7 downto 0);
     y : in std_logic_vector (7 downto 0);
     Cin_Geral : in std_logic;
     S : out std_logic_vector (7 downto 0);
     Cout_Geral : out std_logic
     
     );
     
     end entity;
     
     architecture comuta of fadder8 is
     component fadder1 is
     port (
     
           x : in std_logic;
           y : in std_logic;
           Cin : std_logic;
           S : out std_logic;
           Cout : out std_logic
           
           );
           
           end component;
           
     signal cout : std_logic_vector (7 downto 0);    
     begin
     
     u_fadder0 : fadder1 port map (x(0), y(0), Cin_Geral, S(0), Cout(0));  
     u_fadder1 : fadder1 port map (x(1), y(1), Cout(0), S(1), Cout(1));  
     u_fadder2 : fadder1 port map (x(2), y(2), Cout(1), S(2), Cout(2));  
     u_fadder3 : fadder1 port map (x(3), y(3), Cout(2), S(3), Cout(3));  
     u_fadder4 : fadder1 port map (x(4), y(4), Cout(3), S(4), Cout(4));  
     u_fadder5 : fadder1 port map (x(5), y(5), Cout(4), S(5), Cout(5));  
     u_fadder6 : fadder1 port map (x(6), y(6), Cout(5), S(6), Cout(6));  
     u_fadder7 : fadder1 port map (x(7), y(7), Cout(6), S(7), Cout_Geral);  
     
     end architecture;
          
     
