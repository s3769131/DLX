library ieee;
use ieee.std_logic_1164.all;

entity P4_adder is
  generic(
    P4_NBIT   : integer := 32;
    P4_CSTEP : integer := 4);
  port(
    P4_operand_A :      in   std_logic_vector(P4_NBIT downto 1);
    P4_operand_B :      in   std_logic_vector(P4_NBIT downto 1);
    P4_carry_in  :      in   std_logic;
    P4_result    :      out  std_logic_vector(P4_NBIT downto 1);
    P4_carry_out :      out  std_logic
  );
end P4_adder;

architecture structural of P4_adder is

  component P4_sum_generator is
    generic(
      P4_SGEN_NBIT  : integer := 32;
      P4_SGEN_CSTEP : integer := 4);
    port(
      P4_SGEN_operand_A :      in   std_logic_vector(P4_SGEN_NBIT downto 1);
      P4_SGEN_operand_B :      in   std_logic_vector(P4_SGEN_NBIT downto 1);
      P4_SGEN_carries_in:      in   std_logic_vector(P4_SGEN_NBIT/P4_SGEN_CSTEP downto 1);
      P4_SGEN_result    :      out  std_logic_vector(P4_SGEN_NBIT downto 1));
  end component P4_sum_generator;

  component P4_carry_generator is
    generic(
      P4_CG_N   	:	integer	:=	32;
      P4_CG_CSTEP	:	integer	:=	4);
    port(
      P4_CG_op1	  :     in	std_logic_vector(P4_CG_N downto 1);
      P4_CG_op2	  :     in	std_logic_vector(P4_CG_N downto 1);
      P4_CG_cin   :     in      std_logic;
      P4_CG_cout  :     out	std_logic_vector(P4_CG_N/P4_CG_CSTEP downto 1));
  end component P4_carry_generator;

  signal sparse_carries_out: std_logic_vector(P4_NBIT/P4_CSTEP downto 0);

begin

  SGEN : P4_sum_generator
    generic map (
      P4_SGEN_NBIT  => P4_NBIT,
      P4_SGEN_CSTEP => P4_CSTEP)
    port map (
      P4_SGEN_operand_A  => P4_operand_A,
      P4_SGEN_operand_B  => P4_operand_B,
      P4_SGEN_carries_in => sparse_carries_out(P4_NBIT/P4_CSTEP-1 downto 0),
      P4_SGEN_result     => P4_result);

  STCG : P4_carry_generator
    generic map (
      P4_CG_N     => P4_NBIT,
      P4_CG_CSTEP => P4_CSTEP)
    port map (
      P4_CG_op1  => P4_operand_A,
      P4_CG_op2  => P4_operand_B,
      P4_CG_cin  => P4_carry_in,
      P4_CG_cout => sparse_carries_out(P4_NBIT/P4_CSTEP downto 1));

  sparse_carries_out(0) <= P4_carry_in;
  P4_carry_out          <= sparse_carries_out(P4_NBIT/P4_CSTEP);

end structural;

--configuration CFG_P4_ADDER_STR of P4_adder is
--  for structural
--    for all : P4_sum_generator
--      use configuration work.CFG_P4_SUM_GENERATOR_STR;
--    end for;
--    for all : P4_carry_generator
--      use configuration work.CFG_P4_CARRY_GENERATOR_STR;
--    end for;
--  end for;
--end configuration CFG_P4_ADDER_STR;


