library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.ALU_pkg.all;

entity TB_COMP_bit_comparator is
end TB_COMP_bit_comparator;

architecture TEST of TB_COMP_bit_comparator is

    component COMP_bit_comparator is
        port(
            COMP_BIT_op1         :  in    std_logic;
            COMP_BIT_op2         :  in    std_logic;
            COMP_BIT_previous_gt :  in    std_logic;
            COMP_BIT_previous_lt :  in    std_logic;
            COMP_BIT_gt          :  out   std_logic;
            COMP_BIT_lt          :  out   std_logic);
    end component;

    signal s_COMP_BIT_op1         :  std_logic   := '0';
    signal s_COMP_BIT_op2         :  std_logic   := '0';
    signal s_COMP_BIT_previous_gt :  std_logic   := '0';
    signal s_COMP_BIT_previous_lt :  std_logic   := '0';
    signal s_COMP_BIT_gt          :  std_logic   := '0';
    signal s_COMP_BIT_ls          :  std_logic   := '0';

begin

    UUT : COMP_bit_comparator
        port map(
            COMP_BIT_op1         => s_COMP_BIT_op1,
            COMP_BIT_op2         => s_COMP_BIT_op2,
            COMP_BIT_previous_gt => s_COMP_BIT_previous_gt,
            COMP_BIT_previous_lt => s_COMP_BIT_previous_lt,
            COMP_BIT_gt          => s_COMP_BIT_gt,
            COMP_BIT_lt          => s_COMP_BIT_ls);

   INPUT_STIMULI_PROCESS : process
   begin
        s_COMP_BIT_op1 <= '0';
        s_COMP_BIT_op2 <= '0';

        s_COMP_BIT_previous_lt  <= '0';
        s_COMP_BIT_previous_gt  <= '0';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '0';
        s_COMP_BIT_previous_gt <= '1';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '1';
        s_COMP_BIT_previous_gt <= '0';
        wait for 1 ns;

        s_COMP_BIT_op1 <= '0';
        s_COMP_BIT_op2 <= '1';

        s_COMP_BIT_previous_lt  <= '0';
        s_COMP_BIT_previous_gt  <= '0';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '0';
        s_COMP_BIT_previous_gt <= '1';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '1';
        s_COMP_BIT_previous_gt <= '0';
        wait for 1 ns;

        s_COMP_BIT_op1 <= '1';
        s_COMP_BIT_op2 <= '0';

        s_COMP_BIT_previous_lt  <= '0';
        s_COMP_BIT_previous_gt  <= '0';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '0';
        s_COMP_BIT_previous_gt <= '1';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '1';
        s_COMP_BIT_previous_gt <= '0';
        wait for 1 ns;

        s_COMP_BIT_op1 <= '1';
        s_COMP_BIT_op2 <= '1';

        s_COMP_BIT_previous_lt  <= '0';
        s_COMP_BIT_previous_gt  <= '0';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '0';
        s_COMP_BIT_previous_gt <= '1';
        wait for 1 ns;
        s_COMP_BIT_previous_lt <= '1';
        s_COMP_BIT_previous_gt <= '0';
        wait;

   end process;
end TEST;
