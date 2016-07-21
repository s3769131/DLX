--------------------------------------------------------------------------------
--! @file
--! @brief Demux 1-2 with a generic number of bits for inputs and output
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
--! Include standard package
use ieee.std_logic_1164.all;

--! @brief Demux 1-2 with a generic number of bits for inputs and output
entity DEMUX12 is
	generic(
		DEMUX_NBIT : integer := 32
	);
	port(
		PORT_IN   : in  std_logic_vector(DEMUX_NBIT-1 downto 0);      --! Input port
		SEL       : in  std_logic;      --! Selection
		PORT_OUT0 : out std_logic_vector(DEMUX_NBIT-1 downto 0);      --! Outport0 
		PORT_OUT1 : out std_logic_vector(DEMUX_NBIT-1 downto 0)       --! Outport1
	);
end entity DEMUX12;

--! @brief Behavioural description of the demux with a 
--!        process sensitive to data input and selection signal
architecture BHV of DEMUX12 is
begin
	MAIN : process(PORT_IN, SEL)
	begin
		if (SEL = '0') then
			PORT_OUT0 <= PORT_IN;
			PORT_OUT1 <= (others  => '0');
		else
			if (SEL = '1') then
				PORT_OUT1 <= PORT_IN;
				PORT_OUT0 <= (others  => '0');
			end if;
		end if;
	end process;
end architecture BHV;