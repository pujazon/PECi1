LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS

   type BANCO_REGISTROS is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal br: BANCO_REGISTROS;

BEGIN

    a <= br(conv_integer(addr_a));
	 b <= br(conv_integer(addr_b));
	
	process (clk)
	begin
		if (wrd = '1' and rising_edge(clk)) then -- Si la senyal d'escriptura està activa.
			br(conv_integer(addr_d)) <= d;
		end if;
	end process;

END Structure;