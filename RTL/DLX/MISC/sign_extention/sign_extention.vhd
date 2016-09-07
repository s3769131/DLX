library ieee;
use ieee.std_logic_1164.all;

entity sign_extention is
    generic(
        SIGN_EXT_IN_NBIT    :   integer :=  16;
        SIGN_EXT_OUT_NBIT   :   integer :=  32);
    port (
        SIGN_EXT_signed :   in  std_logic;
        SIGN_EXT_input  :   in  std_logic_vector(SIGN_EXT_IN_NBIT-1 downto 0);
        SIGN_EXT_output :   out std_logic_vector(SIGN_EXT_OUT_NBIT-1 downto 0));
end sign_extention;

architecture str of sign_extention is

    component bit_mux_2to1 is
        port(
            BIT_MUX_2to1_in0    :   in  std_logic;
            BIT_MUX_2to1_in1    :   in  std_logic;
            BIT_MUX_2to1_sel    :   in  std_logic;
            BIT_MUX_2to1_out    :   out std_logic);
    end component;

begin

    SIGN_EXT_GEN : for i in 0 to SIGN_EXT_OUT_NBIT-1 generate
        LOWER_BIT : if i < SIGN_EXT_IN_NBIT generate
            SIGN_EXT_output(i)    <=  SIGN_EXT_input(i);
        end generate;
        UPPER_BIT : if i >= SIGN_EXT_IN_NBIT generate
            MUX : bit_mux_2to1
                port map(
                    BIT_MUX_2to1_in0    =>  '0',
                    BIT_MUX_2to1_in1    =>  SIGN_EXT_input(SIGN_EXT_IN_NBIT-1),
                    BIT_MUX_2to1_sel    =>  SIGN_EXT_signed,
                    BIT_MUX_2to1_out    =>  SIGN_EXT_output(i));
        end generate;
    end generate;

end str;

configuration CFG_SIGN_EXTENTION_STR of sign_extention is
    for str
        for SIGN_EXT_GEN
            for LOWER_BIT
            end for;
            for UPPER_BIT
                for MUX : bit_mux_2to1
                    use configuration work.CFG_BIT_MUX_2to1_BHV;
                end for;
            end for;
        end for;
    end for;
end CFG_SIGN_EXTENTION_STR;
