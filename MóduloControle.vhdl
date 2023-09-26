-- Parte 1 do controle 

-- registrador pc

library ieee;
use ieee.std_logic_1164.all;

entity reg08bit_PC is
    port(
        in_pc  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        pc_rw  : in std_logic;
        out_rw : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of reg08bit_PC is
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
        ur : reg01bitC port map(in_pc(i), clk, pr, cl, pc_rw, out_rw(i));
    end generate gr;
end architecture;

-- mux 2x8

library ieee;
use ieee.std_logic_1164.all;

entity mux2x8_PC is
    port(
        c0  : in  std_logic_vector(7 downto 0);
        c1  : in  std_logic_vector(7 downto 0);
        barr_inc : in  std_logic;
        s_mux2pc  : out std_logic_vector(7 downto 0);
        zc  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of mux2x8_PC is
begin
    
    s_mux2pc(0) <= (c0(0) and not(barr_inc)) or (c1(0) and barr_inc); 
    s_mux2pc(1) <= (c0(1) and not(barr_inc)) or (c1(1) and barr_inc); 
    s_mux2pc(2) <= (c0(2) and not(barr_inc)) or (c1(2) and barr_inc); 
    s_mux2pc(3) <= (c0(3) and not(barr_inc)) or (c1(3) and barr_inc); 
    s_mux2pc(4) <= (c0(4) and not(barr_inc)) or (c1(4) and barr_inc); 
    s_mux2pc(5) <= (c0(5) and not(barr_inc)) or (c1(5) and barr_inc); 
    s_mux2pc(6) <= (c0(6) and not(barr_inc)) or (c1(6) and barr_inc); 
    s_mux2pc(7) <= (c0(7) and not(barr_inc)) or (c1(7) and barr_inc);

 
    zc <= c0 when barr_inc = '0' else c1;

end architecture;



-- PC Completo
library ieee;
use ieee.std_logic_1164.all;

entity PC_COMPLETO is
    port(
        barr            : in std_logic_vector(7 downto 0);
        clk             : in std_logic;
        cl              : in std_logic;
        pc_rw, barr_inc : in std_logic;
        s_endpc2mem     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of PC_COMPLETO is
--add
    component fadder8 is
        port (
        a, b : in std_logic_vector(7 downto 0);
            cin  : in std_logic;
            s    : out std_logic_vector(7 downto 0);
            cout : out std_logic
        );
    end component;
--mux_2x8
    component mux2x8_PC is
        port(
            c0  : in  std_logic_vector(7 downto 0);
            c1  : in  std_logic_vector(7 downto 0);
            barr_inc : in  std_logic;
            s_mux2pc  : out std_logic_vector(7 downto 0);
            zc  : out std_logic_vector(7 downto 0)
        );
    end component;
--PC_Reg
    component reg08bit_PC is
        port(
            in_pc  : in std_logic_vector(7 downto 0);
            clk     : in std_logic;
            pr, cl  : in std_logic;
            pc_rw  : in std_logic;
            out_rw : out std_logic_vector(7 downto 0)
        );
    end component;
    signal scout : std_logic;
    signal s_add, s_mux2pc, s_pcatual, szc : std_logic_vector(7 downto 0);
begin
--port map do ADD
add: fadder8 port map("00000001",  s_pcatual, '0', s_add, scout);
--port map do MUX
mux: mux2x8_PC port map(barr, s_add, barr_inc, s_mux2pc, szc);
--port map do PC
pc: reg08bit_PC port map(s_mux2pc, clk, '1', cl, pc_rw, s_pcatual);
--
s_endpc2mem <= s_pcatual;

end architecture;


-- PARTE DA UC

-- registrador ri

library ieee;
use ieee.std_logic_1164.all;

entity reg08bit_RI is
    port(
        in_str  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        ri_rw   : in std_logic;
        out_str : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of reg08bit_RI is
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
        ur : reg01bitC port map(in_str(i), clk, pr, cl, ri_rw, out_str(i));
    end generate gr;
end architecture;

-- decodificador

library ieee;
use ieee.std_logic_1164.all;

entity decodificador is
    port(
        in_str   : in std_logic_vector(7 downto 0);
        s        : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of decodificador is

begin
        s <= "10000000000" when in_str = "00000000" else   --nop
             "01000000000" when in_str = "00010000" else   --sta
             "00100000000" when in_str = "00100000" else   --lda
             "00010000000" when in_str = "00110000" else   --add
             "00001000000" when in_str = "01000000" else   --or
             "00000100000" when in_str = "01010000" else   --and
             "00000010000" when in_str = "01100000" else   --not
             "00000001000" when in_str = "10000000" else   --jmp
             "00000000100" when in_str = "10010000" else   --jn
             "00000000010" when in_str = "10100000" else   --jz
             "00000000001" when in_str = "11110000" else   --hlt
             (others => 'Z');

end architecture;

-- counter

library ieee;
use ieee.std_logic_1164.all;

entity ctrljk is
	port(
		ea : in std_logic_vector(2 downto 0);
		j : out std_logic_vector(2 downto 0);
		k : out std_logic_vector(2 downto 0)
	
	  );
end entity;

architecture controle of ctrljk is

begin	
	--jk2
	j(2) <= ea(1) and ea(0);
	k(2) <= ea(1) and ea(0);
	
	--jk1
	j(1) <=  ea(0);
	k(1) <= ea(1) and ea(0);
	
	--jk0
	j(0) <= '1';
	k(0) <= '1';
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity contador is
	port(
		 clk, cl : in std_logic;
		 v : out std_logic_vector(2 downto 0)
	 );
end entity;

architecture contar of contador is

	component ffjk is
	    port(
		j, k   : in std_logic;
		clk    : in std_logic;
		pr, cl : in std_logic;
		q, nq  : out std_logic
	    );
	end component;

	component ctrljk is
	port(
		ea : in std_logic_vector(2 downto 0);
		j : out std_logic_vector(2 downto 0);
		k : out std_logic_vector(2 downto 0)

	  );
end component;

	signal sv :std_logic_vector(2 downto 0);
	signal sj, sk : std_logic_vector(2 downto 0);

begin

	v <= sv;
	--ff bit 0 até 2
	gerador : for i in 2 downto 0 generate
		ff : ffjk port map(sj(i), sk(i), clk, '1', cl, sv(i));
	end generate gerador;

	--CTRL jk
	uctrljk : ctrljk port map(sv, sj, sk);

end architecture;

-- operacoes

-- operacao lda
library ieee;
use ieee.std_logic_1164.all;

entity LDA is
    port(
        b      : in std_logic_vector(2 downto 0);
        ldaout : out std_logic_vector(10 downto 0)
        
        -- ldaout (10) = barr_inc
        -- ldaout (9) = pc_inc
        -- ldaout (8 downto 6) = ula_op
        -- ldaout (5) = pc_rw
        -- ldaout (4) = ac_rw
        -- ldaout (3) = mem_rw
        -- ldaout (2) = rem_rw
        -- ldaout (1) = rdm_rw
        -- ldaout (0) = ri_rw
        );
end entity;

architecture comp of LDA is
begin
       ldaout(10) <= '1';
       ldaout(9) <= not(b(2)) or b(1) or not(b(0));
       ldaout(8 downto 6) <= "000";
       ldaout(5) <= not b(1) and (b(2) xor b(0)); 
       ldaout(4) <= b(2) and (b(1) and b(0));        
       ldaout(3) <= '0';
       ldaout(2) <= (not b(1) and (b(2) xnor b(0))) or (not b(2) and b(1) and b(0));
       ldaout(1) <= (b(2) and not b(0)) or (not b(2) and not b(1) and b(0));
       ldaout(0) <= not(b(2)) and b(1) and not(b(0));
end architecture;

-- operacao add

library ieee;
use ieee.std_logic_1164.all;

entity ADD is
    port(
        b      : in std_logic_vector(2 downto 0);
        addout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of ADD is
begin
       addout(10) <= '1';
       addout(9) <= not(b(2)) or b(1) or not(b(0));
       addout(8 downto 6) <= "001";
       addout(5) <= not b(1) and (b(2) xor b(0)); 
       addout(4) <= b(2) and (b(1) and b(0)); 
       addout(3) <= '0';
       addout(2) <= (not b(1) and (b(2) xnor b(0))) or (not b(2) and b(1) and b(0));
       addout(1) <= (b(2) and not b(0)) or (not b(2) and not b(1) and b(0));
       addout(0) <= not(b(2)) and b(1) and not(b(0));
end architecture;

-- operacao and

library ieee;
use ieee.std_logic_1164.all;

entity AND_UC is
    port(
        b      : in std_logic_vector(2 downto 0);
        andout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of AND_UC is
begin
       andout(10) <= '1';
       andout(9) <= not(b(2)) or b(1) or not(b(0));
       andout(8 downto 6) <= "011";
       andout(5) <= not b(1) and (b(2) xor b(0)); 
       andout(4) <= b(2) and (b(1) and b(0)); 
       andout(3) <= '0';
       andout(2) <= (not b(1) and (b(2) xnor b(0))) or (not b(2) and b(1) and b(0));
       andout(1) <= (b(2) and not b(0)) or (not b(2) and not b(1) and b(0));
       andout(0) <= not(b(2)) and b(1) and not(b(0));
end architecture;


-- operacao or

library ieee;
use ieee.std_logic_1164.all;

entity OR_UC is
    port(
        b     : in std_logic_vector(2 downto 0);
        orout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of OR_UC is
begin
      orout(10)  <='1';
      orout(9)  <= not(b(2)) or b(1) or not(b(0));
      orout(8 downto 6)  <= "010";
      orout(5)  <= not b(1) and (b(2) xor b(0)); 
      orout(4)  <= b(2) and (b(1) and b(0)); 
      orout(3)  <= '0';
      orout(2)  <= (not b(1) and (b(2) xnor b(0))) or (not b(2) and b(1) and b(0));
      orout(1)  <= (b(2) and not b(0)) or (not b(2) and not b(1) and b(0));
      orout(0)  <= not(b(2)) and b(1) and not(b(0));
end architecture;

-- operacao nop

library ieee;
use ieee.std_logic_1164.all;

entity NOP is
    port(
            b      : in std_logic_vector(2 downto 0);
            nopout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of NOP is
begin
       nopout(10) <= '1';
       nopout(9) <= '1';
       nopout(8 downto 6) <= "000";
       nopout(5) <= not b(2) and not b(1) and b(0);
       nopout(4) <= '0';
       nopout(3) <= '0';
       nopout(2) <= not b(2) and not b(1) and not b(0);
       nopout(1) <= not(b(2)) and not(b(1)) and b(0);
       nopout(0) <= not(b(2)) and b(1) and not(b(0));
end architecture;


-- operacao not

library ieee;
use ieee.std_logic_1164.all;

entity NOT_UC is
    port(
            b : in std_logic_vector(2 downto 0);
            notout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of NOT_UC is
begin
       notout(10) <= '1';
       notout(9)  <= '1';
       notout(8 downto 6) <= "100";
       notout(5)  <= not b(2) and not b(1) and b(0);
       notout(4)  <= b(2) and b(1) and b(0);
       notout(3)  <= '0';
       notout(2)  <= not b(2) and not b(1) and not b(0);
       notout(1)  <= not(b(2)) and not(b(1)) and b(0);
       notout(0)  <= not(b(2)) and b(1) and not(b(0));
end architecture;

-- operacao sta

library ieee;
use ieee.std_logic_1164.all;

entity STA is
    port(
            b      : in std_logic_vector(2 downto 0);
            
            staout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of STA is
begin
       staout(10) <= '1';
       staout(9)  <= not(b(2));
       staout(8 downto 6) <= "000";
       staout(5)  <= (not(b(2)) and not(b(1)) and b(0)) or (b(2) and not(b(1)) and not(b(0)));
       staout(4)  <= '0';
       staout(3)  <= b(2) and b(1) and not(b(0));
       staout(2)  <= not(b(2) or b(1) or b(0)) or (not(b(2)) and b(1) and b(0)) or (b(2) and not(b(1)) and b(0));
       staout(1)  <= (not(b(2)) and not(b(1)) and b(0)) or (b(2) and not(b(1)) and not(b(0)));
       staout(0)  <= not(b(2)) and b(1) and not(b(0));
end architecture;

-- operacao jmp

library ieee;
use ieee.std_logic_1164.all;

entity JMP is
    port(
        b      : in std_logic_vector(2 downto 0);
        jmpout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of JMP is
begin
       jmpout(10) <= not(b(0)) or not(b(2)) or b(1);
       jmpout(9) <= '1';
       jmpout(8 downto 6) <= "000";
       jmpout(5) <= not(b(1)) and b(0);
       jmpout(4) <= '0';
       jmpout(3) <= '0';
       jmpout(2) <= not(b(2) or b(1) or b(0)) or (not(b(2)) and b(1) and b(0));
       jmpout(1) <= not(b(1)) and (b(2) or b(0)) and (not(b(2)) or not(b(0)));
       jmpout(0) <= not(b(2)) and b(1) and not(b(0));
end architecture;

--operacao jn

library ieee;
use ieee.std_logic_1164.all;

entity JN is
    port(
        b : in std_logic_vector(2 downto 0);
        n : in std_logic;
       
        jnout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of JN is

  signal sjntout, sjnfout : std_logic_vector(10 downto 0);

begin

        -- true
		    sjntout(10) <= not(b(0)) or not(b(2)) or b(1);
		    sjntout(9) <= '1';
		    sjntout(8 downto 6) <= "000";
		    sjntout(5) <= not(b(1)) and b(0);
		    sjntout(4) <= '0';
		    sjntout(3) <= '0';
		    sjntout(2) <= not(b(2) or b(1) or b(0)) or (not(b(2)) and b(1) and b(0));
		    sjntout(1) <= not(b(1)) and (b(2) or b(0)) and (not(b(2)) or not(b(0)));
		    sjntout(0) <= not(b(2)) and b(1) and not(b(0));

		    -- false
			  sjnfout(10) <= '1';
			  sjnfout(9) <= '1' ;
			  sjnfout(8 downto 6) <= "000";
			  sjnfout(5) <= b(0) and not(b(2));
			  sjnfout(4) <= '0';
			  sjnfout(3) <= '0';
			  sjnfout(2) <= not(b(2)) and not(b(1)) and not(b(0));
			  sjnfout(1) <= not(b(2)) and not(b(1)) and b(0);
			  sjnfout(0) <= not(b(2)) and b(1) and not(b(0));

        jnout <= sjntout when n = '1' else sjnfout;

end comp;

-- operacao jz

library ieee;
use ieee.std_logic_1164.all;

entity JZ is
    port(
        b     : in std_logic_vector(2 downto 0);
        z     : in std_logic;
        jzout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of JZ is

signal sjztout, sjzfout : std_logic_vector(10 downto 0);

begin

    -- true
		sjztout(10) <= not(b(0)) or not(b(2)) or b(1);
		sjztout(9) <= '1';
		sjztout(8 downto 6) <= "000";
		sjztout(5) <= not(b(1)) and b(0);
		sjztout(4) <= '0';
		sjztout(3) <= '0';
		sjztout(2) <= not(b(2) or b(1) or b(0)) or (not(b(2)) and b(1) and b(0));
		sjztout(1) <= not(b(1)) and (b(2) or b(0)) and (not(b(2)) or not(b(0)));
		sjztout(0) <= not(b(2)) and b(1) and not(b(0));

    -- false
		sjzfout(10) <= '1';
		sjzfout(9) <= '1' ;
		sjzfout(8 downto 6) <= "000";
		sjzfout(5) <= b(0) and not(b(2));
		sjzfout(4) <= '0';
		sjzfout(3) <= '0';
		sjzfout(2) <= not(b(2)) and not(b(1)) and not(b(0));
		sjzfout(1) <=  not(b(2)) and not(b(1)) and b(0);
		sjzfout(0) <= not(b(2)) and b(1) and not(b(0));

    jzout <= sjztout when z = '1' else sjzfout;

end architecture;

-- operacao hlt

library ieee;
use ieee.std_logic_1164.all;

entity HLT is
    port(
        b      : in std_logic_vector(2 downto 0);
        hltout : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of HLT is
begin
       hltout(10) <='0';
       hltout(9) <= '0';
       hltout(8 downto 6) <= "000";
       hltout(5) <= '0';
       hltout(4) <= '0';
       hltout(3) <= '0';
       hltout(2) <= '0';
       hltout(1) <=  '0';
       hltout(0) <= '0';
end architecture;


-- uc pequena

library ieee;
use ieee.std_logic_1164.all;

entity Unidade_controle is
    port(
        cl,clk : in std_logic;
        nz     : in std_logic_vector(1 downto 0);
        dec2uc : in std_logic_vector(10 downto 0);
        s_uc   : out std_logic_vector(10 downto 0)
        );
end entity;

architecture comp of Unidade_controle is
    --nop
  component nop is
        port(
              b      : in std_logic_vector(2 downto 0);
              nopout : out std_logic_vector(10 downto 0)
            );
    end component;
    --lda
    component LDA is
        port(
              b      : in std_logic_vector(2 downto 0);
              ldaout : out std_logic_vector(10 downto 0)
            );
    end component;
    --add
    component ADD is
        port(
              b      : in std_logic_vector(2 downto 0);
              addout : out std_logic_vector(10 downto 0)
            );
    end component;
    --sta
   component STA is
        port(
              b      : in std_logic_vector(2 downto 0);
              staout : out std_logic_vector(10 downto 0)
            );
    end component;
    --and
    component AND_UC is
        port(
              b      : in std_logic_vector(2 downto 0);
              andout : out std_logic_vector(10 downto 0)
            );
    end component;
    --or
    component OR_UC is
        port(
              b     : in std_logic_vector(2 downto 0);
              orout : out std_logic_vector(10 downto 0)
            );
    end component;
    --not
    component NOT_UC is
        port(
              b      : in std_logic_vector(2 downto 0);
              notout : out std_logic_vector(10 downto 0)
            );
    end component;
    --jmp
    component JMP is
        port(
              b      : in std_logic_vector(2 downto 0);
              jmpout : out std_logic_vector(10 downto 0)
            );
    end component;
    --jn
    component JN is
        port(
              b     : in std_logic_vector(2 downto 0);
              n     : in std_logic;
              jnout : out std_logic_vector(10 downto 0)
            );
    end component;
    --jz
    component JZ is
        port(
              b     : in std_logic_vector(2 downto 0);
              z     : in std_logic;
              jzout : out std_logic_vector(10 downto 0)
            );
    end component;
--hlt
    component HLT is
        port(
              b      : in std_logic_vector(2 downto 0);
              hltout : out std_logic_vector(10 downto 0)
            );
    end component;
--counter
    component contador is
        port(
            clk, cl : in std_logic;
            v : out std_logic_vector(2 downto 0)
        );
    end component;

    signal s_counter, s_ula_op : std_logic_vector(2 downto 0);
    signal s_barr_nop, s_barr_lda, s_barr_add, s_barr_sta, s_barr_and, s_barr_or, s_barr_not, s_barr_jmp, s_barr_jn, s_barr_jz, s_barr_hlt: std_logic_vector(10 downto 0);
begin
--port maps
u_cont: contador port map(clk, cl, s_counter);
--
u_nop: NOP port map(s_counter, s_barr_nop);
--
u_lda: LDA port map(s_counter, s_barr_lda);
--
u_sta: STA port map(s_counter, s_barr_sta);
--
u_and: AND_UC port map(s_counter, s_barr_and);
--
u_or: OR_UC port map(s_counter, s_barr_or);
--
u_not: NOT_UC port map(s_counter, s_barr_not);
--
u_jmp: JMP port map(s_counter, s_barr_jmp);
--
u_jn: JN port map(s_counter, nz(1), s_barr_jn);
--
u_jz: JZ port map(s_counter, nz(0), s_barr_jz);
--
u_add: ADD port map(s_counter, s_barr_add);
--
u_hlt: HLT port map(s_counter, s_barr_hlt);


--barramentos
s_uc <= s_barr_nop when dec2uc = "10000000000" else
        s_barr_sta when dec2uc = "01000000000" else
        s_barr_lda when dec2uc = "00100000000" else
        s_barr_add when dec2uc = "00010000000" else
        s_barr_or  when dec2uc = "00001000000" else
        s_barr_and when dec2uc = "00000100000" else
        s_barr_not when dec2uc = "00000010000" else
        s_barr_jmp when dec2uc = "00000001000" else
        s_barr_jn  when dec2uc = "00000000100" else
        s_barr_jz  when dec2uc = "00000000010" else
        s_barr_hlt when dec2uc = "00000000001" else
        (others => 'Z');
end architecture;

-- uc completa

library ieee;
use ieee.std_logic_1164.all;

entity UC_COMPLETA is
    port(
			cl, clk, s_ri_rw : in std_logic;
      nz               : in std_logic_vector(1 downto 0);
      int_barramento   : in std_logic_vector(7 downto 0);
      uc_out           : out std_logic_vector(10 downto 0)
    );
end entity;

architecture comp of UC_COMPLETA is
--RI
component reg08bit_RI is
    port(
        in_str  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        ri_rw   : in std_logic;
        out_str : out std_logic_vector(7 downto 0)
    );
end component;
--DECODIFICADOR
    component decodificador is
        port(
            in_str   : in std_logic_vector(7 downto 0);
            s        : out std_logic_vector(10 downto 0)
            );
    end component;
--UC
    component Unidade_controle is
        port(
            cl,clk : in std_logic;
            nz     : in std_logic_vector(1 downto 0);
            dec2uc : in std_logic_vector(10 downto 0);
            s_uc   : out std_logic_vector(10 downto 0)
            );
    end component;

    signal s_ri     : std_logic_vector(7 downto 0);
    signal s_dec2uc : std_logic_vector(10 downto 0);
begin
--port maps
ri: reg08bit_RI port map(int_barramento, clk, '1', cl, s_ri_rw, s_ri);
dc: decodificador port map(s_ri, s_dec2uc);
uc: Unidade_controle port map(cl, clk, nz, s_dec2uc, uc_out);
end architecture;
