LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.const_logic.all;

ENTITY memory_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END memory_alu;

ARCHITECTURE Structure OF memory_alu IS
 -- OPERACIONS COMPONENT: MOVI, MOVHI
BEGIN
	with f select
		w <= y when f_mem_movi,
			  y(7 downto 0) & x(7 downto 0) when f_mem_movhi,
			  x when f_mem_jump,
			  invalid when others;
END Structure;