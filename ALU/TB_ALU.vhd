library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_ALU is
end TB_ALU;

architecture TEST of TB_ALU is

   component ALU is
      generic(
         ALU_NBIT :  integer  := 32);
      port(
         ALU_command    :  in    std_logic_vector(5 downto 0);
         ALU_operand1   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
         ALU_operand2   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
         ALU_result     :  out   std_logic_vector(ALU_NBIT-1 downto 0));
   end component;

   constant c_ALU_NBIT  :  integer  := 32;

   signal s_ALU_command    :  std_logic_vector(5 downto 0);
   signal s_ALU_operand1   :  std_logic_vector(c_ALU_NBIT-1 downto 0);
   signal s_ALU_operand2   :  std_logic_vector(c_ALU_NBIT-1 downto 0);
   signal s_ALU_result     :  std_logic_vector(c_ALU_NBIT-1 downto 0);

begin

   UUT : ALU
      generic map(
         ALU_NBIT    => c_ALU_NBIT)
      port map(
         ALU_command    => s_ALU_command,
         ALU_operand1   => s_ALU_operand1,
         ALU_operand2   => s_ALU_operand2,
         ALU_result     => s_ALU_result);

   INPUT_STIMULI_PROCESS : process
   begin
      s_ALU_operand1 <= x"00231ac3";
      s_ALU_operand2 <= x"f209401d";

      s_ALU_command  <= "000000";
      wait for 1 ns;
      s_ALU_command  <= "010000";
      wait for 1 ns;
      s_ALU_command  <= "100000";
      wait for 1 ns;
      s_ALU_command  <= "110000";
      wait for 1 ns;
      s_ALU_command  <= "000001";
      wait for 1 ns;
      s_ALU_command  <= "000101";
      wait for 1 ns;
      s_ALU_command  <= "000110";
      wait for 1 ns;
      s_ALU_command  <= "001110";
      wait for 1 ns;
      s_ALU_command  <= "010110";
      wait for 1 ns;
      s_ALU_command  <= "011110";
      wait for 1 ns;
      s_ALU_command  <= "000111";
      wait for 1 ns;
      s_ALU_command  <= "111011";
      wait for 1 ns;
      s_ALU_command  <= "011111";
      wait for 1 ns;
      s_ALU_command  <= "100011";
      wait for 1 ns;
      s_ALU_command  <= "011011";
      wait for 1 ns;
      s_ALU_command  <= "100111";
      wait;
   end process;

end TEST;
