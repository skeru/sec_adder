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
  
-- TEST OTHER PORTS --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity test_port is
  port(
    a, b: in std_logic;
    r: in std_logic;
    not_a: out std_logic;
    a_xor_b: out std_logic
    );
  end test_port;
  
architecture test of test_port is
  component encoder port(a: in std_logic; r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  component sec_not port(a: in t_sec_signal; b: out t_sec_signal); -- NOT --
  end component;
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  
  signal out_a_sign, out_b_sign, not_a_sign, a_xor_b_sign: t_sec_signal;
  begin
    encoder1: encoder port map (a, r, out_a_sign);
    encoder2: encoder port map (b, r, out_b_sign);
    not1: sec_not port map (out_a_sign, not_a_sign);
    xor1: sec_xor port map (out_a_sign, out_b_sign, r, a_xor_b_sign);
    not_decoder: decoder port map (not_a_sign, not_a);
    xor_decoder: decoder port map (a_xor_b_sign, a_xor_b);
  end;