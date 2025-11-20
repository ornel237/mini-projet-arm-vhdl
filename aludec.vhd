
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

---- Décodeur ALU selon ton tableau
---- Entrées :
----   ALUOp      : '1' = Data Processing ; '0' = pas DP
----   Funct(4:1) : code opération (0100=ADD, 0010=SUB, 0000=AND, 1100=ORR)
----   Funct(0)   : S bit (mettre à jour flags ?)
---- Sorties :
----   ALUControl(1:0) : 00=ADD, 01=SUB, 10=AND, 11=ORR
----   FlagW(1:0)      : 00=aucun flag, 10=NZ, 11=NZCV

--entity aludec is
--port(
--    ALUOp       : in  std_logic;
--    Funct       : in  std_logic_vector(4 downto 0); -- [4:1]=cmd, [0]=S
--    ALUControl  : out std_logic_vector(1 downto 0);
--    FlagW       : out std_logic_vector(1 downto 0)
--  );
--end aludec;

--architecture Behavioral of aludec is
--signal cmd : std_logic_vector(3 downto 0); -- Funct(4:1)
--  signal S   : std_logic;                    -- Funct(0)
--begin

-- cmd <= Funct(4 downto 1);
--  S   <= Funct(0);

--  process(ALUOp, cmd, S, funct)
--  begin


--    if ALUOp = '1' then
--      -- On est en Data Processing -> décoder l'opération
--      case cmd is
--        when "0100" =>          -- ADD
--          ALUControl <= "00";
--          if S = '1' then
--            FlagW <= "11";      -- NZ + CV
--          end if;

--        when "0010" =>          -- SUB
--          ALUControl <= "01";
--          if S = '1' then
--            FlagW <= "11";      -- NZ + CV
--          end if;

--        when "0000" =>          -- AND
--          ALUControl <= "10";
--          if S = '1' then
--            FlagW <= "10";      -- NZ seulement
--          end if;

--        when "1100" =>          -- ORR
--          ALUControl <= "11";
--          if S = '1' then
--            FlagW <= "10";      -- NZ seulement
--          end if;

--        when others =>
--          -- instruction non supportée : garder les défauts
--          null;
--      end case;
--      else
--          -- valeurs par défaut (ALUOp=0 ou cas inconnus)
--      ALUControl <= "00";  -- par défaut: ADD
--      FlagW      <= "00";  -- pas de mise à jour des flags
--    end if;
--  end process;
  
--end Behavioral;






library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Décodeur ALU avec support pour CMP
-- Entrées :
--   ALUOp      : '1' = Data Processing ; '0' = pas DP
--   Funct(4:1) : code opération (0100=ADD, 0010=SUB, 0000=AND, 1100=ORR, 1010=CMP)
--   Funct(0)   : S bit (mettre à jour flags ?)
-- Sorties :
--   ALUControl(1:0) : 00=ADD, 01=SUB, 10=AND, 11=ORR
--   FlagW(1:0)      : 00=aucun flag, 10=NZ, 11=NZCV
--   NoWrite         : 1=ne pas écrire dans le registre (pour CMP)

entity aludec is
  port(
    ALUOp       : in  std_logic;
    Funct       : in  std_logic_vector(4 downto 0); -- [4:1]=cmd, [0]=S
    ALUControl  : out std_logic_vector(1 downto 0);
    FlagW       : out std_logic_vector(1 downto 0);
    NoWrite     : out std_logic                      -- *** NOUVEAU pour CMP ***
  );
end aludec;

architecture Behavioral of aludec is
  signal cmd : std_logic_vector(3 downto 0); -- Funct(4:1)
  signal S   : std_logic;                    -- Funct(0)
begin

  cmd <= Funct(4 downto 1);
  S   <= Funct(0);

  process(ALUOp, cmd, S, funct)
  begin
    -- Valeurs par défaut
    ALUControl <= "00";  -- ADD par défaut
    FlagW      <= "00";  -- pas de mise à jour des flags
    NoWrite    <= '0';   -- écriture normale dans le registre

    if ALUOp = '1' then
      -- On est en Data Processing -> décoder l'opération
      case cmd is
        when "0100" =>          -- ADD
          ALUControl <= "00";
          NoWrite    <= '0';
          if S = '1' then
            FlagW <= "11";      -- NZ + CV
          end if;

        when "0010" =>          -- SUB
          ALUControl <= "01";
          NoWrite    <= '0';
          if S = '1' then
            FlagW <= "11";      -- NZ + CV
          end if;

        when "0000" =>          -- AND
          ALUControl <= "10";
          NoWrite    <= '0';
          if S = '1' then
            FlagW <= "10";      -- NZ seulement
          end if;

        when "1100" =>          -- ORR
          ALUControl <= "11";
          NoWrite    <= '0';
          if S = '1' then
            FlagW <= "10";      -- NZ seulement
          end if;

        -- *** NOUVEAU : Support pour CMP ***
        when "1010" =>          -- CMP (Compare)
          ALUControl <= "01";   -- SUB operation
          NoWrite    <= '1';    -- *** NE PAS écrire le résultat ***
          FlagW      <= "11";   -- Toujours mettre à jour NZCV (S=1 implicite)
          -- Note: CMP a toujours S=1, donc on ignore le bit S

        when others =>
          -- instruction non supportée : garder les défauts
          null;
      end case;
    end if;
  end process;
  
end Behavioral;
