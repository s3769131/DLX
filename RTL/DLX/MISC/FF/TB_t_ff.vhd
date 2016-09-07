library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_t_ff is
end TB_t_ff;

architecture TEST of TB_t_ff is

    component t_ff is
        port(
            TFF_clk :   in  std_logic;
            TFF_rst :   in  std_logic;
            TFF_t   :   in  std_logic;
            TFF_q   :   out std_logic;
            TFF_nq  :   out std_logic);
    end component;

    signal s_TFF_clk    :   std_logic   :=  '0';
    signal s_TFF_rst    :   std_logic   :=  '0';
    signal s_TFF_t      :   std_logic   :=  '0';
    signal s_TFF_q      :   std_logic   :=  '0';
    signal s_TFF_nq     :   std_logic   :=  '0';

begin

    UUT : t_ff
        port map(
            TFF_clk =>  s_TFF_clk,
            TFF_rst =>  s_TFF_rst,
            TFF_t   =>  s_TFF_t,
            TFF_q   =>  s_TFF_q,
            TFF_nq  =>  s_TFF_nq);

    CLOCK_PROCESS : process
    begin
        CLK_LOOP : for i in 0 to 50 loop
            s_TFF_clk   <=  '0';
            wait for 1 ns;
            s_TFF_clk   <=  '1';
            wait for 1 ns;
        end loop;
        wait;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_TFF_rst   <=  '0';
        s_TFF_t     <=  '0';
        wait for 4 ns;
        s_TFF_rst   <=  '1';
        s_TFF_t     <=  '1';
        wait for 4 ns;
        s_TFF_t     <=  '0';
        wait;
    end process;

end TEST;
