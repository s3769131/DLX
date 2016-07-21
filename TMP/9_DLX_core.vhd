--------------------------------------------------------------------------------
--! @file
--! @brief
--!
--!
--!
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;

--! Include standard package for type
use ieee.std_logic_1164.all;
--! Include standard package for handling casts
use ieee.numeric_std.all;
--! Include user-defined package for alternative math_real
use work.dlx_pkg.all;

entity DLX_CORE is
  port(
    DLX_CLK     : in    std_logic;      --! Clock signal
    DLX_RST     : in    std_logic;      --! Reset signal, active low
    DLX_IM_ADDR : out   std_logic_vector(31 downto 0); --! Address to instruction memory
    DLX_IM_DATA : in    std_logic_vector(31 downto 0); --! Data in from instruction memory
    DLX_IM_EN   : out   std_logic;      --! Enable signal (active TODO) to instruction memory
    DLX_IM_RDY  : in    std_logic;      --! Ack signal from instruction memory
    DLX_DM_ADDR : out   std_logic_vector(31 downto 0); --! Address to data memory
    DLX_DM_DATA : inout std_logic_vector(31 downto 0); --! Data from/to data memory
    DLX_DM_EN   : out   std_logic;      --! Enable signal (active TODO) to data memory
    DLX_DM_RW   : out   std_logic;      --! Read/~Write signal to data memory
    DLX_DM_RDY  : in    std_logic       --! Ack signal from data memory
  );
end entity;

architecture STR of DLX_CORE is
begin
end architecture STR;
