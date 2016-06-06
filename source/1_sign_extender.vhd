--------------------------------------------------------------------------------
--! @file
--! @brief 
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
--! Include standard package
use ieee.std_logic_1164.all;

entity SIGN_EXTENDER is
  generic(
    SIGEXT_IN  : integer := 16; --!
    SIGEXT_OUT : integer := 32  --!
  );
  port(
    SIGEXT_DATA_IN  : in std_logic_vector(SIGEXT_IN - 1 downto 0); --!
    SIGEXT_DATA_OUT : out std_logic_vector(SIGEXT_OUT - 1 downto 0) --!
  );
end entity SIGN_EXTENDER;

architecture BHV of SIGN_EXTENDER is
begin
  SIGN_EXTENDER_PROC : process (SIGEXT_DATA_IN)
  begin
    SIGEXT_DATA_OUT(SIGEXT_IN-1 downto 0)  <= SIGEXT_DATA_IN;
    for i in SIGEXT_IN to SIGEXT_OUT-1 loop
      SIGEXT_DATA_OUT(i)  <= SIGEXT_DATA_IN(SIGEXT_IN-1);
    end loop;   
  end process SIGN_EXTENDER_PROC;
  
end architecture BHV;
