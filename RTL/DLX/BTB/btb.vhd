library ieee;
use ieee.std_logic_1164.all;
use work.REGF_pkg.all;

entity BTB is
  generic(
    BTB_NBIT    : integer := 32;
    BTB_ENTRIES : integer := 1024);
  port(
    BTB_PC                   : in  std_logic_vector(BTB_NBIT - 1 downto 0);
    BTB_TARGET_PC            : out std_logic_vector(BTB_NBIT - 1 downto 0);
    BTB_BRANCH_PREDICTION    : out std_logic;
    BTB_CALCULATED_PC        : in  std_logic_vector(BTB_NBIT - 1 downto 0);
    BTB_CALCULATED_CONDITION : in  std_logic;
    BTB_CLR                  : in  std_logic;
    BTB_EN                   : in  std_logic;
    BTB_RST                  : in  std_logic;
    BTB_CLK                  : in  std_logic);
end entity BTB;

architecture STR of BTB is
  component decoder
    generic(DEC_NBIT : integer := 5);
    port(
      DEC_address : in  std_logic_vector(DEC_NBIT - 1 downto 0);
      DEC_enable  : in  std_logic;
      DEC_output  : out std_logic_vector(2 ** DEC_NBIT - 1 downto 0)
    );
  end component decoder;

  component multiplexer
    generic(
      MUX_NBIT : integer := 4;
      MUX_NSEL : integer := 3
    );
    port(
      MUX_inputs : in  std_logic_vector(2 ** MUX_NSEL * MUX_NBIT - 1 downto 0);
      MUX_select : in  std_logic_vector(MUX_NSEL - 1 downto 0);
      MUX_output : out std_logic_vector(MUX_NBIT - 1 downto 0)
    );
  end component multiplexer;

  component EQ_COMPARATOR
    generic(COMP_NBIT : integer := 32);
    port(
      COMP_A   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_B   : in  std_logic_vector(COMP_NBIT - 1 downto 0);
      COMP_RES : out std_logic
    );
  end component EQ_COMPARATOR;
  component sat_counter
    generic(SAT_NBIT : integer := 4);
    port(
      SAT_CLK : in  std_logic;
      SAT_RST : in  std_logic;
      SAT_EN  : in  std_logic;
      SAT_UP  : in  std_logic;
      SAT_OUT : out std_logic_vector(SAT_NBIT - 1 downto 0)
    );
  end component sat_counter;

  component REGF_register
    generic(REG_NBIT : integer := 8);
    port(
      REG_clk      : in  std_logic;
      REG_rst      : in  std_logic;
      REG_enable   : in  std_logic;
      REG_data_in  : in  std_logic_vector(REG_NBIT - 1 downto 0);
      REG_data_out : out std_logic_vector(REG_NBIT - 1 downto 0)
    );
  end component REGF_register;

  constant nbit_tag : integer := log2ceil(BTB_ENTRIES);
  constant nbit_mem : integer := BTB_NBIT + nbit_tag;

  signal s_mem_out      : std_logic_vector(BTB_NBIT * BTB_ENTRIES - 1 downto 0);
  signal s_mem_data_out : std_logic_vector(nbit_mem - 1 downto 0);
  signal s_mem_tag      : std_logic_vector(nbit_tag - 1 downto 0);
  signal s_mem_target   : std_logic_vector(BTB_NBIT - 1 downto 0);
  signal s_tag_equality : std_logic_vector(0 downto 0);

  signal s_target_mux_input : std_logic_vector(2 * BTB_NBIT - 1 downto 0);

begin
  MEMORY_BLOCK : for i in 0 to BTB_ENTRIES - 1 generate
    REG : REGF_register
      generic map(
        REG_NBIT => nbit_mem
      )
      port map(
        REG_clk      => BTB_CLK,
        REG_rst      => BTB_RST,
        REG_enable   => '0',            ---
        REG_data_in  => (others => '0'), ---
        REG_data_out => s_mem_out(i * BTB_NBIT to (i + 1) * BTB_NBIT - 1)
      );
  end generate MEMORY_BLOCK;

  MUX_OUT_MEM : multiplexer
    generic map(
      MUX_NBIT => nbit_mem,
      MUX_NSEL => BTB_ENTRIES
    )
    port map(
      MUX_inputs => s_mem_out,
      MUX_select => BTB_PC(nbit_tag + 2 downto 2),
      MUX_output => s_mem_data_out
    );

  s_mem_tag    <= s_mem_data_out(nbit_mem - 1 downto BTB_NBIT);
  s_mem_target <= s_mem_data_out(BTB_NBIT - 1 downto 0);

  COMPARATOR : EQ_COMPARATOR
    generic map(
      COMP_NBIT => BTB_NBIT - nbit_tag - 2
    )
    port map(
      COMP_A   => BTB_PC(BTB_NBIT - 1 downto nbit_tag + 2),
      COMP_B   => s_mem_tag,
      COMP_RES => s_tag_equality(0)
    );

  s_target_mux_input(2 * BTB_NBIT - 1 downto BTB_NBIT) <= s_mem_data_out(BTB_NBIT - 1 downto 0);
  s_target_mux_input(BTB_NBIT - 1 downto 0)            <= (others => '0');

  TARGET_MUX : multiplexer
    generic map(
      MUX_NBIT => BTB_NBIT,
      MUX_NSEL => 1
    )
    port map(
      MUX_inputs => s_target_mux_input,
      MUX_select => s_tag_equality,
      MUX_output => BTB_TARGET_PC
    );

end architecture STR;
