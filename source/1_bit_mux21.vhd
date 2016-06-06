--------------------------------------------------------------------------------
--! @file
--! @brief Mux 2-1 with a single bit for inputs and output
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
--! Include standard package
use ieee.std_logic_1164.all;

--! @brief Mux 2-1 with a single bit for inputs and output
entity BIT_MUX21 is
	port(
		PORT_0   : in  std_logic;       --! Input port0
		PORT_1   : in  std_logic;       --! Input port1
		SEL      : in  std_logic;       --! Selection
		PORT_OUT : out std_logic
	);                                  --! Output port
end entity BIT_MUX21;

--! @brief Behavioural description of the mux with a 
--!        process sensitive to data inputs and selection signal
architecture BHV of BIT_MUX21 is
begin
	MAIN : process(PORT_0, PORT_1, SEL)
	begin
		if (SEL = '0') then
			PORT_OUT <= PORT_0;
		else
			if (SEL = '1') then
				PORT_OUT <= PORT_1;
			end if;
		end if;
	end process;
end architecture BHV;