
--! \author    Emanuele Parisi
--! \version   1.0
--! \date      2 Jun 2016
--! \copyright GNU Public License.
--! \brief     A package for some usefull functions, used in ALU entity.
--!
--! In this package are stored some definition and functions usefull in the ALU definition.
library ieee;
use ieee.std_logic_1164.all;

package ALU_pkg is
   function log2ceil (constant n : in integer) return integer;
   function divide2  (constant dividend : in integer) return integer;
   function to_int   (constant vett : in std_logic_vector) return integer;
end ALU_pkg;

package body ALU_pkg is

   --! \brief     compute the base two integer logarithm of an integer parameter.
   --!
   --! computes the base two integer logarithm of an integer parameter, using a
   --! standard iterative algorithm.
   --! \param     n value of which the base two logarithm will be computed.
   function log2ceil(constant n : in integer) return integer is
      variable m  :  integer  := 0;    -- variable that will hold the final result.
      variable p  :  integer  := 1;    -- lazy variable for computing the final result.
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
      variable c  :  integer  := 0;
   begin
      MAIN_LOOP : for i in 0 to dividend loop
         if 2*c < dividend then
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
      variable int   :  integer  := 0;
      variable len   :  integer  := vett'length;
   begin
      MAIN_LOOP : for i in 0 to len-1 loop
         if vett(i) = '1' then
            int := int + 2**i;
         end if;
      end loop MAIN_LOOP;
      return int;
   end;

end ALU_pkg;
