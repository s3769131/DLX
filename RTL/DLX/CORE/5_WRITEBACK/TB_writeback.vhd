library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_writeback is
end entity TB_writeback;

architecture TEST of TB_writeback is
  component writeback
    generic(WB_NBIT : integer := 32);
    port(
      WB_IR_IN          : in  std_logic_vector(WB_NBIT - 1 downto 0);
      WB_NPC_IN         : in  std_logic_vector(WB_NBIT - 1 downto 0);
      WB_IR_OUT         : out std_logic_vector(WB_NBIT - 1 downto 0);
      WB_NPC_OUT        : out std_logic_vector(WB_NBIT - 1 downto 0);
      WB_DATA_FROM_MEM  : in  std_logic_vector(WB_NBIT - 1 downto 0);
      WB_DATA_FROM_ALU  : in  std_logic_vector(WB_NBIT - 1 downto 0);
      WB_CU_MUX_CONTROL : in  std_logic;
      WB_DATA_TO_RF     : out std_logic_vector(WB_NBIT - 1 downto 0)
    );
  end component writeback;
  
  constant c_NBIT : integer := 32;

  signal s_IR_IN          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_NPC_IN         : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_DATA_FROM_MEM  : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_DATA_FROM_ALU  : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_CU_MUX_CONTROL : std_logic                             := '0';
  signal s_NPC_OUT        : std_logic_vector(c_NBIT - 1 downto 0);
  signal s_IR_OUT         : std_logic_vector(c_NBIT - 1 downto 0);
  signal s_DATA_TO_RF     : std_logic_vector(c_NBIT - 1 downto 0);
begin
  
  UUT : writeback
    generic map(
      WB_NBIT => c_NBIT
    )
    port map(
      WB_IR_IN          => s_IR_IN,
      WB_NPC_IN         => s_NPC_IN,
      WB_IR_OUT         => s_IR_OUT,
      WB_NPC_OUT        => s_NPC_OUT,
      WB_DATA_FROM_MEM  => s_DATA_FROM_MEM,
      WB_DATA_FROM_ALU  => s_DATA_FROM_ALU,
      WB_CU_MUX_CONTROL => s_CU_MUX_CONTROL,
      WB_DATA_TO_RF     => s_DATA_TO_RF
    );
end architecture TEST;
