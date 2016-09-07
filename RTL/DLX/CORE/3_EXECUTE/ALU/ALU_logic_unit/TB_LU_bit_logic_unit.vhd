library ieee;
use ieee.std_logic_1164.all;

entity TB_LU_bit_logic_unit is
end TB_LU_bit_logic_unit;

architecture TEST of TB_LU_bit_logic_unit is

   component LU_bit_logic_unit is
      port(
         LU_BIT_LOGIC_UNIT_sel  :  in    std_logic_vector(3 downto 0);
         LU_BIT_LOGIC_UNIT_op1  :  in    std_logic;
         LU_BIT_LOGIC_UNIT_op2  :  in    std_logic;
         LU_BIT_LOGIC_UNIT_res  :  out   std_logic);
   end component;

   signal s_LU_BIT_LOGIC_UNIT_sel   :  std_logic_vector(3 downto 0)  := (others =>  '0');
   signal s_LU_BIT_LOGIC_UNIT_op1   :  std_logic   := '0';
   signal s_LU_BIT_LOGIC_UNIT_op2   :  std_logic   := '0';
   signal s_LU_BIT_LOGIC_UNIT_res   :  std_logic   := '0';

begin

   UUT : LU_bit_logic_unit
      port map(
         LU_BIT_LOGIC_UNIT_sel   => s_LU_BIT_LOGIC_UNIT_sel,
         LU_BIT_LOGIC_UNIT_op1   => s_LU_BIT_LOGIC_UNIT_op1,
         LU_BIT_LOGIC_UNIT_op2   => s_LU_BIT_LOGIC_UNIT_op2,
         LU_BIT_LOGIC_UNIT_res   => s_LU_BIT_LOGIC_UNIT_res
      );

   INPUT_STIMULI_PROCESS : process
   begin
      s_LU_BIT_LOGIC_UNIT_op1 <= '0';
      s_LU_BIT_LOGIC_UNIT_op2 <= '0';

      s_LU_BIT_LOGIC_UNIT_sel <= "1000";  -- bitwise AND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0111";  -- bitwise NAND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1110";  -- bitwise OR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0001";  -- bitwise NOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0110";  -- bitwise XOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1001";  -- bitwise XNOR
      wait for 1 ns;

      s_LU_BIT_LOGIC_UNIT_op1 <= '0';
      s_LU_BIT_LOGIC_UNIT_op2 <= '1';

      s_LU_BIT_LOGIC_UNIT_sel <= "0001";  -- bitwise AND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1110";  -- bitwise NAND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0111";  -- bitwise OR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1000";  -- bitwise NOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0110";  -- bitwise XOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1001";  -- bitwise XNOR
      wait for 1 ns;

      s_LU_BIT_LOGIC_UNIT_op1 <= '1';
      s_LU_BIT_LOGIC_UNIT_op2 <= '0';

      s_LU_BIT_LOGIC_UNIT_sel <= "0001";  -- bitwise AND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1110";  -- bitwise NAND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0111";  -- bitwise OR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1000";  -- bitwise NOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0110";  -- bitwise XOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1001";  -- bitwise XNOR
      wait for 1 ns;

      s_LU_BIT_LOGIC_UNIT_op1 <= '1';
      s_LU_BIT_LOGIC_UNIT_op2 <= '1';

      s_LU_BIT_LOGIC_UNIT_sel <= "0001";  -- bitwise AND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1110";  -- bitwise NAND
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0111";  -- bitwise OR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1000";  -- bitwise NOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "0110";  -- bitwise XOR
      wait for 1 ns;
      s_LU_BIT_LOGIC_UNIT_sel <= "1001";  -- bitwise XNOR
      wait;
   end process;

end TEST;
