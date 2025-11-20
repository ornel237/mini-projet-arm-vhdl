library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
  port(
    clk      : in  std_logic;
    RegWrite : in  std_logic;
    RA1      : in  std_logic_vector(3 downto 0);
    RA2      : in  std_logic_vector(3 downto 0);
    A3       : in  std_logic_vector(3 downto 0);
    WD3      : in  std_logic_vector(31 downto 0);
    R15      : in  std_logic_vector(31 downto 0);
    RD1      : out std_logic_vector(31 downto 0);
    RD2      : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of regfile is
  type ram_t is array(0 to 15) of std_logic_vector(31 downto 0);
  signal ram : ram_t := (others => (others => '0'));
begin
  -- Lecture asynchrone
  RD1 <= (others => '0') when RA1 = "1111" else ram(to_integer(unsigned(RA1)));
  RD2 <= (others => '0') when RA2 = "1111" else ram(to_integer(unsigned(RA2)));

  -- Écriture synchrone (front montant) si RegWrite='1'
  process(clk)
  begin
    if rising_edge(clk) then
      if RegWrite = '1' then
        if A3 = "1111" then
          -- si on voulait simuler R15, on écrirait R15 ici ; pour le labo: rien
          null;
        else
          ram(to_integer(unsigned(A3))) <= WD3;
        end if;
      end if;
      -- on peut forcer R15 si besoin:
      ram(15) <= R15;  -- pas utilisé dans ce labo ; R15 lié à 0 dans le datapath
    end if;
  end process;
end architecture;
