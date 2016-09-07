library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity counter is
    generic(
        CNT_NBIT    :   integer :=  4);
    port(
        CNT_clk     :   in  std_logic;
        CNT_rst     :   in  std_logic;
        CNT_enable  :   in  std_logic;
        CNT_up_down :   in  std_logic;
        CNT_tc      :   out std_logic;
        CNT_out     :   out std_logic_vector(0 to CNT_NBIT-1));
end entity counter;

architecture bhv of counter is
    signal count    :   integer;
begin

    MAIN : process(CNT_rst, CNT_clk)
    begin
        if CNT_rst = '0' then
            count   <=  0;
        else
            if CNT_clk'event and CNT_clk = '1' and CNT_enable = '1' then
                if CNT_up_down = '1' then
                    count   <=  count + 1;
                elsif CNT_up_down = '0' then
                    count   <=  count - 1;
                end if;
            end if;
        end if;
    end process;

    TC : process(CNT_up_down, count)
    begin
        if CNT_up_down = '1' then
            if count = 2**CNT_NBIT-2 then
                CNT_tc  <=  '1';
            else
                CNT_tc  <=  '0';
            end if;
        elsif CNT_up_down = '0' then
            if count = 1 then
                CNT_tc  <=  '1';
            else
                CNT_tc  <=  '0';
            end if;
        end if;
    end process;

    CNT_out <=  std_logic_vector(to_unsigned(count,CNT_NBIT));
end bhv;

architecture str of counter is

    component t_ff is
        port(
            TFF_clk :   in  std_logic;
            TFF_rst :   in  std_logic;
            TFF_t   :   in  std_logic;
            TFF_q   :   out std_logic;
            TFF_nq  :   out std_logic);
    end component;

    component bit_mux_2to1 is
        port(
            BIT_MUX_2to1_in0    :   in  std_logic;
            BIT_MUX_2to1_in1    :   in  std_logic;
            BIT_MUX_2to1_sel    :   in  std_logic;
            BIT_MUX_2to1_out    :   out std_logic);
    end component;

    signal s_mux_out    :   std_logic_vector(CNT_NBIT-1 downto 0);
    signal s_t_ff_q     :   std_logic_vector(CNT_NBIT-1 downto 0);
    signal s_t_ff_nq    :   std_logic_vector(CNT_NBIT-1 downto 0);
    signal s_t_ff_t     :   std_logic_vector(CNT_NBIT downto 0);

begin

    S_T_FF_T_GEN : for i in 0 to CNT_NBIT generate
        BIT0 : if i = 0 generate
            s_t_ff_t(0) <=  CNT_enable;
        end generate;
        BIT1 : if i = 1 and i /= CNT_NBIT generate
            s_t_ff_t(1) <=  CNT_enable and s_mux_out(0);
        end generate;
        OTHER : if i >= 2 and i /= CNT_NBIT generate
            s_t_ff_t(i) <=  CNT_enable and s_mux_out(i-1) and s_t_ff_t(i-1);
        end generate;
        LAST : if i = CNT_NBIT generate
            s_t_ff_t(i) <=  s_mux_out(i-1) and s_t_ff_t(i-1);
        end generate;
    end generate;

    TFF_GEN : for i in 0 to CNT_NBIT-1 generate
        TFF : t_ff
            port map(
                TFF_clk =>  CNT_clk,
                TFF_rst =>  CNT_rst,
                TFF_t   =>  s_t_ff_t(i),
                TFF_q   =>  s_t_ff_q(i),
                TFF_nq  =>  s_t_ff_nq(i));
    end generate;

    MUX_GEN : for i in 0 to CNT_NBIT-1 generate
        MUX : bit_mux_2to1
            port map(
                BIT_MUX_2to1_in0    =>  s_t_ff_nq(i),
                BIT_MUX_2to1_in1    =>  s_t_ff_q(i),
                BIT_MUX_2to1_sel    =>  CNT_up_down,
                BIT_MUX_2to1_out    =>  s_mux_out(i));
    end generate;

    CNT_tc  <=  s_t_ff_t(CNT_NBIT);
    CNT_out <=  s_t_ff_q;
end str;

configuration CFG_COUNTER_BHV of counter is
    for bhv
    end for;
end configuration CFG_COUNTER_BHV;

configuration CFG_COUNTER_STR of counter is
    for str
        for S_T_FF_T_GEN
            for BIT0
            end for;
            for BIT1
            end for;
            for OTHER
            end for;
            for LAST
            end for;
        end for;
        for TFF_GEN
            for TFF : t_ff
                use configuration work.CFG_T_FF_BHV;
            end for;
        end for;
        for MUX_GEN
            for MUX : bit_mux_2to1
                use configuration work.CFG_BIT_MUX_2to1_BHV;
            end for;
        end for;
    end for;
end configuration CFG_COUNTER_STR;
