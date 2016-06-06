library ieee;
use ieee.std_logic_1164.all;

--! FULL_ADDER
--!  models a single full adder, with a data-flow description style.
entity FULL_ADDER is
  port(
    FA_OP1   :   in  std_logic;  -- First operand
    FA_OP2   :   in  std_logic;  -- Second operand
    FA_CIN   :   in  std_logic;  -- Carry in
    FA_COUT  :   out std_logic;  -- Carry out
    FA_RES   :   out std_logic); -- Sum
end FULL_ADDER;

architecture BHV of FULL_ADDER is
begin
  FA_RES  <=  FA_OP1 xor FA_OP2 xor FA_CIN;
  FA_COUT <=  (FA_OP1 and FA_OP2) or (FA_OP1 and FA_CIN) or (FA_OP2 and FA_CIN);
end BHV;

--configuration CFG_FULL_ADDER_DFLOW of full_adder is
--  for dflow
--  end for;
--end configuration CFG_FULL_ADDER_DFLOW;
