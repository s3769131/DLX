
--! \author    Emanuele Parisi
--! \version   1.0
--! \date      2 Jun 2016
--! \copyright GNU Public License.
--! \brief     A package for some usefull functions, used in REGF_register_file entity.
--!
--! In this package are stored some definitions and functions usefull in the REGF_register_file definition.
library ieee;
use ieee.std_logic_1164.all;

package DLX_pkg is
    function log2ceil (constant n : in integer) return integer;
    type bus_array is array(natural range <>, natural range <>) of std_logic;
end DLX_pkg;

package body DLX_pkg is

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
end DLX_pkg;
