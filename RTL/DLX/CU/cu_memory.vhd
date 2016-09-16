library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cu_memory is
  port(
    ROM_DATA_READY  : in  std_logic;
    DRAM_DATA_READY : in  std_logic;
    ROM_EN          : out std_logic;
    DRAM_EN         : out std_logic;
    IFID_CLR        : out std_logic;
    IFID_EN         : out std_logic;
    IDEX_CLR        : out std_logic;
    IDEX_EN         : out std_logic;
    EXMEM_CLR       : out std_logic;
    EXMEM_EN        : out std_logic;
    MEMWB_CLR       : out std_logic;
    MEMWB_EN        : out std_logic
  );
end entity cu_memory;

architecture STR of cu_memory is
begin
  ROM_EN  <= '1';
  DRAM_EN <= '1';

  IFID_CLR  <= '0';
  IFID_EN   <= '1';--ROM_DATA_READY and DRAM_DATA_READY;
  IDEX_CLR  <= '0';
  IDEX_EN   <= '1';--DRAM_DATA_READY;
  EXMEM_CLR <= '0';
  EXMEM_EN  <= '1';--DRAM_DATA_READY;
  MEMWB_CLR <= '0';
  MEMWB_EN  <= '1';--DRAM_DATA_READY;
end architecture STR;
