LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY regfile_system IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
			 ei 	  : IN  STD_LOGIC;
			 di 	  : IN  STD_LOGIC;
			 reti	  : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);			
			 exc_code : IN STD_LOGIC_VECTOR(3 downto 0);
			 intr_sys	: IN STD_LOGIC;
			 int_enable : OUT STD_LOGIC;
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 addr_m : IN STD_LOGIC_VECTOR(15 downto 0));
END regfile_system;

ARCHITECTURE Structure OF regfile_system IS

   type BANCO_REGISTROS is array(7 downto 0) of std_logic_vector(15 downto 0);
	signal bs: BANCO_REGISTROS := (others => (others => '0'));

BEGIN

   a <= bs(5) when intr_sys = '1' else
		  bs(1) when reti = '1' else
		  bs(conv_integer(addr_a));

	process (clk)
	begin
	--Mira primero las 3 instrucciones implicitas, si ninguna de las 3 es verdad,
	--Como wrd esta a 1 pues es un wrs per tant lo escribe en el S(addt_d) <= d
	-- Ojo para WRS Primero ha de leer de REG_0 i entonces ponerlo en DATA i Si <= d
	
		if (rising_edge(clk) and intr_sys = '1') then
			--Si hay exce/interr se guarda en S2 el code
			bs(2) <= x"000" & exc_code;
			bs(0) <= bs(7);
			bs(1) <= d;
			--a <= bs(5);
			bs(7)(1) <= '0';
			if (exc_code = "0001") then -- evitamos señal extra para alineamiento incorrecto
				bs(3) <= addr_m;
			end if;
		elsif (wrd = '1' and rising_edge(clk)) then -- Si la senyal d'escriptura esta  activa.
			if (ei = '1') then
				bs(7)(1) <= '1';
			elsif (di = '1') then
				bs(7)(1) <= '0';
			elsif (reti = '1') then
				bs(7) <= bs(0);
			else bs(conv_integer(addr_d)) <= d;
			end if;
		end if;
	end process;

	int_enable <= bs(7)(1);
	
END Structure;