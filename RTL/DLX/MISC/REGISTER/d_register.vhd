library ieee;
use ieee.std_logic_1164.all;

entity d_register is
    generic(
        REG_NBIT    :   integer :=  8);
    port(
        REG_clk         :   in  std_logic;
        REG_rst         :   in  std_logic;
        REG_clr         :   in  std_logic;
        REG_enable      :   in  std_logic;
        REG_data_in     :   in  std_logic_vector(REG_NBIT-1 downto 0);
        REG_data_out    :   out std_logic_vector(REG_NBIT-1 downto 0));
end d_register;

architecture str of d_register is

    component d_ff is
        port(
            DFF_clk :   in  std_logic;
            DFF_rst :   in  std_logic;
            DFF_clr :   in  std_logic;
            DFF_d   :   in  std_logic;
            DFF_q   :   out std_logic;
            DFF_nq  :   out std_logic);
    end component;

    component bit_mux_2to1 is
        port(
            BIT_MUX_2to1_in0    :   in  std_logic;
            BIT_MUX_2to1_in1    :   in  std_logic;
            BIT_MUX_2to1_sel    :   in  std_logic;
            BIT_MUX_2to1_out    :   out std_logic);
    end component;

    signal s_storage    :   std_logic_vector(REG_NBIT-1 downto 0);
    signal s_next_val   :   std_logic_vector(REG_NBIT-1 downto 0);

begin

    DFF_GEN : for i in 0 to REG_NBIT-1 generate
        DFF : d_ff
            port map(
                DFF_clk =>  REG_clk,
                DFF_rst =>  REG_rst,
                DFF_clr =>  REG_clr,
                DFF_d   =>  s_next_val(i),
                DFF_q   =>  s_storage(i),
                DFF_nq  =>  open);
    end generate;

    MUX_GEN : for i in 0 to REG_NBIT-1 generate
        MUX : bit_mux_2to1
            port map(
                BIT_MUX_2to1_in0    =>  s_storage(i),
                BIT_MUX_2to1_in1    =>  REG_data_in(i),
                BIT_MUX_2to1_sel    =>  REG_enable,
                BIT_MUX_2to1_out    =>  s_next_val(i));
    end generate;

    REG_data_out    <=  s_storage;
end str;

configuration CFG_D_REGISTER_STR of d_register is
    for str
        for DFF_GEN
            for DFF : d_ff
                use configuration work.CFG_D_FF_BHV;
            end for;
        end for;
        for MUX_GEN
            for MUX : bit_mux_2to1
                use configuration work.CFG_BIT_MUX_2to1_BHV;
            end for;
        end for;
    end for;
end CFG_D_REGISTER_STR;
