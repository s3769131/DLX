library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_CLA_sum_generator is
end TB_CLA_sum_generator;

architecture TEST of TB_CLA_sum_generator is

   component CLA_sum_generator is
      generic(
         CLA_SGEN_NBIT       :  integer  := 16;
         CLA_SGEN_CARRY_STEP :  integer  := 4);
      port(
         CLA_SGEN_op1   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
         CLA_SGEN_op2   :  in    std_logic_vector(CLA_SGEN_NBIT-1 downto 0);
         CLA_SGEN_cin   :  in    std_logic_vector(CLA_SGEN_NBIT/CLA_SGEN_CARRY_STEP-1 downto 0);
         CLA_SGEN_res   :  out   std_logic_vector(CLA_SGEN_NBIT-1 downto 0)
      );
   end component;

   constant c_CLA_SGEN_NBIT         :  integer  := 16;
   constant c_CLA_SGEN_CARRY_STEP   :  integer  := 4;

   signal s_CLA_SGEN_op1  :  std_logic_vector(c_CLA_SGEN_NBIT-1 downto 0)                       := (others => '0');
   signal s_CLA_SGEN_op2  :  std_logic_vector(c_CLA_SGEN_NBIT-1 downto 0)                       := (others => '0');
   signal s_CLA_SGEN_cin  :  std_logic_vector(c_CLA_SGEN_NBIT/c_CLA_SGEN_CARRY_STEP-1 downto 0) := (others => '0');
   signal s_CLA_SGEN_res  :  std_logic_vector(c_CLA_SGEN_NBIT-1 downto 0)                       := (others => '0');

begin

   UUT : CLA_sum_generator
      generic map(
         CLA_SGEN_NBIT        => c_CLA_SGEN_NBIT,
         CLA_SGEN_CARRY_STEP  => c_CLA_SGEN_CARRY_STEP
      )
      port map(
         CLA_SGEN_op1   => s_CLA_SGEN_op1,
         CLA_SGEN_op2   => s_CLA_SGEN_op2,
         CLA_SGEN_cin   => s_CLA_SGEN_cin,
         CLA_SGEN_res   => s_CLA_SGEN_res
      );

   INPUT_STIMULI_PROCESS : process
   begin
      s_CLA_SGEN_cin  <= "0000";
      s_CLA_SGEN_op1  <= x"0000";
      s_CLA_SGEN_op2  <= x"0000";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0001";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0000";
      s_CLA_SGEN_op1  <= x"ffff";
      s_CLA_SGEN_op2  <= x"0000";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0001";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0000";
      s_CLA_SGEN_op1  <= x"ffff";
      s_CLA_SGEN_op2  <= x"ffff";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0001";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0000";
      s_CLA_SGEN_op1  <= x"305f";
      s_CLA_SGEN_op2  <= x"2601";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0001";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0000";
      s_CLA_SGEN_op1  <= x"dbe8";
      s_CLA_SGEN_op2  <= x"63f7";
      wait for 1 ns;
      s_CLA_SGEN_cin  <= "0001";
      wait;
   end process;

end TEST;
