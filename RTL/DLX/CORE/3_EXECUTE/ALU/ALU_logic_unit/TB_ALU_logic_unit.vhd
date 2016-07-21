library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_ALU_logic_unit is
end TB_ALU_logic_unit;

architecture TEST of TB_ALU_logic_unit is

   component ALU_logic_unit is
      generic(
         ALU_LU_NBIT   :  integer  := 32
      );
      port(
         ALU_LU_sel  :  in    std_logic_vector(3 downto 0);
         ALU_LU_op1  :  in    std_logic_vector(ALU_LU_NBIT-1 downto 0);
         ALU_LU_op2  :  in    std_logic_vector(ALU_LU_NBIT-1 downto 0);
         ALU_LU_res  :  out   std_logic_vector(ALU_LU_NBIT-1 downto 0));
   end component;

   constant c_ALU_LU_NBIT :  integer  := 2;

   signal s_ALU_LU_sel :  std_logic_vector(3 downto 0)  := (others =>  '0');
   signal s_ALU_LU_op1 :  std_logic_vector(c_ALU_LU_NBIT-1 downto 0)  := (others => '0');
   signal s_ALU_LU_op2 :  std_logic_vector(c_ALU_LU_NBIT-1 downto 0)  := (others => '0');
   signal s_ALU_LU_res :  std_logic_vector(c_ALU_LU_NBIT-1 downto 0)  := (others => '0');

begin

   UUT : ALU_logic_unit
      port map(
         ALU_LU_sel => s_ALU_LU_sel,
         ALU_LU_op1 => s_ALU_LU_op1,
         ALU_LU_op2 => s_ALU_LU_op2,
         ALU_LU_res => s_ALU_LU_res
      );

   INPUT_STIMULI_PROCESS : process
   begin
      for i in 0 to 3 loop
         for j in 0 to 3 loop
            s_ALU_LU_op1  <= std_logic_vector(to_unsigned(i,c_ALU_LU_NBIT));
            s_ALU_LU_op2  <= std_logic_vector(to_unsigned(j,c_ALU_LU_NBIT));

            s_ALU_LU_sel <= "0001";  -- bitwise AND
            wait for 1 ns;
            s_ALU_LU_sel <= "1110";  -- bitwise NAND
            wait for 1 ns;
            s_ALU_LU_sel <= "0111";  -- bitwise OR
            wait for 1 ns;
            s_ALU_LU_sel <= "1000";  -- bitwise NOR
            wait for 1 ns;
            s_ALU_LU_sel <= "0110";  -- bitwise XOR
            wait for 1 ns;
            s_ALU_LU_sel <= "1001";  -- bitwise XNOR
            wait for 1 ns;
         end loop;
      end loop;
      wait;
   end process;

end TEST;
