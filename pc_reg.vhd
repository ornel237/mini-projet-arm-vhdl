library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_reg is
  port(
    clk   : in  std_logic;
    reset : in  std_logic;                   -- async, actif haut
    --PC    : out std_logic_vector(31 downto 0);
     D    : in std_logic_vector(31 downto 0);
     Q   : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of pc_reg is
  signal pc_r : std_logic_vector(31 downto 0) := (others => '0');
begin
  process(clk, reset)
  begin
    if reset = '1' then
      pc_r <= (others => '0');
    elsif rising_edge(clk) then
     -- pc_r <= pc_r + 4;                      -- incrément ARM
      pc_r <= D;                        -- chargement du prochain PC

    end if;
  end process;
 -- PC <= std_logic_vector(pc_r);
 Q <= std_logic_vector(pc_r);                            -- sortie vers le reste du système

end architecture;
