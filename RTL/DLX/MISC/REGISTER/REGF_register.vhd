library ieee;
use ieee.std_logic_1164.all;

entity REGF_register is
    generic(
        REG_NBIT    :   integer :=  8);
    port(
        REG_clk         :   in  std_logic;
        REG_rst         :   in  std_logic;
        REG_enable      :   in  std_logic;
        REG_data_in     :   in  std_logic_vector(REG_NBIT-1 downto 0);
        REG_data_out    :   out std_logic_vector(REG_NBIT-1 downto 0));
end REGF_register;

architecture bhv of REGF_register is
    signal s_storage    :   std_logic_vector(REG_NBIT-1 downto 0);
begin

    MAIN : process(REG_clk)
    begin
        if REG_clk = '1' and REG_clk'event then
            if REG_rst = '0' then
                s_storage   <=  (others => '0');
            else
                if REG_enable = '1' then
                    s_storage   <=  REG_data_in;
                end if;
            end if;
        end if;
    end process;
    REG_data_out    <=  s_storage;
end bhv;

configuration CFG_REGF_REGISTER_BHV of REGF_register is
    for bhv
    end for;
end CFG_REGF_REGISTER_BHV;
