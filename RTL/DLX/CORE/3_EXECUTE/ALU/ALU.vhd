library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;


--!   \brief   Arithmetic logic unit.
--!
--!   This entity models an integer ALU for a MIPS-like processor, able of operation of sum, subtraction,
--!   shifting, bitwise logic and comparison. The parallelism of the ALU is generic, and only the parallelism
--!   for the operand has to be specified. The ALU performs a certain operation given the code specified at the
--!   input ALU_command, which is 6 bit long; the following operations are supported:
--!
--!   OPERATION               OPERAND1                OPERAND2             CODE
--!   shift_left_logic        value to be shifted     shift amount         00**00
--!   shift_right_logic       value to be shifted     shift amount         01**00
--!   shift_left_arith        value to be shifted     shift amount         10**00
--!   shift_right_logic       value to be shifted     shift amount         11**00
--!   sum                     first addend            second addend        ***001
--!   subtraction             minuend                 subtract             ***101
--!   set_less_than           first operand           second operand       *00110
--!   set_less_equal          first operand           second operand       *01110
--!   set_equal               first operand           second operand       *10110
--!   set_not_equal           first operand           second operand       *11110
--!   bitwise_and             first operand           second operand       000111
--!   bitwise_nand            first operand           second operand       111011
--!   bitwise_or              first operand           second operand       011111
--!   bitwise_nor             first operand           second operand       100011
--!   bitwise_xor             first operand           second operand       011011
--!   bitwise_xnor            first operand           second operand       100111
entity ALU is
   generic(
      ALU_NBIT :  integer  := 32);
   port(
      ALU_command    :  in    std_logic_vector(5 downto 0);
      ALU_operand1   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
      ALU_operand2   :  in    std_logic_vector(ALU_NBIT-1 downto 0);
      ALU_result     :  out   std_logic_vector(ALU_NBIT-1 downto 0));
end ALU;

architecture str of ALU is

   component ALU_control is
      port(
         ALU_CTRL_command  :  in    std_logic_vector(5 downto 0);
         ALU_CTRL_shf_lr   :  out   std_logic;
         ALU_CTRL_shf_la   :  out   std_logic;
         ALU_CTRL_add_sub  :  out   std_logic;
         ALU_CTRL_comp_sel :  out   std_logic_vector(1 downto 0);
         ALU_CTRL_res_sel  :  out   std_logic_vector(1 downto 0);
         ALU_CTRL_log_func :  out   std_logic_vector(3 downto 0));
   end component;

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

   component ALU_carry_lookahead_adder is
      generic(
         ALU_CLA_NBIT       :  integer  := 32);
      port(
         ALU_CLA_op1     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_op2     :  in    std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_add     :  in    std_logic;
         ALU_CLA_res     :  out   std_logic_vector(ALU_CLA_NBIT-1 downto 0);
         ALU_CLA_cout    :  out   std_logic;
         ALU_CLA_ovflow  :  out   std_logic);
   end component;

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

   component bit_mux_4to1 is
      port(
         BIT_MUX_4to1_in0  :  in    std_logic;
         BIT_MUX_4to1_in1  :  in    std_logic;
         BIT_MUX_4to1_in2  :  in    std_logic;
         BIT_MUX_4to1_in3  :  in    std_logic;
         BIT_MUX_4to1_sel  :  in    std_logic_vector(1 downto 0);
         BIT_MUX_4to1_out  :  out   std_logic);
   end component;

   component mux_4to1 is
      generic (
         MUX_4to1_NBIT :  integer  := 4);
      port (
         MUX_4to1_in0  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
         MUX_4to1_in1  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
         MUX_4to1_in2  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
         MUX_4to1_in3  :  in    std_logic_vector(MUX_4to1_NBIT-1 downto 0);
         MUX_4to1_sel  :  in    std_logic_vector(1 downto 0);
         MUX_4to1_out  :  out   std_logic_vector(MUX_4to1_NBIT-1 downto 0));
   end component;

   constant c_zero_padding                :  std_logic_vector(ALU_NBIT-2 downto 0)  := (others => '0');

   signal s_control_shifter_left_right    :  std_logic;
   signal s_control_shifter_logic_arith   :  std_logic;
   signal s_control_add_sub               :  std_logic;
   signal s_control_logic_function        :  std_logic_vector(3 downto 0);
   signal s_control_comparator_select     :  std_logic_vector(1 downto 0);
   signal s_control_alu_result_select     :  std_logic_vector(1 downto 0);

   signal s_shifter_result                :  std_logic_vector(ALU_NBIT-1 downto 0);
   signal s_adder_result                  :  std_logic_vector(ALU_NBIT-1 downto 0);
   signal s_adder_carry_out               :  std_logic;
   signal s_logic_unit_result             :  std_logic_vector(ALU_NBIT-1 downto 0);
   signal s_comparator_less_than          :  std_logic;
   signal s_comparator_less_equal         :  std_logic;
   signal s_comparator_equal              :  std_logic;
   signal s_comparator_not_equal          :  std_logic;
   signal s_comparator_mux_out            :  std_logic;

   signal s_comparator_result             :  std_logic_vector(ALU_NBIT-1 downto 0);

