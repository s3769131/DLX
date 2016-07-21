library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   Carry look-ahead adder/subtractor.
--!
--!   This entity models the network that permorms the sum or the subtraction among two operands
--!   given as input. A look-ahead architecture is used.
entity ALU_carry_lookahead_adder is
   generic(
      ALU_CLA_NBIT       :  integer  := 16);   --!   parallelism of the operands.
   port(
      ALU_CLA_op1     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   first operand of the sum.
      ALU_CLA_op2     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   second operand of the sum.
      ALU_CLA_add     :  in    std_logic;                                  --!   carries.
      ALU_CLA_res     :  out   std_logic_vector(ALU_CLA_NBIT-1 downto 0);  --!   result of the operation.
      ALU_CLA_cout    :  out   std_logic;                                  --!   carry out of the overall operation.
      ALU_CLA_ovflow  :  out   std_logic);                                 --!   report if an overflow is detected.
end ALU_carry_lookahead_adder;

architecture str of ALU_carry_lookahead_adder is

   component CLA_carry_generator is
      generic(
         CLA_CGEN_NBIT       :  integer  := 16;
         CLA_CGEN_CARRY_STEP :  integer  := 4);
      port(
         CLA_CGEN_op1   :  in    std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
         CLA_CGEN_op2   :  in    std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
         CLA_CGEN_cin   :  in    std_logic;
         CLA_CGEN_cout  :  out   std_logic_vector(CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP-1 downto 0));
   end component;

   component CLA_sum_generator is
      generic(
         CLA_SGEN_NBIT       :  integer  := 16;
         CLA_SGEN_CARRY_STEP :  integer  := 4);
      port(
         CLA_SGEN_op1   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
         CLA_SGEN_op2   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
         CLA_SGEN_cin   :  in    std_logic_vector(CLA_SGEN_NBIT/CLA_SGEN_CARRY_STEP-1 downto 0);
         CLA_SGEN_res   :  out   std_logic_vector(CLA_SGEN_NBIT-1 downto 0)
      );
   end component;

   constant CLA_CARRY_STEP :  integer  := 2**(divide2(log2ceil(ALU_CLA_NBIT))-1);
   constant N_CARRIES      :  integer  := ALU_CLA_NBIT/CLA_CARRY_STEP;

   signal actual_op2       :  std_logic_vector(ALU_CLA_NBIT-1 downto 0);
   signal actual_carries   :  std_logic_vector(N_CARRIES-1 downto 0);
   signal carries          :  std_logic_vector(N_CARRIES-1 downto 0);

begin

   OP2_GEN : for i in 0 to ALU_CLA_NBIT-1 generate
      actual_op2(i)  <= ALU_CLA_op2(i) xor ALU_CLA_add;
   end generate;

   actual_carries <= carries(N_CARRIES-2 downto 0)&(ALU_CLA_add);

   CARRY_GENERATOR : CLA_carry_generator
      generic map(
         CLA_CGEN_NBIT        => ALU_CLA_NBIT,
         CLA_CGEN_CARRY_STEP  => CLA_CARRY_STEP
      )
      port map(
         CLA_CGEN_op1   => ALU_CLA_op1,
         CLA_CGEN_op2   => actual_op2,
         CLA_CGEN_cin   => ALU_CLA_add,
         CLA_CGEN_cout  => carries
      );

   RES_GENERATOR : CLA_sum_generator
      generic map(
         CLA_SGEN_NBIT        => ALU_CLA_NBIT,
         CLA_SGEN_CARRY_STEP  => CLA_CARRY_STEP
      )
      port map(
         CLA_SGEN_op1   => ALU_CLA_op1,
         CLA_SGEN_op2   => actual_op2,
         CLA_SGEN_cin   => actual_carries,
         CLA_SGEN_res   => ALU_CLA_res
      );

   ALU_CLA_ovflow <= carries(N_CARRIES-1) xor ALU_CLA_op1(ALU_CLA_NBIT-1) xor ALU_CLA_op2(ALU_CLA_NBIT-1);
   ALU_CLA_cout   <= carries(N_CARRIES-1);

end str;

configuration CFG_ALU_CARRY_LOOKAHEAD_ADDER_STR of ALU_carry_lookahead_adder is
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
end configuration CFG_ALU_CARRY_LOOKAHEAD_ADDER_STR;
