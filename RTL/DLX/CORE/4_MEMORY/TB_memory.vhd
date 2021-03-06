library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_memory is
end entity TB_memory;

architecture TEST of TB_memory is
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

  constant c_NBIT          : integer                               := 32;
  signal s_IR_IN           : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_NPC_IN          : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_IR_OUT          : std_logic_vector(c_NBIT - 1 downto 0);
  signal s_NPC_OUT         : std_logic_vector(c_NBIT - 1 downto 0);
  signal s_ADDRESS_IN      : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_ADDRESS_OUT     : std_logic_vector(c_NBIT - 1 downto 0);
  signal s_INTERFACE       : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_DATA_IN         : std_logic_vector(c_NBIT - 1 downto 0) := (others => '0');
  signal s_CU_READNOTWRITE : std_logic                             := '0';
  signal s_DATA_OUT        : std_logic_vector(c_NBIT - 1 downto 0);

  signal s_CU_SIGNED_LOAD : std_logic                    := '0';
  signal s_CU_LOAD_TYPE   : std_logic_vector(1 downto 0) := "00";
begin
  UUT : memory
    generic map(
      MEM_IR_NBIT   => c_NBIT,
      MEM_PC_NBIT   => c_NBIT,
      MEM_DATA_NBIT => c_NBIT,
      MEM_ADDR_NBIT => c_NBIT
    )
    port map(
      MEM_IR_IN           => s_IR_IN,
      MEM_NPC_IN          => s_NPC_IN,
      MEM_IR_OUT          => s_IR_OUT,
      MEM_NPC_OUT         => s_NPC_OUT,
      MEM_ADDRESS_IN      => s_ADDRESS_IN,
      MEM_ADDRESS_OUT     => s_ADDRESS_OUT,
      MEM_INTERFACE       => s_INTERFACE,
      MEM_DATA_IN         => s_DATA_IN,
      MEM_CU_READNOTWRITE => s_CU_READNOTWRITE,
      MEM_DATA_OUT        => s_DATA_OUT,
      MEM_CU_SIGNED_LOAD  => s_CU_SIGNED_LOAD,
      MEM_CU_LOAD_TYPE    => s_CU_LOAD_TYPE
    );

  process
  begin
    -- Write in memory
    s_INTERFACE       <= (others => 'Z');
    s_DATA_IN         <= x"EEEEEEEE";
    s_CU_READNOTWRITE <= '0';
    wait for 1 ns;
    -- Read unsigned byte
    s_INTERFACE <= x"000000FF";
    s_CU_LOAD_TYPE <= "10";
    s_CU_SIGNED_LOAD <= '0';
    s_CU_READNOTWRITE <= '1';
    wait for 1 ns;
    -- Read signed byte
    s_INTERFACE <= x"000000FF";
    s_CU_LOAD_TYPE <= "10";
    s_CU_SIGNED_LOAD <= '1';
    s_CU_READNOTWRITE <= '1';
    wait for 1 ns;
    -- Read unsigned halfword
    s_INTERFACE <= x"0000FFFF";
    s_CU_LOAD_TYPE <= "01";
    s_CU_SIGNED_LOAD <= '0';
    s_CU_READNOTWRITE <= '1';
    wait for 1 ns;
    -- Read signed halfword
    s_INTERFACE <= x"0000FFFF";
    s_CU_LOAD_TYPE <= "01";
    s_CU_SIGNED_LOAD <= '1';
    s_CU_READNOTWRITE <= '1';
    wait for 1 ns;
    -- Read word
    s_INTERFACE <= x"FFFFFFFF";
    s_CU_LOAD_TYPE <= "00";
    s_CU_SIGNED_LOAD <= '0';
    s_CU_READNOTWRITE <= '1';
    wait for 1 ns;
    wait;
  end process;

end architecture TEST;
