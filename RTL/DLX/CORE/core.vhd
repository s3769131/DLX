library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity core is
  generic(
    CORE_PC_NBIT   : positive := 32;    --- Number of bit of Program Counter
    CORE_IR_NBIT   : positive := 32;    --- Number of bit of Instruction Register
    -- CORE_IMM_SIZE  : positive := 16;    --- Number of bit of Immediate
    CORE_ALU_NBIT  : positive := 32;    --- Number of bit of ALU
    CORE_DATA_NBIT : positive := 32;    --- Number of bit of data interface from and to memories
    CORE_ADDR_NBIT : positive := 32;    --- Number of bit of memory addresses
    CORE_RF_NREG   : positive := 32;    --- Number of registers in the integer RF
    CORE_RF_NBIT   : positive := 32     --- Number of bit per register (integer register file)
  );
  port(
    CORE_CLK              : in    std_logic;
    CORE_RST              : in    std_logic;
    CORE_IFID_EN          : in    std_logic; ---Enable signal for pipeling register IF/ID
    CORE_IFID_CLR         : in    std_logic; ---Clear signal (Sync) for pipeling register IF/ID
    CORE_IDEX_EN          : in    std_logic; ---Enable signal for pipeling register ID/EX
    CORE_IDEX_CLR         : in    std_logic; ---Clear signal (Sync) for pipeling register ID/EX
    CORE_EXMEM_EN         : in    std_logic; ---Enable signal for pipeling register EX/MEM            
    CORE_EXMEM_CLR        : in    std_logic; ---Clear signal (Sync) for pipeling register EX/MEM   
    CORE_MEMWB_EN         : in    std_logic; ---Enable signal for pipeling register MEM/WB         
    CORE_MEMWB_CLR        : in    std_logic; ---Clear signal (Sync) for pipeling register MEM/WB  

    CORE_DRAM_INTERFACE   : inout std_logic_vector(CORE_DATA_NBIT - 1 downto 0); --
    CORE_DRAM_ADDRESS     : out   std_logic_vector(CORE_ADDR_NBIT - 1 downto 0); --

    CORE_ROM_INTERFACE    : in    std_logic_vector(CORE_IR_NBIT - 1 downto 0); --
    CORE_ROM_ADDRESS      : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0); --

    CU_IF_PC_EN           : in    std_logic;
    CU_IF_PC_CLR          : in    std_logic;
    CU_ID_destination_sel : in    std_logic_vector(1 downto 0);
    CU_ID_rf_write_en     : in    std_logic;
    -- CU_ID_sigext_signed   : in    std_logic;
    CU_ID_sigext_op       : in    std_logic_vector(1 downto 0);
    CU_ID_read1_en        : in    std_logic;
    CU_ID_read2_en        : in    std_logic;
    CU_EX_IS_BRANCH       : in    std_logic; -- Signal from CU to identify if the current instruction is a branch (0 is not a branch)
    CU_EX_BRANCH_TYPE     : in    std_logic;
    CU_EX_ALU_CONTROL     : in    std_logic_vector(5 downto 0);
    CU_EX_TOP_MUX         : in    std_logic;
    CU_EX_BOT_MUX         : in    std_logic;
    CU_EX_FW_TOP_MUX      : in    std_logic_vector(1 downto 0);
    CU_EX_FW_BOT_MUX      : in    std_logic_vector(1 downto 0);
    CU_MEM_READNOTWRITE   : in    std_logic;
    CU_MEM_SIGNED_LOAD    : in    std_logic;
    CU_MEM_LOAD_TYPE      : in    std_logic_vector(1 downto 0);
    CU_WB_MUX_CONTROL     : in    std_logic_vector(1 downto 0); --

    BTB_PREDICTION_IN     : in    std_logic;
    BTB_TARGET_IN         : in    std_logic_vector(CORE_PC_NBIT - 1 downto 0);
    BTB_WRONG_TARGET      : out   std_logic;
    BTB_WRONG_PREDICTION  : out   std_logic;
    BTB_TARGET_OUT        : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0);
    BTB_CONDITION_OUT     : out   std_logic;
    BTB_PC_WRITE          : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0); --

    CORE_IFID_IR          : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
    CORE_IDEX_IR          : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
    CORE_EXMEM_IR         : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
    CORE_MEMWB_IR         : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0)
  );
end entity core;

