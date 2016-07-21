library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
   port(
      fa_op1   :  in    std_logic;
      fa_op2   :  in    std_logic;
      fa_cin   :  in    std_logic;
      fa_cout  :  out   std_logic;
      fa_res   :  out   std_logic);
end full_adder;

architecture dflow of full_adder is
begin
   fa_res  <=  fa_op1 xor fa_op2 xor fa_cin;
   fa_cout <=  (fa_op1 and fa_op2) or (fa_op1 and fa_cin) or (fa_op2 and fa_cin);
end dflow;

configuration CFG_FULL_ADDER_DFLOW of full_adder is
   for dflow
   end for;
end configuration CFG_FULL_ADDER_DFLOW;
