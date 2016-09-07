library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_ff is
    port(
        DFF_clk :   in  std_logic;
        DFF_rst :   in  std_logic;
        DFF_clr :   in  std_logic;
        DFF_d   :   in  std_logic;
        DFF_q   :   out std_logic;
        DFF_nq  :   out std_logic);
end entity d_ff;

architecture bhv of d_ff is
    signal data : std_logic;

begin
    MAIN : process(DFF_rst, DFF_clk)
    begin
        if DFF_rst = '0' then
            data <= '0';
        else
            if DFF_clk'event and DFF_clk = '1' then
                if DFF_clr = '1' then
                    data <= '0';
                else
                    data <= DFF_d;
                end if;
            end if;
        end if;
    end process;

    DFF_q   <= data;
    DFF_nq  <= not data;
end architecture bhv;

configuration CFG_D_FF_BHV of d_ff is
    for bhv
    end for;
end configuration CFG_D_FF_BHV;
