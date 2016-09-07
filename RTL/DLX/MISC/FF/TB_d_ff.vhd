library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_d_ff is
end TB_d_ff;

architecture TEST of TB_d_ff is

    component d_ff is
        port(
            DFF_clk :   in  std_logic;
            DFF_rst :   in  std_logic;
            DFF_clr :   in  std_logic;
            DFF_d   :   in  std_logic;
            DFF_q   :   out std_logic;
            DFF_nq  :   out std_logic);
    end component;

    signal s_DFF_clk    :   std_logic   :=  '0';
    signal s_DFF_rst    :   std_logic   :=  '0';
    signal s_DFF_clr    :   std_logic   :=  '0';
    signal s_DFF_d      :   std_logic   :=  '0';
    signal s_DFF_q      :   std_logic   :=  '0';
    signal s_DFF_nq     :   std_logic   :=  '0';

begin

    UUT : d_ff
        port map(
            DFF_clk =>  s_DFF_clk,
            DFF_rst =>  s_DFF_rst,
            DFF_clr =>  s_DFF_clr,
            DFF_d   =>  s_DFF_d,
            DFF_q   =>  s_DFF_q,
            DFF_nq  =>  s_DFF_nq);

    CLOCK_PROCESS : process
    begin
        CLK_LOOP : for i in 0 to 50 loop
            s_DFF_clk   <=  '0';
            wait for 1 ns;
            s_DFF_clk   <=  '1';
            wait for 1 ns;
        end loop;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_DFF_rst   <=  '0';
        s_DFF_clr   <=  '0';
        s_DFF_d     <=  '0';
        wait for 4 ns;
        s_DFF_rst   <=  '1';
        s_DFF_d     <=  '1';
        wait for 4 ns;
        s_DFF_d     <=  '0';
        wait;
    end process;

end TEST;
