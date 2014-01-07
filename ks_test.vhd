-- secure kogge stone adder test --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity ks_test is
  port (
    a: in std_logic_vector(3 downto 0);
    b: in std_logic_vector(3 downto 0);
    rnd: in std_logic_vector(3 downto 0);
    c_in: in std_logic;
    sum: out std_logic_vector(3 downto 0);
    c_out: out std_logic);
  end ks_test;
  
architecture test of ks_test is
  component secure_ks_adder generic( width: integer := 4);
    port(a, b: in t_sec_signal_vector(width-1 downto 0); rnd: in std_logic_vector(width-1 downto 0); c_in: in t_sec_signal; sum: out t_sec_signal_vector(width-1 downto 0); c_out: out t_sec_signal);
  end component;
  component encoder_vector generic (width : integer := 4);
    port(a, r: in std_logic_vector(width-1 downto 0); b: out t_sec_signal_vector(width-1 downto 0));
  end component;
  component decoder_vector generic (width : integer := 4);
    port(a: in t_sec_signal_vector(width-1 downto 0); b: out std_logic_vector(width-1 downto 0));
  end component;
  component encoder port(a, r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  signal a_sign, b_sign, sum_sign: t_sec_signal_vector(3 downto 0);
  signal c_in_sign, c_out_sign: t_sec_signal;
  begin
    encoder_a: encoder_vector port map (a, rnd, a_sign);
    encoder_b: encoder_vector port map (b, rnd, b_sign);
    encoder_c: encoder port map (c_in, rnd(0), c_in_sign);
    ks: secure_ks_adder port map (a_sign, b_sign, rnd, c_in_sign, sum_sign, c_out_sign);
    decoder_s: decoder_vector port map (sum_sign, sum);
    decoder_c: decoder port map (c_out_sign, c_out);
  end;