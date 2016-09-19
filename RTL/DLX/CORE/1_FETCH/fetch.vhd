library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
  generic(
    FETCH_PC_NBIT : integer := 32;      --  program counter bit length
    FETCH_IR_NBIT : integer := 32);     --  instruction register bit length
  port(
    FETCH_clk                : in  std_logic; --  clk signal
    FETCH_rst                : in  std_logic; --  reset signal, active low
    FETCH_pc_enable          : in  std_logic; --  enable signal for program counter
    FETCH_pc_clear           : in  std_logic; --  clear signal for program counter
    FETCH_branch_pred_error  : in  std_logic; --  set if a misprediction is detected by the execute stage
    FETCH_btb_prediction_in  : in  std_logic; --  taken/not taken prediction by the btb
    FETCH_btb_target_in      : in  std_logic_vector(FETCH_PC_NBIT - 1 downto 0); --  target prediction by the btb
    FETCH_alu_out            : in  std_logic_vector(FETCH_PC_NBIT - 1 downto 0); --  correct branch target
    FETCH_ir_in              : in  std_logic_vector(FETCH_IR_NBIT - 1 downto 0); --  instruction register from cache
    FETCH_ir_out             : out std_logic_vector(FETCH_IR_NBIT - 1 downto 0);
    FETCH_btb_prediction_out : out std_logic; --  taken/not taken prediction by the btb
    FETCH_btb_target_out     : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
    FETCH_pc                 : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0); --  pc of the current instruction
    FETCH_npc                : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0)); --  pc plus 4
end entity fetch;

architecture str of fetch is
  component multiplexer is
    generic(
      MUX_NBIT : integer := 4;
      MUX_NSEL : integer := 3);
    port(
      MUX_inputs : in  std_logic_vector(2 ** MUX_NSEL * MUX_NBIT - 1 downto 0);
      MUX_select : in  std_logic_vector(MUX_NSEL - 1 downto 0);
      MUX_output : out std_logic_vector(MUX_NBIT - 1 downto 0));
  end component;

  component d_register is
    generic(
      REG_NBIT : integer := 8);
    port(
      REG_clk      : in  std_logic;
      REG_rst      : in  std_logic;
      REG_clr      : in  std_logic;
      REG_enable   : in  std_logic;
      REG_data_in  : in  std_logic_vector(REG_NBIT - 1 downto 0);
      REG_data_out : out std_logic_vector(REG_NBIT - 1 downto 0));
  end component;

  component fetch_control is
    generic(
      FETCH_CTRL_IR_NBIT : integer := 32);
    port(
      FETCH_CTRL_ir       : in  std_logic_vector(FETCH_CTRL_IR_NBIT - 1 downto 0);
      FETCH_CTRL_btb_pred : in  std_logic;
      FETCH_CTRL_err_pred : in  std_logic;
      FETCH_CTRL_out      : out std_logic_vector(1 downto 0));
  end component fetch_control;

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

  constant c_slv4 : std_logic_vector(FETCH_PC_NBIT - 1 downto 0) := x"00000004";

  signal s_pc_in        : std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
  signal s_pc_out       : std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
  signal s_pc_mux_in    : std_logic_vector(4 * FETCH_PC_NBIT - 1 downto 0);
  signal s_pc_mux_sel   : std_logic_vector(1 downto 0);
  signal s_pc_plus4_out : std_logic_vector(FETCH_PC_NBIT - 1 downto 0);

begin
  FETCH_pc <= s_pc_out;
  PROGRAM_COUNTER : d_register
    generic map(
      REG_NBIT => FETCH_PC_NBIT)
    port map(
      REG_clk      => FETCH_clk,
      REG_rst      => FETCH_rst,
      REG_clr      => FETCH_pc_clear,
      REG_enable   => FETCH_pc_enable,
      REG_data_in  => s_pc_in,
      REG_data_out => s_pc_out);

  s_pc_mux_in(FETCH_PC_NBIT - 1 downto 0)                     <= s_pc_plus4_out;
  s_pc_mux_in(2 * FETCH_PC_NBIT - 1 downto FETCH_PC_NBIT)     <= FETCH_btb_target_in;
  s_pc_mux_in(3 * FETCH_PC_NBIT - 1 downto 2 * FETCH_PC_NBIT) <= FETCH_alu_out;
  s_pc_mux_in(4 * FETCH_PC_NBIT - 1 downto 3 * FETCH_PC_NBIT) <= FETCH_alu_out;
  PROGRAM_COUNTER_MUX : multiplexer
    generic map(
      MUX_NBIT => FETCH_PC_NBIT,
      MUX_NSEL => 2)
    port map(
      MUX_inputs => s_pc_mux_in,
      MUX_select => s_pc_mux_sel,
      MUX_output => s_pc_in);

  NPC_SEL : fetch_control
    generic map(
      FETCH_CTRL_IR_NBIT => FETCH_IR_NBIT)
    port map(
      FETCH_CTRL_ir       => FETCH_ir_in,
      FETCH_CTRL_btb_pred => FETCH_btb_prediction_in,
      FETCH_CTRL_err_pred => FETCH_branch_pred_error,
      FETCH_CTRL_out      => s_pc_mux_sel);

  FETCH_npc <= s_pc_plus4_out;
  PLUS4_ADDER : CLA
    generic map(
      CLA_NBIT => FETCH_PC_NBIT)
    port map(
      CLA_op1    => s_pc_out,
      CLA_op2    => c_slv4,
      CLA_add    => '0',
      CLA_res    => s_pc_plus4_out,
      CLA_cout   => open,
      CLA_ovflow => open);

  FETCH_ir_out             <= FETCH_ir_in;
  FETCH_btb_prediction_out <= FETCH_btb_prediction_in;
  FETCH_btb_target_out     <= FETCH_btb_target_in;
end architecture str;

configuration CFG_FETCH_STR of fetch is
  for str
    for PROGRAM_COUNTER : d_register
      use configuration work.CFG_D_REGISTER_STR;
    end for;
    for PROGRAM_COUNTER_MUX : multiplexer
      use configuration work.CFG_MULTIPLEXER_DFLOW;
    end for;
    for NPC_SEL : fetch_control
      use configuration work.CFG_FETCH_CONTROL_BHV;
    end for;
    for PLUS4_ADDER : CLA
      use configuration work.CFG_CLA_STR;
    end for;
  end for;
end CFG_FETCH_STR;
