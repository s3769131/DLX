library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity bht_entry is
    generic(
        BHT_ENT_NBIT    :   integer :=  2);
    port(
        BHT_ENT_clk         :   in  std_logic;
        BHT_ENT_rst         :   in  std_logic;
        BHT_ENT_enable      :   in  std_logic;
        BHT_ENT_error       :   in  std_logic;
        BHT_ENT_prediction  :   out std_logic);
end bht_entry;

architecture str of bht_entry is

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

    component t_ff is
        port(
            TFF_clk :   in  std_logic;
            TFF_rst :   in  std_logic;
            TFF_t   :   in  std_logic;
            TFF_q   :   out std_logic;
            TFF_nq  :   out std_logic);
    end component;

    signal s_counter_enable :   std_logic;
    signal s_counter_out    :   std_logic_vector(BHT_ENT_NBIT-1 downto 0);
    signal s_counter_zeros  :   std_logic;
    signal s_t_ff_t         :   std_logic;

begin

    SINGLE_BIT_ENTRY : if BHT_ENT_NBIT = 1 generate
        s_t_ff_t    <=  BHT_ENT_enable and BHT_ENT_error;
        TFF : t_ff
            port map(
                TFF_clk =>  BHT_ENT_clk,
                TFF_rst =>  BHT_ENT_rst,
                TFF_t   =>  s_t_ff_t,
                TFF_q   =>  BHT_ENT_prediction,
                TFF_nq  =>  open);
    end generate;
    MULTIPLE_BIT_ENTRY : if BHT_ENT_NBIT > 1 generate
        s_counter_zeros     <=  nor_reduce(s_counter_out(BHT_ENT_NBIT-2 downto 0));
        s_counter_enable    <=  BHT_ENT_enable and (BHT_ENT_error or (not s_counter_zeros));
        BHT_ENT_prediction  <=  s_counter_out(BHT_ENT_NBIT-1);
        CNT : counter
            generic map(
                CNT_NBIT    =>  BHT_ENT_NBIT)
            port map(
                CNT_clk     =>  BHT_ENT_clk,
                CNT_rst     =>  BHT_ENT_rst,
                CNT_enable  =>  s_counter_enable,
                CNT_up_down =>  BHT_ENT_error,
                CNT_tc      =>  open,
                CNT_out     =>  s_counter_out);
    end generate;

end str;

configuration CFG_BHT_ENTRY_STR of bht_entry is
    for str
        for SINGLE_BIT_ENTRY
            for TFF : t_ff
                use configuration work.CFG_T_FF_BHV;
            end for;
        end for;
        for MULTIPLE_BIT_ENTRY
            for CNT : counter
                use configuration work.CFG_COUNTER_STR;
            end for;
        end for;
    end for;
end configuration CFG_BHT_ENTRY_STR;
