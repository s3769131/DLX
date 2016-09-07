library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  generic(
    MEM_NBIT : integer := 32);
  port(
    MEM_IR_IN  : in std_logic_vector(MEM_NBIT - 1 downto 0);  -- Instruction register in 
    MEM_NPC_IN : in std_logic_vector(MEM_NBIT - 1 downto 0);  -- Next program counter (it can be the speculated) 

    MEM_IR_OUT  : out std_logic_vector(MEM_NBIT - 1 downto 0);  -- Instruction register out 
    MEM_NPC_OUT : out std_logic_vector(MEM_NBIT - 1 downto 0);  -- Next program counter (it can be the speculated) 

    MEM_ADDRESS_IN      : in    std_logic_vector(MEM_NBIT - 1 downto 0);
    MEM_ADDRESS_OUT     : out   std_logic_vector(MEM_NBIT - 1 downto 0);
    MEM_INTERFACE       : inout std_logic_vector(MEM_NBIT - 1 downto 0);
    MEM_DATA_IN         : in    std_logic_vector(MEM_NBIT - 1 downto 0);
    MEM_CU_READNOTWRITE : in    std_logic;
    MEM_DATA_OUT        : out   std_logic_vector(MEM_NBIT - 1 downto 0)
    );
end entity memory;

architecture STR of memory is
  signal s_internal_ir      : std_logic_vector(MEM_NBIT - 1 downto 0);
  signal s_internal_npc     : std_logic_vector(MEM_NBIT - 1 downto 0);
  signal s_internal_address : std_logic_vector(MEM_NBIT - 1 downto 0);

  -- signal s_internal_data : std_logic_vector(MEM_NBIT-1 downto 0);

  -- signal a : std_logic_vector (MEM_NBIT -1 downto 0);   -- DFF that stores 
  -- value from input.
  -- signal b : std_logic_vector (MEM_NBIT - 1 downto 0);  -- DFF that stores 
  -- feedback value.
  
begin
  s_internal_ir <= MEM_IR_IN;
  MEM_IR_OUT    <= s_internal_ir;

  s_internal_npc <= MEM_NPC_IN;
  MEM_NPC_OUT    <= s_internal_npc;

  s_internal_address <= MEM_ADDRESS_IN;
  MEM_ADDRESS_OUT    <= s_internal_address;


  process (MEM_CU_READNOTWRITE, MEM_INTERFACE, MEM_DATA_IN)
  begin
    if(MEM_CU_READNOTWRITE = '1') then
      MEM_DATA_OUT  <= MEM_INTERFACE;
      MEM_INTERFACE <= (others => 'Z');
    else

      if (MEM_CU_READNOTWRITE = '0') then
        MEM_DATA_OUT  <= MEM_INTERFACE;
        MEM_INTERFACE <= MEM_DATA_IN;
      end if;

    end if;

  end process;


  
end architecture STR;
