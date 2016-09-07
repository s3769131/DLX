library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.DLX_pkg.all;

entity btb is
    generic(
        BTB_NENTRY      :   integer :=  8;
        BTB_TARGET_NBIT :   integer :=  8;
        BTB_BHT_NBIT    :   integer :=  2);
    port(
        BTB_clk                 :   in  std_logic;
        BTB_rst                 :   in  std_logic;
        BTB_enable              :   in  std_logic;
        BTB_wrong_target        :   in  std_logic;
        BTB_wrong_prediction    :   in  std_logic;
        BTB_addr_write          :   in  std_logic_vector(log2ceil(BTB_NENTRY)-1 downto 0);
        BTB_target_write        :   in  std_logic_vector(BTB_TARGET_NBIT-1 downto 0);
        BTB_addr_read           :   in  std_logic_vector(log2ceil(BTB_NENTRY)-1 downto 0);
        BTB_prediction          :   out std_logic;
        BTB_target_prediction   :   out std_logic_vector(BTB_TARGET_NBIT-1 downto 0));
end btb;

architecture str of btb is

    component bit_multiplexer is
        generic(
            BIT_MUX_NSEL    :   integer :=  3);
        port(
            BIT_MUX_inputs  :   in  std_logic_vector(2**BIT_MUX_NSEL-1 downto 0);
            BIT_MUX_select  :   in  std_logic_vector(BIT_MUX_NSEL-1 downto 0);
            BIT_MUX_output  :   out std_logic);
    end component;

    component multiplexer is
        generic(
            MUX_NBIT    :   integer :=  4;
            MUX_NSEL    :   integer :=  3);
        port(
            MUX_inputs  :   in  std_logic_vector(2**MUX_NSEL * MUX_NBIT - 1 downto 0);
            MUX_select  :   in  std_logic_vector(MUX_NSEL-1 downto 0);
            MUX_output  :   out std_logic_vector(MUX_NBIT-1 downto 0));
    end component;

    component d_register is
        generic(
            REG_NBIT    :   integer :=  8);
        port(
            REG_clk         :   in  std_logic;
            REG_rst         :   in  std_logic;
            REG_clr         :   in  std_logic;
            REG_enable      :   in  std_logic;
            REG_data_in     :   in  std_logic_vector(REG_NBIT-1 downto 0);
            REG_data_out    :   out std_logic_vector(REG_NBIT-1 downto 0));
    end component;

    component decoder is
        generic(
            DEC_NBIT    :   integer :=  5);
        port(
            DEC_address :   in  std_logic_vector(DEC_NBIT-1 downto 0);
            DEC_enable  :   in  std_logic;
            DEC_output  :   out std_logic_vector(2**DEC_NBIT-1 downto 0));
    end component;

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

    signal s_mux_prediction_in  :   std_logic_vector(BTB_NENTRY-1 downto 0);
    signal s_mux_target_in      :   std_logic_vector(BTB_TARGET_NBIT*BTB_NENTRY-1 downto 0);
    signal s_mux_prediction_out :   std_logic;
    signal s_mux_target_out     :   std_logic_vector(BTB_TARGET_NBIT-1 downto 0);
    signal s_equality_address   :   std_logic;
    signal s_mux_forward_target :   std_logic;
    signal s_decoder_out        :   std_logic_vector(BTB_NENTRY-1 downto 0);
    signal s_register_enable    :   std_logic_vector(BTB_NENTRY-1 downto 0);

begin

    TARGET_MUX : multiplexer
        generic map(
            MUX_NBIT    =>  BTB_TARGET_NBIT,
            MUX_NSEL    =>  log2ceil(BTB_NENTRY))
        port map(
            MUX_inputs  =>  s_mux_target_in,
            MUX_select  =>  BTB_addr_read,
            MUX_output  =>  BTB_target_prediction);

    PREDICTION_MUX : bit_multiplexer
        generic map(
            BIT_MUX_NSEL    =>  log2ceil(BTB_NENTRY))
        port map(
            BIT_MUX_inputs  =>  s_mux_prediction_in,
            BIT_MUX_select  =>  BTB_addr_read,
            BIT_MUX_output  =>  BTB_prediction);

    WRITE_DECODER : decoder
        generic map(
            DEC_NBIT    =>  log2ceil(BTB_NENTRY))
        port map(
            DEC_address =>  BTB_addr_write,
            DEC_enable  =>  BTB_enable,
            DEC_output  =>  s_decoder_out);

    TARGET_REGISTER_GEN : for i in 0 to BTB_NENTRY-1 generate
        s_register_enable(i)    <=  s_decoder_out(i) and BTB_wrong_target;
        REG : d_register
            generic map(
                REG_NBIT    =>  BTB_TARGET_NBIT)
            port map(
                REG_clk         =>  BTB_clk,
                REG_rst         =>  BTB_rst,
                REG_clr         =>  '0',
                REG_enable      =>  s_register_enable(i),
                REG_data_in     =>  BTB_target_write,
                REG_data_out    =>  s_mux_target_in((i+1)*BTB_TARGET_NBIT-1 downto i*BTB_TARGET_NBIT));
    end generate;

    BHT_ENTRIES_GEN : for i in 0 to BTB_NENTRY-1 generate
        BHT_ENT : bht_entry
            generic map(
                BHT_ENT_NBIT    =>  BTB_BHT_NBIT)
            port map(
                BHT_ENT_clk         =>  BTB_clk,
                BHT_ENT_rst         =>  BTB_rst,
                BHT_ENT_enable      =>  s_decoder_out(i),
                BHT_ENT_error       =>  BTB_wrong_prediction,
                BHT_ENT_prediction  =>  s_mux_prediction_in(i));
    end generate;

end str;

configuration CFG_BTB_STR of btb is
    for str
        for TARGET_MUX : multiplexer
            use configuration work.CFG_MULTIPLEXER_DFLOW;
        end for;
        for PREDICTION_MUX : bit_multiplexer
            use configuration work.CFG_BIT_MULTIPLEXER_DFLOW;
        end for;
        for WRITE_DECODER : decoder
            use configuration work.CFG_DECODER_BHV;
        end for;
        for TARGET_REGISTER_GEN
            for REG : d_register
                use configuration work.CFG_D_REGISTER_STR;
            end for;
        end for;
        for BHT_ENTRIES_GEN
            for BHT_ENT : bht_entry
                use configuration work.CFG_BHT_ENTRY_STR;
            end for;
        end for;
    end for;
end configuration CFG_BTB_STR;
