 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_top_check is
end entity;

architecture sim of tb_top_check is
  -- ==== utilitaires ====
  -- SLV -> chaîne hex (padding gauche)
  function slv_to_hex(slv : std_logic_vector) return string is
    constant HEX : string := "0123456789ABCDEF";
    variable L      : integer := slv'length;
    variable N      : integer := (L + 3)/4;  -- nb de nibbles
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

  -- "0101...32b..." -> std_logic_vector(31 downto 0)
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

  -- ==== signaux TB ====
  signal clk, reset       : std_logic := '1';
  signal ALUResult_tap    : std_logic_vector(31 downto 0);
  signal ReadData_tap     : std_logic_vector(31 downto 0);
  signal dummy_Result     : std_logic_vector(31 downto 0);
  signal WriteData  : std_logic_vector(31 downto 0);
  signal PC  : std_logic_vector(31 downto 0);
  signal instr  : std_logic_vector(31 downto 0);
  signal expectedData, expectedAlu : std_logic_vector(31 downto 0);

  constant PIPE_LATENCY_CYCLES : integer := 1;  -- ajuste si besoin (fetch+decode+exec)

--  -- ==== DUT ====
--  component top_simple
--    port(
--      clk, reset     : in  std_logic;
--      Result         : out std_logic_vector(31 downto 0);
--      WriteData_tap  : out std_logic_vector(31 downto 0);
--      ALUResult_tap  : out std_logic_vector(31 downto 0);
--      ReadData_tap   : out std_logic_vector(31 downto 0)
--    );
--  end component;
  component top_simple
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
end component;
  

begin
  UUT: top_simple
    port map(
      clk            => clk,
      reset          => reset,
      Result         => dummy_Result,
      WriteData_tap  => WriteData,
      ALUResult_tap  => ALUResult_tap,
      ReadData_tap   => ReadData_tap,
      PC_out        => PC,
      Instr_out     => instr
    );

  -- Horloge : 10 ns
  clk <= not clk after 5 ns;

  -- Reset court
  process
  begin
    wait for 2 ns;
    reset <= '0'; wait;
  end process;

  -- Lecture attentes & vérification pipeline-safe
  process
    file fexp : text open read_mode is "ExpectedData.txt";
    variable L        : line;
    variable sALU     : string(1 to 32);
    variable sDATA    : string(1 to 32);
    variable ch       : character;
    variable vALU, vDATA : std_logic_vector(31 downto 0);
    variable n        : integer := 0;
  begin
    -- fin reset + un front de synchro
    wait until reset = '0';
--    wait until rising_edge(clk);

    while not endfile(fexp) loop
    wait until rising_edge(clk);
      readline(fexp, L);
      for i in 1 to 32 loop read(L, sALU(i)); end loop;
      read(L, ch); -- '_'
      for i in 1 to 32 loop read(L, sDATA(i)); end loop;

      vALU  := bin32_to_slv(sALU);
      vDATA := bin32_to_slv(sDATA);
     -- n := n + 1;
      expectedData <= vdata;
      expectedAlu <= valu;
      -- Laisser le pipeline produire la valeur du vecteur n
      --for k in 1 to PIPE_LATENCY_CYCLES loop
        
      --end loop;
     -- wait for 1 ns;  -- delta pour stabiliser

      assert ALUResult_tap = vALU
        report "Vecteur " & integer'image(n) &
               " : ALU attendu=" & sALU &
               " obtenu=0x" & slv_to_hex(ALUResult_tap)
        severity error;

      assert ReadData_tap = vDATA
        report "Vecteur " & integer'image(n) &
               " : DATA attendu=" & sDATA &
               " obtenu=0x" & slv_to_hex(ReadData_tap)
        severity error;
        
    end loop;

    report "Fin : " & integer'image(n) & " vecteurs vérifiés." severity note;
    wait;
  end process;

end architecture;
