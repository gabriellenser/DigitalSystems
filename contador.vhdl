library ieee;
use ieee.std_logic_1164.all;
entity contador is
		port(
		reset : in std_logic;
		sclk : in std_logic;
		q : out std_logic_vector(3 downto 0)
		);
end contador;

architecture test of contador is 

component ffjk_process is  
	port(   
                  j, k   : in  std_logic;
		   clock  : in  std_logic; 
		   pr, cl : in  std_logic; 
	           q, nq  : out std_logic  
);
end component;

signal sj, sk : std_logic_vector(3 downto 0);
signal sq, snq : std_logic_vector(3 downto 0);

begin 
	
	u0 : ffjk_process port map(sj(0), sk(0), sclk, '1', reset, sq(0), snq(0));
   u1 : ffjk_process port map(sj(1), sk(1), sclk, '1', reset, sq(1), snq(1));
   u2 : ffjk_process port map(sj(2), sk(2), sclk, reset, '1', sq(2), snq(2));
   u3 : ffjk_process port map(sj(3), sk(3), sclk, '1', reset, sq(3), snq(3));

	q <= sq;


	sj(3) <= (sq(1)) and (sq(2) xor sq(0));
	sk(3) <= (not(sq(2)) and not(sq(0))) or (sq(2) and not(sq(1)) and sq(0));
	
	sj(2) <= (not(sq(0)) and sq(3)) or (not (sq(3)) and sq(0) and sq(1));
	sk(2) <= (sq(3)) and not (sq(1));
	
	sj(1) <= (not sq(3) and sq(0)) or (not sq(0) and sq(3) and sq(2));
        sk(1) <= (not(sq(3)) and sq(0)) or (sq(3) and not(sq(0))) or (sq(3) and not(sq(2)));
	
        sj(0) <= not(sq(3)) or sq(2);
	sk(0) <= (not sq(3) or not(sq(1)) or sq(2));
	
end architecture test;
