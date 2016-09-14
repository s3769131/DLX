library ieee;
use ieee.std_logic_1164.all;

package CU_pkg is
  constant CU_OPCODE_NBIT : positive := 6;
  constant CU_FUNC_NBIT   : positive := 6;

  constant CU_ALU_OPCODE : std_logic_vector(8-1 downto 0) := (others => '0');

  ---------------------------------------------------------------------------------------------
  --                                  GENERAL INSTRUCTION
  --              mnemonic                                                    coding (opcode)
  ---------------------------------------------------------------------------------------------
  constant dlx_j     : std_logic_vector(8 - 1 downto 0) := x"02";
  constant dlx_jal   : std_logic_vector(8 - 1 downto 0) := x"03";
  constant dlx_beqz  : std_logic_vector(8 - 1 downto 0) := x"04";
  constant dlx_bnez  : std_logic_vector(8 - 1 downto 0) := x"05";
  constant dlx_bfpt  : std_logic_vector(8 - 1 downto 0) := x"06";
  constant dlx_bfpf  : std_logic_vector(8 - 1 downto 0) := x"07";
  constant dlx_addi  : std_logic_vector(8 - 1 downto 0) := x"08";
  constant dlx_addui : std_logic_vector(8 - 1 downto 0) := x"09";
  constant dlx_subi  : std_logic_vector(8 - 1 downto 0) := x"0a";
  constant dlx_subui : std_logic_vector(8 - 1 downto 0) := x"0b";
  constant dlx_andi  : std_logic_vector(8 - 1 downto 0) := x"0c";
  constant dlx_ori   : std_logic_vector(8 - 1 downto 0) := x"0d";
  constant dlx_xori  : std_logic_vector(8 - 1 downto 0) := x"0e";
  constant dlx_lhi   : std_logic_vector(8 - 1 downto 0) := x"0f";
  constant dlx_rfe   : std_logic_vector(8 - 1 downto 0) := x"10";
  constant dlx_trap  : std_logic_vector(8 - 1 downto 0) := x"11";
  constant dlx_jr    : std_logic_vector(8 - 1 downto 0) := x"12";
  constant dlx_jalr  : std_logic_vector(8 - 1 downto 0) := x"13";
  constant dlx_slli  : std_logic_vector(8 - 1 downto 0) := x"14";
  constant dlx_nop   : std_logic_vector(8 - 1 downto 0) := x"15";
  constant dlx_srli  : std_logic_vector(8 - 1 downto 0) := x"16";
  constant dlx_srai  : std_logic_vector(8 - 1 downto 0) := x"17";
  constant dlx_seqi  : std_logic_vector(8 - 1 downto 0) := x"18";
  constant dlx_snei  : std_logic_vector(8 - 1 downto 0) := x"19";
  constant dlx_slti  : std_logic_vector(8 - 1 downto 0) := x"1a";
  constant dlx_sgti  : std_logic_vector(8 - 1 downto 0) := x"1b";
  constant dlx_slei  : std_logic_vector(8 - 1 downto 0) := x"1c";
  constant dlx_sgei  : std_logic_vector(8 - 1 downto 0) := x"1d";
  constant dlx_lb    : std_logic_vector(8 - 1 downto 0) := x"20";
  constant dlx_lh    : std_logic_vector(8 - 1 downto 0) := x"21";
  constant dlx_lw    : std_logic_vector(8 - 1 downto 0) := x"23";
  constant dlx_lbu   : std_logic_vector(8 - 1 downto 0) := x"24";
  constant dlx_lhu   : std_logic_vector(8 - 1 downto 0) := x"25";
  constant dlx_lf    : std_logic_vector(8 - 1 downto 0) := x"26";
  constant dlx_ld    : std_logic_vector(8 - 1 downto 0) := x"27";
  constant dlx_sb    : std_logic_vector(8 - 1 downto 0) := x"28";
  constant dlx_sh    : std_logic_vector(8 - 1 downto 0) := x"29";
  constant dlx_sw    : std_logic_vector(8 - 1 downto 0) := x"2b";
  constant dlx_sf    : std_logic_vector(8 - 1 downto 0) := x"2e";
  constant dlx_sd    : std_logic_vector(8 - 1 downto 0) := x"2f";
  constant dlx_itlb  : std_logic_vector(8 - 1 downto 0) := x"38";
  constant dlx_sltui : std_logic_vector(8 - 1 downto 0) := x"3a";
  constant dlx_sgtui : std_logic_vector(8 - 1 downto 0) := x"3b";
  constant dlx_sleui : std_logic_vector(8 - 1 downto 0) := x"3c";
  constant dlx_sgeui : std_logic_vector(8 - 1 downto 0) := x"3d";

  ---------------------------------------------------------------------------------------------
  --  REGISTER-REGISTER INSTRUCTION
  --              mnemonic                                                coding (func)
  ---------------------------------------------------------------------------------------------
  constant dlx_sll     : std_logic_vector(8 - 1 downto 0) := x"04";
  constant dlx_srl     : std_logic_vector(8 - 1 downto 0) := x"06";
  constant dlx_sra     : std_logic_vector(8 - 1 downto 0) := x"07";
  constant dlx_add     : std_logic_vector(8 - 1 downto 0) := x"20";
  constant dlx_addu    : std_logic_vector(8 - 1 downto 0) := x"21";
  constant dlx_sub     : std_logic_vector(8 - 1 downto 0) := x"22";
  constant dlx_subu    : std_logic_vector(8 - 1 downto 0) := x"23";
  constant dlx_and     : std_logic_vector(8 - 1 downto 0) := x"24";
  constant dlx_or      : std_logic_vector(8 - 1 downto 0) := x"25";
  constant dlx_xor     : std_logic_vector(8 - 1 downto 0) := x"26";
  constant dlx_seq     : std_logic_vector(8 - 1 downto 0) := x"28";
  constant dlx_sne     : std_logic_vector(8 - 1 downto 0) := x"29";
  constant dlx_slt     : std_logic_vector(8 - 1 downto 0) := x"2a";
  constant dlx_sgt     : std_logic_vector(8 - 1 downto 0) := x"2b";
  constant dlx_sle     : std_logic_vector(8 - 1 downto 0) := x"2c";
  constant dlx_sge     : std_logic_vector(8 - 1 downto 0) := x"2d";
  constant dlx_movi2s  : std_logic_vector(8 - 1 downto 0) := x"30";
  constant dlx_movs2i  : std_logic_vector(8 - 1 downto 0) := x"31";
  constant dlx_movf    : std_logic_vector(8 - 1 downto 0) := x"32";
  constant dlx_movd    : std_logic_vector(8 - 1 downto 0) := x"33";
  constant dlx_movfp2i : std_logic_vector(8 - 1 downto 0) := x"34";
  constant dlx_movi2fp : std_logic_vector(8 - 1 downto 0) := x"35";
  constant dlx_movi2t  : std_logic_vector(8 - 1 downto 0) := x"36";
  constant dlx_movt2i  : std_logic_vector(8 - 1 downto 0) := x"37";
  constant dlx_sltu    : std_logic_vector(8 - 1 downto 0) := x"3a";
  constant dlx_sgtu    : std_logic_vector(8 - 1 downto 0) := x"3b";
  constant dlx_sleu    : std_logic_vector(8 - 1 downto 0) := x"3c";
  constant dlx_sgeu    : std_logic_vector(8 - 1 downto 0) := x"3d";

  ----
  --  INSTRUCTION TYPE
  ----
  -- 00 : Reg-Reg
  -- 01 : Load/Store
  -- 10 : Immediate
  -- 11 : Branch/Jump
  constant IT_REG_REG : std_logic_vector(1 downto 0) := "00";
  constant IT_LD_ST  : std_logic_vector(1 downto 0) := "01";
  constant IT_IMM    : std_logic_vector(1 downto 0) := "10";
  constant IT_BR_J   : std_logic_vector(1 downto 0) := "11";

end CU_pkg;

package body CU_pkg is
end CU_pkg;
