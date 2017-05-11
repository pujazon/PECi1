LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.const_control.all;

ENTITY excepcions_controller IS
	PORT(
			instr_il : IN STD_LOGIC;
			mem_align :	IN STD_LOGIC;
			div_zero : IN STD_LOGIC;
			intr:	IN STD_LOGIC;
			code_excep : OUT STD_LOGIC_VECTOR(3 downto 0);
			intr_sys	: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE Structure OF excepcions_controller IS

BEGIN

	--Aqui estoy dando prioridad 1. a las interrupciones, 2 a las excecpiones en caso de que vinieran mas de 1
	--Que me parece que para estas no puede pasar
	
	code_excep <= interrupcio_code when intr = '1' else
					  excepcio_0 when instr_il = '1' else
					  excepcio_1 when mem_align = '1' else
					  excepcio_4 when div_zero = '1' else
					  NO_HAY_EXCEPCION;
					  
	--intr_sys sera el signal que le dira al regS si hay interr/excep o no. Lo ponemos aqui i no en interr_controller
	--PQ este es el que mria si hay excep pero tmb interr
	
	intr_sys <= '1' when (intr = '1' or instr_il = '1' or mem_align = '1' or div_zero = '1') else
					'0';
END Structure;