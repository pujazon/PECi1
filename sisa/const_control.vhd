LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

package const_control is
	constant opcode_mov : std_logic_vector := "0101";
	constant opcode_st : std_logic_vector := "0100";
	constant opcode_ld : std_logic_vector := "0011";
	constant opcode_stb : std_logic_vector := "1110";
	constant opcode_ldb : std_logic_vector := "1101";
	constant opcode_arith : std_logic_vector := "0000";
	constant opcode_cmp : std_logic_vector := "0001";
	constant opcode_mul : std_logic_vector := "1000";
	constant opcode_addi : std_logic_vector := "0010";
	constant opcode_br : std_logic_vector := "0110";
	constant opcode_jx : std_logic_vector := "1010";
	constant opcode_sys : std_logic_vector := "1111";	
	constant opcode_in_out : std_logic_vector := "0111";
	
	constant f_jal : std_logic_vector := "100";
	constant f_jz : std_logic_vector := "000";
	constant f_jnz : std_logic_vector := "001";
	constant f_jmp : std_logic_vector := "011";
	constant f_calls : std_logic_vector := "111";
	
	constant pc_inicial : std_logic_vector := x"C000";
	
	type ESTADO is (FETCH, DEMW, SYS);
	
	constant halt : std_logic_vector := x"FFFF";	
	
	constant interrupcio_code : std_logic_vector := "1111";
	constant excepcio_0 : std_logic_vector := "0000";
	constant excepcio_1 : std_logic_vector := "0001";
	constant excepcio_4 : std_logic_vector := "0100";
	constant excepcio_6 : std_logic_vector := "0110";
	constant excepcio_7 : std_logic_vector := "0111";
	constant excepcio_8 : std_logic_vector := "1000";
	constant excepcio_9 : std_logic_vector := "1001";
	constant excepcio_11 : STD_logic_vector := "1011";
	constant excepcio_13 : STD_logic_vector := "1101";
	constant calls_code : std_logic_vector := "1110";
	constant NO_HAY_EXCEPCION : std_logic_vector := "0011"; --EN REALIDAD DA IGUAL EL CODIGO DE ESSTE
	
end const_control;
