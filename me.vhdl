library ieee;
use ieee.std_logic_1164.all;
	    

entity me is
port  (

             reset, clock : in std_logic;
             vintcinc, cinq : in std_logic;
             rec, disp, cof, dev : out std_logic
             
          );
          
          end entity me;
          
architecture arq of me is
    component FEA is
        port
        (
            vintcinc, cinq : in std_logic;
            e : in  std_logic_vector(2 downto 0);
            e_out : out std_logic_vector (2 downto 0)
        );
        
    end component FEA;

	
component bancoReg3 is
         port 
         (
            ein     : in std_logic_vector(2 downto 0);
            rst, clk : in std_logic;
            eout    : out std_logic_vector(2 downto 0)
            
         );   
            
    end component bancoReg3;
            
component SEA is
        port (
            e  : in std_logic_vector(2 downto 0);
            rec, disp, cof, dev  : out std_logic
            
        );
        
    end component SEA;
         

signal se, seout : std_logic_vector(2 downto 0);

begin 

u_FEA : FEA port map(vintcinc, cinq, se, seout);
u_reg : bancoReg3 port map(seout, reset, clock, se);
u_SEA : SEA port map(se, rec, disp, cof, dev);


end architecture;

