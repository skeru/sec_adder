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

-- TEST SIGNAL ENCODER DECODER --
LIBRARY ieee;
use ieee.std_logic_1164.all;
use work.sec_type.all;

entity test_encoder_decoder_vect is
  generic ( width: integer := 4);
  port(
    a: in std_logic_vector(width-1 downto 0);
    rnd: in std_logic_vector(width-1 downto 0);
    enc: out t_sec_signal_vector(width-1 downto 0);
    b: out std_logic_vector(width-1 downto 0));
  end test_encoder_decoder_vect;
  
architecture test of test_encoder_decoder_vect is
  component encoder_vector port(a: in std_logic_vector; r: in std_logic_vector; b: out t_sec_signal_vector);
  end component;
  component decoder_vector port(a: in t_sec_signal_vector; b: out std_logic_vector);
  end component;
  signal tmp: t_sec_signal_vector(width-1 downto 0);
  begin
    encoder1: encoder_vector port map (a, rnd, tmp);
    enc <= tmp;
    decoder1: decoder_vector port map (tmp, b);
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
    a_xor_b: out std_logic;
    a_and_b: out std_logic;
    a_or_b: out std_logic
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
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  component sec_or port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- OR --
  end component;

  
  signal out_a_sign, out_b_sign, not_a_sign, a_xor_b_sign, a_or_b_sign, a_and_b_sign: t_sec_signal;
  begin
    encoder1: encoder port map (a, r, out_a_sign);
    encoder2: encoder port map (b, r, out_b_sign);
    not1: sec_not port map (out_a_sign, not_a_sign);
    xor1: sec_xor port map (out_a_sign, out_b_sign, r, a_xor_b_sign);
    and1: sec_and port map (out_a_sign, out_b_sign, r, a_and_b_sign);
    or1: sec_or port map (out_a_sign, out_b_sign, r, a_or_b_sign);
    not_decoder: decoder port map (not_a_sign, not_a);
    xor_decoder: decoder port map (a_xor_b_sign, a_xor_b);
    and_decoder: decoder port map (a_and_b_sign, a_and_b);
    or_decoder: decoder port map (a_or_b_sign, a_or_b);
  end;