library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DLX is
  generic(
    DLX_PC_NBIT   : positive := 32;
    DLX_IR_NBIT   : positive := 32;
    DLX_ALU_NBIT  : positive := 32;
    DLX_DATA_NBIT : positive := 32;
    DLX_ADDR_NBIT : positive := 32;
    DLX_RF_NREG   : positive := 32;
    DLX_RF_NBIT   : positive := 32);
  port(
    DLX_CLK           : in    std_logic;
    DLX_RST           : in    std_logic;
    ROM_ADDRESS       : out   std_logic_vector(DLX_PC_NBIT - 1 downto 0);
    ROM_EN            : out   std_logic;
    ROM_DATA_READY    : in    std_logic;
    ROM_INTERFACE     : in    std_logic_vector(DLX_IR_NBIT - 1 downto 0);
    DRAM_ADDRESS      : out   std_logic_vector(DLX_ADDR_NBIT - 1 downto 0);
    DRAM_EN           : out   std_logic;
    DRAM_READNOTWRITE : out   std_logic;
    DRAM_DATA_READY   : in    std_logic;
    DRAM_INTERFACE    : inout std_logic_vector(DLX_DATA_NBIT - 1 downto 0)
  );
end entity DLX;

architecture STR of DLX is
  component core
    generic(
      CORE_PC_NBIT   : positive := 32;
      CORE_IR_NBIT   : positive := 32;
      CORE_ALU_NBIT  : positive := 32;
      CORE_DATA_NBIT : positive := 32;
      CORE_ADDR_NBIT : positive := 32;
      CORE_RF_NREG   : positive := 32;
      CORE_RF_NBIT   : positive := 32
    );
    port(
      CORE_CLK              : in    std_logic;
      CORE_RST              : in    std_logic;
      CORE_IFID_EN          : in    std_logic;
      CORE_IFID_CLR         : in    std_logic;
      CORE_IDEX_EN          : in    std_logic;
      CORE_IDEX_CLR         : in    std_logic;
      CORE_EXMEM_EN         : in    std_logic;
      CORE_EXMEM_CLR        : in    std_logic;
      CORE_MEMWB_EN         : in    std_logic;
      CORE_MEMWB_CLR        : in    std_logic;
      CORE_DRAM_INTERFACE   : inout std_logic_vector(CORE_DATA_NBIT - 1 downto 0);
      CORE_DRAM_ADDRESS     : out   std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
      CORE_ROM_INTERFACE    : in    std_logic_vector(CORE_IR_NBIT - 1 downto 0);
      CORE_ROM_ADDRESS      : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0);
      CU_IF_PC_EN           : in    std_logic;
      CU_IF_PC_CLR          : in    std_logic;
      CU_ID_destination_sel : in    std_logic_vector(1 downto 0);
      CU_ID_rf_write_en     : in    std_logic;
      --    CU_ID_sigext_signed   : in    std_logic;
      CU_ID_sigext_op       : in    std_logic_vector(1 downto 0);
      CU_ID_read1_en        : in    std_logic;
      CU_ID_read2_en        : in    std_logic;
      CU_EX_IS_BRANCH       : in    std_logic;
      CU_EX_BRANCH_TYPE     : in    std_logic;
      CU_EX_ALU_CONTROL     : in    std_logic_vector(5 downto 0);
      CU_EX_TOP_MUX         : in    std_logic;
      CU_EX_BOT_MUX         : in    std_logic;
      CU_EX_FW_TOP_MUX      : in    std_logic_vector(1 downto 0);
      CU_EX_FW_BOT_MUX      : in    std_logic_vector(1 downto 0);
      CU_MEM_READNOTWRITE   : in    std_logic;
      CU_MEM_SIGNED_LOAD    : in    std_logic;
      CU_MEM_LOAD_TYPE      : in    std_logic_vector(1 downto 0);
      CU_WB_MUX_CONTROL     : in    std_logic_vector(1 downto 0);
      CU_IS_JUMP_AND_LINK   : in    std_logic;
      BTB_PREDICTION_IN     : in    std_logic;
      BTB_TARGET_IN         : in    std_logic_vector(CORE_PC_NBIT - 1 downto 0);
      BTB_WRONG_TARGET      : out   std_logic;
      BTB_WRONG_PREDICTION  : out   std_logic;
      BTB_TARGET_OUT        : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0);
      BTB_CONDITION_OUT     : out   std_logic;
      BTB_PC_WRITE          : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0);
      CORE_IFID_IR          : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
      CORE_IDEX_IR          : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
      CORE_EXMEM_IR         : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0);
      CORE_MEMWB_IR         : out   std_logic_vector(CORE_IR_NBIT - 1 downto 0)
    );
  end component core;
  component cu
    generic(CU_IR_NBIT : positive := 32);
    port(
      CU_CLK                : in  std_logic;
      CU_RST                : in  std_logic;
      CU_IR                 : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
      CU_ROM_DATA_READY     : in  std_logic;
      CU_DRAM_DATA_READY    : in  std_logic;
      CU_ROM_EN             : out std_logic;
      CU_DRAM_EN            : out std_logic;
      CU_IFID_EN            : out std_logic;
      CU_IFID_CLR           : out std_logic;
      CU_IDEX_EN            : out std_logic;
      CU_IDEX_CLR           : out std_logic;
      CU_EXMEM_EN           : out std_logic;
      CU_EXMEM_CLR          : out std_logic;
      CU_MEMWB_EN           : out std_logic;
      CU_MEMWB_CLR          : out std_logic;
      CU_IF_PC_EN           : out std_logic;
      CU_IF_PC_CLR          : out std_logic;
      CU_ID_destination_sel : out std_logic_vector(1 downto 0);
      CU_ID_rf_write_en     : out std_logic;
      CU_ID_sigext_op       : out std_logic_vector(1 downto 0);
      CU_ID_read1_en        : out std_logic;
      CU_ID_read2_en        : out std_logic;
      CU_EX_IS_BRANCH       : out std_logic;
      CU_EX_BRANCH_TYPE     : out std_logic;
      CU_EX_ALU_CONTROL     : out std_logic_vector(5 downto 0);
      CU_EX_TOP_MUX         : out std_logic;
      CU_EX_BOT_MUX         : out std_logic;
      CU_EX_FW_TOP_MUX      : out std_logic_vector(1 downto 0);
      CU_EX_FW_BOT_MUX      : out std_logic_vector(1 downto 0);
      CU_MEM_READNOTWRITE   : out std_logic;
      CU_MEM_SIGNED_LOAD    : out std_logic;
      CU_MEM_LOAD_TYPE      : out std_logic_vector(1 downto 0);
      CU_WB_MUX_CONTROL     : out std_logic_vector(1 downto 0);
      CU_IDEX_IR            : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
      CU_EXMEM_IR           : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
      CU_MEMWB_IR           : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
      CU_wrong_prediction   : in  std_logic;
      CU_wrong_target       : in  std_logic;
      CU_is_jump_and_link   : out    std_logic
    );
  end component cu;

  signal s_IFID_EN            : std_logic;
  signal s_IFID_CLR           : std_logic;
  signal s_IDEX_EN            : std_logic;
  signal s_IDEX_CLR           : std_logic;
  signal s_EXMEM_EN           : std_logic;
  signal s_EXMEM_CLR          : std_logic;
  signal s_MEMWB_EN           : std_logic;
  signal s_MEMWB_CLR          : std_logic;
  --  signal s_DRAM_INTERFACE     : std_logic;
  --  signal s_DRAM_ADDRESS       : std_logic;
  --  signal s_ROM_INTERFACE      : std_logic;
  --  signal s_ROM_ADDRESS        : std_logic;
  signal s_IF_PC_EN           : std_logic;
  signal s_IF_PC_CLR          : std_logic;
  signal s_ID_destination_sel : std_logic_vector(1 downto 0);
  signal s_ID_rf_write_en     : std_logic;
  -- signal s_ID_sigext_signed   : std_logic;
  signal s_ID_sigext_op       : std_logic_vector(1 downto 0);
  signal s_ID_read1_en        : std_logic;
  signal s_ID_read2_en        : std_logic;
  signal s_EX_IS_BRANCH       : std_logic;
  signal s_EX_BRANCH_TYPE     : std_logic;
  signal s_EX_ALU_CONTROL     : std_logic_vector(5 downto 0);
  signal s_EX_TOP_MUX         : std_logic;
  signal s_EX_BOT_MUX         : std_logic;
  signal s_EX_FW_TOP_MUX      : std_logic_vector(1 downto 0);
  signal s_EX_FW_BOT_MUX      : std_logic_vector(1 downto 0);
  signal s_MEM_READNOTWRITE   : std_logic;
  signal s_MEM_SIGNED_LOAD    : std_logic;
  signal s_MEM_LOAD_TYPE      : std_logic_vector(1 downto 0);
  signal s_WB_MUX_CONTROL     : std_logic_vector(1 downto 0);

  signal s_PREDICTION_IN    : std_logic := '0';
  signal s_TARGET_IN        : std_logic_vector(DLX_PC_NBIT - 1 downto 0) := (others  => '0');
  signal s_WRONG_TARGET     : std_logic;
  signal s_WRONG_PREDICTION : std_logic;
  signal s_TARGET_OUT       : std_logic_vector(DLX_PC_NBIT - 1 downto 0);
  signal s_CONDITION_OUT    : std_logic;
  signal s_PC_WRITE         : std_logic_vector(DLX_PC_NBIT - 1 downto 0);

  signal s_IFID_IR  : std_logic_vector(DLX_IR_NBIT - 1 downto 0);
  signal s_IDEX_IR  : std_logic_vector(DLX_IR_NBIT - 1 downto 0);
  signal s_EXMEM_IR : std_logic_vector(DLX_IR_NBIT - 1 downto 0);
  signal s_MEMWB_IR : std_logic_vector(DLX_IR_NBIT - 1 downto 0);
  
 signal IS_JUMP_AND_LINK   :    std_logic;

