library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   Performs the sum among the specified operands.
--!
--!   This entity models the network that permorms the sum among the two operands in input, given
--!   the partial carries computed by the carry look-ahead logic.
entity CLA_sum_generator is
   generic(
      CLA_SGEN_NBIT       :  integer  := 16;   --!   parallelism of the input operands.
      CLA_SGEN_CARRY_STEP :  integer  := 4);   --!   step in carries generation.
   port(
      CLA_SGEN_op1   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);  --!   first operand of the sum.
      CLA_SGEN_op2   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);  --!   second operand of the sum.
      CLA_SGEN_cin   :  in    std_logic_vector(CLA_SGEN_NBIT/CLA_SGEN_CARRY_STEP-1 downto 0);   --!   carries.
      CLA_SGEN_res   :  out   std_logic_vector(CLA_SGEN_NBIT-1 downto 0)   --!   result of the operation.
   );
end CLA_sum_generator;

architecture structural of CLA_sum_generator is

   component carry_select_adder is
      generic(
         CSA_NBIT   :  integer  := 4);
      port(
         CSA_op1  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_op2  :  in    std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_cin  :  in    std_logic;
         CSA_res  :  out   std_logic_vector(CSA_NBIT-1 downto 0);
         CSA_cout :  out   std_logic);
   end component;

   component ripple_carry_adder is
      generic(
         RCA_NBIT : integer   := 4);
      port(
         RCA_op1  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_op2  :  in    std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cin  :  in    std_logic;
         RCA_res  :  out   std_logic_vector(RCA_NBIT-1 downto 0);
         RCA_cout :  out   std_logic);
   end component;

   constant N_ADDER  :  integer  := CLA_SGEN_NBIT/CLA_SGEN_CARRY_STEP;

begin

   SGEN_GEN : for i in 0 to N_ADDER-1 generate
      RCA_GEN : if i = 0 generate
         RCA : ripple_carry_adder
            generic map(
               RCA_NBIT => CLA_SGEN_CARRY_STEP
            )
            port map(
               RCA_op1  => CLA_SGEN_op1(CLA_SGEN_CARRY_STEP-1 downto 0),
               RCA_op2  => CLA_SGEN_op2(CLA_SGEN_CARRY_STEP-1 downto 0),
               RCA_cin  => CLA_SGEN_cin(0),
               RCA_res  => CLA_SGEN_res(CLA_SGEN_CARRY_STEP-1 downto 0),
               RCA_cout => open
            );
      end generate;
      CSA_GEN : if i /= 0 generate
         CSA : carry_select_adder
            generic map(
               CSA_NBIT => CLA_SGEN_CARRY_STEP
            )
            port map(
               CSA_op1  => CLA_SGEN_op1((i+1)*CLA_SGEN_CARRY_STEP-1 downto i*CLA_SGEN_CARRY_STEP),
               CSA_op2  => CLA_SGEN_op2((i+1)*CLA_SGEN_CARRY_STEP-1 downto i*CLA_SGEN_CARRY_STEP),
               CSA_cin  => CLA_SGEN_cin(i),
               CSA_res  => CLA_SGEN_res((i+1)*CLA_SGEN_CARRY_STEP-1 downto i*CLA_SGEN_CARRY_STEP),
               CSA_cout => open
            );
      end generate;
   end generate;

end structural;

configuration CFG_CLA_SGEN_STR of CLA_sum_generator is
   for structural
      for SGEN_GEN
         for RCA_GEN
            for RCA : ripple_carry_adder
               use configuration work.CFG_RIPPLE_CARRY_ADDER_STR;
            end for;
         end for;
         for CSA_GEN
            for CSA : carry_select_adder
               use configuration work.CFG_CARRY_SELECT_ADDER_STR;
            end for;
         end for;
      end for;
   end for;
end configuration CFG_CLA_SGEN_STR;
