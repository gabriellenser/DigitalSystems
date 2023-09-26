-- registrador rdm

library ieee;
use ieee.std_logic_1164.all;

entity reg08bit_RDM is
    port(
        in_rdm  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        rdm_rw  : in std_logic;
        out_rdm : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of reg08bit_RDM is
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
        ur : reg01bitC port map(in_rdm(i), clk, pr, cl, rdm_rw, out_rdm(i));
    end generate gr;
end architecture;

-- registrador rem

library ieee;
use ieee.std_logic_1164.all;

entity reg08bit_REM is
    port(
        in_rem  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        rem_rw  : in std_logic;
        out_rem : out std_logic_vector(7 downto 0)
    );
end entity;

architecture reg of reg08bit_REM is
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
        ur : reg01bitC port map(in_rem(i), clk, pr, cl, rem_rw, out_rem(i));
    end generate gr;
end architecture;

-- mux 2x8

library ieee;
use ieee.std_logic_1164.all;

entity mux2x8_MEM is
    port(
        c0  : in  std_logic_vector(7 downto 0);
        c1  : in  std_logic_vector(7 downto 0);
        barr_pc : in  std_logic;
        s_mux2rem  : out std_logic_vector(7 downto 0);
        zc  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture comuta of mux2x8_MEM is
begin
    
    s_mux2rem(0) <= (c0(0) and not(barr_pc)) or (c1(0) and barr_pc); 
    s_mux2rem(1) <= (c0(1) and not(barr_pc)) or (c1(1) and barr_pc); 
    s_mux2rem(2) <= (c0(2) and not(barr_pc)) or (c1(2) and barr_pc); 
    s_mux2rem(3) <= (c0(3) and not(barr_pc)) or (c1(3) and barr_pc); 
    s_mux2rem(4) <= (c0(4) and not(barr_pc)) or (c1(4) and barr_pc); 
    s_mux2rem(5) <= (c0(5) and not(barr_pc)) or (c1(5) and barr_pc); 
    s_mux2rem(6) <= (c0(6) and not(barr_pc)) or (c1(6) and barr_pc); 
    s_mux2rem(7) <= (c0(7) and not(barr_pc)) or (c1(7) and barr_pc); 

    
    zc <= c0 when barr_pc = '0' else c1;

end architecture;

-- neander asynchronous simple ram memory
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity as_ram is
	port(
		addr  : in    std_logic_vector(7 downto 0);
		data  : inout std_logic_vector(7 downto 0);
		notrw : in    std_logic;
		reset : in    std_logic
	);
end entity as_ram;

architecture behavior of as_ram is
	type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);
	signal ram : ram_type;
	signal data_out : std_logic_vector(7 downto 0);
begin
	
	rampW : process(notrw, reset, addr, data)
	type binary_file is file of character;
	file load_file : binary_file open read_mode is "neanderram.mem";
	variable char : character;
	begin
		if (reset = '0' and reset'event) then
			-- init ram
			read(load_file, char); -- 0x03 '.'
			read(load_file, char); -- 0x4E 'N'
			read(load_file, char); -- 0x44 'D'
			read(load_file, char); -- 0x52 'R'
			for i in 0 to 255 loop
				if not endfile(load_file) then
						read(load_file, char);
						ram(i) <= std_logic_vector(to_unsigned(character'pos(char),8));
						read(load_file, char);	-- 0x00 orindo de alinhamento 16bits	
				end if; -- if not endfile(load_file) then
			end loop; -- for i in 0 to 255
        else
		    if (reset = '1' and notrw = '1') then
			    -- Write
			    ram(to_integer(unsigned(addr))) <= data;
		    end if; -- reset == '1'
		end if; -- reset == '0'
	end process rampW;

	data <= data_out when (reset = '1' and notrw = '0')
		  else (others => 'Z');

	rampR : process(notrw, reset, addr, data)
	begin
		if (reset = '1' and notrw = '0') then
				-- Read
				data_out <= ram(to_integer(unsigned(addr)));
		end if; -- reset = '1' and notrw = '0'
	end process rampR;
end architecture behavior;

-- memoria completa

library ieee;
use ieee.std_logic_1164.all;

entity MEMORIA_COMPLETA is
  port(
      barr_pc, rem_rw, mem_rw, rdm_rw : in std_logic;
      cl, clk                         : in std_logic;
      end_barr, end_pc                : in std_logic_vector (7 downto 0);
      int_barramento                  : inout std_logic_vector (7 downto 0)
      );
end entity;
architecture arquitetura of MEMORIA_COMPLETA is
--component mux_2x8
component mux2x8_MEM is
    port(
        c0  : in  std_logic_vector(7 downto 0);
        c1  : in  std_logic_vector(7 downto 0);
        barr_pc : in  std_logic;
        s_mux2rem  : out std_logic_vector(7 downto 0);
        zc  : out std_logic_vector(7 downto 0)
    );
end component;
--component REM
component reg08bit_REM is
    port(
        in_rem  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        rem_rw   : in std_logic;
        out_rem : out std_logic_vector(7 downto 0)
    );
end component;
--component memoria
component as_ram is
	port(
		addr  : in    std_logic_vector(7 downto 0);
		data  : inout std_logic_vector(7 downto 0);
		notrw : in    std_logic;
		reset : in    std_logic
	);
end component;
--component RDM
component reg08bit_RDM is
    port(
        in_rdm  : in std_logic_vector(7 downto 0);
        clk     : in std_logic;
        pr, cl  : in std_logic;
        rdm_rw  : in std_logic;
        out_rdm : out std_logic_vector(7 downto 0)
	    );
end component;
 Signal szc, ss_mux2rem, s_rem2mem, s_mem2rdm, s_rdm2barramento : std_logic_vector(7 downto 0);
begin
--port map mux 2x8
mux: mux2x8_MEM port map(end_barr, end_pc, barr_pc, ss_mux2rem, szc);
--port map REM
S_rem: reg08bit_REM port map(ss_mux2rem, clk, '1', cl, rem_rw, s_rem2mem);
--port map memoria
memoria: as_ram port map(s_rem2mem, s_mem2rdm, mem_rw, cl);
--port map RDM
S_rdm: reg08bit_RDM port map(s_mem2rdm, clk, '1', cl, rdm_rw, s_rdm2barramento);

--Barramentos
int_barramento <= s_rdm2barramento when mem_rw = '0' else (others => 'Z');
s_mem2rdm      <= int_barramento when mem_rw = '1' else (others => 'Z');
end architecture;