begin
  core_inst : core
    generic map(
      CORE_PC_NBIT   => DLX_PC_NBIT,
      CORE_IR_NBIT   => DLX_IR_NBIT,
      CORE_ALU_NBIT  => DLX_ALU_NBIT,
      CORE_DATA_NBIT => DLX_DATA_NBIT,
      CORE_ADDR_NBIT => DLX_ADDR_NBIT,
      CORE_RF_NREG   => DLX_RF_NREG,
      CORE_RF_NBIT   => DLX_RF_NBIT
    )
    port map(
      CORE_CLK              => DLX_CLK,
      CORE_RST              => DLX_RST,
      CORE_IFID_EN          => s_IFID_EN,
      CORE_IFID_CLR         => s_IFID_CLR,
      CORE_IDEX_EN          => s_IDEX_EN,
      CORE_IDEX_CLR         => s_IDEX_CLR,
      CORE_EXMEM_EN         => s_EXMEM_EN,
      CORE_EXMEM_CLR        => s_EXMEM_CLR,
      CORE_MEMWB_EN         => s_MEMWB_EN,
      CORE_MEMWB_CLR        => s_MEMWB_CLR,
      CORE_DRAM_INTERFACE   => DRAM_INTERFACE,
      CORE_DRAM_ADDRESS     => DRAM_ADDRESS,
      CORE_ROM_INTERFACE    => ROM_INTERFACE,
      CORE_ROM_ADDRESS      => ROM_ADDRESS,
      CU_IF_PC_EN           => s_IF_PC_EN,
      CU_IF_PC_CLR          => s_IF_PC_CLR,
      CU_ID_destination_sel => s_ID_destination_sel,
      CU_ID_rf_write_en     => s_ID_rf_write_en,
      --CU_ID_sigext_signed   => s_ID_sigext_signed,
      CU_ID_sigext_op       => s_ID_sigext_op,
      CU_ID_read1_en        => s_ID_read1_en,
      CU_ID_read2_en        => s_ID_read2_en,
      CU_EX_IS_BRANCH       => s_EX_IS_BRANCH,
      CU_EX_BRANCH_TYPE     => s_EX_BRANCH_TYPE,
      CU_EX_ALU_CONTROL     => s_EX_ALU_CONTROL,
      CU_EX_TOP_MUX         => s_EX_TOP_MUX,
      CU_EX_BOT_MUX         => s_EX_BOT_MUX,
      CU_EX_FW_TOP_MUX      => s_EX_FW_TOP_MUX,
      CU_EX_FW_BOT_MUX      => s_EX_FW_BOT_MUX,
      CU_MEM_READNOTWRITE   => s_MEM_READNOTWRITE,
      CU_MEM_SIGNED_LOAD    => s_MEM_SIGNED_LOAD,
      CU_MEM_LOAD_TYPE      => s_MEM_LOAD_TYPE,
      CU_WB_MUX_CONTROL     => s_WB_MUX_CONTROL,
      cu_is_jump_and_link => is_jump_and_link,
      BTB_PREDICTION_IN     => s_PREDICTION_IN,
      BTB_TARGET_IN         => s_TARGET_IN,
      BTB_WRONG_TARGET      => s_WRONG_TARGET,
      BTB_WRONG_PREDICTION  => s_WRONG_PREDICTION,
      BTB_TARGET_OUT        => s_TARGET_OUT,
      BTB_CONDITION_OUT     => s_CONDITION_OUT,
      BTB_PC_WRITE          => s_PC_WRITE,
      CORE_IFID_IR          => s_IFID_IR,
      CORE_IDEX_IR          => s_IDEX_IR,
      CORE_EXMEM_IR         => s_EXMEM_IR,
      CORE_MEMWB_IR         => s_MEMWB_IR
    );

  cu_inst : cu
    generic map(
      CU_IR_NBIT => DLX_IR_NBIT
    )
    port map(
      CU_CLK                => DLX_CLK,
      CU_RST                => DLX_RST,
      CU_IR                 => s_IFID_IR,
      CU_ROM_DATA_READY     => ROM_DATA_READY,
      CU_DRAM_DATA_READY    => DRAM_DATA_READY,
      CU_ROM_EN             => ROM_EN,
      CU_DRAM_EN            => DRAM_EN,
      CU_IFID_EN            => s_IFID_EN,
      CU_IFID_CLR           => s_IFID_CLR,
      CU_IDEX_EN            => s_IDEX_EN,
      CU_IDEX_CLR           => s_IDEX_CLR,
      CU_EXMEM_EN           => s_EXMEM_EN,
      CU_EXMEM_CLR          => s_EXMEM_CLR,
      CU_MEMWB_EN           => s_MEMWB_EN,
      CU_MEMWB_CLR          => s_MEMWB_CLR,
      CU_IF_PC_EN           => s_IF_PC_EN,
      CU_IF_PC_CLR          => s_IF_PC_CLR,
      CU_ID_destination_sel => s_ID_destination_sel,
      CU_ID_rf_write_en     => s_ID_rf_write_en,
      CU_ID_sigext_op       => s_ID_sigext_op,
      CU_ID_read1_en        => s_ID_read1_en,
      CU_ID_read2_en        => s_ID_read2_en,
      CU_EX_IS_BRANCH       => s_EX_IS_BRANCH,
      CU_EX_BRANCH_TYPE     => s_EX_BRANCH_TYPE,
      CU_EX_ALU_CONTROL     => s_EX_ALU_CONTROL,
      CU_EX_TOP_MUX         => s_EX_TOP_MUX,
      CU_EX_BOT_MUX         => s_EX_BOT_MUX,
      CU_EX_FW_TOP_MUX      => s_EX_FW_TOP_MUX,
      CU_EX_FW_BOT_MUX      => s_EX_FW_BOT_MUX,
      CU_MEM_READNOTWRITE   => s_MEM_READNOTWRITE,
      CU_MEM_SIGNED_LOAD    => s_MEM_SIGNED_LOAD,
      CU_MEM_LOAD_TYPE      => s_MEM_LOAD_TYPE,
      CU_WB_MUX_CONTROL     => s_WB_MUX_CONTROL,
      CU_IDEX_IR            => s_IDEX_IR,
      CU_EXMEM_IR           => s_EXMEM_IR,
      CU_MEMWB_IR           => s_MEMWB_IR,
      CU_wrong_prediction   => s_WRONG_TARGET,
      CU_wrong_target       => s_WRONG_PREDICTION,
      CU_is_jump_and_link  => IS_JUMP_AND_LINK
    );

  DRAM_READNOTWRITE <= s_MEM_READNOTWRITE;
end architecture STR;

configuration CFG_DLX_STR of DLX is
  for STR
  end for;
end configuration CFG_DLX_STR;
