library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_btb_simo is
end entity TB_btb_simo;

architecture TEST of TB_btb_simo is
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

  constant c_NBIT    : integer := 32;
  constant c_ENTRIES : integer := 1024;
  constant c_TCLK    : time    := 1 ns;

  signal s_CALCULATED_PC     : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_CALCULATED_TARGET : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_PC                : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_TARGET_PC         : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');

  signal s_BRANCH_PREDICTION    : std_logic := '0';
  signal s_CALCULATED_CONDITION : std_logic := '0';
  signal s_CLR                  : std_logic := '0';
  signal s_EN                   : std_logic := '0';
  signal s_RST                  : std_logic := '0';
  signal s_CLK                  : std_logic := '0';

begin
  UUT : component BTB
    generic map(
      BTB_NBIT    => c_NBIT,
      BTB_ENTRIES => c_ENTRIES
    )
    port map(
      BTB_PC                   => s_PC,
      BTB_TARGET_PC            => s_TARGET_PC,
      BTB_BRANCH_PREDICTION    => s_BRANCH_PREDICTION,
      BTB_CALCULATED_PC        => s_CALCULATED_PC,
      BTB_CALCULATED_TARGET    => s_CALCULATED_TARGET,
      BTB_CALCULATED_CONDITION => s_CALCULATED_CONDITION,
      BTB_CLR                  => s_CLR,
      BTB_EN                   => s_EN,
      BTB_RST                  => s_RST,
      BTB_CLK                  => s_CLK
    );

  CLK_PROC : process
  begin
    wait for c_TCLK / 2;
    s_CLK <= not s_CLK;
  end process CLK_PROC;

  STIM : process
  begin
    wait for 1.1 ns;
    s_RST <= '1';
    wait for 1 ns;
    s_EN <= '1';
    s_CALCULATED_PC <= x"0F0000F0";
    s_CALCULATED_TARGET <= x"FFFFFFFF";
    s_CALCULATED_CONDITION <= '1';
    wait for 3 ns;
    s_EN <= '0';
    wait for 1 ns;
    s_PC <= x"0F0000F0";
    wait;
  end process STIM;

end architecture TEST;
