library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_CLA_carry_generator is
end TB_CLA_carry_generator;

architecture TEST of TB_CLA_carry_generator is

   component CLA_carry_generator is
      generic(
         CLA_CGEN_NBIT       :  integer  := 32;
         CLA_CGEN_CARRY_STEP :  integer  := 4);
      port(
         CLA_CGEN_op1  :   in   std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
         CLA_CGEN_op2  :   in   std_logic_vector(CLA_CGEN_NBIT-1 downto 0);
         CLA_CGEN_cin  :   in   std_logic;
         CLA_CGEN_cout :   out  std_logic_vector(CLA_CGEN_NBIT/CLA_CGEN_CARRY_STEP downto 0));
   end component;

   constant c_CLA_CGEN_NBIT         :  integer  := 16;
   constant c_CLA_CGEN_CARRY_STEP   :  integer  := 4;

   signal s_CLA_CGEN_op1  :  std_logic_vector(c_CLA_CGEN_NBIT-1 downto 0)  := (others => '0');
   signal s_CLA_CGEN_op2  :  std_logic_vector(c_CLA_CGEN_NBIT-1 downto 0)  := (others => '0');
   signal s_CLA_CGEN_cin  :  std_logic   := '0';
   signal s_CLA_CGEN_cout :  std_logic_vector(c_CLA_CGEN_NBIT/c_CLA_CGEN_CARRY_STEP-1 downto 0) := (others => '0');

begin

   UUT : CLA_carry_generator
      generic map(
         CLA_CGEN_NBIT        => c_CLA_CGEN_NBIT,
         CLA_CGEN_CARRY_STEP  => c_CLA_CGEN_CARRY_STEP
      )
      port map(
         CLA_CGEN_op1   => s_CLA_CGEN_op1,
         CLA_CGEN_op2   => s_CLA_CGEN_op2,
         CLA_CGEN_cin   => s_CLA_CGEN_cin,
         CLA_CGEN_cout  => s_CLA_CGEN_cout
      );

   INPUT_STIMULI_PROCESS : process
   begin
      s_CLA_CGEN_cin  <= '0';
      s_CLA_CGEN_op1  <= x"0000";
      s_CLA_CGEN_op2  <= x"0000";
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '1';
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '0';
      s_CLA_CGEN_op1  <= x"ffff";
      s_CLA_CGEN_op2  <= x"0000";
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '1';
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '0';
      s_CLA_CGEN_op1  <= x"ffff";
      s_CLA_CGEN_op2  <= x"ffff";
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '1';
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '0';
      s_CLA_CGEN_op1  <= x"305f";
      s_CLA_CGEN_op2  <= x"2601";
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '1';
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '0';
      s_CLA_CGEN_op1  <= x"dbe8";
      s_CLA_CGEN_op2  <= x"63f7";
      wait for 1 ns;
      s_CLA_CGEN_cin  <= '1';
      wait;
   end process;

end TEST;
