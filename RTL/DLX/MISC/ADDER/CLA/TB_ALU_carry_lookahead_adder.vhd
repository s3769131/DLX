library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_ALU_carry_lookahead_adder is
end TB_ALU_carry_lookahead_adder;

architecture TEST of TB_ALU_carry_lookahead_adder is

   component ALU_carry_lookahead_adder is
      generic(
         ALU_CLA_NBIT       :  integer  := 16);
      port(
         ALU_CLA_op1    :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_op2    :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_add    :  in    std_logic;
         ALU_CLA_res    :  out   std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_cout   :  out   std_logic;
         ALU_CLA_ovflow :  out   std_logic);
   end component;

   constant c_ALU_CLA_NBIT        :  integer  := 32;

   signal s_ALU_CLA_op1     :  std_logic_vector(c_ALU_CLA_NBIT-1 downto 0) := (others => '0');
   signal s_ALU_CLA_op2     :  std_logic_vector(c_ALU_CLA_NBIT-1 downto 0) := (others => '0');
   signal s_ALU_CLA_add     :  std_logic                                   := '0';
   signal s_ALU_CLA_res     :  std_logic_vector(c_ALU_CLA_NBIT-1 downto 0) := (others => '0');
   signal s_ALU_CLA_cout    :  std_logic                                   := '0';
   signal s_ALU_CLA_ovflow  :  std_logic                                   := '0';

begin

   UUT : ALU_carry_lookahead_adder
      generic map(
         ALU_CLA_NBIT         => c_ALU_CLA_NBIT)
      port map(
         ALU_CLA_op1    => s_ALU_CLA_op1,
         ALU_CLA_op2    => s_ALU_CLA_op2,
         ALU_CLA_add    => s_ALU_CLA_add,
         ALU_CLA_res    => s_ALU_CLA_res,
         ALU_CLA_cout   => s_ALU_CLA_cout,
         ALU_CLA_ovflow => s_ALU_CLA_ovflow);

   INPUT_STIMULI_PROCESS : process
   begin
      s_ALU_CLA_add  <= '0';
      s_ALU_CLA_op1  <= x"00000000";
      s_ALU_CLA_op2  <= x"00000000";
      wait for 1 ns;
      s_ALU_CLA_add  <= '1';
      wait for 1 ns;
      s_ALU_CLA_add  <= '0';
      s_ALU_CLA_op1  <= x"ffffffff";
      s_ALU_CLA_op2  <= x"00000000";
      wait for 1 ns;
      s_ALU_CLA_add  <= '1';
      wait for 1 ns;
      s_ALU_CLA_add  <= '0';
      s_ALU_CLA_op1  <= x"ffffffff";
      s_ALU_CLA_op2  <= x"ffffffff";
      wait for 1 ns;
      s_ALU_CLA_add  <= '1';
      wait for 1 ns;
      s_ALU_CLA_add  <= '0';
      s_ALU_CLA_op1  <= x"1011305f";
      s_ALU_CLA_op2  <= x"10112601";
      wait for 1 ns;
      s_ALU_CLA_add  <= '1';
      wait for 1 ns;
      s_ALU_CLA_add  <= '0';
      s_ALU_CLA_op1  <= x"f003dbe8";
      s_ALU_CLA_op2  <= x"100063f7";
      wait for 1 ns;
      s_ALU_CLA_add  <= '1';
      wait;
   end process;

end TEST;
