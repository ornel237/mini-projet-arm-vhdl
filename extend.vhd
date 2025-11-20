library ieee;
use ieee.std_logic_1164.all;

entity extend is
  port(
    instr  : in  std_logic_vector(23 downto 0);
    ImmSrc : in  std_logic_vector(1 downto 0);
    ExtImm : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of extend is
begin
  process(instr, ImmSrc)
  begin
    case ImmSrc is
      when "00" =>  -- Imm8
        ExtImm <= (31 downto 8 => '0') & instr(7 downto 0);
      when "01" =>  -- Imm12
        ExtImm <= (31 downto 12 => '0') & instr(11 downto 0);
      when "10" =>  -- Imm24
        ExtImm <= (31 downto 24 => '0') & instr(23 downto 0);
      when others =>
        ExtImm <= (others => '0');
    end case;
  end process;
end architecture;
