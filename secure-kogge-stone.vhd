-- secure bit propagate generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_bit_pg is
  port(
    a: in t_sec_signal;
    b: in t_sec_signal;
    rnd: in std_logic;
    p: out t_sec_signal;
    g: out t_sec_signal);
end secure_bit_pg;

architecture secure of secure_bit_pg is
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  begin
    gen_g: sec_and port map (a, b, rnd, g);
    gen_p: sec_xor port map (a, b, rnd, p);
  end;


-- secure group propagate generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_group_pg is
  port(
    p0: in t_sec_signal;
    p1: in t_sec_signal;
    g0: in t_sec_signal;
    g1: in t_sec_signal;
    rnd: in std_logic;
    p2: out t_sec_signal;
    g2: out t_sec_signal);
end secure_group_pg;

architecture secure of secure_group_pg is
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  component sec_or port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- OR --
  end component;
  signal tmp: t_sec_signal;
  begin
    gen_tmp: sec_and port map (g0, p1, rnd, tmp); -- tmp <= g0 and p1
    gen_g: sec_or port map (g1, tmp, rnd, g2);    -- g2 <= g1 or tmp
    gen_p: sec_and port map (p1, p0, rnd, p2);    -- p2 <= p0 and p1
  end;
    
-- secure group generate --
library ieee;
use work.sec_type.all;
use ieee.std_logic_1164.all;

entity secure_group_g is
  port(
    p1: in t_sec_signal;
    g0: in t_sec_signal;
    g1: in t_sec_signal;
    rnd: in std_logic;
    g2: out t_sec_signal);
end secure_group_g;

architecture secure of secure_group_g is
  component sec_and port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- AND --
  end component;
  component sec_or port(a, b: in t_sec_signal; rnd: in std_logic; c: out t_sec_signal); -- OR --
  end component;
  signal tmp: t_sec_signal;
  begin
    gen_tmp: sec_and port map (g0, p1, rnd, tmp); -- tmp <= g0 and p1
    gen_g: sec_or port map (g1, tmp, rnd, g2); -- g2 <= g1 or tmp
  end;
    
-- secure Kogge Stone adder --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
PACKAGE my_funs IS
    function log2 (i: natural) return integer;
END my_funs;
 
PACKAGE BODY my_funs IS
    function log2( i : natural) return integer is
    variable temp    : integer := i;
    variable ret_val : integer := 0; 
  begin					
    while temp > 1 loop
      ret_val := ret_val + 1;
      temp    := temp / 2;     
    end loop;
  	
    return ret_val;
  end function;
END my_funs;
 
 
library ieee;
use ieee.std_logic_1164.all;
use work.my_funs.all;
use work.sec_type.all;

entity secure_ks_adder is
  generic( width: integer :=8);
  port(
    a: in t_sec_signal_vector(width-1 downto 0);
    b: in t_sec_signal_vector(width-1 downto 0);
    c_in: in t_sec_signal;
    rnd: in std_logic_vector(width-1 downto 0);
    sum: out t_sec_signal_vector(width-1 downto 0);
    c_out: out t_sec_signal);
end secure_ks_adder;

architecture behavioral of secure_ks_adder is
  constant depth: integer := log2(width);
  component sec_xor port(a, b: in t_sec_signal; r: in std_logic; c: out t_sec_signal); -- XOR --
  end component;
  component secure_group_g port(p1, g0, g1: in t_sec_signal; rnd: in std_logic; g2: out t_sec_signal); -- group generate --
  end component;
  component secure_bit_pg port(a, b: in t_sec_signal; rnd: in std_logic; p, g: out t_sec_signal); -- bit generate propagate --
  end component;
  component secure_group_pg port(p0, p1, g0, g1: in t_sec_signal; rnd: in std_logic; p2, g2: out t_sec_signal); -- group generate propagate --
  end component;
  type t_adder_signal is array (depth downto 0) of t_sec_signal_vector (width - 1 downto -1);
  signal p,g: t_adder_signal;
begin
  
  -- bit propagate and generate
  bit_propagate_generate_for: for i in width-1 downto 0 generate begin
    bit_map: secure_bit_pg port map (a(i), b(i), rnd(i), p(0)(i), g(0)(i));
  end generate bit_propagate_generate_for;
  
  --carry in initialization
  p(0)(-1) <= c_in;
  g(0)(-1) <= c_in;
  
  --depth generation
  depth_for_gen: for d in 1 to depth generate
    constant prev: integer := d-1;
    constant shift: integer := 2**prev;    
    begin
      
    -- propagation of unchanged signals
    only_propagation: for s in (-1) to shift-2 generate begin
      p(d)(s) <= p(prev)(s);
      g(d)(s) <= g(prev)(s);      
    end generate only_propagation;
    
    -- group generation
    group_g_for_gen: for g_index in shift-1 to (2**d)-2 generate begin
      group_carry_generation: secure_group_g port map (
        p(prev)(g_index), 
        g(prev)(g_index - shift), -- g(prev)(g_index - shift), 
        g(prev)(g_index), -- g(prev)(g_index),  
        rnd(d), 
        g(d)(g_index));
       p(d)(g_index) <= p(prev)(g_index); --quite useless
    end generate group_g_for_gen;
    
    -- group generation and propagation
    group_gp_for_gen: for gp_index in (2**d)-1 to width-1 generate begin
      group_carry_generation_propagation: secure_group_pg port map (
        p(prev)(gp_index - shift),  
        p(prev)(gp_index), 
        g(prev)(gp_index - shift), 
        g(prev)(gp_index),
        rnd(gp_index), 
        p(d)(gp_index), 
        g(d)(gp_index));
    end generate group_gp_for_gen;
  end generate depth_for_gen;
  
  -- sum final computation
  final_xor: for index in 0 to width - 1 generate begin
    adder_xor: sec_xor port map (p(0)(index), g(depth)(index - 1), rnd(index), sum(index));
  end generate final_xor;
  
  -- carry out
  carry_out: secure_group_g port map (
    p(depth)(width - 1), 
    g(depth)(-1), 
    g(depth)(width - 1), 
    rnd(0), 
    c_out);
  
end;