library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
  generic(
    EXE_PC_NBIT : integer := 32;
    EXE_IR_NBIT : integer := 32;
    EXE_ALU_NBIT: integer := 32
   );
  port(
    EXE_IR_IN           : in  std_logic_vector(EXE_IR_NBIT - 1 downto 0); -- Instruction register in 
    EXE_NPC_IN          : in  std_logic_vector(EXE_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    EXE_IR_OUT          : out std_logic_vector(EXE_IR_NBIT - 1 downto 0); -- Instruction register out 
    EXE_NPC_OUT         : out std_logic_vector(EXE_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    EXE_RF_IN1          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Data coming from out port 1 of register file
    EXE_IMM_IN          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Immediated with sign extended
    EXE_RF_IN2          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Data coming from out port 2 of register file

    EXE_FW_ALU_FROM_MEM : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- ALU data coming from MEM stage
    EXE_FW_ALU_FROM_WB  : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- ALU data coming from WB stage
    EXE_FW_MEM_FROM_WB  : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- MEM data coming from WB stage

    EXE_BRANCH_TYPE     : in  std_logic; -- Identify the type of branch under execution (0 for bz, 1 for bnz)
    EXE_PRED_COND       : in  std_logic; -- Predicted condition of a branch (comes from BPU)
    EXE_CALC_COND       : out std_logic; -- Calculated condition of a branch
    EXE_WRONG_COND      : out std_logic; -- Signal to identify the condition in which the predicted branch condition is wrong (may be useless)
    EXE_WRONG_TARGET    : out std_logic; -- Signal to identify the condition in which the predicted branch target is wrong (may be useless)
    EXE_ALU_OUT         : out std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Output of ALU logic

    EXE_CU_ALU_CONTROL  : in  std_logic_vector(5 downto 0); -- Control signal for ALU operation selection
    EXE_CU_TOP_MUX      : in  std_logic; -- Signal from general CU for top multiplexer
    EXE_CU_BOT_MUX      : in  std_logic; -- Signal from general CU for bottom multiplexer
    EXE_CU_FW_TOP_MUX   : in  std_logic_vector(1 downto 0); -- Signal from forwarding logic for top multiplexer
    EXE_CU_FW_BOT_MUX   : in  std_logic_vector(1 downto 0) -- Signal from forwarding logic for bottom multiplexer
  );
end entity execute;

architecture STR of execute is
  component bit_mux_2to1
    port(
      BIT_MUX_2to1_in0 : in  std_logic;
      BIT_MUX_2to1_in1 : in  std_logic;
      BIT_MUX_2to1_sel : in  std_logic;
      BIT_MUX_2to1_out : out std_logic
    );
  end component bit_mux_2to1;

  component mux_2to1
    generic(MUX_2to1_NBIT : integer := 4);
    port(
      MUX_2to1_in0 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_in1 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_sel : in  std_logic;
      MUX_2to1_out : out std_logic_vector(MUX_2to1_NBIT - 1 downto 0)
    );
  end component mux_2to1;

  component mux_4to1
    generic(MUX_4to1_NBIT : integer := 4);
    port(
      MUX_4to1_in0 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in1 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in2 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in3 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_sel : in  std_logic_vector(1 downto 0);
      MUX_4to1_out : out std_logic_vector(MUX_4to1_NBIT - 1 downto 0)
    );
  end component mux_4to1;

  component ALU
    generic(ALU_NBIT : integer := 32);
    port(
      ALU_command  : in  std_logic_vector(5 downto 0);
      ALU_operand1 : in  std_logic_vector(ALU_NBIT - 1 downto 0);
      ALU_operand2 : in  std_logic_vector(ALU_NBIT - 1 downto 0);
      ALU_result   : out std_logic_vector(ALU_NBIT - 1 downto 0)
    );
  end component ALU;

  component EQ_COMPARATOR
    generic(COMP_NBIT : integer := 32);
    port(
      COMP_A   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_B   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_RES : out std_logic
    );
  end component EQ_COMPARATOR;

  signal s_internal_ir       : std_logic_vector(EXE_IR_NBIT - 1 downto 0); -- Internal replica of input IR_IN
  signal s_internal_npc      : std_logic_vector(EXE_PC_NBIT - 1 downto 0); -- Internal replica of input NPC_IN
  signal s_top_mux_out       : std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Out signal from TOP_MUX
  signal s_bot_mux_out       : std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Out signal from BOT_MUX
  signal s_top_fw_mux_out    : std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Out signal from TOP_FW_MUX
  signal s_bot_fw_mux_out    : std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Out signal from BOT_FW_MUX
  signal s_alu_out           : std_logic_vector(EXE_ALU_NBIT - 1 downto 0); -- Out signal from ALU
  signal s_zero_comp_out     : std_logic;
  signal s_zero_comp_out_inv : std_logic;
  signal s_cond_mux_out      : std_logic;

begin
  TOP_MUX : mux_2to1
    generic map(
      MUX_2to1_NBIT => EXE_ALU_NBIT
    )
    port map(
      MUX_2to1_in0 => s_internal_npc,
      MUX_2to1_in1 => EXE_RF_IN1,
      MUX_2to1_sel => EXE_CU_TOP_MUX,
      MUX_2to1_out => s_top_mux_out
    );

  BOT_MUX : mux_2to1
    generic map(
      MUX_2to1_NBIT => EXE_ALU_NBIT
    )
    port map(
      MUX_2to1_in0 => EXE_IMM_IN,
      MUX_2to1_in1 => EXE_RF_IN2,
      MUX_2to1_sel => EXE_CU_BOT_MUX,
      MUX_2to1_out => s_bot_mux_out
    );

  TOP_FW_MUX : mux_4to1
    generic map(
      MUX_4to1_NBIT => EXE_ALU_NBIT
    )
    port map(
      MUX_4to1_in0 => s_top_mux_out,
      MUX_4to1_in1 => EXE_FW_ALU_FROM_MEM,
      MUX_4to1_in2 => EXE_FW_ALU_FROM_WB,
      MUX_4to1_in3 => EXE_FW_MEM_FROM_WB,
      MUX_4to1_sel => EXE_CU_FW_TOP_MUX,
      MUX_4to1_out => s_top_fw_mux_out
    );

  BOT_FW_MUX : mux_4to1
    generic map(
      MUX_4to1_NBIT => EXE_ALU_NBIT
    )
    port map(
      MUX_4to1_in0 => s_bot_mux_out,
      MUX_4to1_in1 => EXE_FW_ALU_FROM_MEM,
      MUX_4to1_in2 => EXE_FW_ALU_FROM_WB,
      MUX_4to1_in3 => EXE_FW_MEM_FROM_WB,
      MUX_4to1_sel => EXE_CU_FW_BOT_MUX,
      MUX_4to1_out => s_bot_fw_mux_out
    );

  ALU_inst : ALU
    generic map(
      ALU_NBIT => EXE_ALU_NBIT
    )
    port map(
      ALU_command  => EXE_CU_ALU_CONTROL,
      ALU_operand1 => s_top_fw_mux_out,
      ALU_operand2 => s_bot_fw_mux_out,
      ALU_result   => s_alu_out
    );

  TARGET_COMP : EQ_COMPARATOR
    generic map(
      COMP_NBIT => EXE_ALU_NBIT
    )
    port map(
      COMP_A   => s_alu_out,
      COMP_B   => s_internal_npc,
      COMP_RES => EXE_WRONG_TARGET
    );

  ZERO_COMP : EQ_COMPARATOR
    generic map(
      COMP_NBIT => EXE_ALU_NBIT
    )
    port map(
      COMP_A   => EXE_RF_IN1,
      COMP_B   => (others => '0'),
      COMP_RES => s_zero_comp_out
    );

  COND_MUX : bit_mux_2to1
    port map(
      BIT_MUX_2to1_in0 => s_zero_comp_out,
      BIT_MUX_2to1_in1 => s_zero_comp_out_inv,
      BIT_MUX_2to1_sel => EXE_BRANCH_TYPE,
      BIT_MUX_2to1_out => s_cond_mux_out
    );

  s_internal_ir <= EXE_IR_IN;
  EXE_IR_OUT    <= s_internal_ir;

  s_internal_npc <= EXE_NPC_IN;
  EXE_NPC_OUT    <= s_internal_npc;

  EXE_ALU_OUT <= s_alu_out;

  s_zero_comp_out_inv <= not s_zero_comp_out;

  EXE_CALC_COND  <= s_cond_mux_out;
  EXE_WRONG_COND <= s_cond_mux_out xor EXE_PRED_COND;

end architecture STR;

configuration CFG_EXECUTE_STR of EXECUTE is
  for STR
    for all : mux_2to1
      use configuration work.CFG_MUX_2to1_BHV;
    end for;

    for all : mux_4to1
      use configuration work.CFG_MUX_4to1_BHV;
    end for;

    for ALU_inst : ALU
      use configuration work.ALU;
    end for;

    for all : EQ_COMPARATOR
      use configuration work.CFG_EQ_COMPARATOR_DFLOW;
    end for;
  end for;
end configuration CFG_EXECUTE_STR;

