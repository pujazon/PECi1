LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.const_control.all;
USE work.const_logic.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			  : IN  STD_LOGIC;
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  		  : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
			 br_n		  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 tknbr	  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			 addr_io   :	OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			 rd_in	  :	OUT STD_LOGIC;
			 wr_out	  :	OUT STD_LOGIC;
			 in_op_mux :	OUT STD_LOGIC;
			 --Signals para instrucciones de sistema-----
			 ei 	  : OUT  STD_LOGIC;
			 di 	  : OUT  STD_LOGIC;
			 reti	  : OUT  STD_LOGIC;
			 wrd_rsys : OUT STD_LOGIC;
			 system 	 : OUT STD_LOGIC; 
			 a_sys	 : OUT STD_LOGIC;
			 rds_bit  : OUT STD_LOGIC;
			 wrs_bit  : OUT STD_LOGIC;
			 getiid_bit  : OUT STD_LOGIC;
			 ---------------------------------------------	
			 ---Excepcion instruccion ilegal--------------
			 instr_il : OUT STD_LOGIC
			 );
END control_l;


ARCHITECTURE Structure OF control_l IS

alias opcode : std_logic_vector(3 downto 0) is ir(15 downto 12);
alias f_sys : std_logic_vector(4 downto 0) is ir(4 downto 0);