architecture STR of core is
  component fetch
    generic(
      FETCH_PC_NBIT : integer := 32;
      FETCH_IR_NBIT : integer := 32
    );
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
    FETCH_npc                : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0) 
    );
  end component fetch;

  component decode
    generic(
      DECODE_NREG    : positive := 32;
      DECODE_NBIT    : positive := 32;
      DECODE_IR_NBIT : positive := 32
    );
    port(
      DECODE_clk             : in  std_logic;
      DECODE_rst             : in  std_logic;
      DECODE_sigext_op       : in  std_logic_vector(1 downto 0);
      DECODE_ir              : in  std_logic_vector(DECODE_IR_NBIT - 1 downto 0);
      DECODE_destination_sel : in  std_logic_vector;
      DECODE_rf_write_en     : in  std_logic;
      DECODE_rf_data_write   : in  std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_addr_write   : in  std_logic_vector(log2ceil(DECODE_NREG) - 1 downto 0);
      DECODE_rf_read_en_rs   : in  std_logic;
      DECODE_rf_read_en_rt   : in  std_logic;
      DECODE_pc_in           : in  std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_npc_in          : in  std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_sigext_out      : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_addr_dest    : out std_logic_vector(log2ceil(DECODE_NREG) - 1 downto 0);
      DECODE_rf_data_read1   : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_data_read2   : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_pc_out          : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_npc_out         : out std_logic_vector(DECODE_NBIT - 1 downto 0)
    );
  end component decode;
  component execute
    generic(
      EXE_PC_NBIT  : integer := 32;
      EXE_IR_NBIT  : integer := 32;
      EXE_ALU_NBIT : integer := 32
    );
    port(
      EXE_IR_IN           : in  std_logic_vector(EXE_IR_NBIT - 1 downto 0);
      EXE_NPC_IN          : in  std_logic_vector(EXE_PC_NBIT - 1 downto 0);
      EXE_IR_OUT          : out std_logic_vector(EXE_IR_NBIT - 1 downto 0);
      EXE_NPC_OUT         : out std_logic_vector(EXE_PC_NBIT - 1 downto 0);
      EXE_RF_IN1          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_IMM_IN          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_RF_IN2          : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_FW_ALU_FROM_MEM : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_FW_ALU_FROM_WB  : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_FW_MEM_FROM_WB  : in  std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_BTB_TARGET      : in  std_logic_vector(EXE_PC_NBIT - 1 downto 0);
      EXE_PRED_COND       : in  std_logic;
      EXE_CALC_COND       : out std_logic;
      EXE_WRONG_COND      : out std_logic;
      EXE_WRONG_TARGET    : out std_logic;
      EXE_ALU_OUT         : out std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
      EXE_CU_IS_BRANCH    : in  std_logic;
      EXE_CU_BRANCH_TYPE  : in  std_logic;
      EXE_CU_ALU_CONTROL  : in  std_logic_vector(5 downto 0);
      EXE_CU_TOP_MUX      : in  std_logic;
      EXE_CU_BOT_MUX      : in  std_logic;
      EXE_CU_FW_TOP_MUX   : in  std_logic_vector(1 downto 0);
      EXE_CU_FW_BOT_MUX   : in  std_logic_vector(1 downto 0)
    );
  end component execute;

  component memory
    generic(
      MEM_IR_NBIT   : integer := 32;
      MEM_PC_NBIT   : integer := 32;
      MEM_DATA_NBIT : integer := 32;
      MEM_ADDR_NBIT : integer := 32
    );
    port(
      MEM_IR_IN           : in    std_logic_vector(MEM_IR_NBIT - 1 downto 0);
      MEM_NPC_IN          : in    std_logic_vector(MEM_PC_NBIT - 1 downto 0);
      MEM_IR_OUT          : out   std_logic_vector(MEM_IR_NBIT - 1 downto 0);
      MEM_NPC_OUT         : out   std_logic_vector(MEM_PC_NBIT - 1 downto 0);
      MEM_ADDRESS_IN      : in    std_logic_vector(MEM_ADDR_NBIT - 1 downto 0);
      MEM_ADDRESS_OUT     : out   std_logic_vector(MEM_ADDR_NBIT - 1 downto 0);
      MEM_DATA_IN         : in    std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
      MEM_DATA_OUT        : out   std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
      MEM_INTERFACE       : inout std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
      MEM_CU_READNOTWRITE : in    std_logic;
      MEM_CU_SIGNED_LOAD  : in    std_logic;
      MEM_CU_LOAD_TYPE    : in    std_logic_vector(1 downto 0)
    );
  end component memory;

  component writeback
    generic(
      WB_PC_NBIT   : positive := 32;
      WB_IR_NBIT   : positive := 32;
      WB_DATA_NBIT : positive := 32
    );
    port(
      WB_IR_IN          : in  std_logic_vector(WB_IR_NBIT - 1 downto 0);
      WB_NPC_IN         : in  std_logic_vector(WB_PC_NBIT - 1 downto 0);
      WB_IR_OUT         : out std_logic_vector(WB_IR_NBIT - 1 downto 0);
      WB_NPC_OUT        : out std_logic_vector(WB_PC_NBIT - 1 downto 0);
      WB_DATA_FROM_MEM  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
      WB_DATA_FROM_ALU  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
      WB_DATA_TO_RF     : out std_logic_vector(WB_DATA_NBIT - 1 downto 0);
      WB_CU_MUX_CONTROL : in  std_logic_vector(1 downto 0)
    );
  end component writeback;

  component d_register
    generic(REG_NBIT : integer := 8);
    port(
      REG_clk      : in  std_logic;
      REG_rst      : in  std_logic;
      REG_clr      : in  std_logic;
      REG_enable   : in  std_logic;
      REG_data_in  : in  std_logic_vector(REG_NBIT - 1 downto 0);
      REG_data_out : out std_logic_vector(REG_NBIT - 1 downto 0)
    );
  end component d_register;

  component d_ff is
    port(
      DFF_clk : in  std_logic;
      DFF_rst : in  std_logic;
      DFF_clr : in  std_logic;
      DFF_d   : in  std_logic;
      DFF_q   : out std_logic;
      DFF_nq  : out std_logic);
  end component d_ff;

  -- constant c_program_counter_nbit        : integer := 32;
  -- constant c_instruction_register_nbit   : integer := 32;
  -- constant c_register_file_nregister : integer := 32;
  -- constant c_register_file_register_nbit : integer := 32;
  -- constant c_register_file_address_nbit  : integer := log2ceil(c_register_file_nregister);
  --constant c_immediate_nbit          : integer := 16;
  -- constant c_opcode_nbit : integer := 6;

  ---Signal to FETCH from ROM
  signal s_IF_IN_IR_IN : std_logic_vector(CORE_IR_NBIT - 1 downto 0);

  --- Signal to FETCH from CU
  signal s_CU_IF_PC_CLR : std_logic;
  signal s_CU_IF_PC_EN  : std_logic;
