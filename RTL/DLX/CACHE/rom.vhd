library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
use work.MEM_pkg.all;


-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity ROM is
  generic(
    ROM_FILE_PATH : string;
    ROM_ENTRIES   : integer := 128;
    ROM_WORD_SIZE : integer := 32
  -- ROM_DATA_DELAY : natural := 2
  );
  port(
    ROM_CLK        : in  std_logic;
    ROM_RST        : in  std_logic;
    ROM_ADDRESS    : in  std_logic_vector(log2ceil(ROM_ENTRIES) - 1 downto 0);
    ROM_ENABLE     : in  std_logic;
    ROM_DATA_READY : out std_logic;
    ROM_DATA_OUT   : out std_logic_vector(ROM_WORD_SIZE - 1 downto 0)
  );
end ROM;

architecture BHV of ROM is
  
 -- type MEMORY_TYPE is array (natural range <>, natural range <>) of std_logic;


  signal ROM : MEMORY_TYPE(ROM_ENTRIES - 1 downto 0, ROM_WORD_SIZE - 1 downto 0) := initilize_mem_from_file(ROM_ENTRIES, ROM_WORD_SIZE, ROM_FILE_PATH);
  
  signal data_out : std_logic_vector(ROM_WORD_SIZE-1 downto 0);
  signal valid : std_logic;
  


 -- signal count : integer;               -- range 0 to (ROM_DATA_DELAY + 1) := 0;

begin
  
  
  process(ROM_RST, ROM_CLK)
  begin                                 -- process FILL_MEM_P
    if (ROM_RST = '1') then
    else
      if ROM_CLK'event and ROM_CLK = '1' then
        if (ROM_ENABLE = '1') then
          for i in 0 to ROM_WORD_SIZE-1 loop
            data_out(i) <= ROM(to_integer(unsigned(ROM_ADDRESS)),i);  --to_integer(unsigned(ROM_ADDRESS)
          end loop;
          valid <= '1';
        else
          valid <= '0';
        end if;
      end if;
    end if;
  end process;

  ROM_DATA_READY <= valid;
  ROM_DATA_OUT   <= data_out when valid = '1' else (others => 'Z');

end BHV;

configuration CFG_ROM_BHV of rom is
  for BHV
  end for;
end configuration CFG_ROM_BHV;

