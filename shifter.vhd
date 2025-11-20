library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- =====================================================================
-- Shifter (Barrel Shifter) pour ARM
-- =====================================================================
-- Effectue les opérations de décalage/rotation sur un opérande 32 bits
-- Supporte: LSL, LSR, ASR, ROR
-- =====================================================================

entity shifter is
  port(
    Src       : in  std_logic_vector(31 downto 0);  -- Donnée d'entrée (Rm)
    Shamt5    : in  std_logic_vector(4 downto 0);   -- Quantité de décalage (0-31)
    Sh        : in  std_logic_vector(1 downto 0);   -- Type de décalage
    ShOut     : out std_logic_vector(31 downto 0)   -- Résultat décalé
  );
end entity;

architecture rtl of shifter is
  signal shamt_int : integer range 0 to 31;
begin
  -- Conversion du décalage en entier
  shamt_int <= to_integer(unsigned(Shamt5));

  process(Src, Sh, shamt_int, Shamt5)
    variable temp : std_logic_vector(31 downto 0);
  begin
    case Sh is
      -- ================================================================
      -- 00: LSL (Logical Shift Left) - Décalage logique à gauche
      -- ================================================================
      -- Décale à gauche, remplit avec des zéros à droite
      -- Exemple: LSL #2:  0b1010 -> 0b101000
      when "00" =>
        if shamt_int = 0 then
          temp := Src;
        else
          temp := std_logic_vector(shift_left(unsigned(Src), shamt_int));
        end if;

      -- ================================================================
      -- 01: LSR (Logical Shift Right) - Décalage logique à droite
      -- ================================================================
      -- Décale à droite, remplit avec des zéros à gauche
      -- Exemple: LSR #2:  0b1010 -> 0b0010
      when "01" =>
        if shamt_int = 0 then
          temp := Src;
        else
          temp := std_logic_vector(shift_right(unsigned(Src), shamt_int));
        end if;

      -- ================================================================
      -- 10: ASR (Arithmetic Shift Right) - Décalage arithmétique à droite
      -- ================================================================
      -- Décale à droite, préserve le bit de signe (MSB)
      -- Utilisé pour diviser des nombres signés par 2^n
      -- Exemple: ASR #2:  0b1010 -> 0b1110 (préserve le signe)
      when "10" =>
        if shamt_int = 0 then
          temp := Src;
        else
          temp := std_logic_vector(shift_right(signed(Src), shamt_int));
        end if;

      -- ================================================================
      -- 11: ROR (Rotate Right) - Rotation à droite
      -- ================================================================
      -- Rotation circulaire: les bits qui sortent à droite reviennent à gauche
      -- Exemple: ROR #2:  0b1010 -> 0b1010 (rotation de 2 positions)
      when "11" =>
        if shamt_int = 0 then
          temp := Src;
        else
          temp := std_logic_vector(rotate_right(unsigned(Src), shamt_int));
        end if;

      when others =>
        temp := Src;  -- Pas de décalage
    end case;

    ShOut <= temp;
  end process;

end architecture;