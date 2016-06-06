library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.ALU_pkg.all;

entity ALU_comparator is
   generic(
      ALU_COMP_NBIT  :  integer  := 32);
   port(
      ALU_COMP_difference  :  in    std_logic_vector(ALU_COMP_NBIT-1 downto 0);
      ALU_COMP_carry_out   :  in    std_logic;
      ALU_COMP_op1_le_op2  :  out   std_logic;
      ALU_COMP_op1_lt_op2  :  out   std_logic;
      ALU_COMP_op1_gt_op2  :  out   std_logic;
      ALU_COMP_op1_ge_op2  :  out   std_logic;
      ALU_COMP_op1_eq_op2  :  out   std_logic);
end ALU_comparator;

architecture bhv of ALU_comparator is
begin

   MAIN : process(ALU_COMP_difference, ALU_COMP_carry_out)
   begin
      ALU_COMP_op1_le_op2  <= (not ALU_COMP_carry_out) or nor_reduce(ALU_COMP_difference);
      ALU_COMP_op1_lt_op2  <= not ALU_COMP_carry_out;
      ALU_COMP_op1_gt_op2  <= ALU_COMP_carry_out and (not nor_reduce(ALU_COMP_difference));
      ALU_COMP_op1_ge_op2  <= ALU_COMP_carry_out;
      ALU_COMP_op1_eq_op2  <= nor_reduce(ALU_COMP_difference);
   end process;

end bhv;

configuration CFG_ALU_COMPARATOR_BHV of ALU_comparator is
   for bhv
   end for;
end configuration CFG_ALU_COMPARATOR_BHV;