begin

   CONTROL_UNIT : ALU_control
      port map(
         ALU_CTRL_command  => ALU_command,
         ALU_CTRL_shf_lr   => s_control_shifter_left_right,
         ALU_CTRL_shf_la   => s_control_shifter_logic_arith,
         ALU_CTRL_add_sub  => s_control_add_sub,
         ALU_CTRL_comp_sel => s_control_comparator_select,
         ALU_CTRL_res_sel  => s_control_alu_result_select,
         ALU_CTRL_log_func => s_control_logic_function);

   SHIFTER : ALU_shifter
      generic map(
         ALU_SHIFTER_NBIT  => ALU_NBIT)
      port map(
         ALU_SHIFTER_operand     => ALU_operand1,
         ALU_SHIFTER_n_shift     => ALU_operand2(log2ceil(ALU_NBIT)-1 downto 0),
         ALU_SHIFTER_left_right  => s_control_shifter_left_right,
         ALU_SHIFTER_logic_arith => s_control_shifter_logic_arith,
         ALU_SHIFTER_result      => s_shifter_result);

   ADDER : ALU_carry_lookahead_adder
      generic map(
         ALU_CLA_NBIT   => ALU_NBIT)
      port map(
         ALU_CLA_op1    => ALU_operand1,
         ALU_CLA_op2    => ALU_operand2,
         ALU_CLA_add    => s_control_add_sub,
         ALU_CLA_res    => s_adder_result,
         ALU_CLA_cout   => s_adder_carry_out,
         ALU_CLA_ovflow => open);

   LOGIC_UNIT : ALU_logic_unit
      generic map(
         ALU_LU_NBIT => ALU_NBIT)
      port map(
         ALU_LU_sel  => s_control_logic_function,
         ALU_LU_op1  => ALU_operand1,
         ALU_LU_op2  => ALU_operand2,
         ALU_LU_res  => s_logic_unit_result);

   COMPARATOR :  ALU_comparator
      generic map(
         ALU_COMP_NBIT  => ALU_NBIT)
      port map(
         ALU_COMP_difference  => s_adder_result,
         ALU_COMP_carry_out   => s_adder_carry_out,
         ALU_COMP_op1_le_op2  => s_comparator_less_equal,
         ALU_COMP_op1_lt_op2  => s_comparator_less_than,
         ALU_COMP_op1_gt_op2  => open,
         ALU_COMP_op1_ge_op2  => open,
         ALU_COMP_op1_eq_op2  => s_comparator_equal);

   s_comparator_not_equal  <= not s_comparator_equal;

   COMPARATOR_MUX : bit_mux_4to1
      port map(
         BIT_MUX_4to1_in0  => s_comparator_less_than,
         BIT_MUX_4to1_in1  => s_comparator_less_equal,
         BIT_MUX_4to1_in2  => s_comparator_equal,
         BIT_MUX_4to1_in3  => s_comparator_not_equal,
         BIT_MUX_4to1_sel  => s_control_comparator_select,
         BIT_MUX_4to1_out  => s_comparator_mux_out);

   s_comparator_result  <= c_zero_padding&s_comparator_mux_out;

   RESULT_SELECTION_MUX : mux_4to1
      generic map(
         MUX_4to1_NBIT  => ALU_NBIT)
      port map(
         MUX_4to1_in0   => s_shifter_result,
         MUX_4to1_in1   => s_adder_result,
         MUX_4to1_in2   => s_comparator_result,
         MUX_4to1_in3   => s_logic_unit_result,
         MUX_4to1_sel   => s_control_alu_result_select,
         MUX_4to1_out   => ALU_result);

end str;

configuration CFG_ALU_STR of ALU is
   for str
      for CONTROL_UNIT : ALU_control
         use configuration work.CFG_ALU_CONTROL_DFLOW;
      end for;
      for SHIFTER : ALU_shifter
         use configuration work.CFG_ALU_SHIFTER_STR;
      end for;
      for ADDER : ALU_carry_lookahead_adder
         use configuration work.CFG_ALU_CARRY_LOOKAHEAD_ADDER_STR;
      end for;
      for LOGIC_UNIT : ALU_logic_unit
         use configuration work.CFG_ALU_LOGIC_UNIT_STR;
      end for;
      for COMPARATOR : ALU_comparator
         use configuration work.CFG_ALU_COMPARATOR_BHV;
      end for;
      for COMPARATOR_MUX : bit_mux_4to1
         use configuration work.CFG_BIT_MUX_4to1_BHV;
      end for;
      for RESULT_SELECTION_MUX : mux_4to1
         use configuration work.CFG_MUX_4to1_BHV;
      end for;
   end for;
end CFG_ALU_STR;
