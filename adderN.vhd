-- adderN.vhd  (correct avec numeric_std)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adderN is
  generic (N : integer := 32);
  port (a    : in  std_logic_vector(N-1 downto 0);
        b    : in  std_logic_vector(N-1 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(N-1 downto 0);
        cout : out std_logic);
end entity;

architecture beh of adderN is
  signal au  : unsigned(N-1 downto 0);
  signal bu  : unsigned(N-1 downto 0);
  signal ciu : unsigned(0 downto 0);
  signal tmp : unsigned(N downto 0);
begin
  au  <= unsigned(a);
  bu  <= unsigned(b);
  ciu <= (0 => cin);
  tmp <= ('0' & au) + ('0' & bu) + ciu;
  sum <= std_logic_vector(tmp(N-1 downto 0));
  cout <= std_logic(tmp(N));
end architecture;
