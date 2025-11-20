-- instr_mem.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity instr_mem is
  port(
    A  : in  std_logic_vector(4 downto 0);           -- PC(6 downto 2)
    RD : out std_logic_vector(31 downto 0)           -- instruction lue
  );
end entity;

architecture sim of instr_mem is
  type ram_t is array (0 to 31) of std_logic_vector(31 downto 0);
  shared variable RAM : ram_t := (others => (others => '0'));

  -- utilitaire : lit 32 caractères '0'/'1' et les convertit
 -- === À placer avant le process init ===
  procedure read_bin32(L : inout line; V : out std_logic_vector(31 downto 0)) is
    variable s : string(1 to 32);
    variable ch : character;
  begin
    for i in 1 to 32 loop
      read(L, ch);
      s(i) := ch;
    end loop;
  
    for i in 1 to 32 loop
      if s(i) = '1' then
        V(32 - i) := '1';
      else
        V(32 - i) := '0';
      end if;
    end loop;
  end procedure;


begin
  -- Initialisation (simulation) : lire Instructions.txt (20 lignes = 20 instructions)
 init: process
    file f : text open read_mode is "Instructions_SHIFTED.txt";
    variable L  : line;
    variable i  : integer := 0;
    variable V  : std_logic_vector(31 downto 0);
  begin
    while (not endfile(f)) and (i <= 31) loop
      readline(f, L);
      if i < 20 then
        read_bin32(L, V);   -- on appelle la procédure
        RAM(i) := V;        -- on stocke dans la RAM
      else
        exit;
      end if;
      i := i + 1;
    end loop;
    wait;
  end process;

  -- lecture combinatoire
  RD <= RAM(to_integer(unsigned(A)));
end architecture;
