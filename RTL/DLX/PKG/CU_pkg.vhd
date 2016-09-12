library ieee;
use ieee.std_logic_1164.all;

package CU_pkg is

        constant    CU_OPCODE_NBIT  :   positive    :=  6;
        constant    CU_FUNC_NBIT    :   positive    :=  6;

        constant    CU_ALU_OPCODE   :   std_logic_vector    :=  (others => '0');

    ---------------------------------------------------------------------------------------------
    --                                  GENERAL INSTRUCTION
    --              mnemonic                                                    coding (opcode)
    ---------------------------------------------------------------------------------------------
        constant    dlx_j       :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x02";
        constant    dlx_jal     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x03";
        constant    dlx_beqz    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x04";
        constant    dlx_bnez    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x05";
        constant    dlx_bfpt    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x06";
        constant    dlx_bfpf    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x07";
        constant    dlx_addi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x08";
        constant    dlx_addui   :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x09";
        constant    dlx_subi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0a";
        constant    dlx_subui   :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0b";
        constant    dlx_andi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0c";
        constant    dlx_ori     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0d";
        constant    dlx_xori    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0e";
        constant    dlx_lhi     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0f";
        constant    dlx_rfe     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x10";
        constant    dlx_trap    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x11";
        constant    dlx_jr      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x12";
        constant    dlx_jalr    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x13";
        constant    dlx_slli    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x14";
        constant    dlx_nop     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x15";
        constant    dlx_srli    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x16";
        constant    dlx_srai    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x17";
        constant    dlx_seqi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x18";
        constant    dlx_snei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x19";
        constant    dlx_slti    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1a";
        constant    dlx_sgti    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1b";
        constant    dlx_slei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1c";
        constant    dlx_sgei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1d";
        constant    dlx_lb      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x20";
        constant    dlx_lh      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x21";
        constant    dlx_lw      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x23";
        constant    dlx_lbu     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x24";
        constant    dlx_lhu     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x25";
        constant    dlx_lf      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x26";
        constant    dlx_ld      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x27";
        constant    dlx_sb      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x28";
        constant    dlx_sh      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x29";
        constant    dlx_sw      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2b";
        constant    dlx_sf      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2e";
        constant    dlx_sd      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2f";
        constant    dlx_itlb    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x38";
        constant    dlx_sltui    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3a";
        constant    dlx_sgtui    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3b";
        constant    dlx_sleui    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3c";
        constant    dlx_sgeui    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3d";

    ---------------------------------------------------------------------------------------------
    --  REGISTER-REGISTER INSTRUCTION
    --              mnemonic                                                coding (func)
    ---------------------------------------------------------------------------------------------
        constant    dlx_sll     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x04";
        constant    dlx_srl     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x06";
        constant    dlx_sra     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x07";
        constant    dlx_add     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x20";
        constant    dlx_addu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x21";
        constant    dlx_sub     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x22";
        constant    dlx_subu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x23";
        constant    dlx_and     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x24";
        constant    dlx_or      :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x25";
        constant    dlx_xor     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x26";
        constant    dlx_seq     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x28";
        constant    dlx_sne     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x29";
        constant    dlx_slt     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2a";
        constant    dlx_sgt     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2b";
        constant    dlx_sle     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2c";
        constant    dlx_sge     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2d";
        constant    dlx_movi2s  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x30";
        constant    dlx_movs2i  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x31";
        constant    dlx_movf    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x32";
        constant    dlx_movd    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x33";
        constant    dlx_movfp2i :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x34";
        constant    dlx_movi2fp :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x35";
        constant    dlx_movi2t  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x36";
        constant    dlx_movt2i  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x37";
        constant    dlx_sltu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3a";
        constant    dlx_sgtu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3b";
        constant    dlx_sleu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3c";
        constant    dlx_sgeu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3d";

end CU_pkg;

package body CU_pkg is
end CU_pkg;
