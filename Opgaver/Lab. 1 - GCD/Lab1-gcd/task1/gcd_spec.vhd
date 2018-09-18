-- -----------------------------------------------------------------------------
--
--  Title      :  Specification of GCD module
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--             :
--             :
--  Purpose    :  This design is a specification of a module that computes the
--             :  greates common devisor of two positive integers in two's
--             :  complement representation.
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

--LIBRARY IEEE;
--USE IEEE.std_logic_1164.ALL;
--USE IEEE.numeric_std.ALL;
--
--ENTITY GCD_sys IS
--	PORT (clk:         IN std_logic;		-- The clock signal.
--		reset:       IN std_logic;			-- Reset the module.
--		req:         IN std_logic;			-- Start computation.
--		AB:          IN unsigned(15 downto 0);
--											-- The two operands. One at at time.
--		ack:         OUT std_logic;			-- Computation is complete.
--		C:           OUT unsigned(15 downto 0));		-- The result.
-- END GCD_sys;

--------------------------------------------------------------------------------
-- A specification of the GCD module (no indication of an implementation)
--
--    1) Implements the correct handshaking on the interface of the module
--       (including some arbitrary time delays in the handshaking).
--    2) GCD is calculated by an algorithm (variables, zero delay, ...)
--    3) Allows simulation of the entire test bench.
--       (The starting point for the actual design work)
--
------------------------------------------------------------------------------

ARCHITECTURE specification OF GCD_sys IS
BEGIN
    PROCESS
        VARIABLE RegA: unsigned(15 downto 0);
        VARIABLE RegB: unsigned(15 downto 0);
    BEGIN

		ack <= '0';
		C <= (others => 'Z');

		-- And endless loop.
		LOOP
		-- First handshake: Input of A operand

			-- Handshake phase 1.
			WAIT UNTIL req'EVENT AND req = '1';

			-- The operand is stored in the register.
			RegA := AB;

			-- Handshake phase 2.
			ack <= '1' AFTER 15 ns;

			-- Handshake phase 3.
			WAIT UNTIL req'EVENT AND req = '0';

			-- Handshake phase 4. Handshake protocol complete.
			ack <= '0' AFTER 5 ns;

			-- Second handshake: Input of B operand, computation and output of result

			-- Handshake phase 1.
			WAIT UNTIL req'EVENT AND req = '1';

			-- The operand is stored in the register.
			RegB := AB;

			-- The algorithm as presented in the problem text.
			WHILE RegA /= RegB LOOP
				IF RegA > RegB THEN
					RegA := RegA - RegB;
				ELSE
					RegB := RegB - RegA;
				END IF;
			END LOOP;

			-- Output the result after a small delay. The delay makes the waveforms
			-- for a simulation easier to read.
			C <= RegA AFTER 15 ns;

			-- Handshake phase 2.
			ack <= '1' AFTER 15 ns;

			-- Handshake phase 3.
			WAIT UNTIL req'EVENT AND req = '0';

			-- Handshake phase 4. Handshake protocol complete. Remove result from
 			-- output.
			ack <= '0' AFTER 5 ns;
			C <= (OTHERS => 'Z') AFTER 5 ns;

		END LOOP;
	END PROCESS;
END specification;
