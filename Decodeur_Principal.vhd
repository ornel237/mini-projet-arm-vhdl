
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ? ENTITÉ : "Decodeur_Principal" (main decoder = décodeur principal)
-- Ce bloc lit quelques bits de l'instruction (Op, Funct5, Funct0)
-- et décide quel type d'action le processeur doit faire :
-- est-ce une addition ? une lecture mémoire ? un branchement ? etc.

entity Decodeur_Principal is
  port(
  Op       : in  std_logic_vector(1 downto 0);  -- les 2 bits principaux du type d'instruction
  Funct5   : in  std_logic;                     -- bit 5 de "Funct", pour préciser DP Reg ou DP Imm
  Funct0   : in  std_logic;                     -- bit 0 de "Funct", pour différencier LDR ou STR
  Branch   : out std_logic;                     -- indique si c'est une instruction de branchement
  MemtoReg : out std_logic;                     -- indique si le résultat vient de la mémoire (LDR)
  MemW     : out std_logic;                     -- indique si on écrit dans la mémoire (STR)
  ALUSrc   : out std_logic;                     -- sélectionne la 2e entrée de l'ALU (registre ou immédiat)
  ImmSrc   : out std_logic_vector(1 downto 0);  -- indique le type d'immédiat à générer (00, 01, 10)
  RegW     : out std_logic;                     -- autorise l'écriture dans un registre
  RegSrc   : out std_logic_vector(1 downto 0);  -- détermine les sources de lecture des registres
  ALUOp    : out std_logic                      -- indique si le décodage ALU détaillé doit être activé
);
end Decodeur_Principal;

architecture Behavioral of Decodeur_Principal is

begin

 process (Op, Funct5, Funct0)
 begin
    --------------------------------------------------------------------
    -- ? Étape 1 : On donne des valeurs par défaut à toutes les sorties.
    -- C'est comme si on "remettait tout à zéro" avant de décider quoi faire.
    --------------------------------------------------------------------
--    Branch   <= '0';
--    MemtoReg <= '0';
--    MemW     <= '0';
--    ALUSrc   <= '0';
--    ImmSrc   <= "00";
--    RegW     <= '0';
--    RegSrc   <= "00";
--    ALUOp    <= '0';

    --------------------------------------------------------------------
    -- ? Étape 2 : On regarde la valeur des deux bits "Op"
    -- pour déterminer le grand type d'instruction :
    --   "00" ? Data Processing (calculs)
    --   "01" ? Load/Store (accès mémoire)
    --   "10" ? Branch (saut dans le programme)
    --------------------------------------------------------------------
    case Op is

      -------------------------------------------------------------------
      -- ? CAS 1 : Op = "00" ? Data Processing (ADD, SUB, AND, ORR, etc.)
      -------------------------------------------------------------------
      when "00" =>
        ALUOp <= '1';  -- on active le décodeur de l'ALU
        RegW  <= '1';  -- on écrira dans un registre (le résultat du calcul)

        -- On regarde le bit Funct5 pour savoir si c'est avec un registre ou un immédiat
        if Funct5 = '0' then
          ----------------------------------------------------------------
          -- ? Sous-cas : Funct5 = 0 ? DP Reg (ex: ADD R1, R2, R3)
          ----------------------------------------------------------------
          ALUSrc <= '0';   -- la deuxième entrée de l'ALU vient d'un registre (pas d'un immédiat)
          RegSrc <= "00";  -- on lit les registres normalement
          ImmSrc <= "00";  -- pas d'immédiat particulier
          branch <= '0';
          memtoreg <= '0';
          memw <= '0';
          -- exemple : ADD, SUB entre registres

        else
          ----------------------------------------------------------------
          -- ? Sous-cas : Funct5 = 1 ? DP Imm (ex: ADD R1, R2, #5)
          ----------------------------------------------------------------
          ALUSrc <= '1';   -- la deuxième entrée de l'ALU vient d'un immédiat (et pas d'un registre)
          RegSrc <= "00";  -- on ignore un des bits, car pas utile ici
          ImmSrc <= "00";  -- immédiat classique pour data processing
          branch <='0';
          memtoreg <= '0';
          memw <= '0';
          
          -- exemple : ADD R1, R2, #5
        end if;

      -------------------------------------------------------------------
      -- ? CAS 2 : Op = "01" ? Instructions mémoire (LDR ou STR)
      -------------------------------------------------------------------
      when "01" =>
        ALUSrc <= '1';   -- on ajoute un offset immédiat à une adresse
        ImmSrc <= "01";  -- type d'immédiat pour le décalage mémoire
        aluop <='0';
--        RegW   <= '1';   -- en général, on écrit dans un registre (LDR) - sauf pour STR, on le corrige ensuite

        -- On regarde Funct0 pour savoir si c'est un LDR ou un STR
        if Funct0 = '0' then
          ---------------------------------------------------------------
          -- ? Sous-cas : Funct0 = 0 ? STR (Store)
          ---------------------------------------------------------------
          MemW     <= '1';  -- on écrit dans la mémoire
          RegSrc   <= "10"; -- on lit deux registres : l'adresse et la donnée à stocker
          RegW   <= '0';
          branch <= '0';
          memtoreg <= '0';
          
          -- Exemple : STR R2, [R0, #4]

        else
          ---------------------------------------------------------------
          -- ? Sous-cas : Funct0 = 1 ? LDR (Load)
          ---------------------------------------------------------------
          MemtoReg <= '1';  -- la donnée vient de la mémoire
          RegSrc   <= "00"; -- peu importe le second registre ici
          RegW   <= '1';
          branch <= '0';
          memw <= '0';
          
          -- Exemple : LDR R2, [R0, #4]
        end if;

      -------------------------------------------------------------------
      -- ? CAS 3 : Op = "10" ? Branch (B label)
      -------------------------------------------------------------------
--      when "10" =>
--        Branch <= '1';   -- on dit au PC de changer d'adresse
--        ImmSrc <= "10";  -- type d'immédiat pour les branches (24 bits)
--        RegW   <= '0';   -- on n'écrit pas dans un registre
--        ALUOp  <= '0';   -- pas besoin d'opération ALU spéciale
--        -- Exemple : B boucle

      -------------------------------------------------------------------
      -- ? CAS PAR DÉFAUT : si Op est inconnu
      -------------------------------------------------------------------
      when others =>
        -- rien à faire, tout reste à zéro (instruction non reconnue)
        null;
    end case;
  end process;
  
end Behavioral;




