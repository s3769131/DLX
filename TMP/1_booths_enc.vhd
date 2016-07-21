library ieee;
use ieee.std_logic_1164.all;

entity booths_enc is
  port (
    in_value : in  std_logic_vector(2 downto 0);
    out_value: out std_logic_vector(2 downto 0));
end entity;

-- in_value = B_(i+1)  B_i  B_(i-1)

architecture BHV of booths_enc is
begin
  ENC: process(in_value)
  begin
    case( in_value ) is

      when "000" =>  out_value <= "000";

      when "001" =>  out_value <= "001";

      when "010" =>  out_value <= "001";

      when "011" =>  out_value <= "011";

      when "100" =>  out_value <= "100";

      when "101" =>  out_value <= "010";

      when "110" =>  out_value <= "010";

      when "111" =>  out_value <= "000";
      
      when others => out_value <= "000";
    
    end case;

  end process;

end architecture;
