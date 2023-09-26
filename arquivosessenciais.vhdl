-- FlipFlop JK ======================================================
library ieee;
use ieee.std_logic_1164.all; -- std_logic para detectar erros

entity ffjk is
    port(
        j, k   : in std_logic;
        clk    : in std_logic;
        pr, cl : in std_logic;
        q, nq  : out std_logic
    );
end entity;

architecture latch of ffjk is
    signal sq  : std_logic := '0'; -- opcional -> valor inicial
    signal snq : std_logic := '1';
begin

    q  <= sq;
    nq <= snq;

    u_ff : process (clk, pr, cl)
    begin
        -- pr = 0 e cl = 0 -> Desconhecido
        if (pr = '0') and (cl = '0') then
            sq  <= 'X';
            snq <= 'X';
            -- prioridade para cl
            elsif (pr = '1') and (cl = '0') then
                sq  <= '0';
                snq <= '1';
                -- tratamento de pr
                elsif (pr = '0') and (cl = '1') then
                    sq  <= '1';
                    snq <= '0';
                    -- pr e cl desativados
                    elsif (pr = '1') and (cl = '1') then
                        if falling_edge(clk) then
                            -- jk = 00 -> mantém estado
                            if    (j = '0') and (k = '0') then
                                sq  <= sq;
                                snq <= snq;
                            -- jk = 01 -> q = 0
                            elsif (j = '0') and (k = '1') then
                                sq  <= '0';
                                snq <= '1';
                            -- jk = 01 -> q = 1
                            elsif (j = '1') and (k = '0') then
                                sq  <= '1';
                                snq <= '0';
                            -- jk = 11 -> q = !q
                            elsif (j = '1') and (k = '1') then
                                sq  <= not(sq);
                                snq <= not(snq);
                            -- jk = ?? -> falha
                            else
                                sq  <= 'U';
                                snq <= 'U';
                            end if;
                        end if;
            else
                sq  <= 'X';
                snq <= 'X';
        end if;
    end process;

end architecture;



-- FlipFlop D =======================================================
library ieee;
use ieee.std_logic_1164.all; -- std_logic para detectar erros

entity ffd is
    port(
        d      : in std_logic;
        clk    : in std_logic;
        pr, cl : in std_logic;
        q, nq  : out std_logic
    );
end entity;

architecture latch of ffd is
    component ffjk is
        port(
            j, k   : in std_logic;
            clk    : in std_logic;
            pr, cl : in std_logic;
            q, nq  : out std_logic
        );
    end component;

    signal nj  : std_logic;
begin

    u_td : ffjk port map(d, nj, clk, pr, cl, q, nq);
    nj <= not(d);

end architecture;


-- adder

library ieee;
use ieee.std_logic_1164.all;

entity fadder1 is
  port (
  a, b : in std_logic;
  cin  : in std_logic;
  s    : out std_logic;
  cout : out std_logic
  );
end fadder1;

architecture behavior_tb of fadder1 is

begin
  s <= (a xor b) xor cin;

  cout <= (a and cin) or (b and cin) or (a and b);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity fadder8 is
  port (
     a, b : in std_logic_vector(7 downto 0);
      cin  : in std_logic;
      s    : out std_logic_vector(7 downto 0);
      cout : out std_logic
    );
end fadder8;

architecture behavior of fadder8 is

 component fadder1 is
  port(
       a, b : in std_logic;
	  cin  : in std_logic;
	  s    : out std_logic;
	  cout : out std_logic
	);
 end component;

  signal carry :std_logic_vector(7 downto 1);

begin
  -- instancias
  f0 : fadder1 port map(a(0), b(0), cin, s(0), carry(1));

  f1 : fadder1 port map(a(1), b(1), carry(1), s(1), carry(2));
  f2 : fadder1 port map(a(2), b(2), carry(2), s(2), carry(3));
  f3 : fadder1 port map(a(3), b(3), carry(3), s(3), carry(4));
  f4 : fadder1 port map(a(4), b(4), carry(4), s(4), carry(5));
  f5 : fadder1 port map(a(5), b(5), carry(5), s(5), carry(6));
  f6 : fadder1 port map(a(6), b(6), carry(6), s(6), carry(7));

  f7 : fadder1 port map(a(7), b(7), carry(7), s(7), cout);
end architecture;


-- registrador 1 bit

library ieee;
use ieee.std_logic_1164.all;

entity reg01bitC is
    port(
        datain  : in std_logic;
        clk     : in std_logic;
        pr, cl  : in std_logic;        
        write   : in std_logic;
        dataout : out std_logic
    );
end entity;

architecture reg of reg01bitC is

    component ffd is
        port(
            d      : in std_logic;
            clk    : in std_logic;
            pr, cl : in std_logic;
            q, nq  : out std_logic
        );
    end component;

    signal tempin, tempout, nqdump : std_logic;

begin

    -- instancia do ffd
    ur : ffd port map(tempin, clk, pr, cl, tempout, nqdump);

    -- saída principal
    dataout <= tempout;

    -- multiplex 2x1
    tempin <= datain when write='1' else tempout;

end architecture;









