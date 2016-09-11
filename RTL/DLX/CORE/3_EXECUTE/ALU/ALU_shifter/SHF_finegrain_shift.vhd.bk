library ieee;
use ieee.std_logic_1164.all;
use work.ALU_pkg.all;

--!   \brief   Select the proper bits in the mask received.
--!
--!   This entity models the network that computes the last step of the shift, when only the bits corresponding
--!   to the final result are selected.
entity SHF_finegrain_shift is
   generic(
      SHF_FS_NBIT   :  integer  := 32; --!   parallelism of the operand.
      SHF_FS_GRAN   :  integer  := 4); --!   granularity of shift.
   port(
      SHF_FS_mask :  in    std_logic_vector(SHF_FS_NBIT+SHF_FS_GRAN-1 downto 0);
      SHF_FS_lr   :  in    std_logic;
      SHF_FS_sel  :  in    std_logic_vector(log2ceil(SHF_FS_GRAN)-1 downto 0);
      SHF_FS_res  :  out   std_logic_vector(SHF_FS_NBIT-1 downto 0));
end SHF_finegrain_shift;

architecture bhv of SHF_finegrain_shift is
   constant MASK_LEN :  integer  := SHF_FS_NBIT+SHF_FS_GRAN;
begin

   MAIN : process(SHF_FS_mask, SHF_FS_lr, SHF_FS_sel)
   begin
      if SHF_FS_lr = '0' then
         SHF_FS_res  <= SHF_FS_mask(MASK_LEN-to_int(SHF_FS_sel)-1 downto SHF_FS_GRAN-to_int(SHF_FS_sel));
      elsif SHF_FS_lr = '1' then
         SHF_FS_res  <= SHF_FS_mask(MASK_LEN-SHF_FS_GRAN+to_int(SHF_FS_sel)-1 downto to_int(SHF_FS_sel));
      end if;
   end process;

end bhv;

configuration CFG_FINEGRAIN_SHIFT_BHV of SHF_finegrain_shift is
   for bhv
   end for;
end configuration CFG_FINEGRAIN_SHIFT_BHV;
