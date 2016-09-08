library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity core is
  generic(
    CORE_PC_NBIT   : positive := 32;
    CORE_IR_NBIT   : positive := 32;
    CORE_IMM_SIZE  : positive := 16;
    CORE_ALU_NBIT  : positive := 32;
    CORE_DATA_NBIT : positive := 32;
    CORE_ADDR_NBIT : positive := 32
  );
  port(
    CORE_CLK            : in    std_logic;
    CORE_RST            : in    std_logic;
    CORE_DXEX_EN        : in    std_logic; ---Enable signal for pipeling register ID/EX
    CORE_DXEX_CLR       : in    std_logic; ---Clear signal (Sync) for pipeling register ID/EX
    CORE_EXMEM_EN       : in    std_logic; ---Enable signal for pipeling register EX/MEM            
    CORE_EXMEM_CLR      : in    std_logic; ---Clear signal (Sync) for pipeling register EX/MEM   
    CORE_MEMWB_EN       : in    std_logic; ---Enable signal for pipeling register MEM/WB         
    CORE_MEMWB_CLR      : in    std_logic; ---Clear signal (Sync) for pipeling register MEM/WB  

    CORE_DRAM_INTERFACE : inout std_logic_vector(CORE_DATA_NBIT - 1 downto 0);
    CORE_DRAM_ADDRESS   : out   std_logic_vector(CORE_ADDR_NBIT - 1 downto 0)
  );
end entity core;

architecture STR of core is
  component fetch
    generic(
      FETCH_PC_NBIT : integer := 32;
      FETCH_IR_NBIT : integer := 32
    );
    port(
      FETCH_clk                : in  std_logic;
      FETCH_rst                : in  std_logic;
      FETCH_pc_enable          : in  std_logic;
      FETCH_pc_clear           : in  std_logic;
      FETCH_btb_prediction_in  : in  std_logic;
      FETCH_btb_target_in      : in  std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
      FETCH_alu_out            : in  std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
      FETCH_ir_in              : in  std_logic_vector(FETCH_IR_NBIT - 1 downto 0);
      FETCH_ir_out             : out std_logic_vector(FETCH_IR_NBIT - 1 downto 0);
      FETCH_pc                 : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
      FETCH_npc                : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0);
      FETCH_btb_prediction_out : out std_logic;
      FETCH_btb_target_out     : out std_logic_vector(FETCH_PC_NBIT - 1 downto 0)
    );
  end component fetch;

  component decode
    generic(
      DECODE_NREG     : integer := 32;
      DECODE_NBIT     : integer := 32;
      DECODE_IMM_SIZE : integer := 16
    );
    port(
      DECODE_clk           : in  std_logic;
      DECODE_rst           : in  std_logic;
      DECODE_sigext_signed : in  std_logic;
      DECODE_sigext_in     : in  std_logic_vector(DECODE_IMM_SIZE - 1 downto 0);
      DECODE_rf_write_en   : in  std_logic;
      DECODE_rf_data_write : in  std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_addr_write : in  std_logic_vector(log2ceil(DECODE_NREG) - 1 downto 0);
      DECODE_rf_addr_read1 : in  std_logic_vector(log2ceil(DECODE_NREG) - 1 downto 0);
      DECODE_rf_addr_read2 : in  std_logic_vector(log2ceil(DECODE_NREG) - 1 downto 0);
      DECODE_npc_in        : in  std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_sigext_out    : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_data_read1 : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_rf_data_read2 : out std_logic_vector(DECODE_NBIT - 1 downto 0);
      DECODE_npc_out       : out std_logic_vector(DECODE_NBIT - 1 downto 0)
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
      EXE_CU_BRANCH_TYPE  : in  std_logic;
      EXE_PRED_COND       : in  std_logic;
      EXE_CALC_COND       : out std_logic;
      EXE_WRONG_COND      : out std_logic;
      EXE_WRONG_TARGET    : out std_logic;
      EXE_ALU_OUT         : out std_logic_vector(EXE_ALU_NBIT - 1 downto 0);
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
      MEM_CU_READNOTWRITE : in    std_logic;
      MEM_DATA_OUT        : out   std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
      MEM_INTERFACE       : inout std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
      MEM_CU_SIGNED_LOAD  : in    std_logic;
      MEM_CU_LOAD_TYPE    : in    std_logic_vector(1 downto 0)
    );
  end component memory;

  component writeback
    generic(
      WB_PC_NBIT   : integer := 32;
      WB_IR_NBIT   : integer := 32;
      WB_DATA_NBIT : integer := 32
    );
    port(
      WB_IR_IN          : in  std_logic_vector(WB_IR_NBIT - 1 downto 0);
      WB_NPC_IN         : in  std_logic_vector(WB_PC_NBIT - 1 downto 0);
      WB_IR_OUT         : out std_logic_vector(WB_IR_NBIT - 1 downto 0);
      WB_NPC_OUT        : out std_logic_vector(WB_PC_NBIT - 1 downto 0);
      WB_DATA_FROM_MEM  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
      WB_DATA_FROM_ALU  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
      WB_CU_MUX_CONTROL : in  std_logic;
      WB_DATA_TO_RF     : out std_logic_vector(WB_DATA_NBIT - 1 downto 0)
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

  --- Pipelined signals coming from DX/EX pipelining registers to EXECUTE
  signal s_DXEX_IR_IN     : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_DXEX_NPC_IN    : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_DXEX_RF_IN1    : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_DXEX_RF_IN2    : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_DXEX_IMM_IN    : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_DXEX_PRED_COND : std_logic_vector(0 downto 0);

  --- Signals from EXECUTE to EX/MEM pipelining registers  
  signal s_EXMEM_IR_OUT       : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_EXMEM_NPC_OUT      : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_EXMEM_CALC_COND    : std_logic;
  signal s_EXMEM_WRONG_COND   : std_logic;
  signal s_EXMEM_WRONG_TARGET : std_logic;
  signal s_EXMEM_ALU_OUT      : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Control signals for EXECUTE
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
  signal s_EXMEM_IR_IN      : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_EXMEM_NPC_IN     : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_EXMEM_ADDRESS_IN : std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
  signal s_EXMEM_DATA_IN    : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Signals coming from MEMORY to MEM/WB pipelining registers
  signal s_MEMWB_IR_OUT      : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_MEMWB_NPC_OUT     : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_MEMWB_ADDRESS_OUT : std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
  signal s_MEMWB_DATA_OUT    : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Interface signal for DRAM 
  signal s_DRAM_INTERFACE : std_logic_vector(CORE_DATA_NBIT - 1 downto 0);

  --- Control signals for MEMORY
  signal s_CU_MEM_READNOTWRITE : std_logic;
  signal s_CU_MEM_SIGNED_LOAD  : std_logic;
  signal s_CU_MEM_LOAD_TYPE    : std_logic_vector(1 downto 0);

  --- Pipelined signals coming from MEM/WB pipelining registers to WB
  signal s_MEMWB_IR_IN         : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_MEMWB_NPC_IN        : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_MEMWB_DATA_FROM_MEM : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);
  signal s_MEMWB_DATA_FROM_ALU : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Signal from WB to previous stage
  signal s_WB_IR_OUT     : std_logic_vector(CORE_IR_NBIT - 1 downto 0);
  signal s_WB_NPC_OUT    : std_logic_vector(CORE_PC_NBIT - 1 downto 0);
  signal s_WB_DATA_TO_RF : std_logic_vector(CORE_ALU_NBIT - 1 downto 0);

  --- Control signals for MEMORY
  signal s_CU_WB_MUX_CONTROL : std_logic;

