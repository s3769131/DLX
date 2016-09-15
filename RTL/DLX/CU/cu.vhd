library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cu is
  generic(
    CU_IR_NBIT : positive := 32
  );
  port(
    CU_CLK                : in  std_logic;
    CU_RST                : in  std_logic;
    CU_IR                 : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
    CU_ROM_DATA_READY     : in  std_logic;
    CU_DRAM_DATA_READY    : in  std_logic; --
    CU_ROM_EN             : out std_logic;
    CU_DRAM_EN            : out std_logic; --     

    CU_IFID_EN            : out std_logic;
    CU_IFID_CLR           : out std_logic;
    CU_IDEX_EN            : out std_logic;
    CU_IDEX_CLR           : out std_logic;
    CU_EXMEM_EN           : out std_logic;
    CU_EXMEM_CLR          : out std_logic;
    CU_MEMWB_EN           : out std_logic;
    CU_MEMWB_CLR          : out std_logic;
    CU_IF_PC_EN           : out std_logic;
    CU_IF_PC_CLR          : out std_logic; ---

    CU_ID_destination_sel : out std_logic_vector(1 downto 0);
    CU_ID_rf_write_en     : out std_logic;
    CU_ID_sigext_op       : out std_logic_vector(1 downto 0);
    CU_ID_read1_en        : out std_logic;
    CU_ID_read2_en        : out std_logic;
    CU_EX_IS_BRANCH       : out std_logic;
    CU_EX_BRANCH_TYPE     : out std_logic;
    CU_EX_ALU_CONTROL     : out std_logic_vector(5 downto 0);
    CU_EX_TOP_MUX         : out std_logic;
    CU_EX_BOT_MUX         : out std_logic;
    CU_EX_FW_TOP_MUX      : out std_logic_vector(1 downto 0);
    CU_EX_FW_BOT_MUX      : out std_logic_vector(1 downto 0);
    CU_MEM_READNOTWRITE   : out std_logic;
    CU_MEM_SIGNED_LOAD    : out std_logic;
    CU_MEM_LOAD_TYPE      : out std_logic_vector(1 downto 0);
    CU_WB_MUX_CONTROL     : out std_logic_vector(1 downto 0); --

    CU_IDEX_IR            : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
    CU_EXMEM_IR           : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
    CU_MEMWB_IR           : in  std_logic_vector(CU_IR_NBIT - 1 downto 0)
  );
end entity cu;

architecture STR of cu is
  component d_register
    generic(REG_NBIT : integer := 8);
    port(
      REG_clk      : in  std_logic;
      REG_rst      : in  std_logic;
      REG_clr      : in  std_logic;
      REG_enable   : in  std_logic;
      REG_data_in  : in  std_logic_vector(REG_NBIT - 1 downto 0);
      REG_data_out : out std_logic_vector(REG_NBIT - 1 downto 0)
    );
  end component d_register;

  component cu_core
    generic(CU_IR_NBIT : positive := 32);
    port(
      CU_instruction_register : in  std_logic_vector(CU_IR_NBIT - 1 downto 0);
      CU_decode_signed_ext    : out std_logic_vector(1 downto 0);
      CU_decode_dest_sel      : out std_logic_vector(1 downto 0);
      CU_decode_read1_en      : out std_logic;
      CU_decode_read2_en      : out std_logic;
      CU_execute_branch_type  : out std_logic;
      CU_execute_alu_op       : out std_logic_vector(5 downto 0);
      CU_execute_top_mux      : out std_logic;
      CU_execute_bottom_mux   : out std_logic;
      CU_execute_is_branch    : out std_logic;
      CU_memory_r_not_w       : out std_logic;
      CU_memory_signed_load   : out std_logic;
      CU_memory_load_type     : out std_logic_vector(1 downto 0);
      CU_writeback_write_en   : out std_logic;
      CU_writeback_mux        : out std_logic_vector(1 downto 0)
    );
  end component cu_core;

  component cu_memory
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
  end component cu_memory;

  component forwarding_unit
    generic(FW_IR_NBIT : positive := 32);
    port(
      FW_IDEX_IR  : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
      FW_EXMEM_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
      FW_MEMWB_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
      FW_TOP_ALU  : out std_logic_vector(1 downto 0);
      FW_BOT_ALU  : out std_logic_vector(1 downto 0)
    );
  end component forwarding_unit;

--  signal s_instruction_register : std_logic_vector(CU_IR_NBIT - 1 downto 0);
  signal s_decode_signed_ext    : std_logic_vector(1 downto 0);
  signal s_decode_dest_sel      : std_logic_vector(1 downto 0);
  signal s_decode_read1_en      : std_logic;
  signal s_decode_read2_en      : std_logic;
  signal s_execute_branch_type  : std_logic;
  signal s_execute_alu_op       : std_logic_vector(5 downto 0);
  signal s_execute_top_mux      : std_logic;
  signal s_execute_bottom_mux   : std_logic;
  signal s_execute_is_branch    : std_logic;
  signal s_memory_r_not_w       : std_logic;
  signal s_memory_signed_load   : std_logic;
  signal s_memory_load_type     : std_logic_vector(1 downto 0);
  signal s_writeback_write_en   : std_logic;
  signal s_writeback_mux        : std_logic_vector(1 downto 0);

  signal s_idexmemwb : std_logic_vector(22 downto 0);
  signal s_exmemwb   : std_logic_vector(16 downto 0);
  signal s_memwb     : std_logic_vector(6 downto 0);
  signal s_wb        : std_logic_vector(2 downto 0);

  signal ps_exmemwb : std_logic_vector(16 downto 0);
  signal ps_memwb   : std_logic_vector(6 downto 0);
  signal ps_wb      : std_logic_vector(2 downto 0);

