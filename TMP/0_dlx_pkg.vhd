package DLX_pkg is
  --! @brief  LOG2CEIL : accept an integer argument and returns the integer value that
  --!         rapresents the integer log2 of the argument, ceiled to next integer.
  function log2ceil(constant n : in integer) return integer;
end DLX_pkg;

package body DLX_pkg is
  function log2ceil(constant n : in integer) return integer is
    variable m : integer := 0;      -- variable that will hold the final result.
    variable p : integer := 1;      -- lazy variable for computing the final result.
  begin
    MAIN_LOOP : for i in 0 to n loop
      if p < n then
        p := p * 2;
        m := m + 1;
      end if;
    end loop MAIN_LOOP;
    return m;
  end;

end DLX_pkg;