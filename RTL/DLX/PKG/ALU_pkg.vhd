
--! \author    Emanuele Parisi
--! \version   1.0
--! \date      2 Jun 2016
--! \copyright GNU Public License.
--! \brief     A package for some usefull functions, used in ALU entity.
--!
--! In this package are stored some definition and functions usefull in the ALU definition.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ALU_pkg is
  type bus_array is array (natural range <>, natural range <>) of std_logic;
  function log2ceil(constant n : in integer) return integer;
  function divide2(constant dividend : in integer) return integer;
  constant ALU_OP_NBIT : positive := 6;

  -------------------------------------------------------------------------------------------------------------
  --                                              ALU OPERATIONS
  --              mnemonic                                                                        code
  -------------------------------------------------------------------------------------------------------------

  constant addition                   : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "010000";
  constant bitwise_and                : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "111000";
  constant bitwise_nand               : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "110111";
  constant bitwise_nor                : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "110001";
  constant bitwise_or                 : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "111110";
  constant bitwise_xnor               : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "111001";
  constant bitwise_xor                : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "110110";
  constant set_equal                  : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100100";
  constant set_not_equal              : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100110";
  constant set_greater_equal_unsigned : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "101000";
  constant set_greater_than_unsigned  : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "101010";
  constant set_less_equal_unsigned    : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100000";
  constant set_greater_equal_signed   : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "101001";
  constant set_greater_than_signed    : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "101011";
  constant set_less_equal_signed      : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100001";
  constant set_less_than_unsigned     : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100010";
  constant set_less_than_signed       : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "100011";
  constant shift_right_logic          : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "000100";
  constant shift_right_arith          : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "000000";
  constant shift_left_logic           : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "001100";
  constant shift_left_arith           : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "001000";
  constant subtraction                : std_logic_vector(ALU_OP_NBIT - 1 downto 0) := "011000";

end ALU_pkg;

package body ALU_pkg is

  --! \brief     compute the base two integer logarithm of an integer parameter.
  --!
  --! computes the base two integer logarithm of an integer parameter, using a
  --! standard iterative algorithm.
  --! \param     n value of which the base two logarithm will be computed.
  function log2ceil(constant n : in integer) return integer is
    variable m : integer := 0;          -- variable that will hold the final result.
    variable p : integer := 1;          -- lazy variable for computing the final result.
  begin
    MAIN_LOOP : for i in 0 to n loop
      if p < n then
        p := p * 2;
        m := m + 1;
      end if;
    end loop MAIN_LOOP;
    return m;
  end;

  --! \brief     computes the division by two of a specified number.
  --!
  --! computes the division among a certain number and two, applying a simple iterative
  --! algorithm. The result is always up-rounded.
  --! \param     dividend value of the number divided by 2.
  function divide2(constant dividend : in integer) return integer is
    variable c : integer := 0;
  begin
    MAIN_LOOP : for i in 0 to dividend loop
      if 2 * c < dividend then
        c := c + 1;
      end if;
    end loop MAIN_LOOP;
    return c;
  end;

  --! \brief     converts std_logic_vector to unsigned integer.
  --!
  --! converts std_logic_vector to unsigned integer, applying a simple iterative algorithm.
  --! \param     vett bits to be converted.
  function to_int(constant vett : in std_logic_vector) return integer is
    variable int : integer := 0;
    variable len : integer := vett'length;
  begin
    --MAIN_LOOP : for i in 0 to len-1 loop
    --   if vett(i) = '1' then
    --      int := int + 2**i;
    --   end if;
    --end loop MAIN_LOOP;
    --return int;
    return to_integer(unsigned(vett));
  end;

end ALU_pkg;
