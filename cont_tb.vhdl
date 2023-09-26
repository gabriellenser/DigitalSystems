library ieee;
use ieee.std_logic_1164.all;
entity cont_tb is
-- entidade vazia
end cont_tb;

architecture test of cont_tb is 

constant CLK_PERIOD : time := 20 ns;

component contador is
		port(
		reset : in std_logic;
		sclk : in std_logic;
		q : out std_logic_vector(3 downto 0)
		);
end component;
   
   signal sclk : std_logic := '0';
   signal sreset : std_logic := '1';
   signal sq : std_logic_vector(3 downto 0);
   
begin

   sclk <= not(sclk) after CLK_PERIOD/2;

   test : contador port map(sreset, sclk, sq);

   --process begin
   u_tb : process 
   begin

      sreset <= '0';
      wait for CLK_PERIOD;

      sreset <= '1';
      wait for CLK_PERIOD;


      wait;
   end process;

end architecture test;
