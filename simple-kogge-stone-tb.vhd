-- http://www.openhdl.com/vhdl/651-vhdl-component-kogge-stone-adder-generic.html

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
 
ENTITY ks_adder_tb IS
    GENERIC (
        width: INTEGER := 5
    );
END ks_adder_tb;
 
ARCHITECTURE tb OF ks_adder_tb IS
    SIGNAL t_a: STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    SIGNAL t_b: STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    SIGNAL t_sum: STD_LOGIC_VECTOR(width-1 DOWNTO 0);
    SIGNAL t_c_in: STD_LOGIC := '1';
    SIGNAL t_c_out: STD_LOGIC;
 
    COMPONENT ks_adder
        GENERIC (
            width: INTEGER := 16
        );
        PORT (
            a :    IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            b :    IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            c_in :    IN STD_LOGIC;
            sum :    OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            c_out :    OUT STD_LOGIC
        );
    END COMPONENT;
 
    FUNCTION to_string(sv: Std_Logic_Vector) return string is
            USE Std.TextIO.all;
            USE ieee.std_logic_textio.all;
        VARIABLE lp: line;
      BEGIN
            write(lp, to_integer(unsigned(sv)));
            RETURN lp.all;
      END;    
BEGIN
    U_ks_adder: ks_adder
    GENERIC MAP (
        width => width
    )
    PORT MAP (
        a => t_a,
        b => t_b,
        c_in => t_c_in,
        sum => t_sum,
        c_out => t_c_out
    );
 
    -- Input Processes
    inp_prc: PROCESS
        VARIABLE v_a: INTEGER := 0;
        VARIABLE v_b: INTEGER := 2**(width-1);
        VARIABLE v_c_in: INTEGER := 0;
    BEGIN
        FOR i IN 0 TO 2**width LOOP
            v_a := v_a + 1;
            v_b := v_b - i;
            IF(v_b < 0) THEN
                v_b := v_b + 2**width-1;
            END IF;
            t_a <= std_logic_vector(to_unsigned(v_a,width));
            t_b <= std_logic_vector(to_unsigned(v_b,width));
            WAIT FOR 1 ns;
            IF t_c_in = '1' THEN
                v_c_in := 1;
            ELSE
                v_c_in := 0;
            END IF;            
            ASSERT TO_INTEGER(UNSIGNED(t_sum)) = (v_a + v_b + v_c_in)
                REPORT "Invalid sum! "&to_string(t_sum)&" != "&to_string(std_logic_vector(to_unsigned(v_a + v_b + v_c_in,width)))&"!";
            WAIT FOR 9 ns;
 
        END LOOP;
    END PROCESS;
 
    c_in_process: PROCESS
    BEGIN
        t_c_in <= not(t_c_in);
        WAIT FOR 10 ns;
    END PROCESS;
END tb;