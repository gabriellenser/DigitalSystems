library ieee;
use ieee.std_logic_1164.all;

entity FEA is
	port(
		e : in  std_logic_vector(2 downto 0); -- estado atual
		vintcinc, cinq : in std_logic; -- equivalem as entradas 25 e 50 no pdf
		e_out : out std_logic_vector (2 downto 0) -- proximo estado
	);
	
end FEA;

architecture arq of FEA is
begin 

 e_out(2) <= not(e(2)) and ((e(1) and cinq) or (vintcinc and cinq) or (e(1) and e(0) and vintcinc));
 e_out(1) <= (not(e(2)) and ((e(0) and cinq) or (not(e(1)) and cinq) or (e(1) and not(vintcinc) and not(cinq)))) or (vintcinc and (e(1) xor e(0)));
 e_out(0) <= not(e(2)) and ((e(0) xor vintcinc) or (vintcinc and cinq));
end architecture; 


