library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_shifted_check is
end entity;

architecture sim of tb_shifted_check is
  -- ==== UTILITAIRES ====
  function slv_to_hex(slv : std_logic_vector) return string is
    constant HEX : string := "0123456789ABCDEF";
    variable L      : integer := slv'length;
    variable N      : integer := (L + 3)/4;
    variable padded : std_logic_vector(N*4-1 downto 0) := (others => '0');
    variable s      : string(1 to N);
    variable nib    : std_logic_vector(3 downto 0);
    variable v      : integer;
  begin
    padded(L-1 downto 0) := slv;
    for i in 0 to N-1 loop
      nib := padded(N*4-1 - i*4 downto N*4-4 - i*4);
      v := to_integer(unsigned(nib));
      s(i+1) := HEX(v+1);
    end loop;
    return s;
  end function;

  function bin32_to_slv(s : in string) return std_logic_vector is
    variable v : std_logic_vector(31 downto 0);
  begin
    for i in 1 to 32 loop
      if s(i) = '1' then
        v(32 - i) := '1';
      else
        v(32 - i) := '0';
      end if;
    end loop;
    return v;
  end function;

  -- ==== SIGNAUX TB ====
  signal clk, reset       : std_logic := '1';
  signal ALUResult_tap    : std_logic_vector(31 downto 0);
  signal ReadData_tap     : std_logic_vector(31 downto 0);
  signal dummy_Result     : std_logic_vector(31 downto 0);
  signal WriteData_tap    : std_logic_vector(31 downto 0);
  signal PC_out           : std_logic_vector(31 downto 0);
  signal Instr_out        : std_logic_vector(31 downto 0);
  signal expectedData, expectedAlu : std_logic_vector(31 downto 0);

  component top_simple
    port(
      clk, reset      : in  std_logic;
      Result          : out std_logic_vector(31 downto 0);
      WriteData_tap   : out std_logic_vector(31 downto 0);
      PC_out          : out std_logic_vector(31 downto 0);
      Instr_out       : out std_logic_vector(31 downto 0);
      ALUResult_tap   : out std_logic_vector(31 downto 0);
      ReadData_tap    : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  -- ==== INSTANCIATION DUT ====
  UUT: top_simple
    port map(
      clk            => clk,
      reset          => reset,
      Result         => dummy_Result,
      WriteData_tap  => WriteData_tap,
      ALUResult_tap  => ALUResult_tap,
      ReadData_tap   => ReadData_tap,
      PC_out         => PC_out,
      Instr_out      => Instr_out
    );

  -- ==== HORLOGE : 10 ns ====
  clk <= not clk after 5 ns;

  -- ==== RESET COURT ====
  process
  begin
    wait for 2 ns;
    reset <= '0'; 
    wait;
  end process;

  -- ==== LECTURE ATTENDUES & VERIFICATION ====
  process
    file fexp : text open read_mode is "ExpectedData_SHIFTED.txt";
    variable L        : line;
    variable sALU     : string(1 to 32);
    variable sDATA    : string(1 to 32);
    variable ch       : character;
    variable vALU, vDATA : std_logic_vector(31 downto 0);
    variable n        : integer := 0;
    variable errCount : integer := 0;
  begin
    wait until reset = '0';
    
    report "========================================" severity note;
    report "  DEBUT DES TESTS SHIFTED REGISTER" severity note;
    report "========================================" severity note;

    while not endfile(fexp) loop
      wait until rising_edge(clk);
      
      readline(fexp, L);
      
      for i in 1 to 32 loop 
        read(L, sALU(i)); 
      end loop;
      read(L, ch);
      for i in 1 to 32 loop 
        read(L, sDATA(i)); 
      end loop;

      vALU  := bin32_to_slv(sALU);
      vDATA := bin32_to_slv(sDATA);
      
      n := n + 1;
      expectedData <= vDATA;
      expectedAlu  <= vALU;

      if ALUResult_tap /= vALU then
        report "ERREUR Vecteur " & integer'image(n) &
               " : ALU attendu=0x" & slv_to_hex(vALU) &
               " obtenu=0x" & slv_to_hex(ALUResult_tap) &
               " | PC=0x" & slv_to_hex(PC_out) &
               " | Instr=0x" & slv_to_hex(Instr_out)
        severity error;
        errCount := errCount + 1;
      else
        report "OK Vecteur " & integer'image(n) &
               " : ALU=0x" & slv_to_hex(ALUResult_tap) &
               " | PC=0x" & slv_to_hex(PC_out)
        severity note;
      end if;

      if ReadData_tap /= vDATA then
        report "ERREUR Vecteur " & integer'image(n) &
               " : DATA attendu=0x" & slv_to_hex(vDATA) &
               " obtenu=0x" & slv_to_hex(ReadData_tap)
        severity error;
        errCount := errCount + 1;
      end if;
        
    end loop;

    report "========================================" severity note;
    report "  FIN DES TESTS SHIFTED REGISTER" severity note;
    report "  Vecteurs vérifiés : " & integer'image(n) severity note;
    report "  Erreurs trouvées  : " & integer'image(errCount) severity note;
    
    if errCount = 0 then
      report "  *** TOUS LES TESTS ONT REUSSI ***" severity note;
    else
      report "  *** ECHEC : " & integer'image(errCount) & " ERREUR(S) ***" severity error;
    end if;
    
    report "========================================" severity note;
    wait;
  end process;

end architecture;