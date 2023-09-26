library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
end entity;

architecture fulladd of fulladder is
   component neg is
      port(
             y : in std_logic_vector ( 7 downto 0);
             s : out std_logic_vector (7 downto 0)
            );
   end component;

   component fadder8 is
      port(

            x : in std_logic_vector (7 downto 0);
            y : in std_logic_vector (7 downto 0);
            Cin_Geral : in std_logic;
            S : out std_logic_vector (7 downto 0);
            Cout_Geral : out std_logic
     
            );
    end component;

   component mux2x8 is
      port (
             c0: in std_logic_vector (7 downto 0);
             c1 : in std_logic_vector (7 downto 0);
             op : in std_logic;
             S : out std_logic_vector (7 downto 0)
            );

   end component;

   signal SYgeral : std_logic_vector (7 downto 0);
   signal ssdeneg : std_logic_vector (7 downto 0);
   signal sx : std_logic_vector (7 downto 0);
   signal sy : std_logic_vector (7 downto 0);
   signal sCin_Geral : std_logic;
   signal sresult : std_logic_vector (7 downto 0);
   signal sCout_Geral : std_logic;
   signal sc0 : std_logic_vector (7 downto 0);
   signal sc1 : std_logic_vector (7 downto 0);
   signal sop : std_logic;
   signal sSmux : std_logic_vector (7 downto 0);
   
   begin
      u_neg : neg port map(SYgeral, ssdeneg);
      umux2x8 : mux2x8 port map(sc0, sc1, sop, sSmux);
      sc0 <= SYgeral (7 downto 0);
      sc1 <= ssdeneg (7 downto 0);
      ufadder8 : fadder8 port map(sx, sy, sCin_Geral, sresult, sCout_Geral);
      sy <= sSmux (7 downto 0);
      SCin_Geral <= sop;
   u_fulladder : process 
   begin

      sx <= "00000000";
      SYgeral <= "11111111";
      sop <= '0';
      wait for 100 ns;

      sx <= "00000000";
      SYgeral <= "11111111";
      sop <= '1';
      wait for 100 ns;

      sx <= "11111111";
      SYgeral <= "00000000";
      sop <= '0';
      wait for 100 ns;
   
      sx <= "11111111";
      SYgeral <= "00000000";
      sop <= '1';
      wait for 100 ns;

      sx <= "00010110";
      SYgeral <= "00010001";
      sop <= '0';
      wait for 100 ns;

      sx <= "00010110";
      SYgeral <= "00010001";
      sop <= '1';
      wait for 100 ns;

      wait;
   end process;
end architecture;
