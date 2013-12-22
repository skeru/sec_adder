
LIBRARY ieee;
USE ieee.std_logic_1164.all;

package sec_type is
type t_sec_signal is array (1 downto 0) of std_logic;
end sec_type;


-- ENCODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity encoder is
  port(
    a: in std_logic;
    r: in std_logic;
    b: out t_sec_signal);
  end encoder;
    
architecture secure of encoder is
  begin
    b(0) <= a xor r;
    b(1) <= r;
  end;

-- DECODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity decoder is
  port(
    a: in t_sec_signal;
    b: out std_logic);
end decoder;
    
architecture secure of decoder is
  begin
    b <= a(0) xor a(1);
  end;


-- SECURE NOT PORT --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity sec_not is 
  port(
    a: in t_sec_signal;
    b: out t_sec_signal);
  end sec_not;
    
architecture secure of sec_not is
  begin
    b(0) <= a(0);
    b(1) <= not a(1);
  end;
  
-- SECURE XOR PORT --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;
  
entity sec_xor is
  port(
    a, b: in t_sec_signal;
    r: in std_logic; -- random input signal
    c: out t_sec_signal);
  end sec_xor;
  
architecture secure of sec_xor is
  begin
    c(0) <= (a(0) xor r) xor (b(0) xor r);
    c(1) <= (a(1) xor r) xor (b(1) xor r);
  end;