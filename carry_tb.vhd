library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity adder_component_bit_pg_tb is
end adder_component_bit_pg_tb;

architecture test_bench of adder_component_bit_pg_tb is
  component secure_bit_pg port(a, b: in t_sec_signal; rnd: in std_logic; p, g: out t_sec_signal); -- bit generate propagate --
  end component;
  component encoder port(a: in std_logic; r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  
  signal rnd: std_logic;
  signal a_signal, b_signal, p_signal, g_signal: std_logic;
  signal a_secure, b_secure, p_secure, g_secure: t_sec_signal;
  
  begin
    -- p <= a xor b
    -- g <= a and b
    rnd <= '0';
    
    encoder_a : encoder port map (a_signal, rnd, a_secure);
    encoder_b : encoder port map (b_signal, rnd, b_secure);
    
    comp : secure_bit_pg port map (a_secure, b_secure, rnd, p_secure, g_secure);
  
    decoder_p : decoder port map (p_secure, p_signal);
    decoder_g : decoder port map (g_secure, g_signal);
      
    assert ( p_signal = ( a_signal xor b_signal ));
    assert ( g_signal = ( a_signal and b_signal ));
      
end;


library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity adder_component_group_g_tb is
end adder_component_group_g_tb;

architecture test_bench of adder_component_group_g_tb is
  component secure_group_g port(p1, g0, g1: in t_sec_signal; rnd: in std_logic; g2: out t_sec_signal); -- group generate --
  end component;
  component encoder port(a: in std_logic; r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  
  signal rnd: std_logic;
  signal g1_signal, p1_signal, g0_signal, g2_signal: std_logic;
  signal g1_secure, p1_secure, g0_secure, g2_secure: t_sec_signal;
  
  begin
    -- g2 <= g1 or (g0 and p1)
    rnd <= '0';
    
    encoder_p1 : encoder port map (p1_signal, rnd, p1_secure);
    encoder_g0 : encoder port map (g0_signal, rnd, g0_secure);
    encoder_g1 : encoder port map (g1_signal, rnd, g1_secure);
    
    comp : secure_group_g port map (p1_secure, g0_secure, g1_secure, rnd, g2_secure);
  
    decoder_g2 : decoder port map (g2_secure, g2_signal);
      
    assert ( g2_signal = (g1_signal or ( g0_signal and p1_signal )));
  
end;


library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity adder_component_group_pg_tb is
end adder_component_group_pg_tb;

architecture test_bench of adder_component_group_pg_tb is

  component secure_group_pg port(p0, p1, g0, g1: in t_sec_signal; rnd: in std_logic; p2, g2: out t_sec_signal); -- group generate propagate --
  end component;
  component encoder port(a: in std_logic; r: in std_logic; b: out t_sec_signal);
  end component;
  component decoder port(a: in t_sec_signal; b: out std_logic);
  end component;
  
  signal rnd: std_logic;
  signal p0_signal, p1_signal, g0_signal, g1_signal, p2_signal, g2_signal: std_logic;
  signal p0_secure, p1_secure, g0_secure, g1_secure, p2_secure, g2_secure: t_sec_signal;
  
  begin
    -- g2 <= g1 or (g0 and p1)
    -- p2 <= p0 xor p1
    rnd <= '0';
    
    encoder_p0 : encoder port map (p0_signal, rnd, p0_secure);
    encoder_p1 : encoder port map (p1_signal, rnd, p1_secure);
    encoder_g0 : encoder port map (g0_signal, rnd, g0_secure);
    encoder_g1 : encoder port map (g1_signal, rnd, g1_secure);
    
    comp : secure_group_pg port map (p0_secure, p1_secure, g0_secure, g1_secure, rnd, p2_secure, g2_secure);
  
    decoder_g2 : decoder port map (g2_secure, g2_signal);
    decoder_p2 : decoder port map (p2_secure, p2_signal);
      
    assert ( g2_signal = (g1_signal or ( g0_signal and p1_signal )));
    assert ( p2_signal = (p0_signal xor p1_signal));
  
end;