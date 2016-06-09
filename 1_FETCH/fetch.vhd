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
    generic(
  		RGS_NBIT: integer := 4
  	);
  	port(
  		RGS_D	:	in	std_logic_vector(RGS_NBIT-1 downto 0);
  		CLK 	:	in	std_logic;
  		RST 	:	in	std_logic;
  		RGS_Q	:	out	std_logic_vector(RGS_NBIT-1 downto 0)
  	);
  end component;

  component MUX is

  end component;
begin

end architecture STR;
