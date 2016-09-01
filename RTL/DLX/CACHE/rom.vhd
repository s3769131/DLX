library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.alu_pkg.all;

-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity ROM is
  generic(
    ROM_FILE_PATH  : string;
    ROM_ENTRIES    : integer := 128;
    ROM_WORD_SIZE  : integer := 32
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

architecture Behavioral of ROM is
  type MEMORY_TYPE is array (0 to ROM_ENTRIES - 1) of integer;

  signal ROM : MEMORY_TYPE;

  signal valid : std_logic;
  signal idout : std_logic_vector(ROM_WORD_SIZE - 1 downto 0);

  signal count : integer;-- range 0 to (ROM_DATA_DELAY + 1) := 0;

begin
  process(ROM_RST, ROM_CLK)
    file mem_fp         : text;
    variable file_line  : line;
    variable index      : integer := 0;
    variable tmp_data_u : std_logic_vector(ROM_WORD_SIZE - 1 downto 0);

  begin  -- process FILL_MEM_P
    if (ROM_RST = '1') then
      file_open(mem_fp, ROM_FILE_PATH, read_mode);

      while (not endfile(mem_fp) and index < ROM_ENTRIES) loop
        readline(mem_fp, file_line);
        hread(file_line, tmp_data_u);
        ROM(index) <= conv_integer(unsigned(tmp_data_u));
        index      := index + 1;
      end loop;

      file_close(mem_fp);

      count <= 0;
      valid <= '0';
    else if ROM_CLK'event and ROM_CLK = '1' then
           if (ROM_ENABLE = '1') then
            -- count <= count + 1;
            -- if (count - 1 = ROM_DATA_DELAY) then
            --   count <= 0;
               valid <= '1';
               idout <= conv_std_logic_vector(ROM(conv_integer(unsigned(ROM_ADDRESS))), ROM_WORD_SIZE);
            -- end if;
           else
             count <= 0;
             valid <= '0';
           end if;
    end if;
  end if;
end process;

ROM_DATA_READY <= valid;
ROM_DATA_OUT   <= idout when valid = '1' else (others => 'Z');

end Behavioral;
