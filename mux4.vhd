-- mux4.vhd
library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
  generic (N : integer := 32);
  port (d0,d1,d2,d3 : in  std_logic_vector(N-1 downto 0);
        sel         : in  std_logic_vector(1 downto 0);
        y           : out std_logic_vector(N-1 downto 0));
end entity;

architecture beh of mux4 is
begin
  with sel select
    y <= d0 when "00",
         d1 when "01",
         d2 when "10",
         d3 when others;
end architecture;
