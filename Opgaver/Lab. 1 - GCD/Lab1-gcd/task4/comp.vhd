-- -----------------------------------------------------------------------------
--
--  Title      :  Components for the GCD module
--             :
--  Developers :  Jens Spars� and Rasmus Bo S�rensen
--             :
--  Purpose    :  This design contains models of the components that must be
--             :  used to implement the GCD module.
--             :
--  Note       :  All the components have a generic parameter that sets the
--             :  bit-width of the component. This defaults to 16 bits, so in
--             :  this assignment there is no need to change it.
--             :
--  Revision   :  02203 fall 2017 v.5.0
--
-- -----------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- A buffer. Defaults to a width of 16 bits. Note the special
-- statement that assigns the input to the output. It is similar to a simple
-- IF-statement but can be used outside a process.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tri IS
    GENERIC (N:     NATURAL := 16);				-- Width of inputs.
    PORT (data_in:  IN  unsigned(N DOWNTO 1);	-- Input.
          data_out: OUT unsigned(N DOWNTO 1));	-- Output.
END tri;

ARCHITECTURE behaviour OF tri IS
BEGIN
    data_out <= data_in;
END behaviour;


--------------------------------------------------------------------------------
-- A 2 to 1 multiplexor. Defaults to a width of 16 bits.
-- If select (s) is 0 input 1 will be choosen else input 2
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mux IS
    GENERIC (N:     NATURAL := 16);				-- Width of inputs and output.
    PORT (data_in1:  IN  unsigned(N DOWNTO 1);	-- Inputs.
          data_in2:  IN unsigned(N DOWNTO 1);
          s       :  IN std_logic;				-- Select signal.
          data_out:  OUT  unsigned(N DOWNTO 1)	-- Output.
          );
END mux;

ARCHITECTURE behaviour OF mux IS
BEGIN
    data_out <= data_in1 WHEN s = '0' ELSE data_in2;
END behaviour;

--------------------------------------------------------------------------------
-- A generic positive edge-triggered register with enable. Width defaults to
-- 16 bits.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg IS
    GENERIC (N:     NATURAL := 16);				-- Width of inputs.
    PORT (clk:      IN  std_logic;				-- Clock signal.
          en:       IN  std_logic;				-- Enable signal.
          data_in:  IN  unsigned(N DOWNTO 1);	-- Input data.
          data_out: OUT unsigned(N DOWNTO 1));	-- Output data.
END reg;

ARCHITECTURE behaviour OF reg IS
BEGIN
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF en = '1' THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;
END behaviour;

--------------------------------------------------------------------------------
-- A simple ALU that works on numbers in two's complement representation. The
-- width defaults to 16 bits. The ALU has the following four functions encoded
-- in the signal "fn":
-- fn = 00 : C = A - B
-- fn = 01 : C = B - A
-- fn = 10 : C = A
-- fn = 11 : C = B
-- The ALU sets the two flags "Z" and "N" which indicates if the result was zero
-- or negative.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY alu IS
    GENERIC (W:     NATURAL := 16);						-- Width of inputs.
    PORT (A, B:     IN unsigned(W DOWNTO 1);			-- Input operands.
          fn:       IN std_logic_vector(1 DOWNTO 0); 	-- Function.
          C:        OUT unsigned(W DOWNTO 1);			-- Result.
          Z:        OUT std_logic;          			-- Result = 0 flag.
          N:        OUT std_logic);         			-- Result neg flag.
END alu;

ARCHITECTURE behaviour OF alu IS
    SIGNAL i_C: unsigned(W DOWNTO 1);

    CONSTANT zero: unsigned(W DOWNTO 1) := (OTHERS => '0');
BEGIN
    C <= i_C;

    WITH fn SELECT
        i_C <= A - B WHEN "00",
               B - A WHEN "01",
               A WHEN "10",
               B WHEN OTHERS;           -- "11"

    N <= i_C(W);
    Z <= '1' WHEN i_C = zero ELSE '0';
END behaviour;
