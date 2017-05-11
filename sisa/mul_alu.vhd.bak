LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE work.const_logic.all;

ENTITY mul_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END mul_alu;

ARCHITECTURE Structure OF mul_alu IS
 -- OPERACIONS COMPONENT: [ADD, ADDI, ST, STB, LD, LDB] -> ADD
 -- SUB, AND, OR, NOT, XOR, SHA, SHL.
	
	function upper(N: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		return N(31 downto 16);
	end upper;
	
	function lower(N: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		return N(15 downto 0);
	end lower;
	
	signal res : Boolean;

BEGIN

	w <= lower(std_LOGIC_VECTOR(unsigned(x)*unsigned(y))) when f = f_mul_mul else
			  upper(std_LOGIC_VECTOR(signed(x)*signed(y))) when f = f_mul_mulh else
			  upper(std_logic_vector(unsigned(x)*unsigned(y))) when f = f_mul_mulhu else
			  std_logic_vector(signed(x)/signed(y)) when f = f_mul_div else
			  std_logic_vector(unsigned(x)/unsigned(y)) when f = f_mul_divu else
			  invalid;
		  
END Structure;
