library ieee;
use ieee.std_logic_1164;

entity FETCH is
  port (
    FTC_IRAM_IN  : in  std_logic_vector(31 downto 0);  --! Data in from instr. mem
    FTC_PC       : out std_logic_vector(31 downto 0);
    FTC_ALU_OUT  : in  std_logic_vector(31 downto 0);
    FTC_NPC      : out std_logic_vector(31 downto 0);
    FTC_IR       : out std_logic_vector(31 downto 0);
    FTC_IRAM_RDY : in std_logic;
    FTC_ZERO     : in std_logic;
    FTC_CLK      : in std_logic;
    FTC_RST      : in std_logic
  );
end entity FETCH;

architecture STR of FETCH is
  component REGISTER is

  end component;
begin

end architecture STR;