BEGIN

	-- No augmentem PC si estem en HALT.
	with ir select
		ldpc <= '0' when halt,
				'1' when others;
				
	--BIT PARA SABER SI ES SYSTEM O NO PARA MULTI
	system <= '1' when opcode = opcode_sys else '0';
				
	-- Seleccionem operacio
	 
	 op <= op_arith when opcode = opcode_st or opcode = opcode_stb 
								or opcode = opcode_ld or opcode = opcode_ldb
								or opcode = opcode_arith or opcode = opcode_addi else
			 op_mem when opcode = opcode_mov or opcode = opcode_jx else
			 op_cmp when opcode = opcode_cmp else
			 op_mul when opcode = opcode_mul else
			 op_arith when opcode = opcode_in_out else
			 op_sys when opcode = opcode_sys; --NO FALTA UN ULTIMO ELSE?, QUE SI NO PILLA NADA HAGA HALT O ALGO
			 
	-- Seleccionem funcio
	 f <= f_arith_add when opcode = opcode_st or opcode = opcode_stb 
								or opcode = opcode_ld or opcode = opcode_ldb
								or opcode = opcode_addi or opcode = opcode_in_out else
			f_mem_movi when opcode = opcode_mov and ir(8) = '0' else
			f_mem_movhi when opcode = opcode_mov and ir(8) = '1' else
			f_mem_jump when opcode = opcode_jx else		
			-----Ara mirem f para SYSTEM---------------
			f_ei when opcode = opcode_sys and f_sys = f_ei else
			f_di when opcode = opcode_sys and f_sys = f_di else
			f_reti when opcode = opcode_sys and f_sys = f_reti else
			f_rds when opcode = opcode_sys and f_sys = f_rds else
			f_wrs when opcode = opcode_sys and f_sys = f_wrs else
			--f_sys_NOT_IMPLEMENTATED when opcode = op_sys else
			--------------------------------------------
			"00" & ir(5 downto 3);
			 
	-- Seleccionem adreces registres
	 
	 with opcode select
		addr_a <= ir(11 downto 9) when opcode_mov,
					ir(8 downto 6) when others;

	 addr_d <= ir(11 downto 9);
	 
	 addr_b <= ir(11 downto 9) when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_br or opcode = opcode_jx or opcode = opcode_in_out else
				  ir(2 downto 0);
				  
	--br_n --> 1 si usan INMEDIATO 0 si no lo usan EN LA ALU 
				  
	 br_n <= '1' when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_ld
							or opcode = opcode_ldb or opcode = opcode_mov or opcode = opcode_addi
				else '0';
				
	 tknbr <= "01" when opcode = opcode_br and (not ir(8)) = z else
				 "10" when opcode = opcode_jx and (ir(2 downto 0) = f_jal or ir(2 downto 0) = f_jmp or (ir(2 downto 0) = f_jz and z = '1') or (ir(2 downto 0) = f_jnz and z = '0')) else
				 "11" when opcode = opcode_sys and ir(4 downto 0) = f_reti else
				 "00";
				  
	 -- Control escriptura i memoria
	 -- Ojo que ara es 0 PER A TOTA INSTR. SYSTEMA - {RDS}
	 
	 wrd <= '0' when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_br or (opcode = opcode_jx and ir(2 downto 0) /= f_jal) or  (opcode = opcode_sys and (ir(4 downto 0) /= f_rds))
					or (opcode = opcode_in_out and ir(8) = '1') --Si es IN de E/S escriura en BR. Si es out no -> '1'
					else '1';
					
	 immed <= (7 downto 0 => ir(7)) & ir(7 downto 0) when opcode = opcode_mov
					else (9 downto 0 => ir(5)) & ir(5 downto 0);
	 
	 wr_m <= '1' when opcode = opcode_st or opcode = opcode_stb
						else '0';
						
	 in_d <= "01" when opcode = opcode_ld or opcode = opcode_ldb else
				"10" when opcode = opcode_jx else
				"11" when (opcode = opcode_sys and ir(4 downto 0) = f_rds)
						else "00";
						
	 immed_x2 <= '1' when opcode = opcode_ld or opcode = opcode_st
						else '0';
						
	 word_byte <= '1' when opcode = opcode_ldb or opcode = opcode_stb
						else '0';
						
	-- Control del CONTROLADOR E/S
	
	addr_io <= ir(7 downto 0);
	
	rd_in <= '1' when opcode = opcode_in_out and ir(8) = '0'
						else '0';
						
	wr_out <= '1' when opcode = opcode_in_out and ir(8) = '1'
						else '0';
						
	in_op_mux <= '1' when opcode = opcode_in_out and ir(8) = '0'
						else '0';
			
	-----SIGNALS DE SYSTEM----------------------------------------------
			
	--Aquests 3 nomes van a 1 si es la instruccio concreta
	ei <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_ei else '0';
	di <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_di else '0';	 
	reti <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_reti else '0';	 
	
	--Tambien haremos un par de signals para poder saber en el Datapath que instruccion de systema es
	
	rds_bit <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_rds else '0';
	wrs_bit <= '1' when  opcode = opcode_sys and ir(4 downto 0) = f_wrs else '0';
	getiid_bit <=  '1' when opcode = opcode_sys and ir(4 downto 0) = f_getiid else '0';
	
	--Ha de escribir en S(i) si es un WRS pero tmb en EI, DI (S7) i RETI (S7 <- S0)
	wrd_rsys <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_wrs or ir(4 downto 0) = f_ei or ir(4 downto 0) = f_di or ir(4 downto 0) = f_reti)					
					else '0';
					
	--Lee de REG_SYS en un RDS pero tmb en un RETI (PC <- S1)	
	a_sys <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_rds or ir(4 downto 0) = f_reti)
				else '0';

	--------------------------------------------------------------------
	
	--Excepcion de instruccion ilegal: Si op no es ninguno de los conocidos, instr_il := '1'--
	--Me da que si hacemos primero el '0' i luego el and es mas eficiente
	instr_il <= '0' when(
	 opcode = opcode_mov or 
	 opcode = opcode_st or
	 opcode = opcode_ld or 
	 opcode = opcode_stb or 
	 opcode = opcode_ldb or 
	 opcode = opcode_arith or 
	 opcode = opcode_cmp or 
	 opcode = opcode_mul or 
	 opcode = opcode_addi or
	 opcode = opcode_br or 
	 opcode = opcode_jx or 
	 opcode = opcode_sys or 
	 opcode = opcode_in_out) else '1';

END Structure;