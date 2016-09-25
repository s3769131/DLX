library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.CU_pkg.all;

entity TB_forwarding_unit is
end entity TB_forwarding_unit;

architecture TEST of TB_forwarding_unit is

    component forwarding_unit is
        generic(
            FW_IR_NBIT : positive := 32);
        port(
            FW_IDEX_IR  : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
            FW_EXMEM_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
            FW_MEMWB_IR : in  std_logic_vector(FW_IR_NBIT - 1 downto 0);
            FW_TOP_ALU  : out std_logic_vector(1 downto 0);
            FW_BOT_ALU  : out std_logic_vector(1 downto 0));
    end component forwarding_unit;

    constant c_FW_IR_NBIT   :   integer :=  32;

    signal s_IDEX_IR    :   std_logic_vector(c_FW_IR_NBIT-1 downto 0);
    signal s_EXMEM_IR   :   std_logic_vector(c_FW_IR_NBIT-1 downto 0);
    signal s_MEMWB_IR   :   std_logic_vector(c_FW_IR_NBIT-1 downto 0);
    signal s_TOP_ALU    :   std_logic_vector(1 downto 0);
    signal s_BOT_ALU    :   std_logic_vector(1 downto 0);

begin

    UUT : forwarding_unit
        generic map(
            FW_IR_NBIT  =>  32)
        port map(
            FW_IDEX_IR  =>  s_IDEX_IR,
            FW_EXMEM_IR =>  s_EXMEM_IR,
            FW_MEMWB_IR =>  s_MEMWB_IR,
            FW_TOP_ALU  =>  s_TOP_ALU,
            FW_BOT_ALU  =>  s_BOT_ALU);

    TEST_PROCESS : process
    begin
        s_IDEX_IR   <=  x"00A43820";
        s_EXMEM_IR  <=  x"0062302A";
        s_MEMWB_IR  <=  x"8C250004";
        wait;
    end process;

end architecture TEST;
