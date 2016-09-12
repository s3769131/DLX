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
        constant    j       :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x02";
        constant    jal     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x03";
        constant    beqz    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x04";
        constant    bnez    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x05";
        constant    bfpt    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x06";
        constant    bfpf    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x07";
        constant    addi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x08";
        constant    addui   :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x09";
        constant    subi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0a";
        constant    subui   :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0b";
        constant    andi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0c";
        constant    ori     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0d";
        constant    xori    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0e";
        constant    lhi     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x0f";
        constant    rfe     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x10";
        constant    trap    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x11";
        constant    jr      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x12";
        constant    jalr    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x13";
        constant    slli    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x14";
        constant    nop     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x15";
        constant    srli    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x16";
        constant    srai    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x17";
        constant    seqi    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x18";
        constant    snei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x19";
        constant    slti    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1a";
        constant    sgti    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1b";
        constant    slei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1c";
        constant    sgei    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x1d";
        constant    lb      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x20";
        constant    lh      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x21";
        constant    lw      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x23";
        constant    lbu     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x24";
        constant    lhu     :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x25";
        constant    lf      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x26";
        constant    ld      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x27";
        constant    sb      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x28";
        constant    sh      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x29";
        constant    sw      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2b";
        constant    sf      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2e";
        constant    sd      :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x2f";
        constant    itlb    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x38";
        constant    sltu    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3a";
        constant    sgtu    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3b";
        constant    sleu    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3c";
        constant    sgeu    :   std_logic_vector(CU_OPCODE_NBIT-1 downto 0)    :=  x"0x3d";

    ---------------------------------------------------------------------------------------------
    --  REGISTER-REGISTER INSTRUCTION
    --              mnemonic                                                coding (func)
    ---------------------------------------------------------------------------------------------
        constant    sll     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x04";
        constant    srl     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x06";
        constant    sra     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x07";
        constant    add     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x20";
        constant    addu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x21";
        constant    sub     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x22";
        constant    subu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x23";
        constant    and     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x24";
        constant    or      :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x25";
        constant    xor     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x26";
        constant    seq     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x28";
        constant    sne     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x29";
        constant    slt     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2a";
        constant    sgt     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2b";
        constant    sle     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2c";
        constant    sge     :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x2d";
        constant    movi2s  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x30";
        constant    movs2i  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x31";
        constant    movf    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x32";
        constant    movd    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x33";
        constant    movfp2i :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x34";
        constant    movi2fp :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x35";
        constant    movi2t  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x36";
        constant    movt2i  :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x37";
        constant    sltu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3a";
        constant    sgtu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3b";
        constant    sleu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3c";
        constant    sgeu    :   std_logic_vector(CU_FUNC_NBIT-1 downto 0)   :=  x"0x3d";

end CU_pkg;

package body CU_pkg is
end CU_pkg;
