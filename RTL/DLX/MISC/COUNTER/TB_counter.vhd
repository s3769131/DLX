library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_counter is
end TB_counter;

architecture TEST of TB_counter is

    component counter is
        generic(
            CNT_NBIT    :   integer :=  4);
        port(
            CNT_clk     :   in  std_logic;
            CNT_rst     :   in  std_logic;
            CNT_enable  :   in  std_logic;
            CNT_up_down :   in  std_logic;
            CNT_tc      :   out std_logic;
            CNT_out     :   out std_logic_vector(0 to CNT_NBIT-1));
    end component;

    constant c_CNT_NBIT :   integer :=  4;

    signal s_CNT_clk        :   std_logic                           :=  '0';
    signal s_CNT_rst        :   std_logic                           :=  '0';
    signal s_CNT_enable     :   std_logic                           :=  '0';
    signal s_CNT_up_down    :   std_logic                           :=  '0';
    signal s_CNT_tc1        :   std_logic                           :=  '0';
    signal s_CNT_tc2        :   std_logic                           :=  '0';
    signal s_CNT_out1       :   std_logic_vector(0 to c_CNT_NBIT-1) :=  (others => '0');
    signal s_CNT_out2       :   std_logic_vector(0 to c_CNT_NBIT-1) :=  (others => '0');

begin

    UUT_BHV : counter
        generic map(
            CNT_NBIT    =>  c_CNT_NBIT)
        port map(
            CNT_clk     =>  s_CNT_clk,
            CNT_rst     =>  s_CNT_rst,
            CNT_enable  =>  s_CNT_enable,
            CNT_up_down =>  s_CNT_up_down,
            CNT_tc      =>  s_CNT_tc1,
            CNT_out     =>  s_CNT_out1);

    UUT_STR : counter
        generic map(
            CNT_NBIT    =>  c_CNT_NBIT)
        port map(
            CNT_clk     =>  s_CNT_clk,
            CNT_rst     =>  s_CNT_rst,
            CNT_enable  =>  s_CNT_enable,
            CNT_up_down =>  s_CNT_up_down,
            CNT_tc      =>  s_CNT_tc2,
            CNT_out     =>  s_CNT_out2);

    CLOCK_PROCESS : process
    begin
        CLK_LOOP : for i in 0 to 50 loop
            s_CNT_clk   <=  '0';
            wait for 1 ns;
            s_CNT_clk   <=  '1';
            wait for 1 ns;
        end loop;
        wait;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_CNT_rst       <=  '0';
        s_CNT_enable    <=  '0';
        s_CNT_up_down   <=  '1';
        wait for 4 ns;
        s_CNT_rst       <=  '1';
        s_CNT_enable    <=  '1';
        wait for 10 ns;
        s_CNT_up_down   <=  '0';
        wait for 30 ns;
        s_CNT_enable    <=  '0';
        wait;
    end process;

end TEST;

configuration CFG_TEST_COUNTER of TB_counter is
    for TEST
        for UUT_BHV : counter
            use configuration work.CFG_COUNTER_BHV;
        end for;
        for UUT_STR : counter
            use configuration work.CFG_COUNTER_STR;
        end for;
    end for;
end configuration CFG_TEST_COUNTER;
