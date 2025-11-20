library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Flags attendus au format NZCV :
-- Flags(3)=N, Flags(2)=Z, Flags(1)=C, Flags(0)=V

entity condcheck is
  port(
    Cond   : in  std_logic_vector(3 downto 0);  -- instr(31 downto 28)
    Flags  : in  std_logic_vector(3 downto 0);  -- NZCV stockés
    CondEx : out std_logic                      -- 1 si condition satisfaite
  );
end entity;

architecture rtl of condcheck is
  signal neg, zero, carry, overflow, ge : std_logic;
begin
  -- Dépaquetage des flags (NZCV)
  neg      <= Flags(3);
  zero     <= Flags(2);
  carry    <= Flags(1);
  overflow <= Flags(0);
  ge       <= not(neg xor overflow);  -- N == V

  -- VHDL-93 : liste de sensibilité explicite
  process(Cond, neg, zero, carry, overflow, ge)
  begin
    case Cond is
      when "0000" => CondEx <= zero;                            -- EQ
      when "0001" => CondEx <= not zero;                        -- NE
      when "0010" => CondEx <= carry;                           -- CS/HS
      when "0011" => CondEx <= not carry;                       -- CC/LO
      when "0100" => CondEx <= neg;                             -- MI
      when "0101" => CondEx <= not neg;                         -- PL
      when "0110" => CondEx <= overflow;                        -- VS
      when "0111" => CondEx <= not overflow;                    -- VC
      when "1000" => CondEx <= carry and (not zero);            -- HI
      when "1001" => CondEx <= not(carry and (not zero));       -- LS
      when "1010" => CondEx <= ge;                              -- GE
      when "1011" => CondEx <= not ge;                          -- LT
      when "1100" => CondEx <= (not zero) and ge;               -- GT
      when "1101" => CondEx <= not((not zero) and ge);          -- LE
      when "1110" => CondEx <= '1';                             -- AL (toujours)
      when others => CondEx <= '0';                             -- réservé
    end case;
    
  end process;
end architecture;
