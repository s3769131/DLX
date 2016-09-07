library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity LU_bit_logic_unit is
    port(
        LU_BIT_LOGIC_UNIT_sel   :   in  std_logic_vector(3 downto 0);
        LU_BIT_LOGIC_UNIT_op1   :   in  std_logic;
        LU_BIT_LOGIC_UNIT_op2   :   in  std_logic;
        LU_BIT_LOGIC_UNIT_res   :   out std_logic);
end LU_bit_logic_unit;

architecture dflow of LU_bit_logic_unit is
    signal s_tmp    :   std_logic_vector(3 downto 0);
begin

    s_tmp(0)    <=  not (LU_BIT_LOGIC_UNIT_sel(0) and (not LU_BIT_LOGIC_UNIT_op1) and (not LU_BIT_LOGIC_UNIT_op2));
    s_tmp(1)    <=  not (LU_BIT_LOGIC_UNIT_sel(1) and (not LU_BIT_LOGIC_UNIT_op1) and LU_BIT_LOGIC_UNIT_op2);
    s_tmp(2)    <=  not (LU_BIT_LOGIC_UNIT_sel(2) and LU_BIT_LOGIC_UNIT_op1 and (not LU_BIT_LOGIC_UNIT_op2));
    s_tmp(3)    <=  not (LU_BIT_LOGIC_UNIT_sel(3) and LU_BIT_LOGIC_UNIT_op1 and LU_BIT_LOGIC_UNIT_op2);
    LU_BIT_LOGIC_UNIT_res   <=  nand_reduce(s_tmp);

end dflow;

configuration CFG_LU_BIT_LOGIC_UNIT_DFLOW of LU_bit_logic_unit is
   for dflow
   end for;
end CFG_LU_BIT_LOGIC_UNIT_DFLOW;
