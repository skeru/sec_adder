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

-- SIGNAL ENCODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity encoder_vector is
  generic (width : integer := 4);
  port(
    a: in std_logic_vector(width-1 downto 0);
    r: in std_logic_vector(width-1 downto 0);
    b: out t_sec_signal_vector(width-1 downto 0));
  end encoder_vector;
  
architecture secure of encoder_vector is
  begin 
    enc_process: process(a,r)
    begin
      for i in width-1 downto 0 loop
        b(i)(0) <= a(i) xor r(i);
        b(i)(1) <= r(i);
      end loop;
    end process;
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

-- SIGNAL DECODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.sec_type.all;

entity decoder_vector is
  generic (width : integer := 4);
  port(
    a: in t_sec_signal_vector(width-1 downto 0);
    b: out std_logic_vector(width-1 downto 0));
  end decoder_vector;
  
architecture secure of decoder_vector is
  begin 
    enc_process: process(a)
    begin
      for i in width-1 downto 0 loop
        b(i) <= a(i)(0) xor a(i)(1);
      end loop;
    end process;
  end;

