library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

package MEM_pkg is
  -- First index: entry number
  -- Second index: bit number
  type MEMORY_TYPE is array (natural range <>, natural range <>) of std_logic;

  function log2ceil(constant n : in integer) return integer;

  impure function initilize_mem_from_file(ENTRIES : integer; WORD_SIZE : integer; FILE_PATH : string) return MEMORY_TYPE;
end package MEM_pkg;

package body MEM_pkg is
  function log2ceil(constant n : in integer) return integer is
    variable m : integer := 0;          -- variable that will hold the final result.
    variable p : integer := 1;          -- lazy variable for computing the final result.
  begin
    MAIN_LOOP : for i in 0 to n loop
      if p < n then
        p := p * 2;
        m := m + 1;
      end if;
    end loop MAIN_LOOP;
    return m;
  end;

  impure function initilize_mem_from_file(ENTRIES : integer; WORD_SIZE : integer; FILE_PATH : string) return MEMORY_TYPE is
    variable tmp_mem : MEMORY_TYPE(ENTRIES - 1 downto 0, WORD_SIZE - 1 downto 0);

    variable file_line : line;
    variable index     : integer := 0;
    variable tmp_data  : std_logic_vector(WORD_SIZE - 1 downto 0);

    file mem_fp : text;

  begin
    file_open(mem_fp, FILE_PATH, read_mode);

    while (not endfile(mem_fp) and index < ENTRIES) loop
      readline(mem_fp, file_line);
      hread(file_line, tmp_data);
      for i in 0 to tmp_data'high loop
        tmp_mem(index, i) := tmp_data(i);
      end loop;
      index := index + 1;
    end loop;

    file_close(mem_fp);

    return tmp_mem;
  end function initilize_mem_from_file;

end package body MEM_pkg;
