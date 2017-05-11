LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.const_logic.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
			 z  : OUT STD_LOGIC;
			 div_zero	: OUT STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS

	COMPONENT memory_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT arith_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT cmp_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT mul_alu IS
	PORT(x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);			 
			 div_zero	: OUT STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	signal sortida_memory, sortida_arith, sortida_cmp, sortida_mul : STD_LOGIC_VECTOR(15 downto 0);
	signal t_div_zero : STD_LOGIC;

BEGIN


	memory_alu0: memory_alu port map (x => x, y => y, f => f, w => sortida_memory);
	arith_alu0: arith_alu port map (x => x, y => y, f => f, w => sortida_arith);
	cmp_alu0: cmp_alu port map(x => x, y => y, f => f, w => sortida_cmp);
	mul_alu0: mul_alu port map(x => x, y => y, f => f, w => sortida_mul, div_zero => t_div_zero);
	

   with op select
		w <= sortida_memory when op_mem,
			  sortida_arith when op_arith,
			  sortida_cmp when op_cmp,
			  sortida_mul when op_mul,
			  invalid when others;
			  	
	z <= '1' when y = x"0000" else '0';
	
	--Fem el seguent: Si no es una op de mul_alu, sera 0 segur. En cas que entri a alu_mul
	--Valdra el valor que tregui la alumul: Si es div / 0 sera 1, sino sera 0;
	
	with op select
		div_zero <= t_div_zero when op_mul,
						'0' when others;

END Structure;