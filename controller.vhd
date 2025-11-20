--library IEEE;
--use IEEE.STD_LOGIC_1164.all;

--entity controller is
--  port(
--    clk, reset  : in  std_logic;                          -- reset pas utilisé ici
--    Instruction : in  std_logic_vector(31 downto 0);
--    ALUFlags    : in  std_logic_vector(3 downto 0);       -- pour plus tard (condlogic)

--    -- vers datapath
--    RegWrite    : out std_logic;
--    RegSrc      : out std_logic_vector(1 downto 0);
--    ALUSrc      : out std_logic;
--    MemWrite    : out std_logic;
--    MemtoReg    : out std_logic;
--    ImmSrc      : out std_logic_vector(1 downto 0);
--    ALUControl  : out std_logic_vector(1 downto 0);
--    -- nouveau : masque d'écriture des flags issu d'aludec (10=NZ, 11=NZCV)
--        FlagW_out    : out std_logic_vector(1 downto 0)
--  );
--end entity;

--architecture rtl of controller is
--  -- Champs instruction
--  signal Op       : std_logic_vector(1 downto 0);
--  signal Funct5   : std_logic;
--  signal Funct0   : std_logic;
--  signal Funct50  : std_logic_vector(4 downto 0);

--  -- Lien entre décodeurs
--  signal ALUOp    : std_logic;

--  -- internes du main decoder
--  signal Branch_i : std_logic;              -- ignoré ici (pas de PC)
--  signal RegW_i   : std_logic;
--  signal MemW_i   : std_logic;
--  signal FlagW    : std_logic_vector(1 downto 0);  -- à câbler plus tard si condlogic
--begin
--  -- Extraction des champs (mêmes positions que ton schéma)
--  Op      <= Instruction(27 downto 26);
--  Funct5  <= Instruction(25);
--  Funct0  <= Instruction(20);
--  Funct50 <= Instruction(24 downto 20);   -- [4:1]=cmd, [0]=S

--  -- Décodeur principal
--  U_MAIN: entity work.Decodeur_Principal
--    port map(
--      Op       => Op,
--      Funct5   => Funct5,
--      Funct0   => Funct0,
--      Branch   => Branch_i,
--      MemtoReg => MemtoReg,
--      MemW     => MemW_i,
--      ALUSrc   => ALUSrc,
--      ImmSrc   => ImmSrc,
--      RegW     => RegW_i,
--      RegSrc   => RegSrc,       -- ATTENTION : RegSrc(0) pilote RA1 (Rn/Rd) et RegSrc(1) pilote RA2 (Rm/Rd) dans ton datapath
--      ALUOp    => ALUOp
--    );

--  -- Décodeur ALU
--  U_ALUDEC: entity work.aludec
--    port map(
--      ALUOp      => ALUOp,
--      Funct      => Funct50,         -- [4:1]=cmd, [0]=S
--      ALUControl => ALUControl,      -- 00=ADD, 01=SUB, 10=AND, 11=ORR
--      FlagW      => FlagW            -- non utilisé pour l'instant
--    );

--  -- Pas d'exécution conditionnelle/branchements ici ? direct
--  RegWrite <= RegW_i;
--  MemWrite <= MemW_i;
--   FlagW_out <= FlagW; 
--  -- Branch_i irait à PCSrc si tu avais un PC; ici on l'ignore.
--end architecture;




library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controller is
  port(
    clk, reset  : in  std_logic;
    Instruction : in  std_logic_vector(31 downto 0);
    ALUFlags    : in  std_logic_vector(3 downto 0);

    -- vers datapath
    RegWrite    : out std_logic;
    RegSrc      : out std_logic_vector(1 downto 0);
    ALUSrc      : out std_logic;
    MemWrite    : out std_logic;
    MemtoReg    : out std_logic;
    ImmSrc      : out std_logic_vector(1 downto 0);
    ALUControl  : out std_logic_vector(1 downto 0);
    FlagW_out   : out std_logic_vector(1 downto 0)
  );
end entity;

architecture rtl of controller is
  -- Champs instruction
  signal Op       : std_logic_vector(1 downto 0);
  signal Funct5   : std_logic;
  signal Funct0   : std_logic;
  signal Funct50  : std_logic_vector(4 downto 0);

  -- Lien entre décodeurs
  signal ALUOp    : std_logic;

  -- internes du main decoder
  signal Branch_i : std_logic;
  signal RegW_i   : std_logic;
  signal MemW_i   : std_logic;
  signal FlagW    : std_logic_vector(1 downto 0);
  
  -- *** NOUVEAU : Signal NoWrite depuis aludec ***
  signal NoWrite_s : std_logic;
  
  -- Signal RegWrite effectif (après masquage par NoWrite)
  signal RegWrite_eff : std_logic;
  
begin
  -- Extraction des champs
  Op      <= Instruction(27 downto 26);
  Funct5  <= Instruction(25);
  Funct0  <= Instruction(20);
  Funct50 <= Instruction(24 downto 20);

  -- Décodeur principal
  U_MAIN: entity work.Decodeur_Principal
    port map(
      Op       => Op,
      Funct5   => Funct5,
      Funct0   => Funct0,
      Branch   => Branch_i,
      MemtoReg => MemtoReg,
      MemW     => MemW_i,
      ALUSrc   => ALUSrc,
      ImmSrc   => ImmSrc,
      RegW     => RegW_i,
      RegSrc   => RegSrc,
      ALUOp    => ALUOp
    );

  -- Décodeur ALU (avec support CMP)
  U_ALUDEC: entity work.aludec
    port map(
      ALUOp      => ALUOp,
      Funct      => Funct50,
      ALUControl => ALUControl,
      FlagW      => FlagW,
      NoWrite    => NoWrite_s        -- *** NOUVEAU ***
    );

  -- *** LOGIQUE DE MASQUAGE POUR CMP ***
  -- Si NoWrite='1' (CMP), forcer RegWrite à '0'
  RegWrite_eff <= RegW_i and (not NoWrite_s);
  
  -- Sorties
  RegWrite <= RegWrite_eff;  -- *** Utiliser la version masquée ***
  MemWrite <= MemW_i;
  FlagW_out <= FlagW; 
  
end architecture;