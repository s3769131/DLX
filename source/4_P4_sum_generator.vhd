library ieee;
use ieee.std_logic_1164.all;

--! P4_SUM_GENERATOR
--  models an array of carry select adder, that receives a certain number of
--  carry lines, with a certain step, from the sparse tree carry generator.
--  Notice that this module does not produce a carry out, because that signal
--  is already produced by the sparse tree carry generator.
entity P4_sum_generator is
  generic(
    P4_SGEN_NBIT  : integer := 32;
    P4_SGEN_CSTEP : integer := 4);
  port(
    P4_SGEN_operand_A :      in   std_logic_vector(P4_SGEN_NBIT downto 1);
    P4_SGEN_operand_B :      in   std_logic_vector(P4_SGEN_NBIT downto 1);
    P4_SGEN_carries_in:      in   std_logic_vector(P4_SGEN_NBIT/P4_SGEN_CSTEP downto 1);
    P4_SGEN_result    :      out  std_logic_vector(P4_SGEN_NBIT downto 1));
end P4_sum_generator;

architecture structural of P4_sum_generator is

  component carry_select_adder is
    generic(
      CSEA_N    :   integer :=  4);  -- parallelism of the carry select adder
    port(
      CSEA_op1       :   in  std_logic_vector(CSEA_N-1 downto 0);
      CSEA_op2       :   in  std_logic_vector(CSEA_N-1 downto 0);
      CSEA_cin       :   in  std_logic;
      CSEA_res       :   out std_logic_vector(CSEA_N-1 downto 0);
      CSEA_cout      :   out std_logic);
  end component;

begin
  CSA_GEN : for i in P4_SGEN_NBIT/P4_SGEN_CSTEP downto 1 generate
    CSA : carry_select_adder
      generic map(
        CSEA_N => P4_SGEN_CSTEP)
      port map(
        CSEA_op1  => P4_SGEN_operand_A (i*P4_SGEN_CSTEP downto (i-1)*P4_SGEN_CSTEP+1),
        CSEA_op2  => P4_SGEN_operand_B (i*P4_SGEN_CSTEP downto (i-1)*P4_SGEN_CSTEP+1),
        CSEA_cin  => P4_SGEN_carries_in(i),
        CSEA_res  => P4_SGEN_result    (i*P4_SGEN_CSTEP downto (i-1)*P4_SGEN_CSTEP+1),
        CSEA_cout => open);
  end generate CSA_GEN;

end structural;

--configuration CFG_P4_SUM_GENERATOR_STR of P4_sum_generator is
--  for structural
--    for CSA_GEN
--      for all : carry_select_adder
--        use configuration work.CFG_CARRY_SELECT_ADDER_STR;
--      end for;
--    end for;
--  end for;
--end configuration CFG_P4_SUM_GENERATOR_STR;
