library ieee;
use ieee.std_logic_1164.all;

entity fetch_unit is
  port(
    clk, reset : in  std_logic;
    PC         : out std_logic_vector(31 downto 0);
    Instr      : out std_logic_vector(31 downto 0);
    PCPlus4    : out std_logic_vector(31 downto 0);
        PCPlus8    : out std_logic_vector(31 downto 0)

  );
end entity;

architecture rtl of fetch_unit is
  signal pc_s : std_logic_vector(31 downto 0);
  signal pc_r, next_pc : std_logic_vector(31 downto 0);
    signal pc_p4, pc_p8  : std_logic_vector(31 downto 0);

begin
-- Registre PC (reset async à 0)
  U_PC : entity work.pc_reg
  --  port map(clk => clk, reset => reset, PC => pc_s);
    port map(clk => clk, reset => reset, D => next_pc, Q => pc_r);
-- Mémoire d'instruction : A = PC(6 downto 2)
  U_IM : entity work.instr_mem
    --port map(A => pc_s(6 downto 2), RD => Instr);
      port map(A => pc_r(6 downto 2), RD => Instr);
 -- PC <= pc_s;
  -- Adder PC+4
  U_ADD4 : entity work.adder
    port map(a => pc_r, b => x"00000004", y => pc_p4);

  -- Adder PC+8 (pour R15 dans le regfile)
  U_ADD8 : entity work.adder
    port map(a => pc_r, b => x"00000008", y => pc_p8);

  -- Pour l'instant, pas de branchement : on suit séquentiel
  next_pc <= pc_p4;

  -- Sorties d'observation / câblage
  PC      <= pc_r;
  PCPlus4 <= pc_p4;
  PCPlus8 <= pc_p8;

end architecture;
