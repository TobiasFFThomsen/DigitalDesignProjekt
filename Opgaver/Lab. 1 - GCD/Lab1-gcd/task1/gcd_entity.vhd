-- -----------------------------------------------------------------------------
--
--  Title      :  Specification of GCD entity
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--             :
--  Purpose    :  Entity of the GCD module
--             :
--  Revision   :  02203 fall 2017 v.5.0
--
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- The GCD-module computes the greatest common divisor of two integers
-- The module behaves as an SLT-module with handshake signals "req" and "ack".
-- "req" and "ack" follow a 4-phase fully interlocked handshake protocol.
--
-- A computation involves two handshakes.
--   (1) During the first handshake the operand A is input.
--   (2) During the second the B operand is input, the computation is performed and
--       the result C is output.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY GCD_sys IS
    PORT (clk:         IN std_logic;           -- The clock signal.
          reset:       IN std_logic;           -- Reset the module.
          req:         IN std_logic;           -- Input operand / Start computation..
          AB:          IN unsigned(15 downto 0);
                                               -- The two operands. One at at time.
          ack:         OUT std_logic;          -- Computation is complete.
          C:           OUT unsigned(15 downto 0));    -- The result.
END GCD_sys;
