library ieee;
use ieee.std_logic_1164.all; 

entity bancoReg3 is
    port(
        ein     : in std_logic_vector(2 downto 0);
        rst, clk : in std_logic;
        eout    : out std_logic_vector(2 downto 0)
    );
end entity;

architecture storage of bancoReg3 is
    component ffd is
        port
        (
            d      : in std_logic;
            clk    : in std_logic;
            pr, cl : in std_logic;
            q, nq  : out std_logic
        );
    end component;

begin

    reg : for i in 2 downto 0 generate
    r : ffd port map(ein(i), clk, '1', rst, eout(i));
    end generate reg;

end architecture;
