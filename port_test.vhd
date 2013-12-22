-- TEST ENCODER DECODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity test_encoder_decoder is
  port(
    a: in std_logic;
    rnd: in std_logic;
    enc: out t_sec_signal;
    b: out std_logic);
  end test_encoder_decoder;
  
architecture test of test_encoder_decoder is
  component encoder port(a: in std_logic; r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  signal tmp: t_sec_signal;
  begin
    encoder1: encoder port map (a, rnd, tmp);
    enc <= tmp;
    decoder1: decoder port map (tmp, b);
  end;