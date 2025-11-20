library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
  port(
    clk      : in  std_logic;
    MemWrite : in  std_logic;
    A        : in  std_logic_vector(31 downto 0);
    WD       : in  std_logic_vector(31 downto 0);
    RD       : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of data_mem is
  type ram_t is array(0 to 63) of std_logic_vector(31 downto 0);
  signal ram : ram_t := (others => (others => '0'));
  signal addr : unsigned(5 downto 0);
begin
  addr <= unsigned(A(5 downto 0));

  -- Lecture asynchrone
  RD <= ram(to_integer(addr));

  -- Écriture synchrone sur front montant si MemWrite='1'
  process(clk)
  begin
    if rising_edge(clk) then
      if MemWrite = '1' then
        ram(to_integer(addr)) <= WD;
      end if;
    end if;
  end process;
end architecture;
