library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity writeback is
  generic(
    WB_PC_NBIT   : integer := 32;
    WB_IR_NBIT   : integer := 32;
    WB_DATA_NBIT : integer := 32);
  port(
    WB_IR_IN          : in  std_logic_vector(WB_IR_NBIT - 1 downto 0); -- Instruction register in 
    WB_NPC_IN         : in  std_logic_vector(WB_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    WB_IR_OUT         : out std_logic_vector(WB_IR_NBIT - 1 downto 0); -- Instruction register out 
    WB_NPC_OUT        : out std_logic_vector(WB_PC_NBIT - 1 downto 0); -- Next program counter (it can be the speculated) 

    WB_DATA_FROM_MEM  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
    WB_DATA_FROM_ALU  : in  std_logic_vector(WB_DATA_NBIT - 1 downto 0);
    WB_CU_MUX_CONTROL : in  std_logic;
    WB_DATA_TO_RF     : out std_logic_vector(WB_DATA_NBIT - 1 downto 0)
  );
end entity writeback;

architecture STR of writeback is
  component mux_2to1
    generic(MUX_2to1_NBIT : integer := 4);
    port(
      MUX_2to1_in0 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_in1 : in  std_logic_vector(MUX_2to1_NBIT - 1 downto 0);
      MUX_2to1_sel : in  std_logic;
      MUX_2to1_out : out std_logic_vector(MUX_2to1_NBIT - 1 downto 0)
    );
  end component mux_2to1;
  signal s_internal_ir  : std_logic_vector(WB_IR_NBIT - 1 downto 0);
  signal s_internal_npc : std_logic_vector(WB_PC_NBIT - 1 downto 0);
begin
  ROUTE_TO_RF : mux_2to1
    generic map(
      MUX_2to1_NBIT => WB_DATA_NBIT
    )
    port map(
      MUX_2to1_in0 => WB_DATA_FROM_MEM,
      MUX_2to1_in1 => WB_DATA_FROM_ALU,
      MUX_2to1_sel => WB_CU_MUX_CONTROL,
      MUX_2to1_out => WB_DATA_TO_RF
    );

  s_internal_ir <= WB_IR_IN;
  WB_IR_OUT     <= s_internal_ir;

  s_internal_npc <= WB_NPC_IN;
  WB_NPC_OUT     <= s_internal_npc;
end architecture STR;

configuration CFG_WRITEBACK_STR of WRITEBACK is
  for STR
    for ROUTE_TO_RF : mux_2to1
      use configuration work.CFG_MUX_2to1_BHV;
    end for;
  end for;
end configuration CFG_WRITEBACK_STR;

