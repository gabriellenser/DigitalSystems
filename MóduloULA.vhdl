-- operacao and

library ieee;
use ieee.std_logic_1164.all;

entity and_logic8b is
    port(
        x : in std_logic_vector(7 downto 0);
        y : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of and_logic8b is

begin

    gerador : for i in 0 to 7 generate
        ss : s(i) <= x(i) and y(i);
    end generate gerador;

end architecture;

-- operacao or

library ieee;
use ieee.std_logic_1164.all;

entity or_logic8b is
    port(
        x : in std_logic_vector(7 downto 0);
        y : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of or_logic8b is

begin

    gerador : for i in 0 to 7 generate
        ss : s(i) <= x(i) or y(i);
    end generate gerador;

end architecture;

-- operacao  not

library ieee;
use ieee.std_logic_1164.all;

entity not_logic8b is
    port(
        x : in std_logic_vector(7 downto 0);
        s : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of not_logic8b is

begin

    gerador : for i in 0 to 7 generate
        ss : s(i) <= not(x(i));
    end generate gerador;

end architecture;

-- registrador ac

library ieee;
use ieee.std_logic_1164.all;

entity reg08bit_AC is
    port(
        in_ac   : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        AC_rw   : in std_logic;
        out_ac  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of reg08bit_AC is
    component reg01bitC is
        port(
            datain  : in std_logic;
            clk     : in std_logic;
            pr, cl  : in std_logic;
            write   : in std_logic;
            dataout : out std_logic
        );
    end component;

begin
    gr: for i in 7 downto 0 generate
        ur : reg01bitC port map(in_ac(i), clk, pr, cl, AC_rw, out_ac(i));
    end generate gr;
end architecture;

-- registrador flags
library ieee;
use ieee.std_logic_1164.all;

entity flag_Ula is
  port(
      in_flag  : in std_logic_vector(1 downto 0);
      clk      : in std_logic;
      pr,cl    : in std_logic;
      flag_rw  : in std_logic;
      out_flags: out std_logic_vector(1 downto 0)
      );
end entity;
architecture arquitetura of flag_ULA is
	component reg01bitC is
		port(
		    datain  : in std_logic;
		    clk     : in std_logic;
		    pr, cl  : in std_logic;
		    write   : in std_logic;
		    dataout : out std_logic
		);
	end component;
begin

    un : reg01bitC port map(in_flag(1), clk, '1', cl, flag_rw, out_flags(1));
    uz : reg01bitC port map(in_flag(0), clk, cl, '1', flag_rw, out_flags(0));

end architecture;

-- detector nz

library ieee;
use ieee.std_logic_1164.all;

entity detector is
    port(
        x : in std_logic_vector(7 downto 0);
        out_NZ : out std_logic_vector(1 downto 0)
    );
end entity;
architecture comuta of detector is
    signal sx : std_logic;
begin
    out_NZ(1) <= x(7);

    sx <= not(x(7) or x(6) or x(5) or x(4) or x(3) or x(2) or x(1) or x(0));

    out_NZ(0) <= sx;
end architecture;


-- mux 5x8

library ieee;
use ieee.std_logic_1164.all;

entity mux5x8 is
    port(
        ent1      : in  std_logic_vector(7 downto 0);
        ent2      : in  std_logic_vector(7 downto 0);
        ula_op    : in  std_logic_vector(2 downto 0);
        out_op    : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of mux5x8 is
  --componente AND
  component and_logic8b is
      port(
          x : in std_logic_vector(7 downto 0);
          y : in std_logic_vector(7 downto 0);
          s : out std_logic_vector(7 downto 0)
      );
  end component;
  --Componente ADD
  component fadder8 is
    port (
      a, b : in std_logic_vector(7 downto 0);
      cin  : in std_logic;
      s    : out std_logic_vector(7 downto 0);
      cout : out std_logic
    );
  end component;
  --Componente NOT
  component not_logic8b is
      port(
          x : in std_logic_vector(7 downto 0);
          s : out std_logic_vector(7 downto 0)
      );
  end component;
  --Componente OR
  component or_logic8b is
      port(
          x : in std_logic_vector(7 downto 0);
          y : in std_logic_vector(7 downto 0);
          s : out std_logic_vector(7 downto 0)
      );
  end component;

  Signal sor, sand, sadd, snot: std_logic_vector(7 downto 0);
  Signal scout: std_logic;

begin
  pand : and_logic8b port map (ent1, ent2, sand);
  padd : fadder8     port map (ent1, ent2, '0', sadd, scout);
  pnot : not_logic8b port map (ent1, snot);
  por  : or_logic8b  port map (ent1, ent2, sor);

    out_op <= ent2 when ula_op = "000" else
		          sadd when ula_op = "001" else
		          sor  when ula_op = "010" else
		          sand when ula_op = "011" else
		          snot when ula_op = "100" else
		 (others =>'Z');


end architecture;


-- ula completa

library ieee;
use ieee.std_logic_1164.all;

entity ULA_COMPLETA is
  port(
      mem_rw, AC_rw  : in std_logic;
      cl, clk        : in std_logic;
      ula_op         : in std_logic_vector (2 downto 0);
      int_barramento : inout std_logic_vector (7 downto 0);
      int_flag       : out std_logic_vector (1 downto 0)
      );
end entity;
architecture arquitetura of ULA_COMPLETA is
-- component da ula
	component mux5x8 is
	    port(
		ent1      : in  std_logic_vector(7 downto 0);
		ent2      : in  std_logic_vector(7 downto 0);
		ula_op    : in  std_logic_vector(2 downto 0);
		out_op    : out std_logic_vector(7 downto 0)
	    );
	end component;
-- component do AC
	component reg08bit_AC is
	    port(
		in_ac  : in std_logic_vector(7 downto 0);
		clk    : in std_logic;
		pr, cl : in std_logic;
		AC_rw  : in std_logic;
		out_ac : out std_logic_vector(7 downto 0)
	    );
	end component;
-- component da FLAG
	component flag_ULA is
	  port(
	      in_flag  : in std_logic_vector(1 downto 0);
	      clk      : in std_logic;
	      pr,cl    : in std_logic;
	      flag_rw    : in std_logic;
	      out_flags: out std_logic_vector(1 downto 0)
	      );
	end component;
--detector  NZ
	component detector is
		port(
			x : in std_logic_vector(7 downto 0);
			out_NZ : out std_logic_vector(1 downto 0)
		);
	end component;

	signal s_ac2ula, s_ula2ac : std_logic_vector(7 downto 0);
	signal s_nz2flag : std_logic_vector(1 downto 0);
	signal ssel: std_logic_vector(2 downto 0);
begin

  ac : reg08bit_AC port map(s_ula2ac, clk, '1', cl, AC_rw, s_ac2ula);

  ula: mux5x8 port map(s_ac2ula, int_barramento, ula_op, s_ula2ac);

  nz: detector port map(s_ula2ac, s_nz2flag);

  flag: flag_ULA port map(s_nz2flag, clk, '1', cl, AC_rw, int_flag);

-- barramento
	int_barramento	<= s_ac2ula when mem_rw = '1' else (others => 'Z');
end architecture;
