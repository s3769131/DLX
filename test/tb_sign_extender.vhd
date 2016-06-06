--------------------------------------------------------------------------------
--! @file
--! @brief 
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
--! Include standard package
use ieee.std_logic_1164.all;

entity tb_sign_extender is
end entity tb_sign_extender;

architecture test of tb_sign_extender is
  component SIGN_EXTENDER
    generic(SIGEXT_IN  : integer := 16;
            SIGEXT_OUT : integer := 32);
    port(SIGEXT_DATA_IN  : in  std_logic_vector(SIGEXT_IN - 1 downto 0);
         SIGEXT_DATA_OUT : out std_logic_vector(SIGEXT_OUT - 1 downto 0));
  end component SIGN_EXTENDER;
  signal DATA_IN  : std_logic_vector(16 - 1 downto 0);
  signal DATA_OUT : std_logic_vector(32 - 1 downto 0);
begin
  DUT : component SIGN_EXTENDER
    generic map(
      SIGEXT_IN  => 16,
      SIGEXT_OUT => 32
    )
    port map(
      SIGEXT_DATA_IN  => DATA_IN,
      SIGEXT_DATA_OUT =>DATA_OUT
    );
  process
  begin
    DATA_IN <= "0111111111111111";
    wait for 5 ns;
    DATA_IN <= "1000000000000000";
    wait;
  end process;
end architecture test;