begin
  cu_core_inst : cu_core
    generic map(
      CU_IR_NBIT => CU_IR_NBIT
    )
    port map(
      CU_instruction_register => CU_IR,
      CU_decode_signed_ext    => s_decode_signed_ext,
      CU_decode_dest_sel      => s_decode_dest_sel,
      CU_decode_read1_en      => s_decode_read1_en,
      CU_decode_read2_en      => s_decode_read2_en,
      CU_execute_branch_type  => s_execute_branch_type,
      CU_execute_alu_op       => s_execute_alu_op,
      CU_execute_top_mux      => s_execute_top_mux,
      CU_execute_bottom_mux   => s_execute_bottom_mux,
      CU_execute_is_branch    => s_execute_is_branch,
      CU_memory_r_not_w       => s_memory_r_not_w,
      CU_memory_signed_load   => s_memory_signed_load,
      CU_memory_load_type     => s_memory_load_type,
      CU_writeback_write_en   => s_writeback_write_en,
      CU_writeback_mux        => s_writeback_mux
    );

  EX : d_register
    generic map(
      REG_NBIT => 16
    ) port map(
      REG_clk => CU_CLK,
      REG_rst => CU_RST,
      REG_clr => '0',
      REG_enable => '1',
      REG_data_in => s_exmemwb,
      REG_data_out => ps_exmemwb
    );

  MEM : d_register
    generic map(
      REG_NBIT => 7
    )
    port map(
      REG_clk      => CU_CLK,
      REG_rst      => CU_RST,
      REG_clr      => '0',
      REG_enable   => '1',
      REG_data_in  => s_memwb,
      REG_data_out => ps_memwb
    );

  WB : d_register
    generic map(
      REG_NBIT => 3
    )
    port map(
      REG_clk      => CU_CLK,
      REG_rst      => CU_RST,
      REG_clr      => '0',
      REG_enable   => '1',
      REG_data_in  => s_wb,
      REG_data_out => ps_wb
    );

  FW_UNIT : forwarding_unit
    generic map(
      FW_IR_NBIT => CU_IR_NBIT
    )
    port map(
      FW_IDEX_IR  => CU_IDEX_IR,
      FW_EXMEM_IR => CU_EXMEM_IR,
      FW_MEMWB_IR => CU_MEMWB_IR,
      FW_TOP_ALU  => CU_EX_FW_TOP_MUX,
      FW_BOT_ALU  => CU_EX_FW_BOT_MUX
    );

  CU_MEM : component cu_memory
    port map(
      ROM_DATA_READY  => CU_ROM_DATA_READY,
      DRAM_DATA_READY => CU_DRAM_DATA_READY,
      ROM_EN          => CU_ROM_EN,
      DRAM_EN         => CU_DRAM_EN,
      IFID_CLR        => CU_IFID_CLR,
      IFID_EN         => CU_IFID_EN,
      IDEX_CLR        => CU_IDEX_CLR,
      IDEX_EN         => CU_IDEX_EN,
      EXMEM_CLR       => CU_EXMEM_CLR,
      EXMEM_EN        => CU_EXMEM_EN,
      MEMWB_CLR       => CU_MEMWB_CLR,
      MEMWB_EN        => CU_MEMWB_EN
    );

  s_idexmemwb(22 downto 21) <= s_decode_signed_ext;
  s_idexmemwb(20 downto 19) <= s_decode_dest_sel;
  s_idexmemwb(18)           <= s_decode_read1_en;
  s_idexmemwb(17)           <= s_decode_read2_en;
  s_idexmemwb(16)           <= s_execute_branch_type;
  s_idexmemwb(15 downto 10) <= s_execute_alu_op;
  s_idexmemwb(9)            <= s_execute_top_mux;
  s_idexmemwb(8)            <= s_execute_bottom_mux;
  s_idexmemwb(7)            <= s_execute_is_branch;
  s_idexmemwb(6)            <= s_memory_r_not_w;
  s_idexmemwb(5)            <= s_memory_signed_load;
  s_idexmemwb(4 downto 3)   <= s_memory_load_type;
  s_idexmemwb(2)            <= s_writeback_write_en;
  s_idexmemwb(1 downto 0)   <= s_writeback_mux; --

  s_memwb <= ps_exmemwb(6 downto 0);

  s_wb <= ps_memwb(2 downto 0);

  s_exmemwb <= s_idexmemwb(16 downto 0);

  CU_ID_sigext_op       <= s_idexmemwb(22 downto 21);
  CU_ID_destination_sel <= s_idexmemwb(20 downto 19);
  CU_ID_read1_en        <= s_idexmemwb(18);
  CU_ID_read2_en        <= s_idexmemwb(17);
  CU_EX_BRANCH_TYPE     <= ps_exmemwb(16);
  CU_EX_ALU_CONTROL     <= ps_exmemwb(15 downto 10);
  CU_EX_TOP_MUX         <= ps_exmemwb(9);
  CU_EX_BOT_MUX         <= ps_exmemwb(8);
  CU_EX_IS_BRANCH       <= ps_exmemwb(7);
  CU_MEM_READNOTWRITE   <= ps_memwb(6);
  CU_MEM_SIGNED_LOAD    <= ps_memwb(5);
  CU_MEM_LOAD_TYPE      <= ps_memwb(4 downto 3);
  CU_ID_rf_write_en     <= ps_wb(2);
  CU_WB_MUX_CONTROL     <= ps_wb(1 downto 0);

  CU_IF_PC_EN  <= '1';
  CU_IF_PC_CLR <= '0';

end architecture STR;

configuration CFG_CU_STR of CU is
  for STR
    
  end for;
end configuration CFG_CU_STR;

