--library ieee;
--use ieee.std_logic_1164.all;

--entity datapath is
--  port(
--    clk         : in  std_logic;
--    Instruction : in  std_logic_vector(31 downto 0);

--    RegWrite    : in  std_logic;
--    RegSrc      : in  std_logic_vector(1 downto 0);
--    ALUSrc      : in  std_logic;
--    MemWrite    : in  std_logic;
--    MemtoReg    : in  std_logic;
--    ImmSrc      : in  std_logic_vector(1 downto 0);
--    ALUControl  : in  std_logic_vector(1 downto 0);
--    R15_in      : in  std_logic_vector(31 downto 0);  -- <<< NOUVEAU (PC+8)
--    ALUFlags    : out std_logic_vector(3 downto 0); -- NZCV
--    Result      : out std_logic_vector(31 downto 0); -- après MUX final
--    ALUResult_tap : out std_logic_vector(31 downto 0);
--    ReadData_tap  : out std_logic_vector(31 downto 0);
--   WriteData_tap : out std_logic_vector(31 downto 0)
--  );
--end entity;

--architecture rtl of datapath is
--  -- Adresses de registres
--  signal RA1, RA2, A3 : std_logic_vector(3 downto 0);

--  -- Bus internes
--  signal RD1, RD2, WD3         : std_logic_vector(31 downto 0);
--  signal SrcA, SrcB            : std_logic_vector(31 downto 0);
--  signal ExtImm                : std_logic_vector(31 downto 0);
--  signal ALUResult, ReadData   : std_logic_vector(31 downto 0);
-- -- signal WriteData_tap   : std_logic_vector(31 downto 0);
 
--  -- Flags individuels de l'ALU
--  signal Nf, Zf, Cf, Vf : std_logic;
--begin
--  -- Sélection des adresses selon RegSrc (bit1 pour RA1, bit0 pour RA2)
--  --RA1 <= Instruction(19 downto 16) when RegSrc(1)='0' else Instruction(15 downto 12);
--  --RA2 <= Instruction(3  downto 0 ) when RegSrc(0)='0' else Instruction(15 downto 12);
  
--  -- RA1 : 0 -> Rn (19:16), 1 -> Rd (15:12)   [piloté par RegSrc(0)]
--  RA1 <= Instruction(19 downto 16) when RegSrc(0)='0' else Instruction(15 downto 12);
  
--  -- RA2 : 0 -> Rm (3:0),   1 -> Rd (15:12)   [piloté par RegSrc(1)]
--  RA2 <= Instruction(3  downto 0 ) when RegSrc(1)='0' else Instruction(15 downto 12);

--  A3  <= Instruction(15 downto 12);

--  -- Banque de registres
--  U_REGS: entity work.regfile
--    port map(
--      clk      => clk,
--      RegWrite => RegWrite,
--      RA1      => RA1,
--      RA2      => RA2,
--      A3       => A3,
--      WD3      => WD3,
--      --R15      => (others => '0'),
--       R15      => R15_in,    -- <<< au lieu de (others => '0')
--      RD1      => RD1,
--      RD2      => RD2
--    );

--  -- Extend
--  U_EXT: entity work.extend
--    port map(
--      instr  => Instruction(23 downto 0),
--      ImmSrc => ImmSrc,
--      ExtImm => ExtImm
--    );

--  -- Sélection entrée B de l'ALU
--  SrcA <= RD1;
--  SrcB <= RD2 when ALUSrc='0' else ExtImm;

--  -- ALU (ton module)
--  U_ALU: entity work.ALU
--    generic map (N => 32)
--    port map(
--      A          => SrcA,
--      B          => SrcB,
--      ALUControl => ALUControl,   -- 00 ADD, 01 SUB, 10 AND, 11 OR
--      Result     => ALUResult,
--      Nflag      => Nf,
--      Zflag      => Zf,
--      Cflag      => Cf,
--      Vflag      => Vf
     
--    );
--  ALUFlags <= Nf & Zf & Cf & Vf;  -- ordre NZCV (peu importe pour ce labo)

--  -- Mémoire de données
--  U_DMEM: entity work.data_mem
--    port map(
--      clk      => clk,
--      MemWrite => MemWrite,
--      A        => ALUResult,
--      WD       => RD2,        -- WriteData
--      RD       => ReadData
--    );

--  -- Mux final vers registre destination et "Result" observable
--  WD3    <= ReadData when MemtoReg='1' else ALUResult;
--  --Result <= WD3;
--  Result <= WD3;
--  WriteData_tap <= RD2;
--  ALUResult_tap <= ALUResult;
--  ReadData_tap  <= ReadData;

--end architecture;







library ieee;
use ieee.std_logic_1164.all;

