library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_ALU_comparator is
end TB_ALU_comparator;

architecture TEST of TB_ALU_comparator is

   component ALU_comparator is
      generic(
         ALU_COMP_NBIT  :  integer  := 32);
      port(
         ALU_COMP_difference  :  in    std_logic_vector(ALU_COMP_NBIT-1 downto 0);
         ALU_COMP_carry_out   :  in    std_logic;
         ALU_COMP_op1_le_op2  :  out   std_logic;
         ALU_COMP_op1_lt_op2  :  out   std_logic;
         ALU_COMP_op1_gt_op2  :  out   std_logic;
         ALU_COMP_op1_ge_op2  :  out   std_logic;
         ALU_COMP_op1_eq_op2  :  out   std_logic);
   end component;

   constant c_ALU_COMP_NBIT :  integer  := 16;

   signal s_ALU_COMP_difference  :  std_logic_vector(c_ALU_COMP_NBIT-1 downto 0) := (others => '0');
   signal s_ALU_COMP_carry_out   :  std_logic                                    := '0';
   signal s_ALU_COMP_op1_le_op2  :  std_logic                                    := '0';
   signal s_ALU_COMP_op1_lt_op2  :  std_logic                                    := '0';
   signal s_ALU_COMP_op1_gt_op2  :  std_logic                                    := '0';
   signal s_ALU_COMP_op1_ge_op2  :  std_logic                                    := '0';
   signal s_ALU_COMP_op1_eq_op2  :  std_logic                                    := '0';

begin

   UUT : ALU_comparator
      generic map(
         ALU_COMP_NBIT  => c_ALU_COMP_NBIT)
      port map(
         ALU_COMP_difference  => s_ALU_COMP_difference,
         ALU_COMP_carry_out   => s_ALU_COMP_carry_out ,
         ALU_COMP_op1_le_op2  => s_ALU_COMP_op1_le_op2,
         ALU_COMP_op1_lt_op2  => s_ALU_COMP_op1_lt_op2,
         ALU_COMP_op1_gt_op2  => s_ALU_COMP_op1_gt_op2,
         ALU_COMP_op1_ge_op2  => s_ALU_COMP_op1_ge_op2,
         ALU_COMP_op1_eq_op2  => s_ALU_COMP_op1_eq_op2);

   INPUT_STIMULI_PROCESS : process
   begin
      s_ALU_COMP_difference   <= x"f384";
      s_ALU_COMP_carry_out    <= '0';
      wait for 1 ns;
      s_ALU_COMP_carry_out    <= '1';
      wait for 1 ns;

      s_ALU_COMP_difference   <= x"3001";
      s_ALU_COMP_carry_out    <= '0';
      wait for 1 ns;
      s_ALU_COMP_carry_out    <= '1';
      wait for 1 ns;

      s_ALU_COMP_difference   <= x"5263";
      s_ALU_COMP_carry_out    <= '0';
      wait for 1 ns;
      s_ALU_COMP_carry_out    <= '1';
      wait;
   end process;

end TEST;
