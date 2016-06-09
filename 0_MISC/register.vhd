library ieee;
use ieee.std_logic_1164.all;

entity register is
	generic(
		NBIT: integer := 4
	);
	port(
		d	:	in	std_logic_vector(NBIT-1 downto 0);
		ck 	:	in	std_logic;
		reset 	:	in	std_logic;
		q	:	out	std_logic_vector(NBIT-1 downto 0)
	);
end register;

architecture BHV of register is
begin
	process(ck)
	begin
    if(ck'event and ck = '1') then
      if(reset = '1') then
        q <= (others => '0');
      else
        q <= d;
      end if;
    end if;
	end process;
end BHV;


configuration CFG_register_BEH_SYNC of register is
	for BHV
	end for;
end CFG_register_BEH_SYNC;