entity datapath is
  port(
    clk         : in  std_logic;
    Instruction : in  std_logic_vector(31 downto 0);

    RegWrite    : in  std_logic;
    RegSrc      : in  std_logic_vector(1 downto 0);
    ALUSrc      : in  std_logic;
    MemWrite    : in  std_logic;
    MemtoReg    : in  std_logic;
    ImmSrc      : in  std_logic_vector(1 downto 0);
    ALUControl  : in  std_logic_vector(1 downto 0);
    R15_in      : in  std_logic_vector(31 downto 0);  -- PC+8
    
    ALUFlags    : out std_logic_vector(3 downto 0);   -- NZCV
    Result      : out std_logic_vector(31 downto 0);  -- Résultat final
    ALUResult_tap : out std_logic_vector(31 downto 0);
    ReadData_tap  : out std_logic_vector(31 downto 0);
    WriteData_tap : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of datapath is
  -- Adresses de registres
  signal RA1, RA2, A3 : std_logic_vector(3 downto 0);

  -- Bus internes
  signal RD1, RD2, WD3         : std_logic_vector(31 downto 0);
  signal SrcA, SrcB            : std_logic_vector(31 downto 0);
  signal ExtImm                : std_logic_vector(31 downto 0);
  signal ALUResult, ReadData   : std_logic_vector(31 downto 0);
  
  -- *** NOUVEAU : Signaux pour le shifter ***
  signal RD2_shifted           : std_logic_vector(31 downto 0);  -- Sortie du shifter
  signal Shamt5                : std_logic_vector(4 downto 0);   -- Quantité de décalage
  signal Sh                    : std_logic_vector(1 downto 0);   -- Type de décalage
  
  -- Flags individuels de l'ALU
  signal Nf, Zf, Cf, Vf : std_logic;
  
begin
  -- ===================================================================
  -- Extraction des champs de l'instruction pour le shifter
  -- ===================================================================
  Shamt5 <= Instruction(11 downto 7);  -- Bits 11-7: quantité de décalage
  Sh     <= Instruction(6 downto 5);   -- Bits 6-5: type de décalage
  
  -- ===================================================================
  -- Sélection des adresses selon RegSrc
  -- ===================================================================
  -- RA1 : 0 -> Rn (19:16), 1 -> Rd (15:12)   [piloté par RegSrc(0)]
  RA1 <= Instruction(19 downto 16) when RegSrc(0)='0' else Instruction(15 downto 12);
  
  -- RA2 : 0 -> Rm (3:0),   1 -> Rd (15:12)   [piloté par RegSrc(1)]
  RA2 <= Instruction(3  downto 0 ) when RegSrc(1)='0' else Instruction(15 downto 12);

  A3  <= Instruction(15 downto 12);

  -- ===================================================================
  -- Banque de registres
  -- ===================================================================
  U_REGS: entity work.regfile
    port map(
      clk      => clk,
      RegWrite => RegWrite,
      RA1      => RA1,
      RA2      => RA2,
      A3       => A3,
      WD3      => WD3,
      R15      => R15_in,
      RD1      => RD1,
      RD2      => RD2
    );

  -- ===================================================================
  -- *** NOUVEAU : Shifter (Barrel Shifter) ***
  -- ===================================================================
  -- Le shifter prend RD2 (deuxième opérande registre) et applique
  -- le décalage/rotation spécifié dans l'instruction
  U_SHIFTER: entity work.shifter
    port map(
      Src    => RD2,          -- Entrée: valeur du registre Rm
      Shamt5 => Shamt5,       -- Quantité de décalage (bits 11-7)
      Sh     => Sh,           -- Type de décalage (bits 6-5)
      ShOut  => RD2_shifted   -- Sortie: valeur décalée
    );

  -- ===================================================================
  -- Extension d'immédiat
  -- ===================================================================
  U_EXT: entity work.extend
    port map(
      instr  => Instruction(23 downto 0),
      ImmSrc => ImmSrc,
      ExtImm => ExtImm
    );

  -- ===================================================================
  -- Sélection des opérandes de l'ALU
  -- ===================================================================
  SrcA <= RD1;
  
  -- *** MODIFICATION : Utiliser RD2_shifted au lieu de RD2 ***
  -- Si ALUSrc=0: utiliser le registre (avec décalage appliqué)
  -- Si ALUSrc=1: utiliser l'immédiat (pas de décalage)
  SrcB <= RD2_shifted when ALUSrc='0' else ExtImm;

  -- ===================================================================
  -- ALU
  -- ===================================================================
  U_ALU: entity work.ALU
    generic map (N => 32)
    port map(
      A          => SrcA,
      B          => SrcB,
      ALUControl => ALUControl,
      Result     => ALUResult,
      Nflag      => Nf,
      Zflag      => Zf,
      Cflag      => Cf,
      Vflag      => Vf
    );
    
  ALUFlags <= Nf & Zf & Cf & Vf;

  -- ===================================================================
  -- Mémoire de données
  -- ===================================================================
  U_DMEM: entity work.data_mem
    port map(
      clk      => clk,
      MemWrite => MemWrite,
      A        => ALUResult,
      WD       => RD2,        -- WriteData (non décalé pour STR)
      RD       => ReadData
    );

  -- ===================================================================
  -- Mux final vers registre destination
  -- ===================================================================
  WD3    <= ReadData when MemtoReg='1' else ALUResult;
  Result <= WD3;
  
  -- Signaux de tap pour testbench
  WriteData_tap <= RD2;
  ALUResult_tap <= ALUResult;
  ReadData_tap  <= ReadData;

end architecture;