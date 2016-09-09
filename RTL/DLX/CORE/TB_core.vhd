library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_core is
end entity TB_core;

architecture TEST of TB_core is
  component core
    generic(
      CORE_PC_NBIT   : positive := 32;
      CORE_IR_NBIT   : positive := 32;
      CORE_IMM_SIZE  : positive := 16;
      CORE_ALU_NBIT  : positive := 32;
      CORE_DATA_NBIT : positive := 32;
      CORE_ADDR_NBIT : positive := 32;
      CORE_RF_NREG   : positive := 32;
      CORE_RF_NBIT   : positive := 32
    );
    port(
      CORE_CLK              : in    std_logic;
      CORE_RST              : in    std_logic;
      CORE_FXDX_EN          : in    std_logic;
      CORE_FXDX_CLR         : in    std_logic;
      CORE_DXEX_EN          : in    std_logic;
      CORE_DXEX_CLR         : in    std_logic;
      CORE_EXMEM_EN         : in    std_logic;
      CORE_EXMEM_CLR        : in    std_logic;
      CORE_MEMWB_EN         : in    std_logic;
      CORE_MEMWB_CLR        : in    std_logic;
      CORE_DRAM_INTERFACE   : inout std_logic_vector(CORE_DATA_NBIT - 1 downto 0);
      CORE_DRAM_ADDRESS     : out   std_logic_vector(CORE_ADDR_NBIT - 1 downto 0);
      CORE_ROM_INTERFACE    : in    std_logic_vector(CORE_IR_NBIT - 1 downto 0);
      CORE_ROM_ADDRESS      : out   std_logic_vector(CORE_PC_NBIT - 1 downto 0);
      CU_FX_PC_EN           : in    std_logic;
      CU_FX_PC_CLR          : in    std_logic;
      CU_DX_destination_sel : in    std_logic;
      CU_DX_rf_write_en     : in    std_logic;
      CU_DX_sigext_signed   : in    std_logic;
      CU_EX_BRANCH_TYPE     : in    std_logic;
      CU_EX_ALU_CONTROL     : in    std_logic_vector(5 downto 0);
      CU_EX_TOP_MUX         : in    std_logic;
      CU_EX_BOT_MUX         : in    std_logic;
      CU_EX_FW_TOP_MUX      : in    std_logic_vector(1 downto 0);
      CU_EX_FW_BOT_MUX      : in    std_logic_vector(1 downto 0);
      CU_MEM_READNOTWRITE   : in    std_logic;
      CU_MEM_SIGNED_LOAD    : in    std_logic;
      CU_MEM_LOAD_TYPE      : in    std_logic_vector(1 downto 0);
      CU_WB_MUX_CONTROL     : in    std_logic;
      BTB_PREDICTION_IN     : in    std_logic;
      BTB_TARGET_IN         : in    std_logic_vector(CORE_PC_NBIT - 1 downto 0)
    );
  end component core;

  constant c_PC_NBIT   : positive := 32;
  constant c_IR_NBIT   : positive := 32;
  constant c_IMM_SIZE  : positive := 16;
  constant c_ALU_NBIT  : positive := 32;
  constant c_DATA_NBIT : positive := 32;
  constant c_ADDR_NBIT : positive := 32;
  constant c_RF_NREG   : positive := 32;
  constant c_RF_NBIT   : positive := 32;

  signal s_CLK                : std_logic;
  signal s_RST                : std_logic;
  signal s_FXDX_EN            : std_logic;
  signal s_FXDX_CLR           : std_logic;
  signal s_DXEX_EN            : std_logic;
  signal s_DXEX_CLR           : std_logic;
  signal s_EXMEM_EN           : std_logic;
  signal s_EXMEM_CLR          : std_logic;
  signal s_MEMWB_EN           : std_logic;
  signal s_MEMWB_CLR          : std_logic;
  signal s_DRAM_INTERFACE     : std_logic_vector(c_DATA_NBIT - 1 downto 0);
  signal s_DRAM_ADDRESS       : std_logic_vector(c_ADDR_NBIT - 1 downto 0);
  signal s_ROM_INTERFACE      : std_logic_vector(c_IR_NBIT - 1 downto 0);
  signal s_ROM_ADDRESS        : std_logic_vector(c_PC_NBIT - 1 downto 0);
  signal s_FX_PC_EN           : std_logic;
  signal s_FX_PC_CLR          : std_logic;
  signal s_DX_destination_sel : std_logic;
  signal s_DX_rf_write_en     : std_logic;
  signal s_DX_sigext_signed   : std_logic;
  signal s_EX_BRANCH_TYPE     : std_logic;
  signal s_EX_ALU_CONTROL     : std_logic_vector(5 downto 0);
  signal s_EX_TOP_MUX         : std_logic;
  signal s_EX_BOT_MUX         : std_logic;
  signal s_EX_FW_TOP_MUX      : std_logic_vector(1 downto 0);
  signal s_EX_FW_BOT_MUX      : std_logic_vector(1 downto 0);
  signal s_MEM_READNOTWRITE   : std_logic;
  signal s_MEM_SIGNED_LOAD    : std_logic;
  signal s_MEM_LOAD_TYPE      : std_logic_vector(1 downto 0);
  signal s_WB_MUX_CONTROL     : std_logic;
  signal s_PREDICTION_IN      : std_logic;
  signal s_TARGET_IN          : std_logic_vector(C_PC_NBIT - 1 downto 0);

begin
  
UUT : core
  generic map(
    CORE_PC_NBIT   => c_PC_NBIT,
    CORE_IR_NBIT   => c_IR_NBIT,
    CORE_IMM_SIZE  => c_IMM_SIZE,
    CORE_ALU_NBIT  => c_ALU_NBIT,
    CORE_DATA_NBIT => c_DATA_NBIT,
    CORE_ADDR_NBIT => c_ADDR_NBIT,
    CORE_RF_NREG   => c_RF_NREG,
    CORE_RF_NBIT   => c_RF_NBIT
  )
  port map(
    CORE_CLK              => s_CLK,
    CORE_RST              => s_RST,
    CORE_FXDX_EN          => s_FXDX_EN,
    CORE_FXDX_CLR         => s_FXDX_CLR,
    CORE_DXEX_EN          => s_DXEX_EN,
    CORE_DXEX_CLR         => s_DXEX_CLR,
    CORE_EXMEM_EN         => s_EXMEM_EN,
    CORE_EXMEM_CLR        => s_EXMEM_CLR,
    CORE_MEMWB_EN         => s_MEMWB_EN,
    CORE_MEMWB_CLR        => s_MEMWB_CLR,
    CORE_DRAM_INTERFACE   => s_DRAM_INTERFACE,
    CORE_DRAM_ADDRESS     => s_DRAM_ADDRESS,
    CORE_ROM_INTERFACE    => s_ROM_INTERFACE,
    CORE_ROM_ADDRESS      => s_ROM_ADDRESS,
    CU_FX_PC_EN           => s_FX_PC_EN,
    CU_FX_PC_CLR          => s_FX_PC_CLR,
    CU_DX_destination_sel => s_DX_destination_sel,
    CU_DX_rf_write_en     => s_DX_rf_write_en,
    CU_DX_sigext_signed   => s_DX_sigext_signed,
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
    BTB_PREDICTION_IN     => s_PREDICTION_IN,
    BTB_TARGET_IN         => s_TARGET_IN
  );
end architecture TEST;
