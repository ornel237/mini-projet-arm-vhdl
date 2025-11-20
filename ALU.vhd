-- ALU.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  generic (N : integer := 32);
  port (
    A, B       : in  std_logic_vector(N-1 downto 0);
    ALUControl : in  std_logic_vector(1 downto 0);  -- 00 ADD, 01 SUB, 10 AND, 11 OR
    Result     : out std_logic_vector(N-1 downto 0);
    Nflag      : out std_logic;  -- Negative
    Zflag      : out std_logic;  -- Zero
    Cflag      : out std_logic;  -- Carry
    Vflag      : out std_logic   -- Overflow
  );
end entity;

architecture structural of ALU is
  -- Composants (ou utilise instantiation directe entity work.<name>)
  component mux4
    generic (N : integer := 32);
    port (d0,d1,d2,d3 : in std_logic_vector(N-1 downto 0);
          sel         : in std_logic_vector(1 downto 0);
          y           : out std_logic_vector(N-1 downto 0));
  end component;

  component adderN
    generic (N : integer := 32);
    port (a,b : in  std_logic_vector(N-1 downto 0);
          cin : in  std_logic;
          sum : out std_logic_vector(N-1 downto 0);
          cout: out std_logic);
  end component;

  -- signaux internes
  signal and_v, or_v, sum_v : std_logic_vector(N-1 downto 0);
  signal cout_v             : std_logic;
  signal sub                : std_logic;
  signal B_eff              : std_logic_vector(N-1 downto 0);
  signal result_i           : std_logic_vector(N-1 downto 0);

  -- overflow helper (std_logic)
  signal ov_addsub : std_logic;
  signal is_addsub : std_logic;
begin
  -- inversion conditionnelle de B pour SUB et Cin=1 (A + ~B + 1)
  sub   <= ALUcontrol(0);
  B_eff <= B xor (N-1 downto 0 => sub);

  -- logique
  and_v <= A and B;
  or_v  <= A or B;
  -- additionneur unique pour ADD/SUB
  U_ADD : adderN
    generic map (N => N)
    port map    (a => A, b => B_eff, cin => sub, sum => sum_v, cout => cout_v);
  -- MUX des 4 opérations (00 AND, 01 OR, 10 ADD, 11 SUB)
  U_MUX : mux4
    generic map (N => N)
    port map    (d0 => sum_v, d1 => sum_v, d2 => and_v, d3 => or_v,
                 sel => ALUControl, y => result_i);
  -- publier
  Result <= result_i;
  -- ===== FLAGS (comme Fig. 5.17) =====
  -- Negative = MSB du résultat
  Nflag <= result_i(N-1);
  -- Zero = 1 si tout à 0 (via numeric_std, portable)
  Zflag <= '1' when unsigned(result_i) = 0 else '0';
  -- Carry = cout de l'additionneur en ADD/SUB (sinon 0)
  Cflag <= cout_v and (not ALUControl(1));
  -- Overflow signé en ADD/SUB :
  -- V = (Amsb xnor B_effmsb) and (Rmsb xor Amsb)
   VFlag <= not(A(N-1) xor B_eff(N-1)xor ALUControl(0) ) and (result_i(N-1) xor A(N-1))and  (not ALUControl(1)) ;
 
end architecture;
