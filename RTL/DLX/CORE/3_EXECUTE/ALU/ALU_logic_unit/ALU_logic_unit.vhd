library ieee;
use ieee.std_logic_1164.all;

entity ALU_logic_unit is
   generic(
      ALU_LU_NBIT   :  integer  := 32
   );
   port(
      ALU_LU_sel  :  in    std_logic_vector(3 downto 0);
      ALU_LU_op1  :  in    std_logic_vector(ALU_LU_NBIT-1 downto 0);
      ALU_LU_op2  :  in    std_logic_vector(ALU_LU_NBIT-1 downto 0);
      ALU_LU_res  :  out   std_logic_vector(ALU_LU_NBIT-1 downto 0));
end ALU_logic_unit;

architecture str of ALU_logic_unit is

   component LU_bit_logic_unit is
      port(
         LU_BIT_LOGIC_UNIT_sel  :  in    std_logic_vector(3 downto 0);
         LU_BIT_LOGIC_UNIT_op1  :  in    std_logic;
         LU_BIT_LOGIC_UNIT_op2  :  in    std_logic;
         LU_BIT_LOGIC_UNIT_res  :  out   std_logic);
   end component;

begin

   LOGIC_UNIT_GEN : for i in 0 to ALU_LU_NBIT-1 generate
      BIT_UNIT : LU_bit_logic_unit
         port map(
            LU_BIT_LOGIC_UNIT_sel   => ALU_LU_sel,
            LU_BIT_LOGIC_UNIT_op1   => ALU_LU_op1(i),
            LU_BIT_LOGIC_UNIT_op2   => ALU_LU_op2(i),
            LU_BIT_LOGIC_UNIT_res   => ALU_LU_res(i)
         );
   end generate;

end str;

configuration CFG_ALU_LOGIC_UNIT_STR of ALU_logic_unit is
   for str
      for LOGIC_UNIT_GEN
         for BIT_UNIT : LU_bit_logic_unit
            use configuration work.CFG_LU_BIT_LOGIC_UNIT_BHV;
         end for;
      end for;
   end for;
end CFG_ALU_LOGIC_UNIT_STR;
