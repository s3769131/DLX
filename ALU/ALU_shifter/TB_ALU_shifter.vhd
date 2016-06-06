library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_pkg.all;

entity TB_ALU_shifter is
end TB_ALU_shifter;

architecture TEST of TB_ALU_shifter is

   component ALU_shifter is
      generic(
         ALU_SHIFTER_NBIT  :  integer  := 32);
      port(
         ALU_SHIFTER_operand     :  in    std_logic_vector(ALU_SHIFTER_NBIT-1 downto 0);
         ALU_SHIFTER_n_shift     :  in    std_logic_vector(log2ceil(ALU_SHIFTER_NBIT)-1 downto 0);
         ALU_SHIFTER_left_right  :  in    std_logic;
         ALU_SHIFTER_logic_arith :  in    std_logic;
         ALU_SHIFTER_result      :  out   std_logic_vector(ALU_SHIFTER_NBIT-1 downto 0));
   end component;

   constant c_ALU_SHIFTER_NBIT   :  integer  := 32;

   signal s_ALU_SHIFTER_operand     :  std_logic_vector(c_ALU_SHIFTER_NBIT-1 downto 0)             := (others => '0');
   signal s_ALU_SHIFTER_n_shift     :  std_logic_vector(log2ceil(c_ALU_SHIFTER_NBIT)-1 downto 0)   := (others => '0');
   signal s_ALU_SHIFTER_left_right  :  std_logic                                                   := '0';
   signal s_ALU_SHIFTER_logic_arith :  std_logic                                                   := '0';
   signal s_ALU_SHIFTER_result      :  std_logic_vector(c_ALU_SHIFTER_NBIT-1 downto 0)             := (others => '0');

begin

   UUT : ALU_shifter
      generic map(
         ALU_SHIFTER_NBIT  => c_ALU_SHIFTER_NBIT)
      port map(
         ALU_SHIFTER_operand     => s_ALU_SHIFTER_operand,
         ALU_SHIFTER_n_shift     => s_ALU_SHIFTER_n_shift,
         ALU_SHIFTER_left_right  => s_ALU_SHIFTER_left_right,
         ALU_SHIFTER_logic_arith => s_ALU_SHIFTER_logic_arith,
         ALU_SHIFTER_result      => s_ALU_SHIFTER_result);

   INPUT_STIMULI_PROCESS : process
   begin
      s_ALU_SHIFTER_operand      <= x"d4f237ac";

      s_ALU_SHIFTER_left_right   <= '0';
      s_ALU_SHIFTER_logic_arith  <= '0';
      for i in 0 to c_ALU_SHIFTER_NBIT-1 loop
         s_ALU_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,log2ceil(c_ALU_SHIFTER_NBIT)));
         wait for 1 ns;
      end loop;

      s_ALU_SHIFTER_left_right   <= '0';
      s_ALU_SHIFTER_logic_arith  <= '1';
      for i in 0 to c_ALU_SHIFTER_NBIT-1 loop
         s_ALU_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,log2ceil(c_ALU_SHIFTER_NBIT)));
         wait for 1 ns;
      end loop;

      s_ALU_SHIFTER_left_right   <= '1';
      s_ALU_SHIFTER_logic_arith  <= '0';
      for i in 0 to c_ALU_SHIFTER_NBIT-1 loop
         s_ALU_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,log2ceil(c_ALU_SHIFTER_NBIT)));
         wait for 1 ns;
      end loop;

      s_ALU_SHIFTER_left_right   <= '1';
      s_ALU_SHIFTER_logic_arith  <= '1';
      for i in 0 to c_ALU_SHIFTER_NBIT-1 loop
         s_ALU_SHIFTER_n_shift   <= std_logic_vector(to_unsigned(i,log2ceil(c_ALU_SHIFTER_NBIT)));
         wait for 1 ns;
      end loop;

      wait;
   end process;

end TEST;
