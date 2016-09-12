library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!     \brief   Arithmetic logic unit.
--!
--!     This entity models an integer ALU for a MIPS-like processor, able of operation of sum, subtraction,
--!     shifting, bitwise logic and comparison. The parallelism of the ALU is generic, and only the parallelism
--!     for the operand has to be specified. The ALU performs a certain operation given the code specified at the
--!     input ALU_command, which is 6 bit long; for the supported operation give a look at ALU_pkg.vhd

entity ALU is
  generic(
    ALU_NBIT : integer := 32);
  port(
    ALU_command  : in  std_logic_vector(5 downto 0);
    ALU_operand1 : in  std_logic_vector(ALU_NBIT - 1 downto 0);
    ALU_operand2 : in  std_logic_vector(ALU_NBIT - 1 downto 0);
    ALU_result   : out std_logic_vector(ALU_NBIT - 1 downto 0));
end ALU;

architecture str of ALU is
  component ALU_control is
    port(
      ALU_CTRL_command   : in  std_logic_vector(5 downto 0);
      ALU_CTRL_shf_lr    : out std_logic;
      ALU_CTRL_shf_la    : out std_logic;
      ALU_CTRL_add_sub   : out std_logic;
      ALU_CTRL_comp_sel  : out std_logic_vector(2 downto 0);
      ALU_CTRL_comp_sign : out std_logic;
      ALU_CTRL_res_sel   : out std_logic_vector(1 downto 0);
      ALU_CTRL_log_func  : out std_logic_vector(3 downto 0));
  end component;

  component ALU_shifter is
    generic(
      ALU_SHIFTER_NBIT : integer := 32);
    port(
      ALU_SHIFTER_operand     : in  std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0);
      ALU_SHIFTER_n_shift     : in  std_logic_vector(log2ceil(ALU_SHIFTER_NBIT) - 1 downto 0);
      ALU_SHIFTER_left_right  : in  std_logic;
      ALU_SHIFTER_logic_arith : in  std_logic;
      ALU_SHIFTER_result      : out std_logic_vector(ALU_SHIFTER_NBIT - 1 downto 0));
  end component;

  component CLA is
    generic(
      CLA_NBIT : integer := 16);
    port(
      CLA_op1    : in  std_logic_vector(CLA_NBIT - 1 downto 0);
      CLA_op2    : in  std_logic_vector(CLA_NBIT - 1 downto 0);
      CLA_add    : in  std_logic;
      CLA_res    : out std_logic_vector(CLA_NBIT - 1 downto 0);
      CLA_cout   : out std_logic;
      CLA_ovflow : out std_logic);
  end component;

  component ALU_logic_unit is
    generic(
      ALU_LU_NBIT : integer := 32
    );
    port(
      ALU_LU_sel : in  std_logic_vector(3 downto 0);
      ALU_LU_op1 : in  std_logic_vector(ALU_LU_NBIT - 1 downto 0);
      ALU_LU_op2 : in  std_logic_vector(ALU_LU_NBIT - 1 downto 0);
      ALU_LU_res : out std_logic_vector(ALU_LU_NBIT - 1 downto 0));
  end component;

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
  end component;

  component bit_multiplexer is
    generic(
      BIT_MUX_NSEL : integer := 3);
    port(
      BIT_MUX_inputs : in  std_logic_vector(2 ** BIT_MUX_NSEL - 1 downto 0);
      BIT_MUX_select : in  std_logic_vector(BIT_MUX_NSEL - 1 downto 0);
      BIT_MUX_output : out std_logic);
  end component;

  component mux_4to1 is
    generic(
      MUX_4to1_NBIT : integer := 4);
    port(
      MUX_4to1_in0 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in1 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in2 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in3 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_sel : in  std_logic_vector(1 downto 0);
      MUX_4to1_out : out std_logic_vector(MUX_4to1_NBIT - 1 downto 0));
  end component;

  constant c_zero_padding : std_logic_vector(ALU_NBIT - 2 downto 0) := (others => '0');

  signal s_control_shifter_left_right  : std_logic;
  signal s_control_shifter_logic_arith : std_logic;
  signal s_control_add_sub             : std_logic;
  signal s_control_logic_function      : std_logic_vector(3 downto 0);
  signal s_control_comparator_select   : std_logic_vector(2 downto 0);
  signal s_control_comparator_signed   : std_logic;
  signal s_control_alu_result_select   : std_logic_vector(1 downto 0);

  signal s_shifter_result     : std_logic_vector(ALU_NBIT - 1 downto 0);
  signal s_adder_result       : std_logic_vector(ALU_NBIT - 1 downto 0);
  signal s_logic_unit_result  : std_logic_vector(ALU_NBIT - 1 downto 0);
  signal s_comparator_result  : std_logic_vector(ALU_NBIT - 1 downto 0);
  signal s_comparator_mux_in  : std_logic_vector(0 to 7);
  signal s_comparator_mux_out : std_logic;