begin
  --- Pipeline register DX/EX for IR
  IR_DXEX : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_IR_IN
    );

  --- Pipeline register DX/EX for NPC
  NPC_DXEX : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_NPC_IN
    );

  --- Pipeline register DX/EX for RF read data at port 1 
  RF_IN1_DXEX : d_register
    generic map(
      REG_NBIT => CORE_ALU_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_RF_IN1
    );

  --- Pipeline register DX/EX for immediate    
  IMM_IN_DXEX : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_IMM_IN
    );

  --- Pipeline register DX/EX for RF read data at port 2
  RF_IN2_DXEX : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_RF_IN2
    );

  --- Pipeline register DX/EX for predicted condition
  PRED_COND_DXEX : d_register
    generic map(
      REG_NBIT => 1
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_DXEX_CLR,
      REG_enable   => CORE_DXEX_EN,
      REG_data_in  => TODO,
      REG_data_out => s_DXEX_PRED_COND
    );

  --- Execute stage
  EX : execute
    generic map(
      EXE_PC_NBIT  => CORE_PC_NBIT,
      EXE_IR_NBIT  => CORE_IR_NBIT,
      EXE_ALU_NBIT => CORE_ALU_NBIT
    )
    port map(
      EXE_IR_IN           => s_DXEX_IR_IN,
      EXE_NPC_IN          => s_DXEX_NPC_IN,
      EXE_IR_OUT          => s_EXMEM_IR_OUT,
      EXE_NPC_OUT         => s_EXMEM_NPC_OUT,
      EXE_RF_IN1          => s_DXEX_RF_IN1,
      EXE_IMM_IN          => s_DXEX_IMM_IN,
      EXE_RF_IN2          => s_DXEX_RF_IN2,
      EXE_PRED_COND       => s_DXEX_PRED_COND(0),
      EXE_CALC_COND       => s_EXMEM_CALC_COND,
      EXE_WRONG_COND      => s_EXMEM_WRONG_COND,
      EXE_WRONG_TARGET    => s_EXMEM_WRONG_TARGET,
      EXE_ALU_OUT         => s_EXMEM_ALU_OUT,
      EXE_FW_ALU_FROM_MEM => s_FW_ALU_FROM_MEM,
      EXE_FW_ALU_FROM_WB  => s_FW_ALU_FROM_WB,
      EXE_FW_MEM_FROM_WB  => s_FW_MEM_FROM_WB,
      EXE_CU_BRANCH_TYPE  => s_CU_EX_BRANCH_TYPE,
      EXE_CU_ALU_CONTROL  => s_CU_EX_ALU_CONTROL,
      EXE_CU_TOP_MUX      => s_CU_EX_TOP_MUX,
      EXE_CU_BOT_MUX      => s_CU_EX_BOT_MUX,
      EXE_CU_FW_TOP_MUX   => s_CU_EX_FW_TOP_MUX,
      EXE_CU_FW_BOT_MUX   => s_CU_EX_FW_BOT_MUX
    );

  IR_EXMEM : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EXMEM_IR_OUT,
      REG_data_out => s_EXMEM_IR_IN
    );

  NPC_EXMEM : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EXMEM_NPC_OUT,
      REG_data_out => s_EXMEM_NPC_IN
    );

  ALU_OUT_EXMEM : d_register
    generic map(
      REG_NBIT => CORE_ALU_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_EXMEM_ALU_OUT,
      REG_data_out => s_EXMEM_ADDRESS_IN
    );

  DATAIN_EXMEM : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_EXMEM_CLR,
      REG_enable   => CORE_EXMEM_EN,
      REG_data_in  => s_DXEX_RF_IN2,
      REG_data_out => s_EXMEM_DATA_IN
    );

  MEM : memory
    generic map(
      MEM_IR_NBIT   => CORE_IR_NBIT,
      MEM_PC_NBIT   => CORE_PC_NBIT,
      MEM_DATA_NBIT => CORE_DATA_NBIT,
      MEM_ADDR_NBIT => CORE_ADDR_NBIT
    )
    port map(
      MEM_IR_IN           => s_EXMEM_IR_IN,
      MEM_NPC_IN          => s_EXMEM_NPC_IN,
      MEM_IR_OUT          => s_MEMWB_IR_OUT,
      MEM_NPC_OUT         => s_MEMWB_NPC_OUT,
      MEM_ADDRESS_IN      => s_EXMEM_ADDRESS_IN,
      MEM_ADDRESS_OUT     => s_MEMWB_ADDRESS_OUT,
      MEM_DATA_IN         => s_EXMEM_DATA_IN,
      MEM_DATA_OUT        => s_MEMWB_DATA_OUT,
      MEM_INTERFACE       => s_DRAM_INTERFACE,
      MEM_CU_READNOTWRITE => s_CU_MEM_READNOTWRITE,
      MEM_CU_SIGNED_LOAD  => s_CU_MEM_SIGNED_LOAD,
      MEM_CU_LOAD_TYPE    => s_CU_MEM_LOAD_TYPE
    );
  CORE_DRAM_ADDRESS   <= s_MEMWB_ADDRESS_OUT;
  CORE_DRAM_INTERFACE <= s_DRAM_INTERFACE;

  IR_MEMWB : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEMWB_IR_OUT,
      REG_data_out => s_MEMWB_IR_IN
    );

  NPC_MEMWB : d_register
    generic map(
      REG_NBIT => CORE_PC_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEMWB_NPC_OUT,
      REG_data_out => s_MEMWB_NPC_IN
    );

  DATAOUT_MEMWB : d_register
    generic map(
      REG_NBIT => CORE_DATA_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_MEMWB_DATA_OUT,
      REG_data_out => s_MEMWB_DATA_FROM_MEM
    );

  ALUOUT_MEMWB : d_register
    generic map(
      REG_NBIT => CORE_IR_NBIT
    )
    port map(
      REG_clk      => CORE_CLK,
      REG_rst      => CORE_RST,
      REG_clr      => CORE_MEMWB_CLR,
      REG_enable   => CORE_MEMWB_EN,
      REG_data_in  => s_EXMEM_DATA_IN,
      REG_data_out => s_MEMWB_DATA_FROM_ALU
    );

  WB : writeback
    generic map(
      WB_PC_NBIT   => CORE_PC_NBIT,
      WB_IR_NBIT   => CORE_IR_NBIT,
      WB_DATA_NBIT => CORE_DATA_NBIT
    )
    port map(
      WB_IR_IN          => s_MEMWB_IR_IN,
      WB_NPC_IN         => s_MEMWB_NPC_IN,
      WB_IR_OUT         => s_WB_IR_OUT,
      WB_NPC_OUT        => s_WB_NPC_OUT,
      WB_DATA_FROM_MEM  => s_MEMWB_DATA_FROM_MEM,
      WB_DATA_FROM_ALU  => s_MEMWB_DATA_FROM_ALU,
      WB_DATA_TO_RF     => s_WB_DATA_TO_RF,
      WB_CU_MUX_CONTROL => s_CU_WB_MUX_CONTROL
    );
    
--- Forwarding data
s_FW_ALU_FROM_MEM <= s_EXMEM_ALU_OUT ;
s_FW_ALU_FROM_WB  <= s_MEMWB_DATA_FROM_ALU;
s_FW_MEM_FROM_WB  <= s_MEMWB_DATA_FROM_MEM;

end architecture STR;
