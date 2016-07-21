library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   left-right shifter.
--!
--!   This entity models a shifter, able to shift a given operand of a variable amount of position, both left
--!   and right, both in a logical and in an arithmetic way. The architecture is inspired by the one of the
--!   shifter implemented in the Niagara T2 processor.
entity ALU_shifter is
   generic(
      ALU_SHIFTER_NBIT  :  integer  := 32);
   port(
      ALU_SHIFTER_operand     :  in    std_logic_vector(ALU_SHIFTER_NBIT-1 downto 0);
      ALU_SHIFTER_n_shift     :  in    std_logic_vector(log2ceil(ALU_SHIFTER_NBIT)-1 downto 0);
      ALU_SHIFTER_left_right  :  in    std_logic;
      ALU_SHIFTER_logic_arith :  in    std_logic;
      ALU_SHIFTER_result      :  out   std_logic_vector(ALU_SHIFTER_NBIT-1 downto 0));
end ALU_shifter;

architecture str of ALU_shifter is

   component SHF_mask_generator is
      generic(
         SHF_MG_NBIT   :  integer  := 32;
         SHF_MG_GRAN   :  integer  := 4);
      port(
         SHF_MG_operand       :  in    std_logic_vector(SHF_MG_NBIT-1 downto 0);
         SHF_MG_left_right    :  in    std_logic;
         SHF_MG_logic_arith   :  in    std_logic;
         SHF_MG_masks_out     :  out   std_logic_vector((SHF_MG_NBIT/SHF_MG_GRAN)*(SHF_MG_NBIT+SHF_MG_GRAN)-1 downto 0)
      );
   end component;

   component SHF_mask_selector is
      generic(
         SHF_MS_NBIT   :  integer  := 32;
         SHF_MS_GRAN   :  integer  := 4);
      port(
         SHF_MS_masks_in   :  in    std_logic_vector((SHF_MS_NBIT/SHF_MS_GRAN)*(SHF_MS_NBIT+SHF_MS_GRAN)-1 downto 0);
         SHF_MS_addr       :  in    std_logic_vector(log2ceil(SHF_MS_NBIT/SHF_MS_GRAN)-1 downto 0);
         SHF_MS_mask_out   :  out   std_logic_vector(SHF_MS_NBIT+SHF_MS_GRAN-1 downto 0));
   end component;

   component SHF_finegrain_shift is
      generic(
         SHF_FS_NBIT   :  integer  := 32;
         SHF_FS_GRAN   :  integer  := 4);
      port(
         SHF_FS_mask :  in    std_logic_vector(SHF_FS_NBIT+SHF_FS_GRAN-1 downto 0);
         SHF_FS_lr   :  in    std_logic;
         SHF_FS_sel  :  in    std_logic_vector(log2ceil(SHF_FS_GRAN)-1 downto 0);
         SHF_FS_res  :  out   std_logic_vector(SHF_FS_NBIT-1 downto 0));
   end component;

   constant SHIFTER_GRAN         :  integer  := 2**divide2(log2ceil(ALU_SHIFTER_NBIT));
   constant MASK_LEN             :  integer  := ALU_SHIFTER_NBIT+SHIFTER_GRAN;
   constant N_MASK               :  integer  := ALU_SHIFTER_NBIT/SHIFTER_GRAN;
   constant FINEGRAIN_SHIFT_NBIT :  integer  := log2ceil(SHIFTER_GRAN);
   constant COARSE_SHIFT_NBIT    :  integer  := log2ceil(ALU_SHIFTER_NBIT)-FINEGRAIN_SHIFT_NBIT;

   signal s_generated_masks   :  std_logic_vector(N_MASK*MASK_LEN-1 downto 0);
   signal s_selected_mask     :  std_logic_vector(MASK_LEN-1 downto 0);

begin

   MASK_GENERATOR_GEN : SHF_mask_generator
      generic map(
         SHF_MG_NBIT => ALU_SHIFTER_NBIT,
         SHF_MG_GRAN => SHIFTER_GRAN)
      port map(
         SHF_MG_operand       => ALU_SHIFTER_operand,
         SHF_MG_left_right    => ALU_SHIFTER_left_right,
         SHF_MG_logic_arith   => ALU_SHIFTER_logic_arith,
         SHF_MG_masks_out     => s_generated_masks);

   MASK_SELECTOR_GEN : SHF_mask_selector
      generic map(
         SHF_MS_NBIT => ALU_SHIFTER_NBIT,
         SHF_MS_GRAN => SHIFTER_GRAN)
      port map(
         SHF_MS_masks_in   => s_generated_masks,
         SHF_MS_addr       => ALU_SHIFTER_n_shift(log2ceil(ALU_SHIFTER_NBIT)-1 downto FINEGRAIN_SHIFT_NBIT),
         SHF_MS_mask_out   => s_selected_mask);

   FINEGRAIN_SHIFT_GEN : SHF_finegrain_shift
      generic map(
         SHF_FS_NBIT => ALU_SHIFTER_NBIT,
         SHF_FS_GRAN => SHIFTER_GRAN)
      port map(
         SHF_FS_mask => s_selected_mask,
         SHF_FS_lr   => ALU_SHIFTER_left_right,
         SHF_FS_sel  => ALU_SHIFTER_n_shift(FINEGRAIN_SHIFT_NBIT-1 downto 0),
         SHF_FS_res  => ALU_SHIFTER_result);

end str;

configuration CFG_ALU_SHIFTER_STR of ALU_shifter is
   for str
      for MASK_GENERATOR_GEN : SHF_mask_generator
         use configuration work.CFG_SHF_MASK_GENERATOR_STR;
      end for;
      for MASK_SELECTOR_GEN : SHF_mask_selector
         use configuration work.CFG_SHF_MASK_SELECTOR_DFLOW;
      end for;
      for FINEGRAIN_SHIFT_GEN : SHF_finegrain_shift
         use configuration work.CFG_FINEGRAIN_SHIFT_BHV;
      end for;
   end for;
end configuration CFG_ALU_SHIFTER_STR;
