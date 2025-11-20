library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top_simple is
  port(
    clk, reset   : in  std_logic;
    --Instruction  : in  std_logic_vector(31 downto 0);  -- injectée depuis TB
    Result       : out std_logic_vector(31 downto 0);   -- pour observer
    WriteData_tap : out std_logic_vector(31 downto 0);
    -- (optionnel) exposer PC/Instr pour la simu :
      PC_out    : out std_logic_vector(31 downto 0);
       Instr_out : out std_logic_vector(31 downto 0);
         ALUResult_tap   : out std_logic_vector(31 downto 0); -- <<< NEW
          ReadData_tap    : out std_logic_vector(31 downto 0)  -- <<< NEW
  );
end entity;

architecture rtl of top_simple is
  signal RegWrite   : std_logic;
  signal RegSrc     : std_logic_vector(1 downto 0);
  signal ALUSrc     : std_logic;
  signal MemWrite   : std_logic;
  signal MemtoReg   : std_logic;
  signal ImmSrc     : std_logic_vector(1 downto 0);
  signal ALUControl : std_logic_vector(1 downto 0);
  signal ALUFlags   : std_logic_vector(3 downto 0); -- NZCV instantanés (depuis ALU)
-- signaux
  signal FlagW_s     : std_logic_vector(1 downto 0); -- 10=NZ, 11=NZCV (depuis aludec)
  signal Flags_stored: std_logic_vector(3 downto 0);-- NZCV mémorisés
  signal FlagWrite_s : std_logic_vector(1 downto 0);  -- masque effectif de write
  signal CondEx      : std_logic;
   -- Contrôles réellement appliqués au datapath (masqués par CondEx)
   signal RegWrite_eff   : std_logic;
   signal MemWrite_eff   : std_logic;
    -- Contrôles issus du contrôleur (avant masquage)
    signal RegWrite_i   : std_logic;
    signal MemWrite_i   : std_logic;
    --signal PC_s, Instr_s : std_logic_vector(31 downto 0);
    signal Instr_s, PC_s, PCPlus4_s, PCPlus8_s : std_logic_vector(31 downto 0);

begin
-- provisoirement, exécuter toutes les instructions
  --CondEx <= '1';
U_FETCH : entity work.fetch_unit
  port map(
    clk   => clk,
    reset => reset,
    PC    => PC_s,
    Instr => Instr_s,
    PCPlus4 => PCPlus4_s,
          PCPlus8 => PCPlus8_s
  );

---------------------------------------------------------------------------
  -- 1) Décodeurs (principal + aludec) regroupés dans 'controller'
  ---------------------------------------------------------------------------
  U_CTRL: entity work.controller
    port map(
      clk         => clk,
      reset       => reset,
      Instruction => Instr_s,
      ALUFlags    => ALUFlags,  -- pas utilisé par le décodage, mais dispo si tu fais condlogic dans controller
      RegWrite    => RegWrite,
      RegSrc      => RegSrc,
      ALUSrc      => ALUSrc,
      MemWrite    => MemWrite,
      MemtoReg    => MemtoReg,
      ImmSrc      => ImmSrc,
      ALUControl  => ALUControl,
      FlagW_out   => FlagW_s       -- <-- récupéré ici

    );
    ---------------------------------------------------------------------------
      -- 2) Registres de flags (Ex.1) + Condition Check (Ex.2)
      ---------------------------------------------------------------------------
    U_FLAGS: entity work.flag_regs
      port map(
        clk       => clk,
        reset     => reset,
        CondEx    => CondEx, -- écriture des flags autorisée seulement si l'instruction s'exécute
        FlagW     => FlagW_s,
        ALUFlags  => ALUFlags,        -- flags instantanés de l'ALU
        FlagsOut  => Flags_stored,    -- flags mémorisés (à donner au Condition Check)
        FlagWrite => FlagWrite_s
      );
        U_COND: entity work.condcheck
          port map(
            Cond   =>Instr_s(31 downto 28),  -- bits de condition de l'instruction
            Flags  => Flags_stored,               -- flags stockés NZCV
            CondEx => CondEx
          );
        -- Masquage des écritures par CondEx (figure 2)
        RegWrite_eff <= RegWrite_i and CondEx;
        MemWrite_eff <= MemWrite_i and CondEx;
 ---------------------------------------------------------------------------
  -- 3) Datapath
  ---------------------------------------------------------------------------
  U_DP: entity work.datapath
    port map(
      clk         => clk,
      Instruction => Instr_s,
      RegWrite    => RegWrite,
      RegSrc      => RegSrc,
      ALUSrc      => ALUSrc,
      MemWrite    => MemWrite,
      MemtoReg    => MemtoReg,
      ImmSrc      => ImmSrc,
      ALUControl  => ALUControl,
       R15_in      => PCPlus8_s,         -- <<< important
      ALUFlags    => ALUFlags,
      Result      => Result,
       ALUResult_tap  => ALUResult_tap,   -- <<< NEW
       ReadData_tap   => ReadData_tap ,    -- <<< NEW
       WriteData_tap => WriteData_tap
    );
    Instr_out <= instr_s;
    PC_out <=PC_s;
end architecture;
