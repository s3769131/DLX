library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------------------------------
--  SIGN_EXTENTION
--
--  Is able to extend a signed/unsigned immediate, expressed on 16 or 23 bits.
--  The possible values for SIGN_EXT_op are:
--      00  :   extends a 16 bits unsigned immediate
--      01  :   extends a 23 bits unsigned immediate
--      10  :   extends a 16 bits signed immediate
--      11  :   extends a 23 bits signed immediate
----------------------------------------------------------------------------------------

entity sign_extention_decode is
    generic(
        SIGN_EXT_NBIT    :   positive :=  32);
    port (
        SIGN_EXT_op     :   in  std_logic_vector(1 downto 0);
        SIGN_EXT_input  :   in  std_logic_vector(SIGN_EXT_NBIT-1 downto 0);
        SIGN_EXT_output :   out std_logic_vector(SIGN_EXT_NBIT-1 downto 0));
end sign_extention_decode;

architecture str of sign_extention_decode is

    component bit_mux_4to1 is
        port(
            BIT_MUX_4to1_in0  :  in    std_logic;
            BIT_MUX_4to1_in1  :  in    std_logic;
            BIT_MUX_4to1_in2  :  in    std_logic;
            BIT_MUX_4to1_in3  :  in    std_logic;
            BIT_MUX_4to1_sel  :  in    std_logic_vector(1 downto 0);
            BIT_MUX_4to1_out  :  out   std_logic);
    end component;

begin

    SIGN_EXT_GEN : for i in 0 to SIGN_EXT_NBIT-1 generate
        BITS_0_TO_15 : if i < 16 generate
            SIGN_EXT_output(i)  <=  SIGN_EXT_input(i);
        end generate;
        BITS_16_TO_25 : if i >= 16 and i < 26 generate
            BIT_SEL : bit_mux_4to1
                port map(
                    BIT_MUX_4to1_in0    =>  '0',
                    BIT_MUX_4to1_in1    =>  SIGN_EXT_input(i),
                    BIT_MUX_4to1_in2    =>  SIGN_EXT_input(15),
                    BIT_MUX_4to1_in3    =>  SIGN_EXT_input(i),
                    BIT_MUX_4to1_sel    =>  SIGN_EXT_op,
                    BIT_MUX_4to1_out    =>  SIGN_EXT_output(i));
        end generate;
        BITS_26_TO_32 : if i >= 26 generate
            BIT_SEL : bit_mux_4to1
                port map(
                    BIT_MUX_4to1_in0    =>  '0',
                    BIT_MUX_4to1_in1    =>  '0',
                    BIT_MUX_4to1_in2    =>  SIGN_EXT_input(15),
                    BIT_MUX_4to1_in3    =>  SIGN_EXT_input(25),
                    BIT_MUX_4to1_sel    =>  SIGN_EXT_op,
                    BIT_MUX_4to1_out    =>  SIGN_EXT_output(i));
        end generate;
    end generate;

end str;

configuration CFG_SIGN_EXTENTION_DEC_STR of sign_extention_decode is
    for str
        for SIGN_EXT_GEN
            for BITS_0_TO_15
            end for;
            for BITS_16_TO_25
                for BIT_SEL : bit_mux_4to1
                    use configuration work.CFG_BIT_MUX_4to1_BHV;
                end for;
            end for;
            for BITS_26_TO_32
                for BIT_SEL : bit_mux_4to1
                    use configuration work.CFG_BIT_MUX_4to1_BHV;
                end for;
            end for;
        end for;
    end for;
end CFG_SIGN_EXTENTION_DEC_STR;
