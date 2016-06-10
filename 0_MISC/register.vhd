library ieee;
use ieee.std_logic_1164.all;

entity REGISTER is
	generic(
		RGS_NBIT: integer := 4
	);
	port(
		RGS_D	 :	in	std_logic_vector(RGS_NBIT-1 downto 0);
    RGS_EN :  in  std_logic;  --! Active high
		CLK 	 :	in	std_logic;
		RST 	 :	in	std_logic;
		RGS_Q	 :	out	std_logic_vector(RGS_NBIT-1 downto 0)
	);
end REGISTER;

architecture BHV of REGISTER is
begin
	process(CLK)
	begin
    if(CLK'event and CLK = '1') then
      if(RST = '1') then
        RGS_Q <= (others => '0');
      else
        if(RGS_EN = '1') then
          RGS_Q <= RGS_D;
        end if;
      end if;
    end if;
	end process;
end BHV;


configuration CFG_REGISTER_BHV of REGISTER is
	for BHV
	end for;
end CFG_REGISTER_BHV;
