library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity port_tb is 
end port_tb;

architecture test_bench of port_tb is
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

  signal rnd: std_logic;
  signal a_signal, b_signal, c_signal, not_signal, xor_signal, and_signal, or_signal: std_logic;
  signal a_secure, b_secure, c_secure, not_secure, xor_secure, and_secure, or_secure: t_sec_signal;
  
  begin
    rnd <= '0';
    
    a_signal <= '0';
    b_signal <= '0';
    
    encoder_a : encoder port map (a_signal, rnd, a_secure);
    encoder_b : encoder port map (b_signal, rnd, b_secure);
    
    not_a : sec_not port map (a_secure, not_secure);
    axorb : sec_xor port map (a_secure, b_secure, rnd, xor_secure);
    aandb : sec_and port map (a_secure, b_secure, rnd, and_secure);
    aorb : sec_or port map (a_secure, b_secure, rnd, or_secure);
    
    decoder_not : decoder port map (not_secure, not_signal);
    not_assert : assert (a_signal = not not_signal);
    
    decoder_xor : decoder port map (xor_secure, xor_signal);
    xor_assert : assert (xor_signal = (a_signal xor b_signal));
    
    decoder_and : decoder port map (and_secure, and_signal);
    and_assert : assert (and_signal = (a_signal and b_signal));
    
    decoder_or : decoder port map (or_secure, or_signal);
    or_assert : assert (or_signal = (a_signal or b_signal));
    
end;