library ieee;
use ieee.std_logic_1164.all;

 entity NEANDER_COMPLETO is
    port(
        cl, clk : in std_logic
        );
 end entity;

 architecture comportamento of NEANDER_COMPLETO is
 --NEANDER
--ULA COMPLETA
	component ULA_COMPLETA is
	  port(
	      mem_rw, AC_rw  : in std_logic;
	      cl, clk        : in std_logic;
	      ula_op         : in std_logic_vector (2 downto 0);
	      int_barramento : inout std_logic_vector (7 downto 0);
	      int_flag       : out std_logic_vector ( 1 downto 0)
	      );
	end component;
--MEMORIA COMPLETA
	component MEMORIA_COMPLETA is
	  port(
	      barr_pc, rem_rw, mem_rw, rdm_rw : in std_logic;
	      cl, clk                         : in std_logic;
	      end_barr, end_pc                : in std_logic_vector (7 downto 0);
	      int_barramento                  : inout std_logic_vector (7 downto 0)
	      );
	end component;
-- PC COMPLETO
	component PC_COMPLETO is
		port(
			barr             : in std_logic_vector(7 downto 0);
			clk              : in std_logic;
			cl               : in std_logic;
			pc_rw, barr_inc  : in std_logic;
			s_endpc2mem      : out std_logic_vector(7 downto 0)
		);
	end component;
-- UC COMPLETO
	component UC_COMPLETA is
		port(
			cl, clk, s_ri_rw : in std_logic;
      nz               : in std_logic_vector(1 downto 0);
      int_barramento   : in std_logic_vector(7 downto 0);
      uc_out           : out std_logic_vector(10 downto 0)
    );
	end component;

--signals

	signal sint_flag: std_logic_vector(1 downto 0);
	signal s_endpc2mem, sint_barramento: std_logic_vector(7 downto 0);
	signal s_uc_out: std_logic_vector(10 downto 0);

begin
--port map
s_ula: ULA_COMPLETA port map(s_uc_out(3), s_uc_out(4), cl, clk, s_uc_out(8 downto 6), sint_barramento, sint_flag);
s_mem: MEMORIA_COMPLETA port map(s_uc_out(9), s_uc_out(2), s_uc_out(3), s_uc_out(1), cl, clk, sint_barramento, s_endpc2mem, sint_barramento);
s_pc: PC_COMPLETO port map(sint_barramento, clk, cl, s_uc_out(5), s_uc_out(10), s_endpc2mem);
s_MC: UC_COMPLETA port map(cl, clk, s_uc_out(0), sint_flag, sint_barramento, s_uc_out);
end comportamento;