signal s_IF_branch_pred_error : std_logic;
  -- Signals from FETCH to IF/ID pipelining registers
  signal s_IF_OUT_IR_OUT             : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_IF_OUT_PC                 : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_IF_OUT_NPC                : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_IF_OUT_BTB_PREDICTION_OUT : std_logic;
  signal s_IF_OUT_btb_target_out     : std_logic_vector(CORE_PC_NBIT - 1 downto 0);

  --- Pipelined signals coming from IF/ID pipelining registers to DECODE
  signal ps_IFID_IR_IN              : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal ps_IFID_BTB_TARGET_OUT     : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_IFID_BTB_PREDICTION_OUT : std_logic;
  signal ps_IFID_pc_in              : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_IFID_NPC_IN             : std_logic_vector(CORE_PC_NBIT - 1 downto 0);

  --- Signals input to DECODE stage.
  --signal s_ID_IN_sigext_in     : std_logic_vector(CORE_IMM_SIZE - 1 downto 0);
  signal s_ID_IN_rf_data_write : std_logic_vector(CORE_RF_NBIT - 1 downto 0);
  signal s_ID_IN_rf_addr_write : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  --signal s_ID_IN_rf_addr_rs    : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  --signal s_ID_IN_rf_addr_rt    : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  --signal s_ID_IN_rf_addr_rd    : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);

  ---Control signal for DECODE
  signal s_CU_ID_destination_sel : std_logic_vector(1 downto 0); ----- CHANGED
  signal s_CU_ID_rf_write_en     : std_logic;
  -- signal s_CU_ID_sigext_signed   : std_logic;
  signal s_CU_sigext_op          : std_logic_vector(1 downto 0);
  signal s_CU_decode_read1_en    : std_logic;
  signal s_CU_decode_read2_en    : std_logic;

  --- Signal from DECODE to ID/EX pipelining registers
  signal s_ID_OUT_pc_out        : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_ID_OUT_npc_out       : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_ID_OUT_sigext_out    : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_ID_OUT_rf_data_read1 : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_ID_OUT_rf_data_read2 : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_ID_OUT_rf_addr_dest  : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);

  --- Pipelined signals coming from ID/EX pipelining registers to EXECUTE
  signal ps_IDEX_rf_addr_dest   : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  signal ps_IDEX_IR_IN          : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal ps_IDEX_NPC_IN         : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_IDEX_RF_IN1         : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal ps_IDEX_RF_IN2         : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal ps_IDEX_IMM_IN         : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal ps_IDEX_PRED_COND      : std_logic;
  signal ps_IDEX_pc             : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_IDEX_BTB_TARGET_OUT : std_logic_vector(CORE_PC_NBIT - 1 downto 0);

  --- Signals from EXECUTE to EX/MEM pipelining registers  
  signal s_EX_OUT_IR_OUT       : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_EX_OUT_NPC_OUT      : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_EX_OUT_CALC_COND    : std_logic;
  signal s_EX_OUT_WRONG_COND   : std_logic;
  signal s_EX_OUT_WRONG_TARGET : std_logic;
  signal s_EX_OUT_ALU_OUT      : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Control signals for EXECUTE
  signal s_CU_EX_IS_BRANCH   : std_logic;
  signal s_CU_EX_BRANCH_TYPE : std_logic;
  signal s_CU_EX_ALU_CONTROL : std_logic_vector(5 downto 0);
  signal s_CU_EX_TOP_MUX     : std_logic;
  signal s_CU_EX_BOT_MUX     : std_logic;
  signal s_CU_EX_FW_TOP_MUX  : std_logic_vector(1 downto 0);
  signal s_CU_EX_FW_BOT_MUX  : std_logic_vector(1 downto 0);

  --- Forwarding data signals to EXECUTE
  signal s_FW_ALU_FROM_MEM : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_FW_ALU_FROM_WB  : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_FW_MEM_FROM_WB  : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Pipelined signals coming from EX/MEM pipelining registers to MEMORY
  signal ps_EXMEM_rf_addr_dest : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  signal ps_EXMEM_IR_IN        : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal ps_EXMEM_NPC_IN       : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_EXMEM_ALU_OUT      : std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
  signal ps_EXMEM_DATA_IN      : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Signals coming from MEMORY to MEM/WB pipelining registers
  signal s_MEM_OUT_IR_OUT      : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_MEM_OUT_NPC_OUT     : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_MEM_OUT_ADDRESS_OUT : std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
  signal s_MEM_OUT_DATA_OUT    : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Interface signal for DRAM 
  signal s_DRAM_INTERFACE : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Control signals for MEMORY
  signal s_CU_MEM_READNOTWRITE : std_logic;
  signal s_CU_MEM_SIGNED_LOAD  : std_logic;
  signal s_CU_MEM_LOAD_TYPE    : std_logic_vector(1 downto 0);

  --- Pipelined signals coming from MEM/WB pipelining registers to WB
  signal ps_MEMWB_rf_addr_dest  : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);
  signal ps_MEMWB_IR_IN         : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal ps_MEMWB_NPC_IN        : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal ps_MEMWB_DATA_FROM_MEM : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal ps_MEMWB_DATA_FROM_ALU : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Signal from WB to previous stage
  signal s_WB_OUT_IR_OUT       : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_WB_OUT_NPC_OUT      : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_WB_OUT_DATA_TO_RF   : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_WB_OUT_RF_ADDR_DEST : std_logic_vector(log2ceil(CORE_RF_NREG) - 1 downto 0);

  --- Control signals for MEMORY
  signal s_CU_WB_MUX_CONTROL : std_logic_vector(1 downto 0);

