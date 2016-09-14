library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CU_pkg.all;

-- 00 : Reg-Reg
-- 01 : Load/Store
-- 10 : Immediate
-- 11 : Branch/Jump

entity instruction_type_decoder is
  generic(
    ITD_IR_NBIT : positive := 32
  );
  port(
    ITD_IR : in  std_logic_vector(ITD_IR_NBIT - 1 downto 0);
    ITD_IT : out std_logic_vector(1 downto 0)
  );
end entity instruction_type_decoder;

architecture BHV of instruction_type_decoder is
  signal s_cu_opcode : std_logic_vector(8 - 1 downto 0);

begin
  s_cu_opcode(7 downto 6) <= (others => '0');
  s_cu_opcode(5 downto 0) <= ITD_IR(ITD_IR_NBIT - 1 downto ITD_IR_NBIT - CU_OPCODE_NBIT);

  decode : process(s_cu_opcode) is
  begin
    case (s_cu_opcode) is
      when CU_ALU_OPCODE =>
        ITD_IT <= IT_REG_REG;

      when dlx_addi | dlx_addui | dlx_subi | dlx_subui | dlx_andi | dlx_ori | dlx_xori | dlx_lhi | dlx_slli | dlx_nop | dlx_srli | dlx_srai | dlx_seqi | dlx_snei | dlx_slti | dlx_sgti | dlx_slei | dlx_sgei | dlx_sltui | dlx_sgtui | dlx_sleui | dlx_sgeui =>
        ITD_IT <= IT_IMM;

      when dlx_lb | dlx_lh | dlx_lw | dlx_lbu | dlx_lhu | dlx_lf | dlx_ld | dlx_sb | dlx_sh | dlx_sw | dlx_sf | dlx_sd =>
        ITD_IT <= IT_LD_ST;

      when dlx_j | dlx_jal | dlx_beqz | dlx_bnez | dlx_jr | dlx_jalr =>
        ITD_IT <= IT_BR_J;

      when others =>
        ITD_IT <= "00";

    end case;

  end process decode;

end architecture BHV;

configuration CFG_INSTRUCTION_TYPE_DECODER_BHV of INSTRUCTION_TYPE_DECODER is
  for BHV
  end for;
end configuration CFG_INSTRUCTION_TYPE_DECODER_BHV;


