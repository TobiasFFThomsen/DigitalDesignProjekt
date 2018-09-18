-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
-- 		       :
--  Purpose    :  This is a FSMD (finite state machine with datapath) 
--             :  implementation the GCD circuit
--             :
--  Revision   :  02203 fall 2017 v.4
--
-- -----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY gcd IS
    PORT (clk:   IN std_logic;				   -- The clock signal.
          reset: IN std_logic;				   -- Reset the module.
          req:   IN std_logic;				   -- Input operand / Start computation.
          AB:    IN unsigned(15 downto 0);	-- The two operands.
          ack:   OUT std_logic;				   -- Computation is complete.
          C:     OUT unsigned(15 downto 0));	-- The result.
END gcd;

ARCHITECTURE FSMD OF gcd IS

TYPE state_type IS ( ... ); -- Input your own state names

SIGNAL reg_a,next_reg_a,next_reg_b,reg_b : unsigned(15 downto 0);

SIGNAL state, next_state : state_type;


BEGIN

-- Combinatoriel logic

CL: PROCESS (req,AB,state,reg_a,reg_b,reset)
BEGIN

   CASE (state) IS

			...< Combinatorical body > ...

   END CASE;
END PROCESS CL;

-- Registers

seq: PROCESS (clk, reset)
BEGIN

	...< Register body >...

END PROCESS seq;


END FSMD;
