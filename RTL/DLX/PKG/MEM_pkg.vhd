library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

package MEM_pkg is
  -- First index: entry number
  -- Second index: bit number
  type MEMORY_TYPE is array (natural range <>, natural range <>) of std_logic;

  function log2ceil(constant n : in integer) return integer;

  procedure HEXTODUALBIT(C : Character; RESULT : out Bit_Vector(3 downto 0); GOOD : out Boolean; ISSUE_ERROR : in Boolean);
  procedure HEX_TO_BITV(L : inout LINE; VALUE : out BIT_VECTOR);
  procedure HEX_TO_UV(L : inout LINE; VALUE : out STD_ULOGIC_VECTOR);
  procedure HEX_TO_LV(L : inout LINE; VALUE : out STD_LOGIC_VECTOR);

  procedure rewrite_contenent(MEMORY : in MEMORY_TYPE; ENTRIES : natural; NBIT : integer; FILEPATH : string);

  impure function initilize_mem_from_file(ENTRIES : integer; WORD_SIZE : integer; FILE_PATH : string) return MEMORY_TYPE;

-- impure function read_from_mem(MEMORY : in MEMORY_TYPE; ADDRESS : in integer) return integer;

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

  procedure HEXTODUALBIT(C : Character; RESULT : out Bit_Vector(3 downto 0); GOOD : out Boolean; ISSUE_ERROR : in Boolean) is
  begin
    case C is
      when '0' => RESULT := x"0";
        GOOD             := TRUE;
      when '1' => RESULT := x"1";
        GOOD             := TRUE;
      when '2' => RESULT := x"2";
        GOOD             := TRUE;
      when '3' => RESULT := x"3";
        GOOD             := TRUE;
      when '4' => RESULT := x"4";
        GOOD             := TRUE;
      when '5' => RESULT := x"5";
        GOOD             := TRUE;
      when '6' => RESULT := x"6";
        GOOD             := TRUE;
      when '7' => RESULT := x"7";
        GOOD             := TRUE;
      when '8' => RESULT := x"8";
        GOOD             := TRUE;
      when '9' => RESULT := x"9";
        GOOD             := TRUE;
      when 'A' => RESULT := x"A";
        GOOD             := TRUE;
      when 'B' => RESULT := x"B";
        GOOD             := TRUE;
      when 'C' => RESULT := x"C";
        GOOD             := TRUE;
      when 'D' => RESULT := x"D";
        GOOD             := TRUE;
      when 'E' => RESULT := x"E";
        GOOD             := TRUE;
      when 'F' => RESULT := x"F";
        GOOD             := TRUE;

      when 'a' => RESULT := x"A";
        GOOD             := TRUE;
      when 'b' => RESULT := x"B";
        GOOD             := TRUE;
      when 'c' => RESULT := x"C";
        GOOD             := TRUE;
      when 'd' => RESULT := x"D";
        GOOD             := TRUE;
      when 'e' => RESULT := x"E";
        GOOD             := TRUE;
      when 'f' => RESULT := x"F";
        GOOD             := TRUE;
      when others =>
        if ISSUE_ERROR then
          assert FALSE report "HREAD Error: Read a '" & C & "', expected a Hex character (0-F).";
        end if;
        GOOD := FALSE;
    end case;
  end;

  procedure HEX_TO_BITV(L : inout LINE; VALUE : out BIT_VECTOR) is
    variable ok : boolean;
    variable c  : character;
    constant ne : integer := VALUE'length / 4;
    variable bv : bit_vector(0 to VALUE'length - 1);
    variable s  : string(1 to ne - 1);
  begin
    if VALUE'length mod 4 /= 0 then
      assert FALSE report "HREAD Error: Trying to read vector " & "with an odd (non multiple of 4) length";
      return;
    end if;

    loop                                -- skip white space
      read(L, c);
      exit when ((c /= ' ') and (c /= CR) and (c /= HT));
    end loop;

    HEXTODUALBIT(c, bv(0 to 3), ok, TRUE);
    if not ok then
      return;
    end if;

    read(L, s, ok);
    if not ok then
      assert FALSE
        report "HREAD Error: Failed to read the STRING";
      return;
    end if;

    for i in 1 to ne - 1 loop
      HEXTODUALBIT(s(i), bv(4 * i to 4 * i + 3), ok, TRUE);
      if not ok then
        return;
      end if;
    end loop;
    VALUE := bv;
  end HEX_TO_BITV;

  procedure HEX_TO_UV(L : inout LINE; VALUE : out STD_ULOGIC_VECTOR) is
    variable tmp : bit_vector(VALUE'length - 1 downto 0);
  begin
    HEX_TO_BITV(L, tmp);
    VALUE := To_X01(tmp);
  end HEX_TO_UV;

  procedure HEX_TO_LV(L : inout LINE; VALUE : out STD_LOGIC_VECTOR) is
    variable tmp : STD_ULOGIC_VECTOR(VALUE'length - 1 downto 0);
  begin
    HEX_TO_UV(L, tmp);
    VALUE := STD_LOGIC_VECTOR(tmp);
  end HEX_TO_LV;

  impure function initilize_mem_from_file(ENTRIES : integer; WORD_SIZE : integer; FILE_PATH : string) return MEMORY_TYPE is
    variable tmp_mem : MEMORY_TYPE(ENTRIES * WORD_SIZE / 8 - 1 downto 0, 7 downto 0);

    variable file_line : line;
    variable index     : integer := 0;
    variable tmp_data  : std_logic_vector(WORD_SIZE - 1 downto 0);

    file mem_fp : text;

  begin
    file_open(mem_fp, FILE_PATH, read_mode);

    while (not endfile(mem_fp) and index < ENTRIES * WORD_SIZE / 8) loop
      readline(mem_fp, file_line);
      HEX_TO_LV(file_line, tmp_data);
      for i in 0 to WORD_SIZE / 8 - 1 loop
        for j in 0 to 7 loop
          tmp_mem(index + i, j) := tmp_data(8 * i + j);
        end loop;
      end loop;
      index := index + WORD_SIZE / 8;
    end loop;

    file_close(mem_fp);

    return tmp_mem;
  end function initilize_mem_from_file;

  procedure rewrite_contenent(MEMORY : in MEMORY_TYPE; ENTRIES : natural; NBIT : integer; FILEPATH : string) is
    variable index : natural range 0 to ENTRIES;
    file wr_file : text;
    variable line_in  : line;
    variable tmp_data : std_logic_vector(NBIT - 1 downto 0);
  begin
    index := 0;
    file_open(wr_file, FILEPATH, WRITE_MODE);
    while index < ENTRIES * NBIT / 8 loop
      for i in 0 to NBIT / 8 - 1 loop
        for j in 0 to 7 loop
          tmp_data(i * 8 + j) := MEMORY(index + i, j); --to_integer(unsigned(ROM_ADDRESS)
        end loop;
      end loop;
      --for i in 0 to NBIT - 1 loop
      --  tmp_data(i) := MEMORY(index, i);
      --end loop;
      hwrite(line_in, tmp_data);
      writeline(wr_file, line_in);
      index := index + 4;
    end loop;
  end rewrite_contenent;

end package body MEM_pkg;
