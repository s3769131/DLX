--------------------------------------------------------------------------------
--! @file
--! @brief Register File with a generic number of registers and a generic number
--!        of bits for each register.
--!        It is allowed to address in parallel two registers for reading and 
--!        one register for writing. 
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;

--! Include standard package for type
use ieee.std_logic_1164.all;
--! Include standard package for handling casts
use ieee.numeric_std.all;
--! Include user-defined package for alternative math_real
use work.dlx_pkg.all;

--! @brief Register File with a generic number of registers and a generic number
--!        of bits for each register.
--!        It is allowed to address in parallel two registers for reading and 
--!        one register for writing. 
entity REGISTER_FILE is
  generic(RF_NBITS : integer := 64;     --! Number of bits for each register
          RF_NREGS : integer := 32);    --! Number of registers
  port(RF_CK       : in  std_logic;     --! Clock signal
       RF_RST      : in  std_logic;     --! Reset signal (active high)
       RF_EN       : in  std_logic;     --! General enable signal (active high)
       RF_W        : in  std_logic;     --! Write enable signal (active high)
       RF_R1       : in  std_logic;     --! Read to port 1 enable signal (active high)
       RF_R2       : in  std_logic;     --! Read to port 2 enable signal (active high)
       RF_WADDR    : in  std_logic_vector(log2ceil(RF_NREGS) - 1 downto 0); --! Address to the writing register 
       RF_R1ADDR   : in  std_logic_vector(log2ceil(RF_NREGS) - 1 downto 0); --! Address to the reading register (port 1)
       RF_R2ADDR   : in  std_logic_vector(log2ceil(RF_NREGS) - 1 downto 0); --! Address to the reading register (port 2)
       RF_DATAIN   : in  std_logic_vector(RF_NBITS - 1 downto 0); --! Data in, to be written
       RF_DATAOUT1 : out std_logic_vector(RF_NBITS - 1 downto 0); --! Data out from port 1, to be read
       RF_DATAOUT2 : out std_logic_vector(RF_NBITS - 1 downto 0)); --! Data out from port 2, to be read
end entity;

--! @brief High level - behavioural description of the register file with a 
--!        process sensitive to clock, reset and enable
architecture BHV of REGISTER_FILE is
  type REG_TYPE is array (RF_NREGS - 1 downto 0) of std_logic_vector(RF_NBITS - 1 downto 0);

  signal REGISTERS : REG_TYPE := (others => (others => '0'));

begin
  RF_PROC : process(RF_CK, RF_RST, RF_EN)
  begin
    if (RF_CK'event and RF_CK = '1' and RF_EN = '1') then
      if (RF_RST = '1') then
        REGISTERS <= (others => (others => '0'));
      else
        if (RF_R1 = '1') then
          RF_DATAOUT1 <= REGISTERS(to_integer(unsigned(RF_R1ADDR)));
        end if;
        if (RF_R2 = '1') then
          RF_DATAOUT2 <= REGISTERS(to_integer(unsigned(RF_R2ADDR)));
        end if;
        if (RF_W = '1') then
          REGISTERS(to_integer(unsigned(RF_WADDR))) <= RF_DATAIN;
        end if;
      end if;
    end if;
  end process;

end architecture;