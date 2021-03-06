-- TYPE DEFINITION --
LIBRARY ieee;
USE ieee.std_logic_1164.all;

package sec_type is
type t_sec_signal is array (1 downto 0) of std_logic;
type t_sec_signal_vector is array (integer range <>) of t_sec_signal;
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
  component encoder port(a, r: in std_logic; b: out t_sec_signal);
  end component;
  begin 
    enc_gen: for i in width-1 downto 0 generate
      encode: encoder port map (a(i), r(i), b(i));
    end generate;
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
use work.sec_type.all;

entity decoder_vector is
  generic (width : integer := 4);
  port(
    a: in t_sec_signal_vector(width-1 downto 0);
    b: out std_logic_vector(width-1 downto 0));
  end decoder_vector;
  
architecture secure of decoder_vector is
  component decoder port (a: in t_sec_signal; b: out std_logic);
  end component;
  begin 
    dec_gen: for i in width-1 downto 0 generate
      decode: decoder port map (a(i), b(i));
    end generate;
  end;

