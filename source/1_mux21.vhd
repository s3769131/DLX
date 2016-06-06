--------------------------------------------------------------------------------
--! @file
--! @brief Mux 2-1 with a generic number of bits for inputs and output
--------------------------------------------------------------------------------

--! Use standard IEEE library
library ieee;
  --! Include standard package
  use ieee.std_logic_1164.all;

--! @brief Mux 2-1 with a generic number of bits for inputs and output
entity MUX21 is 
  generic ( MUX21_N : integer := 32);        --! Width of input and output ports
  port    ( PORT_0   : in  std_logic_vector(MUX21_N-1 downto 0); --! Input port0
            PORT_1   : in  std_logic_vector(MUX21_N-1 downto 0); --! Input port1
            SEL      : in  std_logic;                            --! Selection
            PORT_OUT : out std_logic_vector(MUX21_N-1 downto 0));--! Output port
end entity MUX21;

--! @brief Behavioural description of the mux with a 
--!        process sensitive to data inputs and selection signal
architecture BHV of MUX21 is
  begin
  MAIN : process (PORT_0, PORT_1, SEL)
    begin
      if (SEL = '0') then
        PORT_OUT <= PORT_0;
      else if (SEL = '1') then 
        PORT_OUT <= PORT_1;
        end if;
      end if;
   end process;
end architecture BHV;