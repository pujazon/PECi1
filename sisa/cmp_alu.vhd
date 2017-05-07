LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE work.const_logic.all;

ENTITY cmp_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END cmp_alu;

ARCHITECTURE Structure OF cmp_alu IS
 -- OPERACIONS COMPONENT: [ADD, ADDI, ST, STB, LD, LDB] -> ADD
 -- SUB, AND, OR, NOT, XOR, SHA, SHL.
	
	signal res : Boolean;

BEGIN

	res <= signed(x) < signed(y) when f = f_cmp_lt else
			  signed(x) <= signed(y) when f = f_cmp_le else
			  x = y when f = f_cmp_eq else
			  unsigned(x) < unsigned(y) when f = f_cmp_ltu else
			  unsigned(x) <= unsigned(y) when f = f_cmp_leu else
			  false;
			  
	w <= x"0001" when res else
		  x"0000";
		  
END Structure;