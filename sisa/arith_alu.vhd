LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE work.const_logic.all;

ENTITY arith_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END arith_alu;

ARCHITECTURE Structure OF arith_alu IS
 -- OPERACIONS COMPONENT: [ADD, ADDI, ST, STB, LD, LDB] -> ADD
 -- SUB, AND, OR, NOT, XOR, SHA, SHL.
 
 alias shiftamount : std_logic_vector(4 downto 0) 
       is y(4 downto 0);
BEGIN

	w <= x AND y when f = f_arith_and else
			  x OR y when f = f_arith_or else
			  x XOR y when f = f_arith_xor else
			  NOT x when f = f_arith_not else
			  x + y when f = f_arith_add else
			  x - y when f = f_arith_sub else
			  std_logic_vector(unsigned(x) sll to_integer(signed(shiftamount))) when f = f_arith_shl else
			  std_logic_vector(signed(x) sll to_integer(signed(shiftamount))) when f = f_arith_sha and shiftamount(4) = '0' else
			  std_logic_vector(shift_right(signed(x), to_integer(abs(signed(shiftamount))))) when f = f_arith_sha and shiftamount(4) = '1' else
			  invalid;
END Structure;