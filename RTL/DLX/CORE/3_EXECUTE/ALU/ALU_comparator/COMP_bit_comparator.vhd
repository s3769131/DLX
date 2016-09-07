library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.ALU_pkg.all;

entity COMP_bit_comparator is
    port(
        COMP_BIT_op1            :   in  std_logic;
        COMP_BIT_op2            :   in  std_logic;
        COMP_BIT_previous_gt    :   in  std_logic;
        COMP_BIT_previous_lt    :   in  std_logic;
        COMP_BIT_gt             :   out std_logic;
        COMP_BIT_lt             :   out std_logic);
end COMP_bit_comparator;

architecture dflow of COMP_bit_comparator is
begin

    COMP_BIT_gt <=  COMP_BIT_previous_gt or (COMP_BIT_op1 and (not COMP_BIT_op2) and (not COMP_BIT_previous_lt));
    COMP_BIT_lt <=  COMP_BIT_previous_lt or ((not COMP_BIT_op1) and COMP_BIT_op2 and (not COMP_BIT_previous_gt));

end dflow;

configuration CFG_BIT_COMPARATOR_DFLOW of COMP_bit_comparator is
    for dflow
    end for;
end configuration CFG_BIT_COMPARATOR_DFLOW;
