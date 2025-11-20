library ieee;
use ieee.std_logic_1164.all;

entity flag_regs is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;                           -- asynchrone, actif haut
    CondEx    : in  std_logic;                           -- 1 si condition vraie
    FlagW     : in  std_logic_vector(1 downto 0);        -- 10: NZ ; 11: NZCV
    ALUFlags  : in  std_logic_vector(3 downto 0);        -- NZCV
    FlagsOut  : out std_logic_vector(3 downto 0);        -- NZCV stockés
    FlagWrite : out std_logic_vector(1 downto 0)         -- masque d'écriture effectif
  );
end entity;

architecture rtl of flag_regs is
  signal flags_r : std_logic_vector(3 downto 0) := (others => '0');
begin
  FlagWrite(1) <= FlagW(1) and CondEx;
  FlagWrite(0) <= FlagW(0) and CondEx;

  process(clk, reset)
  begin
    if reset = '1' then
      flags_r <= (others => '0');
    elsif rising_edge(clk) then
      if CondEx = '1' then
        if FlagW(1) = '1' then
          flags_r(3 downto 2) <= ALUFlags(3 downto 2); -- N,Z
        end if;
        if FlagW(0) = '1' then
          flags_r(1 downto 0) <= ALUFlags(1 downto 0); -- C,V
        end if;
      end if;
    end if;
  end process;

  FlagsOut <= flags_r;
end architecture;
