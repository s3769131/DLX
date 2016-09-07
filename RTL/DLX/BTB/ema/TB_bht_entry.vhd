library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_bht_entry is
end TB_bht_entry;

architecture TEST of TB_bht_entry is

    component bht_entry is
        generic(
            BHT_ENT_NBIT    :   integer :=  2);
        port(
            BHT_ENT_clk         :   in  std_logic;
            BHT_ENT_rst         :   in  std_logic;
            BHT_ENT_enable      :   in  std_logic;
            BHT_ENT_error       :   in  std_logic;
            BHT_ENT_prediction  :   out std_logic);
    end component;

    constant c_BHT_ENT_NBIT :   integer :=  2;

    signal s_BHT_ENT_clk        :   std_logic   :=  '0';
    signal s_BHT_ENT_rst        :   std_logic   :=  '0';
    signal s_BHT_ENT_enable     :   std_logic   :=  '0';
    signal s_BHT_ENT_error      :   std_logic   :=  '0';
    signal s_BHT_ENT_prediction :   std_logic   :=  '0';

begin

    BHT_ENT : bht_entry
        generic map(
            BHT_ENT_NBIT    =>  c_BHT_ENT_NBIT)
        port map(
            BHT_ENT_clk         =>  s_BHT_ENT_clk,
            BHT_ENT_rst         =>  s_BHT_ENT_rst,
            BHT_ENT_enable      =>  s_BHT_ENT_enable,
            BHT_ENT_error       =>  s_BHT_ENT_error,
            BHT_ENT_prediction  =>  s_BHT_ENT_prediction);

    CLOCK_PROCESS : process
    begin
        CLK_LOOP : for i in 0 to 50 loop
            s_BHT_ENT_clk   <=  '0';
            wait for 1 ns;
            s_BHT_ENT_clk   <=  '1';
            wait for 1 ns;
        end loop;
        wait;
    end process;

    INPUT_STIMULI_PROCESS : process
    begin
        s_BHT_ENT_rst       <=  '0';
        s_BHT_ENT_enable    <=  '0';
        s_BHT_ENT_error     <=  '0';
        wait for 4 ns;
        s_BHT_ENT_rst       <=  '1';
        s_BHT_ENT_enable    <=  '1';
        wait for 10 ns;
        s_BHT_ENT_error     <=  '1';
        wait for 10 ns;
        s_BHT_ENT_error     <=  '0';
        wait;
    end process;

end TEST;
