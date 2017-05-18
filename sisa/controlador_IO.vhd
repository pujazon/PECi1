LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY controlador_IO IS
    PORT (boot    : IN  STD_LOGIC;
          CLOCK_50    : IN  STD_LOGIC;
		  clk		  : IN STD_LOGIC;
          addr_io      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			 wr_out	:	IN STD_LOGIC;
          wr_io : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          rd_io : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
          rd_in : IN  STD_LOGIC;
          led_verdes      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          led_rojos      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 ps2_clk : inout std_logic;
			 ps2_data : inout std_logic;
			 --Signals per al cursor, VGA
			 vga_cursor : out std_logic_vector(15 downto 0);
			 vga_cursor_enable : out std_logic; 
			 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          SW        : in std_logic_vector(9 downto 0);
			 KEY : IN STD_LOGIC_VECTOR(3 downto 0);
			 inta : IN  STD_LOGIC;
			 intr : OUT STD_LOGIC
			 );
END controlador_IO;

ARCHITECTURE Structure OF controlador_IO IS

   --type BANCO_REGISTROS is array(255 downto 0) of std_logic_vector(15 downto 0);
	type BANCO_REGISTROS is array(50 downto 0) of std_logic_vector(15 downto 0);
	signal br_io: BANCO_REGISTROS := ((others=> (others=>'0')));
	signal puerto : integer range 0 to 255;
	signal temporal : std_LOGIC_VECTOR(15 downto 0);
	signal data_ready : STD_LOGIC;
	signal read_char : STD_LOGIC_VECTOR (7 downto 0);
	signal bit_clear_char: STD_LOGIC;
	
	constant HEX_OFF : std_LOGIC_VECTOR := "1111111";
	
	component keyboard_controller is
    Port (clk        : in    STD_LOGIC;
          reset      : in    STD_LOGIC;
			 inta			: in	  STD_LOGIC;
          ps2_clk    : inout STD_LOGIC;
          ps2_data   : inout STD_LOGIC;
			 intr			: out   STD_LOGIC;
          read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
          clear_char : in    STD_LOGIC;
          data_ready : out   STD_LOGIC);
	end component;
	
	component pulsadores IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		keys:		IN STD_LOGIC_VECTOR(3 downto 0);
		intr:		OUT STD_LOGIC;
		rd_keys: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
	END component;
	
	component interruptores IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		switch:		IN STD_LOGIC_VECTOR(9 downto 0);
		intr:		OUT STD_LOGIC;
		rd_switch: OUT STD_LOGIC_VECTOR(9 downto 0)
	);
	END component;
	
	component timer IS
	PORT(
		boot: 	IN STD_LOGIC;
		CLOCK_50:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		intr:		OUT STD_LOGIC
	);
	END component;
	
	component interrupt_controller IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		key_intr:	IN STD_LOGIC;
		timer_intr: IN STD_LOGIC;
		switch_intr: IN STD_LOGIC;
		ps2_intr:	IN STD_LOGIC;
		key_inta:	OUT STD_LOGIC;
		timer_inta: OUT STD_LOGIC;
		switch_inta: OUT STD_LOGIC;
		ps2_inta:	OUT STD_LOGIC;
		intr:		OUT STD_LOGIC;
		iid:		OUT STD_LOGIC_VECTOR(7 downto 0)
	);
	END component;

	COMPONENT driver7segmentos IS
	PORT( 	codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;

	signal hex0_out, hex1_out, hex2_out, hex3_out : STD_LOGIC_VECTOR(6 DOWNTO 0);	
	signal contador_ciclos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	signal contador_milisegundos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
	signal ps2_inta_t, ps2_intr_t : STD_LOGIC;
	signal timer_inta_t, timer_intr_t : STD_LOGIC;
	signal switch_inta_t, switch_intr_t : STD_LOGIC;
	signal key_inta_t, key_intr_t : STD_LOGIC;
	signal rd_switch_t : STD_LOGIC_VECTOR(9 DOWNTO 0);
	signal rd_keys_t : STD_LOGIC_VECTOR(3 downto 0);
	signal iid_t : STD_LOGIC_VECTOR(7 downto 0);
	signal rd_io_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

	keyboard: keyboard_controller port map(clk => CLOCK_50, reset => boot, ps2_clk => ps2_clk,
														ps2_data => ps2_data, 
														read_char => read_char , clear_char => bit_clear_char,
														data_ready => data_ready, inta => ps2_inta_t, intr => ps2_intr_t);
														
	sw0: interruptores port map(clk => clk, boot => boot, inta => switch_inta_t, intr => switch_intr_t,
											switch => SW, rd_switch => rd_switch_t);
	
	tmr0: timer port map(CLOCK_50 => CLOCK_50, boot => boot, inta => timer_inta_t, intr => timer_intr_t);
	
	key0: pulsadores port map(clk => clk, boot => boot, inta => key_inta_t, intr => key_intr_t, keys => KEY, 
										rd_keys => rd_keys_t);
										
	int0: interrupt_controller port map(clk => clk, boot => boot, inta => inta, intr => intr,
										key_intr => key_intr_t, timer_intr => timer_intr_t, switch_intr => switch_intr_t,
										ps2_intr => ps2_intr_t, key_inta => key_inta_t, timer_inta => timer_inta_t, 
										switch_inta => switch_inta_t, ps2_inta => ps2_inta_t, iid => iid_t);
	
	driverHEX0: driver7segmentos port map(codigoCaracter => br_io(10)(3 downto 0), bitsCaracter => hex0_out);
	driverHEX1: driver7segmentos port map(codigoCaracter => br_io(10)(7 downto 4), bitsCaracter => hex1_out);
	driverHEX2: driver7segmentos port map(codigoCaracter => br_io(10)(11 downto 8), bitsCaracter => hex2_out);
	driverHEX3: driver7segmentos port map(codigoCaracter => br_io(10)(15 downto 12), bitsCaracter => hex3_out);
	
	puerto <= (conv_integer(addr_io));

		led_verdes  <= br_io(5)(7 DOWNTO 0);
		led_rojos  <= br_io(6)(7 DOWNTO 0);		
		
		
		with br_io(9)(0) select
			HEX0 <= HEX_OFF when '0',
					  hex0_out when others;
					  
		with br_io(9)(1) select
			HEX1 <= HEX_OFF when '0',
					  hex1_out when others;
					  
		with br_io(9)(2) select
			HEX2 <= HEX_OFF when '0',
					  hex2_out when others;
					  
		with br_io(9)(3) select
			HEX3 <= HEX_OFF when '0',
					  hex3_out when others;

	process (CLOCK_50)
	begin
	
		if rising_edge(CLOCK_50) then
			 if contador_ciclos=0 then
				 contador_ciclos<=x"C350"; -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos
				 if contador_milisegundos>0 then
					contador_milisegundos <= contador_milisegundos-1;
				 end if;
			 else
				 contador_ciclos <= contador_ciclos-1;
			 end if;
		 end if;
	
		if (wr_out = '1' and rising_edge(CLOCK_50)) then -- Si la senyal d'escriptura esta activa.
			if (puerto = 16) then 
				bit_clear_char <= '1';
			else
				bit_clear_char <= '0';
				br_io(puerto) <= wr_io;
			end if;
		elsif (rising_edge(CLOCK_50)) then
			if (inta = '1') then
				rd_io <= "00000000" & iid_t;
			elsif (rd_in = '1') then -- Si la senyal de lectura esta activa.
				br_io(15) (7 downto 0) <= read_char;
				br_io(21) <= contador_milisegundos;
				br_io(20) <= contador_ciclos;
				br_io(16)(0) <= data_ready;
				br_io(7) <= "000000000000" & rd_keys_t;
				br_io(8) <= "000000" & rd_switch_t;
				rd_io <= br_io(puerto); --HAY QUE USAR RD_IN PARA EFECTOS COLATERALES
											--PERO AUN NO
			end if;
		end if;

	end process;



END Structure;