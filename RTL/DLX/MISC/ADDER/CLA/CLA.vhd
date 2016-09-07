library ieee;
use ieee.std_logic_1164.all;
use work.DLX_pkg.all;

entity CLA is
    generic(
        CLA_NBIT       :  integer  := 16);
    port(
        CLA_op1     :  in   std_logic_vector(CLA_NBIT-1 downto 0);
        CLA_op2     :  in   std_logic_vector(CLA_NBIT-1 downto 0);
        CLA_add     :  in   std_logic;
        CLA_res     :  out  std_logic_vector(CLA_NBIT-1 downto 0);
        CLA_cout    :  out  std_logic;
        CLA_ovflow  :  out  std_logic);
end CLA;

architecture str of CLA is

    component CLA_carry_generator is
        generic(
            CLA_CGEN_NBIT       :   integer  := 16;
            CLA_CGEN_CARRY_STEP :   integer  := 4);
        port(
            CLA_CGEN_op1    :   in  std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
            CLA_CGEN_op2    :   in  std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
            CLA_CGEN_cin    :   in  std_logic;
            CLA_CGEN_cout   :   out std_logic_vector(CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP-1 downto 0));
    end component;

    component CLA_sum_generator is
        generic(
            CLA_SGEN_NBIT       :  integer  := 16;
            CLA_SGEN_CARRY_STEP :  integer  := 4);
        port(
            CLA_SGEN_op1   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
            CLA_SGEN_op2   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
            CLA_SGEN_cin   :  in    std_logic_vector(CLA_SGEN_NBIT/CLA_SGEN_CARRY_STEP-1 downto 0);
            CLA_SGEN_res   :  out   std_logic_vector(CLA_SGEN_NBIT-1 downto 0));
    end component;

    constant CLA_CARRY_STEP :   integer := 2**((log2ceil(CLA_NBIT))/2-1);
    constant N_CARRIES      :   integer := CLA_NBIT/CLA_CARRY_STEP;

    signal actual_op2       :   std_logic_vector(CLA_NBIT-1 downto 0);
    signal actual_carries   :   std_logic_vector(N_CARRIES-1 downto 0);
    signal carries          :   std_logic_vector(N_CARRIES-1 downto 0);

begin

    OP2_GEN : for i in 0 to CLA_NBIT-1 generate
        actual_op2(i)  <= CLA_op2(i) xor CLA_add;
    end generate;

    actual_carries <= carries(N_CARRIES-2 downto 0)&(CLA_add);

    CARRY_GENERATOR : CLA_carry_generator
        generic map(
            CLA_CGEN_NBIT        => CLA_NBIT,
            CLA_CGEN_CARRY_STEP  => CLA_CARRY_STEP)
        port map(
            CLA_CGEN_op1   => CLA_op1,
            CLA_CGEN_op2   => actual_op2,
            CLA_CGEN_cin   => CLA_add,
            CLA_CGEN_cout  => carries);

    RES_GENERATOR : CLA_sum_generator
        generic map(
            CLA_SGEN_NBIT        => CLA_NBIT,
            CLA_SGEN_CARRY_STEP  => CLA_CARRY_STEP)
        port map(
            CLA_SGEN_op1   => CLA_op1,
            CLA_SGEN_op2   => actual_op2,
            CLA_SGEN_cin   => actual_carries,
            CLA_SGEN_res   => CLA_res);

    CLA_ovflow <= carries(N_CARRIES-1) xor CLA_op1(CLA_NBIT-1) xor CLA_op2(CLA_NBIT-1);
    CLA_cout   <= carries(N_CARRIES-1);

end str;

configuration CFG_CLA_STR of CLA is
    for str
        for OP2_GEN
        end for;
        for CARRY_GENERATOR : CLA_carry_generator
            use configuration work.CFG_CLA_CGEN_STR;
        end for;
        for RES_GENERATOR : CLA_sum_generator
            use configuration work.CFG_CLA_SGEN_STR;
        end for;
    end for;
end configuration CFG_CLA_STR;
