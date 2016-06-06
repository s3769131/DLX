library ieee;
use ieee.std_logic_1164.all;

entity LU_bit_logic_unit is
   port(
      LU_BIT_LOGIC_UNIT_sel  :  in    std_logic_vector(0 to 3);
      LU_BIT_LOGIC_UNIT_op1  :  in    std_logic;
      LU_BIT_LOGIC_UNIT_op2  :  in    std_logic;
      LU_BIT_LOGIC_UNIT_res  :  out   std_logic);
end LU_bit_logic_unit;

architecture bhv of LU_bit_logic_unit is
begin

   MAIN : process(LU_BIT_LOGIC_UNIT_op1, LU_BIT_LOGIC_UNIT_op2, LU_BIT_LOGIC_UNIT_sel)
      variable tmp0, tmp1, tmp2, tmp3  :  std_logic;
   begin
      tmp0  := not (LU_BIT_LOGIC_UNIT_sel(0) and (not LU_BIT_LOGIC_UNIT_op1) and (not LU_BIT_LOGIC_UNIT_op2));
      tmp1  := not (LU_BIT_LOGIC_UNIT_sel(1) and (not LU_BIT_LOGIC_UNIT_op1) and LU_BIT_LOGIC_UNIT_op2);
      tmp2  := not (LU_BIT_LOGIC_UNIT_sel(2) and LU_BIT_LOGIC_UNIT_op1 and (not LU_BIT_LOGIC_UNIT_op2));
      tmp3  := not (LU_BIT_LOGIC_UNIT_sel(3) and LU_BIT_LOGIC_UNIT_op1 and LU_BIT_LOGIC_UNIT_op2);
      LU_BIT_LOGIC_UNIT_res  <= not (tmp0 and tmp1 and tmp2 and tmp3);
   end process;

end bhv;

configuration CFG_LU_BIT_LOGIC_UNIT_BHV of LU_bit_logic_unit is
   for bhv
   end for;
end CFG_LU_BIT_LOGIC_UNIT_BHV;
