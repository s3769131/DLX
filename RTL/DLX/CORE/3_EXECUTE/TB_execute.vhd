library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_execute is
end entity TB_execute;

architecture TEST of TB_execute is
  component execute
    generic(EXE_NBIT : integer := 32);
    port(
      EXE_IR_IN           : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_NPC_IN          : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_IR_OUT          : out std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_NPC_OUT         : out std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_RF_IN1          : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_IMM_IN          : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_RF_IN2          : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_FW_ALU_FROM_MEM : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_FW_ALU_FROM_WB  : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_FW_MEM_FROM_WB  : in  std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_BRANCH_TYPE     : in  std_logic;
      EXE_PRED_COND       : in  std_logic;
      EXE_CALC_COND       : out std_logic;
      EXE_WRONG_COND      : out std_logic;
      EXE_WRONG_TARGET    : out std_logic;
      EXE_ALU_OUT         : out std_logic_vector(EXE_NBIT - 1 downto 0);
      EXE_CU_ALU_CONTROL  : in  std_logic_vector(5 downto 0);
      EXE_CU_TOP_MUX      : in  std_logic;
      EXE_CU_BOT_MUX      : in  std_logic;
      EXE_CU_FW_TOP_MUX   : in  std_logic_vector(1 downto 0);
      EXE_CU_FW_BOT_MUX   : in  std_logic_vector(1 downto 0)
    );
  end component execute;
  
  constant c_NBIT : integer := 32;
  
  signal     s_IR_IN           : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_NPC_IN          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_RF_IN1          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_IMM_IN          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_RF_IN2          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_FW_ALU_FROM_MEM : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_FW_ALU_FROM_WB  : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_FW_MEM_FROM_WB  : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal     s_CU_FW_BOT_MUX   : std_logic_vector(1 downto 0)          := (others => '0');
  signal     s_CU_ALU_CONTROL  : std_logic_vector(5 downto 0)          := (others => '0');
  signal     s_CU_FW_TOP_MUX   : std_logic_vector(1 downto 0)          := (others => '0');
  signal     s_BRANCH_TYPE     : std_logic := '0';
  signal     s_PRED_COND       : std_logic := '0';
  signal     s_CU_TOP_MUX      : std_logic := '0';
  signal     s_CU_BOT_MUX      : std_logic := '0';
  
  signal     s_CALC_COND       : std_logic;
  signal     s_WRONG_COND      : std_logic;
  signal     s_WRONG_TARGET    : std_logic;
  signal     s_IR_OUT          : std_logic_vector(c_NBIT - 1 downto 0);
  signal     s_ALU_OUT         : std_logic_vector(c_NBIT - 1 downto 0);
  signal     s_NPC_OUT         : std_logic_vector(c_NBIT - 1 downto 0);

begin
  DUT : component execute
    generic map(
      EXE_NBIT => c_NBIT
    )
    port map(
      EXE_IR_IN           => s_IR_IN,
      EXE_NPC_IN          => s_NPC_IN,
      EXE_IR_OUT          => s_IR_OUT,
      EXE_NPC_OUT         => s_NPC_OUT,
      EXE_RF_IN1          => s_RF_IN1,
      EXE_IMM_IN          => s_IMM_IN,
      EXE_RF_IN2          => s_RF_IN2,
      EXE_FW_ALU_FROM_MEM => s_FW_ALU_FROM_MEM,
      EXE_FW_ALU_FROM_WB  => s_FW_ALU_FROM_WB,
      EXE_FW_MEM_FROM_WB  => s_FW_MEM_FROM_WB,
      EXE_BRANCH_TYPE     => s_BRANCH_TYPE,
      EXE_PRED_COND       => s_PRED_COND,
      EXE_CALC_COND       => s_CALC_COND,
      EXE_WRONG_COND      => s_WRONG_COND,
      EXE_WRONG_TARGET    => s_WRONG_TARGET,
      EXE_ALU_OUT         => s_ALU_OUT,
      EXE_CU_ALU_CONTROL  => s_CU_ALU_CONTROL,
      EXE_CU_TOP_MUX      => s_CU_TOP_MUX,
      EXE_CU_BOT_MUX      => s_CU_BOT_MUX,
      EXE_CU_FW_TOP_MUX   => s_CU_FW_TOP_MUX,
      EXE_CU_FW_BOT_MUX   => s_CU_FW_BOT_MUX
    );
end architecture TEST;
