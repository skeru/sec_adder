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
  signal a_signal, b_signal: t_sec_signal;
  begin
    a_signal(0) <= (a(0) xor r);
    b_signal(0) <= (b(0) xor r);    
    c(0) <= a_signal(0) xor b_signal(0);
    a_signal(1) <= (a(1) xor r);
    b_signal(1) <= (b(1) xor r);    
    c(1) <= a_signal(1) xor b_signal(1);
  end;
  
-- SECURE AND PORT --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;
  
entity sec_and is
  port(
    a, b: in t_sec_signal;
    rnd: in std_logic; -- random input signal
    c: out t_sec_signal);
  end sec_and;
  
architecture secure of sec_and is
  signal x, z: std_logic;
  begin
    x <= rnd xor (a(0) and b(1));
    z <= x xor (a(1) and b(0));
    c(0) <= (a(0) and b(0)) xor rnd;
    c(1) <= (a(1) and b(1)) xor z;
  end;