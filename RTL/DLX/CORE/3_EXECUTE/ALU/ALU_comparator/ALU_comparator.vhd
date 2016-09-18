library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.ALU_pkg.all;

entity ALU_comparator is
    generic(
        ALU_COMP_NBIT  :  integer  := 32);
    port(
        ALU_COMP_op1        :   in  std_logic_vector(ALU_COMP_NBIT-1 downto 0);
        ALU_COMP_op2        :   in  std_logic_vector(ALU_COMP_NBIT-1 downto 0);
        ALU_COMP_signed     :   in  std_logic;
        ALU_COMP_op1_le_op2 :   out std_logic;
        ALU_COMP_op1_lt_op2 :   out std_logic;
        ALU_COMP_op1_gt_op2 :   out std_logic;
        ALU_COMP_op1_ge_op2 :   out std_logic;
        ALU_COMP_op1_eq_op2 :   out std_logic;
        ALU_COMP_op1_ne_op2 :   out std_logic);
end ALU_comparator;

architecture str of ALU_comparator is

    component COMP_bit_comparator is
        port(
            COMP_BIT_op1            :   in  std_logic;
            COMP_BIT_op2            :   in  std_logic;
            COMP_BIT_previous_gt    :   in  std_logic;
            COMP_BIT_previous_lt    :   in  std_logic;
            COMP_BIT_gt             :   out std_logic;
            COMP_BIT_lt             :   out std_logic);
    end component;

    constant N_LEVEL  :  integer  := log2ceil(ALU_COMP_NBIT);

    type std_logic_matrix is array (N_LEVEL downto 0) of std_logic_vector(ALU_COMP_NBIT-1 downto 0);

    signal gt_matrix    :   std_logic_matrix;
    signal lt_matrix    :   std_logic_matrix;

    signal s_op1_le_op2   : std_logic;
    signal s_op1_lt_op2   : std_logic;
    signal s_op1_gt_op2   : std_logic;
    signal s_op1_ge_op2   : std_logic;
    signal s_op1_eq_op2   : std_logic;
    signal s_op1_ne_op2   : std_logic;

begin

    LEVEL_GEN : for l in N_LEVEL downto 0 generate
        ELEMENT_GEN : for e in 2**l-1 downto 0 generate
            FIRST_ROW_GEN : if l = N_LEVEL generate
                CB : COMP_bit_comparator
                    port map(
                        COMP_BIT_op1            =>  ALU_COMP_op1(e),
                        COMP_BIT_op2            =>  ALU_COMP_op2(e),
                        COMP_BIT_previous_gt    =>  '0',
                        COMP_BIT_previous_lt    =>  '0',
                        COMP_BIT_gt             =>  gt_matrix(l)(e),
                        COMP_BIT_lt             =>  lt_matrix(l)(e));
            end generate;
            OTHER_ROW_GEN : if l /= N_LEVEL generate
                CB : COMP_bit_comparator
                    port map(
                        COMP_BIT_op1           =>  gt_matrix(l+1)(2*e),
                        COMP_BIT_op2           =>  lt_matrix(l+1)(2*e),
                        COMP_BIT_previous_gt   =>  gt_matrix(l+1)(2*e+1),
                        COMP_BIT_previous_lt   =>  lt_matrix(l+1)(2*e+1),
                        COMP_BIT_gt            =>  gt_matrix(l)(e),
                        COMP_BIT_lt            =>  lt_matrix(l)(e));
            end generate;
        end generate;
    end generate;

    s_op1_lt_op2 <=  lt_matrix(0)(0) xor (ALU_COMP_signed and (ALU_COMP_op1(ALU_COMP_NBIT-1) xor ALU_COMP_op2(ALU_COMP_NBIT-1)));
    s_op1_gt_op2 <=  gt_matrix(0)(0) xor (ALU_COMP_signed and (ALU_COMP_op1(ALU_COMP_NBIT-1) xor ALU_COMP_op2(ALU_COMP_NBIT-1)));

    s_op1_eq_op2 <=  s_op1_lt_op2 nor s_op1_gt_op2;
    s_op1_ne_op2 <=  s_op1_lt_op2 or s_op1_gt_op2;
    s_op1_le_op2 <=  s_op1_lt_op2 or (s_op1_lt_op2 nor s_op1_gt_op2);
    s_op1_ge_op2 <=  s_op1_gt_op2 or (s_op1_lt_op2 nor s_op1_gt_op2);

    ALU_COMP_op1_lt_op2 <=  s_op1_lt_op2;
    ALU_COMP_op1_gt_op2 <=  s_op1_gt_op2;
    ALU_COMP_op1_eq_op2 <=  s_op1_eq_op2;
    ALU_COMP_op1_ne_op2 <=  s_op1_ne_op2;
    ALU_COMP_op1_le_op2 <=  s_op1_le_op2;
    ALU_COMP_op1_ge_op2 <=  s_op1_ge_op2;

end str;

configuration CFG_ALU_COMPARATOR_STR of ALU_comparator is
    for str
        for LEVEL_GEN
            for ELEMENT_GEN
                for FIRST_ROW_GEN
                    for CB : COMP_bit_comparator
                        use configuration work.CFG_BIT_COMPARATOR_DFLOW;
                    end for;
                end for;
                for OTHER_ROW_GEN
                    for CB : COMP_bit_comparator
                        use configuration work.CFG_BIT_COMPARATOR_DFLOW;
                    end for;
                end for;
            end for;
        end for;
    end for;
end configuration CFG_ALU_COMPARATOR_STR;
