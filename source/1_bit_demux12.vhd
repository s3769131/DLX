--------------------------------------------------------------------------------
--! @file
--! @brief Demux 1-2 with a single bit for inputs and output
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
--! Include standard package
use ieee.std_logic_1164.all;

--! @brief Demux 1-2 with a single bit for inputs and output
entity BIT_DEMUX12 is
	port(
		PORT_IN   : in  std_logic;      --! Input port
		SEL       : in  std_logic;      --! Selection
		PORT_OUT0 : out std_logic;      --! Outport0 
		PORT_OUT1 : out std_logic       --! Outport1
	);
end entity BIT_DEMUX12;

--! @brief Behavioural description of the demux with a 
--!        process sensitive to data input and selection signal
architecture BHV of BIT_DEMUX12 is
begin
	MAIN : process(PORT_IN, SEL)
	begin
		if (SEL = '0') then
			PORT_OUT0 <= PORT_IN;
			PORT_OUT1 <= '0';
		else
			if (SEL = '1') then
				PORT_OUT1 <= PORT_IN;
				PORT_OUT0 <= '0';
			end if;
		end if;
	end process;
end architecture BHV;