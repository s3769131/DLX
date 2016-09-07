library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port(
        FA_op1  :   in  std_logic;
        FA_op2  :   in  std_logic;
        FA_cin  :   in  std_logic;
        FA_cout :   out std_logic;
        FA_res  :   out std_logic);
end full_adder;

architecture dflow of full_adder is
begin
    FA_res  <=  FA_op1 xor FA_op2 xor FA_cin;
    FA_cout <=  (FA_op1 and FA_op2) or (FA_op1 and FA_cin) or (FA_op2 and FA_cin);
end dflow;

configuration CFG_FULL_ADDER_DFLOW of full_adder is
    for dflow
    end for;
end configuration CFG_FULL_ADDER_DFLOW;