begin
  -----------------------------------------------------------------------------
  --                              FETCH
  -----------------------------------------------------------------------------
  s_IF_branch_pred_error  <= s_EX_OUT_WRONG_COND or s_EX_OUT_WRONG_TARGET;
  IF_stage : fetch
    generic map(
      FETCH_PC_NBIT => CORE_PC_NBIT,
      FETCH_IR_NBIT => CORE_IR_NBIT)
    port map(
      fetch_branch_pred_error => s_IF_branch_pred_error,
      FETCH_clk                => CORE_CLK,
      FETCH_rst                => CORE_RST,
      FETCH_pc_enable          => s_CU_IF_PC_EN,
      FETCH_pc_clear           => s_CU_IF_PC_CLR,
      FETCH_btb_prediction_in  => BTB_PREDICTION_IN,
      FETCH_btb_target_in      => BTB_TARGET_IN,
      FETCH_alu_out            => s_EX_OUT_NPC_OUT, -----OK
      FETCH_ir_in              => s_IF_IN_IR_IN,
      FETCH_ir_out             => s_IF_OUT_IR_OUT,
      FETCH_pc                 => s_IF_OUT_PC,
      FETCH_npc                => s_IF_OUT_NPC,
      FETCH_btb_prediction_out => s_IF_OUT_BTB_PREDICTION_OUT,
      FETCH_btb_target_out     => s_IF_OUT_btb_target_out);

  --- Interface with IROM
  s_IF_IN_IR_IN    <= CORE_ROM_INTERFACE;
  CORE_ROM_ADDRESS <= s_IF_OUT_PC;

  -----------------------------------------------------------------------------
  --                              IF/ID REGISTERS
  -----------------------------------------------------------------------------
  IFID_PC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT)
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IFID_CLR,
      REG_enable   => CORE_IFID_EN,
      REG_data_in  => s_IF_OUT_PC,
      REG_data_out => ps_IFID_pc_in);

  IFID_NPC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT)
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IFID_CLR,
      REG_enable   => CORE_IFID_EN,
      REG_data_in  => s_IF_OUT_NPC,
      REG_data_out => ps_IFID_NPC_IN);

  IFID_IR : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT)
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IFID_CLR,
      REG_enable   => CORE_IFID_EN,
      REG_data_in  => s_IF_OUT_IR_OUT,
      REG_data_out => ps_IFID_IR_IN);

  IFID_BTB_TARGET : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT)
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IFID_CLR,
      REG_enable   => CORE_IFID_EN,
      REG_data_in  => s_IF_OUT_btb_target_out,
      REG_data_out => ps_IFID_BTB_TARGET_OUT);

  IFID_BTB_PREDICTION : d_ff
    port map(
      DFF_clk => CORE_CLK,
      DFF_rst => CORE_RST,
      DFF_clr => CORE_IFID_CLR,
      DFF_d   => s_IF_OUT_BTB_PREDICTION_OUT,
      DFF_q   => ps_IFID_BTB_PREDICTION_OUT,
      DFF_nq  => open);

  -----------------------------------------------------------------------------
  --                              DECODE
  -----------------------------------------------------------------------------


  s_ID_IN_rf_addr_write <= s_WB_OUT_RF_ADDR_DEST; -- from write back
  s_ID_IN_rf_data_write <= s_WB_OUT_DATA_TO_RF;

  ID : decode
    generic map(
      DECODE_NREG    => CORE_RF_NREG,
      DECODE_NBIT    => CORE_RF_NBIT,
      DECODE_IR_NBIT => CORE_IR_NBIT
    )
    port map(
      DECODE_clk             => CORE_CLK,
      DECODE_rst             => CORE_RST,
      DECODE_sigext_op       => s_CU_sigext_op,
      DECODE_ir              => ps_IFID_IR_IN,
      DECODE_destination_sel => s_CU_ID_destination_sel,
      DECODE_rf_write_en     => s_CU_ID_rf_write_en,
      DECODE_rf_data_write   => s_ID_IN_rf_data_write,
      DECODE_rf_addr_write   => s_ID_IN_rf_addr_write,
      DECODE_rf_read_en_rs   => s_CU_decode_read1_en,
      DECODE_rf_read_en_rt   => s_CU_decode_read2_en,
      DECODE_pc_in           => ps_IFID_pc_in,
      DECODE_npc_in          => ps_IFID_NPC_IN,
      DECODE_sigext_out      => s_ID_OUT_sigext_out,
      DECODE_rf_addr_dest    => s_ID_OUT_rf_addr_dest,
      DECODE_rf_data_read1   => s_ID_OUT_rf_data_read1,
      DECODE_rf_data_read2   => s_ID_OUT_rf_data_read2,
      DECODE_pc_out          => s_ID_OUT_pc_out,
      DECODE_npc_out         => s_ID_OUT_npc_out
    );

  -----------------------------------------------------------------------------
  --                              ID/EX REGISTERS
  -----------------------------------------------------------------------------

  --- Pipeline register ID/EX for IR
  IDEX_PC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => ps_IFID_pc_in,
      REG_data_out => ps_IDEX_pc
    );

  --- Pipeline register ID/EX for IR
  IDEX_IR : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => ps_IFID_IR_IN,
      REG_data_out => ps_IDEX_IR_IN
    );

  --- Pipeline register ID/EX for NPC
  IDEX_NPC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => s_ID_OUT_npc_out,
      REG_data_out => ps_IDEX_NPC_IN
    );

  --- Pipeline register ID/EX for RF read data at port 1 
  IDEX_RF_IN1 : d_register
    generic map(
      REG_NBIT => CORE_ALU_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => s_ID_OUT_rf_data_read1,
      REG_data_out => ps_IDEX_RF_IN1
    );

  --- Pipeline register ID/EX for immediate    
  IDEX_IMM_IN : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => s_ID_OUT_sigext_out,
      REG_data_out => ps_IDEX_IMM_IN
    );

  --- Pipeline register ID/EX for RF read data at port 2
  IDEX_RF_IN2 : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => s_ID_OUT_rf_data_read2,
      REG_data_out => ps_IDEX_RF_IN2
    );

  --- Pipeline register ID/EX for predicted condition

  IDEX_PRED_COND : d_ff
    port map(
      DFF_clk => CORE_CLK,
      DFF_rst => CORE_RST,
      DFF_clr => CORE_IDEX_CLR,
      DFF_d   => ps_IFID_BTB_PREDICTION_OUT,
      DFF_q   => ps_IDEX_PRED_COND,
      DFF_nq  => open);

  IDEX_RF_ADDR_DEST : d_register
    generic map(
      REG_NBIT => log2ceil(CORE_RF_NREG)
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => s_ID_OUT_rf_addr_dest,
      REG_data_out => ps_IDEX_rf_addr_dest
    );

  IDEX_BTB_TARGET : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_IDEX_CLR,
      REG_enable   => CORE_IDEX_EN,
      REG_data_in  => ps_IFID_BTB_TARGET_OUT,
      REG_data_out => ps_IDEX_BTB_TARGET_OUT
    );

  -----------------------------------------------------------------------------
  --                              EXECUTE
  -----------------------------------------------------------------------------
  --- Execute stage
  EX : execute
    generic map(
      EXE_PC_NBIT  => CORE_PC_NBIT,
      EXE_IR_NBIT  => CORE_IR_NBIT,
      EXE_ALU_NBIT => CORE_ALU_NBIT
    )
    port map(
      EXE_IR_IN           => ps_IDEX_IR_IN,
      EXE_NPC_IN          => ps_IDEX_NPC_IN,
      EXE_IR_OUT          => s_EX_OUT_IR_OUT,
      EXE_NPC_OUT         => s_EX_OUT_NPC_OUT,
      EXE_RF_IN1          => ps_IDEX_RF_IN1,
      EXE_IMM_IN          => ps_IDEX_IMM_IN,
      EXE_RF_IN2          => ps_IDEX_RF_IN2,
      EXE_PRED_COND       => ps_IDEX_PRED_COND,
      EXE_CALC_COND       => s_EX_OUT_CALC_COND,
      EXE_WRONG_COND      => s_EX_OUT_WRONG_COND,
      EXE_WRONG_TARGET    => s_EX_OUT_WRONG_TARGET,
      EXE_ALU_OUT         => s_EX_OUT_ALU_OUT,
      EXE_FW_ALU_FROM_MEM => s_FW_ALU_FROM_MEM,
      EXE_FW_ALU_FROM_WB  => s_FW_ALU_FROM_WB,
      EXE_FW_MEM_FROM_WB  => s_FW_MEM_FROM_WB,
      EXE_CU_IS_BRANCH    => s_CU_EX_IS_BRANCH,
      EXE_CU_BRANCH_TYPE  => s_CU_EX_BRANCH_TYPE,
      EXE_CU_ALU_CONTROL  => s_CU_EX_ALU_CONTROL,
      EXE_CU_TOP_MUX      => s_CU_EX_TOP_MUX,
      EXE_CU_BOT_MUX      => s_CU_EX_BOT_MUX,
      EXE_CU_FW_TOP_MUX   => s_CU_EX_FW_TOP_MUX,
      EXE_CU_FW_BOT_MUX   => s_CU_EX_FW_BOT_MUX,
      EXE_BTB_TARGET      => ps_IDEX_BTB_TARGET_OUT
    );

  BTB_WRONG_TARGET     <= s_EX_OUT_WRONG_TARGET;
  BTB_WRONG_PREDICTION <= s_EX_OUT_WRONG_COND;
  BTB_TARGET_OUT       <= s_EX_OUT_ALU_OUT; -- This one or the pipelined signal?
  BTB_CONDITION_OUT    <= s_EX_OUT_CALC_COND;
  BTB_PC_WRITE         <= ps_IDEX_pc;
  -----------------------------------------------------------------------------
  --                             EX/MEM REGISTERS
  -----------------------------------------------------------------------------

  EXMEM_IR : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EX_OUT_IR_OUT,
      REG_data_out => ps_EXMEM_IR_IN
    );

  EXMEM_NPC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EX_OUT_NPC_OUT,
      REG_data_out => ps_EXMEM_NPC_IN
    );

  EXMEM_ALU_OUT : d_register
    generic map(
      REG_NBIT => CORE_ALU_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EX_OUT_ALU_OUT,
      REG_data_out => ps_EXMEM_ALU_OUT
    );

  EXMEM_DATAIN : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => ps_IDEX_RF_IN2,
      REG_data_out => ps_EXMEM_DATA_IN
    );

  EXMEM_RF_ADDR_DEST : d_register
    generic map(
      REG_NBIT => log2ceil(CORE_RF_NREG)
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => ps_IDEX_rf_addr_dest,
      REG_data_out => ps_EXMEM_rf_addr_dest
    );

  -----------------------------------------------------------------------------
  --                              MEMORY
  -----------------------------------------------------------------------------

  MEM : memory
    generic map(
      MEM_IR_NBIT   => CORE_IR_NBIT,
      MEM_PC_NBIT   => CORE_PC_NBIT,
      MEM_DATA_NBIT => CORE_DATA_NBIT,
      MEM_ADDR_NBIT => CORE_ADDR_NBIT
    )
    port map(
      MEM_IR_IN           => ps_EXMEM_IR_IN,
      MEM_NPC_IN          => ps_EXMEM_NPC_IN,
      MEM_IR_OUT          => s_MEM_OUT_IR_OUT,
      MEM_NPC_OUT         => s_MEM_OUT_NPC_OUT,
      MEM_ADDRESS_IN      => ps_EXMEM_ALU_OUT,
      MEM_ADDRESS_OUT     => s_MEM_OUT_ADDRESS_OUT,
      MEM_DATA_IN         => ps_EXMEM_DATA_IN,
      MEM_DATA_OUT        => s_MEM_OUT_DATA_OUT,
      MEM_INTERFACE       => s_DRAM_INTERFACE,
      MEM_CU_READNOTWRITE => s_CU_MEM_READNOTWRITE,
      MEM_CU_SIGNED_LOAD  => s_CU_MEM_SIGNED_LOAD,
      MEM_CU_LOAD_TYPE    => s_CU_MEM_LOAD_TYPE
    );

  CORE_DRAM_ADDRESS   <= s_MEM_OUT_ADDRESS_OUT;
  CORE_DRAM_INTERFACE <= s_DRAM_INTERFACE; ---??

  -----------------------------------------------------------------------------
  --                             MEM/WB REGISTERS
  -----------------------------------------------------------------------------

  MEMWB_IR : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEM_OUT_IR_OUT,
      REG_data_out => ps_MEMWB_IR_IN
    );

  MEMWB_NPC : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEM_OUT_NPC_OUT,
      REG_data_out => ps_MEMWB_NPC_IN
    );

  MEMWB_DATAOUT : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEM_OUT_DATA_OUT,
      REG_data_out => ps_MEMWB_DATA_FROM_MEM
    );

  MEMWB_ALUOUT : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => ps_EXMEM_ALU_OUT,
      REG_data_out => ps_MEMWB_DATA_FROM_ALU
    );
  MEMWB_RF_ADDR_DEST : d_register
    generic map(
      REG_NBIT => log2ceil(CORE_RF_NREG)
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => ps_EXMEM_rf_addr_dest,
      REG_data_out => ps_MEMWB_rf_addr_dest
    );
  -----------------------------------------------------------------------------
  --                              WRITEBACK
  -----------------------------------------------------------------------------

  WB : writeback
    generic map(
      WB_PC_NBIT   => CORE_PC_NBIT,
      WB_IR_NBIT   => CORE_IR_NBIT,
      WB_DATA_NBIT => CORE_DATA_NBIT
    )
    port map(
      WB_IR_IN          => ps_MEMWB_IR_IN,
      WB_NPC_IN         => ps_MEMWB_NPC_IN,
      WB_IR_OUT         => s_WB_OUT_IR_OUT,
      WB_NPC_OUT        => s_WB_OUT_NPC_OUT,
      WB_DATA_FROM_MEM  => ps_MEMWB_DATA_FROM_MEM,
      WB_DATA_FROM_ALU  => ps_MEMWB_DATA_FROM_ALU,
      WB_DATA_TO_RF     => s_WB_OUT_DATA_TO_RF,
      WB_CU_MUX_CONTROL => s_CU_WB_MUX_CONTROL
    );

  s_WB_OUT_RF_ADDR_DEST <= ps_MEMWB_rf_addr_dest;

  --- Forwarding data
  s_FW_ALU_FROM_MEM <= ps_EXMEM_ALU_OUT;
  s_FW_ALU_FROM_WB  <= ps_MEMWB_DATA_FROM_ALU;
  s_FW_MEM_FROM_WB  <= ps_MEMWB_DATA_FROM_MEM;

  --- Control signals
  s_CU_IF_PC_CLR <= CU_IF_PC_CLR;
  s_CU_IF_PC_EN  <= CU_IF_PC_EN;

  s_CU_ID_destination_sel <= CU_ID_destination_sel;
  s_CU_ID_rf_write_en     <= CU_ID_rf_write_en;
  -- s_CU_ID_sigext_signed   <= CU_ID_sigext_signed;
  s_CU_sigext_op          <= CU_ID_sigext_op;
  s_CU_decode_read1_en    <= CU_ID_read1_en;
  s_CU_decode_read2_en    <= CU_ID_read2_en;

  s_CU_EX_IS_BRANCH   <= CU_EX_IS_BRANCH;
  s_CU_EX_BRANCH_TYPE <= CU_EX_BRANCH_TYPE;
  s_CU_EX_ALU_CONTROL <= CU_EX_ALU_CONTROL;
  s_CU_EX_TOP_MUX     <= CU_EX_TOP_MUX;
  s_CU_EX_BOT_MUX     <= CU_EX_BOT_MUX;
  s_CU_EX_FW_TOP_MUX  <= CU_EX_FW_TOP_MUX;
  s_CU_EX_FW_BOT_MUX  <= CU_EX_FW_BOT_MUX;

  s_CU_MEM_READNOTWRITE <= CU_MEM_READNOTWRITE;
  s_CU_MEM_SIGNED_LOAD  <= CU_MEM_SIGNED_LOAD;
  s_CU_MEM_LOAD_TYPE    <= CU_MEM_LOAD_TYPE;

  s_CU_WB_MUX_CONTROL <= CU_WB_MUX_CONTROL;

  CORE_IFID_IR  <= ps_IFID_IR_IN;
  CORE_IDEX_IR  <= ps_IDEX_IR_IN;
  CORE_EXMEM_IR <= ps_EXMEM_IR_IN;
  CORE_MEMWB_IR <= ps_MEMWB_IR_IN;

end architecture STR;

configuration CFG_CORE_STR of CORE is
  for STR
    for all : fetch
      use configuration work.CFG_FETCH_STR;
    end for;
    for all : decode
      use configuration work.CFG_DECODE_STR;
    end for;
    for all : execute
      use configuration work.CFG_EXECUTE_STR;
    end for;
    for all : memory
      use configuration work.CFG_MEMORY_STR;
    end for;
    for all : writeback
      use configuration work.CFG_WRITEBACK_STR;
    end for;
    for all : d_ff
      use configuration work.CFG_D_FF_BHV;
    end for;
    for all : d_register
      use configuration work.CFG_D_REGISTER_STR;
    end for;
  end for;
end configuration CFG_CORE_STR;

