library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_btb is

end entity TB_btb;

architecture TEST of TB_btb is
  component BTB
    generic(
      BTB_NBIT    : integer := 32;
      BTB_ENTRIES : integer := 1024
      );
    port(
      BTB_PC                   : in  std_logic_vector(BTB_NBIT - 1 downto 0);
      BTB_TARGET_PC            : out std_logic_vector(BTB_NBIT - 1 downto 0);
      BTB_BRANCH_PREDICTION    : out std_logic;
      BTB_CALCULATED_PC        : in  std_logic_vector(BTB_NBIT - 1 downto 0);
      BTB_CALCULATED_TARGET    : in  std_logic_vector(BTB_NBIT - 1 downto 0);
      BTB_CALCULATED_CONDITION : in  std_logic;
      BTB_CLR                  : in  std_logic;
      BTB_EN                   : in  std_logic;
      BTB_RST                  : in  std_logic;
      BTB_CLK                  : in  std_logic
      );
  end component BTB;
begin
  UUT : component BTB
    generic map(
      BTB_NBIT    => 32,
      BTB_ENTRIES => 1024
      )
    port map(
      BTB_PC                   => (others => '0'),
      BTB_TARGET_PC            => open,
      BTB_BRANCH_PREDICTION    => open,
      BTB_CALCULATED_PC        => (others => '0'),
      BTB_CALCULATED_TARGET    => (others => '0'),
      BTB_CALCULATED_CONDITION => '0',
      BTB_CLR                  => '0',
      BTB_EN                   => '0',
      BTB_RST                  => '0',
      BTB_CLK                  => '0'
      );
end architecture TEST;
