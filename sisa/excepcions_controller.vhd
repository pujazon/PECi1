LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.const_control.all;

ENTITY excepcions_controller IS
	PORT(
			clk: IN STD_LOGIC;
			instr_il : IN STD_LOGIC;
			mem_align :	IN STD_LOGIC;
			div_zero : IN STD_LOGIC;
			system_l:	IN STD_LOGIC;
			sys_call_b : IN STD_LOGIC;
			exc_code : OUT STD_LOGIC_VECTOR(3 downto 0);
			system	: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE Structure OF excepcions_controller IS

	signal code_excep : STD_LOGIC_VECTOR(3 downto 0);
	signal system_t : STD_LOGIC;
	
BEGIN

	--Aqui estoy dando prioridad 1. a las interrupciones, 2 a las excecpiones en caso de que vinieran mas de 1
	--Que me parece que para estas no puede pasar
	
	code_excep <= excepcio_0 when instr_il = '1' else
					  excepcio_1 when mem_align = '1' else
					  excepcio_4 when div_zero = '1' else
					  calls_code when sys_call_b = '1' else
					  interrupcio_code when system_l = '1' else
					  NO_HAY_EXCEPCION;
					  
	--intr_sys sera el signal que le dira al regS si hay interr/excep o no. Lo ponemos aqui i no en interr_controller
	--PQ este es el que mria si hay excep pero tmb interr
	
	system_t <= '1' when (system_l = '1' or instr_il = '1' or mem_align = '1' or div_zero = '1' or sys_call_b ='1') else
					'0';
					
	system <= system_t;
					
	process(clk, system_t) begin	
		if (rising_edge(clk) and system_t = '1') then
			exc_code <= code_excep;
		end if;
	end process;
END Structure;