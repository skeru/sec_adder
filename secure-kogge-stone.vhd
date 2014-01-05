-- secure bit propagate generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_bit_pg is
  port(
    a: in t_sec_signal;
    b: in t_sec_signal;
    rnd: in std_logic;
    p: out t_sec_signal;
    g: out t_sec_signal);
end secure_bit_pg;

architecture secure of secure_bit_pg is
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  begin
    foo: sec_and port map (a, b, rnd, g);
    fee: sec_xor port map (a, b, rnd, p);
  end;


-- secure group propagate generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_group_pg is
  port(
    p0: in t_sec_signal;
    p1: in t_sec_signal;
    g0: in t_sec_signal;
    g1: in t_sec_signal;
    rnd: in std_logic;
    p2: out t_sec_signal;
    g2: out t_sec_signal);
end secure_group_pg;

architecture secure of secure_group_pg is
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  component sec_or port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- OR --
  end component;
  signal tmp: t_sec_signal;
  begin
    foo: sec_and port map (g0, p1, rnd, tmp);
    fuu: sec_or port map (g1, tmp, rnd, g2);
    fee: sec_xor port map (p1, p0, rnd, p2);
  end;
    
-- secure group generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_group_g is
  port(
    p1: in t_sec_signal;
    g0: in t_sec_signal;
    g1: in t_sec_signal;
    rnd: in std_logic;
    g2: out t_sec_signal);
end secure_group_g;

architecture secure of secure_group_g is
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  component sec_or port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- OR --
  end component;
  signal tmp: t_sec_signal;
  begin
    foo: sec_and port map (g0, p1, rnd, tmp);
    fuu: sec_or port map (g1, tmp, rnd, g2);
  end;
    
-- secure Kogge Stone adder --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
PACKAGE my_funs IS
    FUNCTION clogb2 (a: NATURAL) RETURN NATURAL;
END my_funs;
 
PACKAGE BODY my_funs IS
    FUNCTION clogb2 (a: NATURAL) RETURN NATURAL IS
        VARIABLE aggregate : NATURAL := a;
        VARIABLE return_val : NATURAL := 0;
    BEGIN
        compute_clogb2: 
        FOR i IN a DOWNTO 0 LOOP
 
            IF aggregate > 0 THEN
                return_val := return_val + 1;
            END IF;
 
            aggregate := aggregate / 2;            
        END LOOP;
 
        RETURN return_val;
 
    END clogb2;
END my_funs;
 
 
library ieee;
use ieee.std_logic_1164.all;
use work.my_funs.all;
use work.sec_type.all;

entity secure_ks_adder is
  generic( width: integer :=4);
  port(
    a: in t_sec_signal_vector(width-1 downto 0);
    b: in t_sec_signal_vector(width-1 downto 0);
    c_in: in t_sec_signal;
    sum: out t_sec_signal_vector(width-1 downto 0);
    c_out: out t_sec_signal);
end secure_ks_adder;

architecture behavioral of secure_ks_adder is
  constant depth: integer := clogb2(width);
  component sec_not port(a: in t_sec_signal; b: out t_sec_signal); -- NOT --
  end component;
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
begin
end;