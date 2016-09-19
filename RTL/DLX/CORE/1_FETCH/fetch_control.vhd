library ieee;
use ieee.std_logic_1164.all;
use work.CU_pkg.all;
use work.FETCH_pkg.all;

entity fetch_control is
  generic(
    FETCH_CTRL_IR_NBIT : integer := 32); --  instruction register bit length
  port(
    FETCH_CTRL_ir       : in  std_logic_vector(FETCH_CTRL_IR_NBIT - 1 downto 0); --  instruction register from cache
    FETCH_CTRL_btb_pred : in  std_logic; --  taken/not taken btb prediction
    FETCH_CTRL_err_pred : in  std_logic; --  set if ALU detects a branch misprediction
    FETCH_CTRL_out      : out std_logic_vector(1 downto 0)); --  choose proper source for program counter
end entity fetch_control;

architecture bhv of fetch_control is
  signal s_use_btb   : std_logic;
  signal s_cu_opcode : std_logic_vector(8 - 1 downto 0);

begin
  s_cu_opcode(7 downto 6) <= (others => '0');
  s_cu_opcode(5 downto 0) <= FETCH_CTRL_ir(31 downto 26);

  DETECT_BRANCH_PROCESS : process(s_cu_opcode)
  begin
    if s_cu_opcode = dlx_j or s_cu_opcode = dlx_jal or s_cu_opcode = dlx_beqz or s_cu_opcode = dlx_bnez or s_cu_opcode = dlx_jr or s_cu_opcode = dlx_jalr then
      s_use_btb <= '1';
    else
      s_use_btb <= '0';
    end if;
  end process;

  MAIN : process(s_use_btb, FETCH_CTRL_btb_pred, FETCH_CTRL_err_pred)
  begin
    if FETCH_CTRL_err_pred = '1' then
      FETCH_CTRL_out <= FETCH_CTRL_SELECT_ALU_OUT;
    elsif FETCH_CTRL_btb_pred = '1' and s_use_btb = '1' then
      FETCH_CTRL_out <= FETCH_CTRL_SELECT_BTB_TARGET;
    else
      FETCH_CTRL_out <= FETCH_CTRL_SELECT_NPC;
    end if;
  end process;

end bhv;

configuration CFG_FETCH_CONTROL_BHV of fetch_control is
  for bhv
  end for;
end CFG_FETCH_CONTROL_BHV;
