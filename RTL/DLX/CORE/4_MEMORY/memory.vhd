library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  generic(
    MEM_IR_NBIT   : integer := 32;
    MEM_PC_NBIT   : integer := 32;
    MEM_DATA_NBIT : integer := 32;
    MEM_ADDR_NBIT : integer := 32
  );
  port(
    MEM_IR_IN           : in    std_logic_vector(MEM_IR_NBIT - 1 downto 0); -- Instruction register in 
    MEM_NPC_IN          : in    std_logic_vector(MEM_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    MEM_IR_OUT          : out   std_logic_vector(MEM_IR_NBIT - 1 downto 0); -- Instruction register out 
    MEM_NPC_OUT         : out   std_logic_vector(MEM_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    MEM_ADDRESS_IN      : in    std_logic_vector(MEM_ADDR_NBIT - 1 downto 0); --
    MEM_ADDRESS_OUT     : out   std_logic_vector(MEM_ADDR_NBIT - 1 downto 0); --

    MEM_DATA_IN         : in    std_logic_vector(MEM_DATA_NBIT - 1 downto 0); --
    MEM_CU_READNOTWRITE : in    std_logic; --
    MEM_DATA_OUT        : out   std_logic_vector(MEM_DATA_NBIT - 1 downto 0); --
    MEM_INTERFACE       : inout std_logic_vector(MEM_DATA_NBIT - 1 downto 0); --

    MEM_CU_SIGNED_LOAD  : in    std_logic;
    MEM_CU_LOAD_TYPE    : in    std_logic_vector(1 downto 0)
  );
end entity memory;

architecture STR of memory is
  component sign_extention
    generic(
      SIGN_EXT_IN_NBIT  : integer := 16;
      SIGN_EXT_OUT_NBIT : integer := 32
    );
    port(
      SIGN_EXT_signed : in  std_logic;
      SIGN_EXT_input  : in  std_logic_vector(SIGN_EXT_IN_NBIT - 1 downto 0);
      SIGN_EXT_output : out std_logic_vector(SIGN_EXT_OUT_NBIT - 1 downto 0)
    );
  end component sign_extention;

  component mux_4to1
    generic(MUX_4to1_NBIT : integer := 4);
    port(
      MUX_4to1_in0 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in1 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in2 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_in3 : in  std_logic_vector(MUX_4to1_NBIT - 1 downto 0);
      MUX_4to1_sel : in  std_logic_vector(1 downto 0);
      MUX_4to1_out : out std_logic_vector(MUX_4to1_NBIT - 1 downto 0)
    );
  end component mux_4to1;

  signal s_internal_ir            : std_logic_vector(MEM_IR_NBIT - 1 downto 0);
  signal s_internal_npc           : std_logic_vector(MEM_PC_NBIT - 1 downto 0);
  signal s_internal_address       : std_logic_vector(MEM_ADDR_NBIT - 1 downto 0);
  signal s_internal_data_from_mem : std_logic_vector(MEM_DATA_NBIT - 1 downto 0);

  signal s_internal_data_word     : std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
  signal s_internal_data_halfword : std_logic_vector(MEM_DATA_NBIT - 1 downto 0);
  signal s_internal_data_byte     : std_logic_vector(MEM_DATA_NBIT - 1 downto 0);

begin
  process(MEM_CU_READNOTWRITE, MEM_INTERFACE, MEM_DATA_IN)
  begin
    if (MEM_CU_READNOTWRITE = '1') then
      s_internal_data_from_mem <= MEM_INTERFACE;
      MEM_INTERFACE            <= (others => 'Z');
    else
      if (MEM_CU_READNOTWRITE = '0') then
        MEM_DATA_OUT  <= MEM_INTERFACE;
        MEM_INTERFACE <= MEM_DATA_IN;
      end if;
    end if;
  end process;

  SIGN_BYTE : sign_extention
    generic map(
      SIGN_EXT_IN_NBIT  => 8,
      SIGN_EXT_OUT_NBIT => MEM_DATA_NBIT
    )
    port map(
      SIGN_EXT_signed => MEM_CU_SIGNED_LOAD,
      SIGN_EXT_input  => s_internal_data_from_mem(7 downto 0),
      SIGN_EXT_output => s_internal_data_byte
    );

  SIGN_HALFWORD : sign_extention
    generic map(
      SIGN_EXT_IN_NBIT  => 16,
      SIGN_EXT_OUT_NBIT => MEM_DATA_NBIT
    )
    port map(
      SIGN_EXT_signed => MEM_CU_SIGNED_LOAD,
      SIGN_EXT_input  => s_internal_data_from_mem(15 downto 0),
      SIGN_EXT_output => s_internal_data_halfword
    );

  s_internal_data_word <= s_internal_data_from_mem(32 - 1 downto 0);

  MUX_LOAD : component mux_4to1
    generic map(
      MUX_4to1_NBIT => MEM_DATA_NBIT
    )
    port map(
      MUX_4to1_in0 => s_internal_data_word,
      MUX_4to1_in1 => s_internal_data_halfword,
      MUX_4to1_in2 => s_internal_data_byte,
      MUX_4to1_in3 => (others => '0'),
      MUX_4to1_sel => MEM_CU_LOAD_TYPE,
      MUX_4to1_out => MEM_DATA_OUT
    );

  s_internal_ir <= MEM_IR_IN;
  MEM_IR_OUT    <= s_internal_ir;

  s_internal_npc <= MEM_NPC_IN;
  MEM_NPC_OUT    <= s_internal_npc;

  s_internal_address <= MEM_ADDRESS_IN;
  MEM_ADDRESS_OUT    <= s_internal_address;

end architecture STR;
