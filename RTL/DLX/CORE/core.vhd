library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.DLX_pkg.all;

entity core is
  port (
    CORE_CLK : in std_logic;
    CORE_RST : in std_logic
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
      EXE_BRANCH_TYPE     : in  std_logic;
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
  
begin

end architecture STR;
