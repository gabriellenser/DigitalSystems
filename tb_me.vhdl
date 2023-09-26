library IEEE;
use IEEE.std_logic_1164.all;

entity tb_me is
end entity;

architecture test of tb_me is
    constant cicloclock : time := 20 ns;

    component me is
        port (
            reset, clock : in std_logic;
            vintcinc, cinq : in std_logic;
            rec, disp, cof, dev : out std_logic
        );
    end component me;

    signal sreset, sclk, svintcinc, scinq : std_logic := '0';
    signal srec, sdisp, scof, sdev : std_logic;
    
begin

    sclk <= not(sclk) after cicloclock / 2;

    u_me : me port map(sreset, sclk, svintcinc, scinq, srec, sdisp, scof, sdev);

    u_tb : process 
    begin
    
    wait for cicloclock; --reset e começa com 25
        sreset <= '1';
        
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; -- Adiciona 25 e fica com 50
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; -- Adiciona 25 e fica com 75
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; --Adiciona 25 e fica com 100
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; --entrega o chocolate
        svintcinc <= '0';
            scinq <= '0';
        
        wait for cicloclock; --Caso onde começa adicionando 50
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; -- Adiciona 50 e atinge 100
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; --entrega o chocolate
        svintcinc <= '0';
            scinq <= '0';
        
        wait for cicloclock; --Começa com 25
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; --Adiciona 50 e fica com 75
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; -- Adiciona 25 e fica com 100
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; --entrega o chocolate
        svintcinc <= '0';
            scinq <= '0';
        
        wait for cicloclock; -- Caso onde começa com 50 
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; --Adiciona 25 e fica com 75
        svintcinc <= '1';
            scinq <= '0';
        
        wait for cicloclock; -- Adiciona 50 e atinge 125
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; --devolve o valor, pois passou de 100
        svintcinc <= '0';
            scinq <= '0';
        
        wait for cicloclock; --apresenta erro
        svintcinc <= '1';
            scinq <= '1';
        
        wait for cicloclock; --devolve o valor
        svintcinc <= '0';
            scinq <= '0';
        
        wait for cicloclock; --parte do 50
        svintcinc <= '0';
            scinq <= '1';
        
        wait for cicloclock; --apresenta erro
        svintcinc <= '1';
            scinq <= '1';
        
        wait for cicloclock; --devolve o valor
        svintcinc <= '0';
            scinq <= '0';

        
        wait;
    end process;
end architecture test;
