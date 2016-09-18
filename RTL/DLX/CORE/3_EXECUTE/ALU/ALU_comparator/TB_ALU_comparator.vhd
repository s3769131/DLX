library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

entity TB_ALU_comparator is
end TB_ALU_comparator;

architecture TEST of TB_ALU_comparator is

  	component ALU_comparator is
    	generic(
      		ALU_COMP_NBIT : integer := 32);
    	port(
		    ALU_COMP_op1        : in  std_logic_vector(ALU_COMP_NBIT - 1 downto 0);
		    ALU_COMP_op2        : in  std_logic_vector(ALU_COMP_NBIT - 1 downto 0);
		    ALU_COMP_signed     : in  std_logic;
		    ALU_COMP_op1_le_op2 : out std_logic;
		    ALU_COMP_op1_lt_op2 : out std_logic;
		    ALU_COMP_op1_gt_op2 : out std_logic;
		    ALU_COMP_op1_ge_op2 : out std_logic;
		    ALU_COMP_op1_eq_op2 : out std_logic;
		    ALU_COMP_op1_ne_op2 : out std_logic);
	end component ALU_comparator;

    constant c_ALU_COMP_NBIT   :  integer  := 32;

    signal s_ALU_COMP_op1        	:  std_logic_vector(c_ALU_COMP_NBIT-1 downto 0)	:= (others => '0');
    signal s_ALU_COMP_op2        	:  std_logic_vector(c_ALU_COMP_NBIT-1 downto 0)	:= (others => '0');
    signal s_ALU_COMP_signed	 	:  std_logic									:= '0';
    signal s_ALU_COMP_op1_le_op2 	:  std_logic                                    := '0';
    signal s_ALU_COMP_op1_lt_op2 	:  std_logic                                    := '0';
    signal s_ALU_COMP_op1_gt_op2 	:  std_logic                                    := '0';
    signal s_ALU_COMP_op1_ge_op2 	:  std_logic                                    := '0';
    signal s_ALU_COMP_op1_eq_op2 	:  std_logic                                    := '0';
    signal s_ALU_COMP_op1_ne_op2 	:  std_logic                                    := '0';

begin

    UUT : ALU_comparator
        generic map(
            ALU_COMP_NBIT  => c_ALU_COMP_NBIT)
        port map(
            ALU_COMP_op1         => s_ALU_COMP_op1,
            ALU_COMP_op2         => s_ALU_COMP_op2,
            ALU_COMP_signed		 => s_ALU_COMP_signed,
            ALU_COMP_op1_le_op2  => s_ALU_COMP_op1_le_op2,
            ALU_COMP_op1_lt_op2  => s_ALU_COMP_op1_lt_op2,
            ALU_COMP_op1_gt_op2  => s_ALU_COMP_op1_gt_op2,
            ALU_COMP_op1_ge_op2  => s_ALU_COMP_op1_ge_op2,
            ALU_COMP_op1_eq_op2  => s_ALU_COMP_op1_eq_op2,
            ALU_COMP_op1_ne_op2  => s_ALU_COMP_op1_ne_op2);

    INPUT_STIMULI_PROCESS : process
    begin
        s_ALU_COMP_op1 <= x"000000f3";
        s_ALU_COMP_op2 <= x"000000a0";
        s_ALU_COMP_signed <= '0';
        wait for 1 ns;
        s_ALU_COMP_signed <= '1';
        wait for 1 ns;
        s_ALU_COMP_op1 <= x"00000024";
        s_ALU_COMP_op2 <= x"00000031";
        s_ALU_COMP_signed <= '0';
        wait for 1 ns;
        s_ALU_COMP_signed <= '1';
        wait for 1 ns;
        s_ALU_COMP_op1 <= x"80000000";
        s_ALU_COMP_op2 <= x"00000011";
        s_ALU_COMP_signed <= '0';
        wait for 1 ns;
        s_ALU_COMP_signed <= '1';
        wait for 1 ns;
        s_ALU_COMP_op1 <= x"00000034";
        s_ALU_COMP_op2 <= x"00000034";
        s_ALU_COMP_signed <= '0';
        wait for 1 ns;
        s_ALU_COMP_signed <= '1';
        wait;
    end process;

end TEST;