begin
  CONTROL_UNIT : ALU_control
    port map(
      ALU_CTRL_command   => ALU_command,
      ALU_CTRL_shf_lr    => s_control_shifter_left_right,
      ALU_CTRL_shf_la    => s_control_shifter_logic_arith,
      ALU_CTRL_add_sub   => s_control_add_sub,
      ALU_CTRL_comp_sel  => s_control_comparator_select,
      ALU_CTRL_comp_sign => s_control_comparator_signed,
      ALU_CTRL_res_sel   => s_control_alu_result_select,
      ALU_CTRL_log_func  => s_control_logic_function);

  SHIFTER : ALU_shifter
    generic map(
      ALU_SHIFTER_NBIT => ALU_NBIT)
    port map(
      ALU_SHIFTER_operand     => ALU_operand1,
      ALU_SHIFTER_n_shift     => ALU_operand2(log2ceil(ALU_NBIT) - 1 downto 0),
      ALU_SHIFTER_left_right  => s_control_shifter_left_right,
      ALU_SHIFTER_logic_arith => s_control_shifter_logic_arith,
      ALU_SHIFTER_result      => s_shifter_result);

  ADDER : CLA
    generic map(
      CLA_NBIT => ALU_NBIT)
    port map(
      CLA_op1    => ALU_operand1,
      CLA_op2    => ALU_operand2,
      CLA_add    => s_control_add_sub,
      CLA_res    => s_adder_result,
      CLA_cout   => open,
      CLA_ovflow => open);

  LOGIC_UNIT : ALU_logic_unit
    generic map(
      ALU_LU_NBIT => ALU_NBIT)
    port map(
      ALU_LU_sel => s_control_logic_function,
      ALU_LU_op1 => ALU_operand1,
      ALU_LU_op2 => ALU_operand2,
      ALU_LU_res => s_logic_unit_result);

  s_comparator_mux_in(6) <= '0';
  s_comparator_mux_in(7) <= '0';
  COMPARATOR : ALU_comparator
    generic map(
      ALU_COMP_NBIT => ALU_NBIT)
    port map(
      ALU_COMP_op1        => ALU_operand1,
      ALU_COMP_op2        => ALU_operand2,
      ALU_COMP_signed     => s_control_comparator_signed,
      ALU_COMP_op1_le_op2 => s_comparator_mux_in(0),
      ALU_COMP_op1_lt_op2 => s_comparator_mux_in(1),
      ALU_COMP_op1_gt_op2 => s_comparator_mux_in(2),
      ALU_COMP_op1_ge_op2 => s_comparator_mux_in(3),
      ALU_COMP_op1_eq_op2 => s_comparator_mux_in(4),
      ALU_COMP_op1_ne_op2 => s_comparator_mux_in(5));

  COMPARATOR_MUX : bit_multiplexer
    generic map(
      BIT_MUX_NSEL => 3)
    port map(
      BIT_MUX_inputs => s_comparator_mux_in,
      BIT_MUX_select => s_control_comparator_select,
      BIT_MUX_output => s_comparator_mux_out);

  s_comparator_result <= c_zero_padding & s_comparator_mux_out;

  RESULT_SELECTION_MUX : mux_4to1
    generic map(
      MUX_4to1_NBIT => ALU_NBIT)
    port map(
      MUX_4to1_in0 => s_shifter_result,
      MUX_4to1_in1 => s_adder_result,
      MUX_4to1_in2 => s_comparator_result,
      MUX_4to1_in3 => s_logic_unit_result,
      MUX_4to1_sel => s_control_alu_result_select,
      MUX_4to1_out => ALU_result);

end str;

configuration CFG_ALU_STR of ALU is
  for str
    for CONTROL_UNIT : ALU_control
      use configuration work.CFG_ALU_CONTROL_BHV;
    end for;
    for SHIFTER : ALU_shifter
      use configuration work.CFG_ALU_SHIFTER_STR;
    end for;
    for ADDER : CLA
      use configuration work.CFG_CLA_STR;
    end for;
    for LOGIC_UNIT : ALU_logic_unit
      use configuration work.CFG_ALU_LOGIC_UNIT_STR;
    end for;
    for COMPARATOR : ALU_comparator
      use configuration work.CFG_ALU_COMPARATOR_STR;
    end for;
    for COMPARATOR_MUX : bit_multiplexer
      use configuration work.CFG_BIT_MULTIPLEXER_DFLOW;
    end for;
    for RESULT_SELECTION_MUX : mux_4to1
      use configuration work.CFG_MUX_4to1_BHV;
    end for;
  end for;
end CFG_ALU_STR;
