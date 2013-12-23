-- TYPE DEFINITION --
LIBRARY ieee;
USE ieee.std_logic_1164.all;

package sec_type is
type t_sec_signal is array (1 downto 0) of std_logic;
type t_sec_signal_vector is array (natural range <>) of t_sec_signal;
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


