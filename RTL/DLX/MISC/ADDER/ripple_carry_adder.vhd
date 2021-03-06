library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
    generic(
        RCA_NBIT :  integer :=  4);
    port(
        RCA_op1     :   in  std_logic_vector(RCA_NBIT-1 downto 0);
        RCA_op2     :   in  std_logic_vector(RCA_NBIT-1 downto 0);
        RCA_cin     :   in  std_logic;
        RCA_res     :   out std_logic_vector(RCA_NBIT-1 downto 0);
        RCA_cout    :   out std_logic);
end ripple_carry_adder;

architecture str of ripple_carry_adder is

    component full_adder is
        port(
            FA_op1  :   in  std_logic;
            FA_op2  :   in  std_logic;
            FA_cin  :   in  std_logic;
            FA_cout :   out std_logic;
            FA_res  :   out std_logic);
    end component;

    signal cout_tmp :   std_logic_vector(RCA_NBIT - 1 downto 0);

begin

    RIPPLE_GEN : for i in 0 to RCA_NBIT - 1 generate
        FIRST_GEN : if i = 0 generate
            FIRST_FA : full_adder
                port map(
                    FA_op1  => RCA_op1(i),
                    FA_op2  => RCA_op2(i),
                    FA_cin  => RCA_cin,
                    FA_cout => cout_tmp(i),
                    FA_res  => RCA_res(i));
        end generate FIRST_GEN;
        MIDDLE_GEN : if i > 0 generate
            MIDDLE_FA : full_adder
                port map(
                    FA_op1  => RCA_op1(i),
                    FA_op2  => RCA_op2(i),
                    FA_cin  => cout_tmp(i-1),
                    FA_cout => cout_tmp(i),
                    FA_res  => RCA_res(i));
        end generate MIDDLE_GEN;
    end generate RIPPLE_GEN;

    RCA_COUT <= cout_tmp(RCA_NBIT-1);

end str;

configuration CFG_RIPPLE_CARRY_ADDER_STR of ripple_carry_adder is
    for str
        for RIPPLE_GEN
            for FIRST_GEN
                for all : full_adder
                    use configuration work.CFG_FULL_ADDER_DFLOW;
                end for;
            end for;
            for MIDDLE_GEN
                for all : full_adder
                    use configuration work.CFG_full_adder_DFLOW;
                end for;
            end for;
        end for;
    end for;
end configuration CFG_ripple_carry_adder_STR;
