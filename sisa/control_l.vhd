LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.const_control.all;
USE work.const_logic.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			  : IN  STD_LOGIC;
			 intr		  : IN  STD_LOGIC;
			 int_enable : IN STD_LOGIC;
			 modo_sistema: IN STD_LOGIC;
			 inta		  : OUT STD_LOGIC;
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
			 ---------------------------------------------	
			 ---Excepcion instruccion ilegal--------------
			 instr_il : OUT STD_LOGIC;
			 ----------------------------
			exc_instr_sys : OUT STD_LOGIC;
			 sys_call_b	: OUT STD_LOGIC;
			 wrd_tlbi : OUT STD_LOGIC;
			 wrd_tlbd : OUT STD_LOGIC;
			 virtual  : OUT STD_LOGIC;
			 miss_tlbd : IN STD_LOGIC;
			 miss_tlbi : IN STD_LOGIC;
			 v_i : IN STD_LOGIC;
			 v_d : IN STD_LOGIC;
			 excp_miss_tlbi : OUT STD_LOGIC;
			 excp_miss_tlbd : OUT STD_LOGIC;
			 excp_v_tlbi : OUT STD_LOGIC;
			 excp_v_tlbd : OUT STD_LOGIC
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
	system <= '1' when (intr = '1' and int_enable = '1')
				else '0';
				
	-- Seleccionem operacio
	 
	 op <= op_arith when opcode = opcode_st or opcode = opcode_stb 
								or opcode = opcode_ld or opcode = opcode_ldb
								or opcode = opcode_arith or opcode = opcode_addi else
			 op_mem when opcode = opcode_mov or opcode = opcode_jx else
			 op_cmp when opcode = opcode_cmp else
			 op_mul when opcode = opcode_mul else
			 op_arith when opcode = opcode_in_out else
			 op_arith; 
			 
	-- Seleccionem funcio
	 f <= f_arith_add when opcode = opcode_st or opcode = opcode_stb 
								or opcode = opcode_ld or opcode = opcode_ldb
								or opcode = opcode_addi or opcode = opcode_in_out or opcode = opcode_sys else
			f_mem_movi when opcode = opcode_mov and ir(8) = '0' else
			f_mem_movhi when opcode = opcode_mov and ir(8) = '1' else
			f_mem_jump when opcode = opcode_jx else		
			"00" & ir(5 downto 3);
			 
	-- Seleccionem adreces registres
	 
	 inta <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_getiid else
			'0';
	 
	 with opcode select
		addr_a <= ir(11 downto 9) when opcode_mov,
					ir(8 downto 6) when others;

	 addr_d <= ir(11 downto 9);
	 
	 addr_b <= ir(11 downto 9) when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_br or opcode = opcode_jx or opcode = opcode_in_out or opcode = opcode_sys else
				  ir(2 downto 0);
				  
	--br_n --> 1 si usan INMEDIATO 0 si no lo usan EN LA ALU 
				  
	 br_n <= '1' when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_ld
							or opcode = opcode_ldb or opcode = opcode_mov or opcode = opcode_addi
				else '0';
				
	 tknbr <= "01" when opcode = opcode_br and (not ir(8)) = z else
				 "10" when (opcode = opcode_jx and (ir(2 downto 0) = f_jal or ir(2 downto 0) = f_jmp or (ir(2 downto 0) = f_jz and z = '1') or (ir(2 downto 0) = f_jnz and z = '0')))
								or (opcode = opcode_sys and ir(4 downto 0) = f_reti) else
				 "00";
				  
	 -- Control escriptura i memoria
	 -- Ojo que ara es 0 PER A TOTA INSTR. SYSTEMA - {RDS}
	 
	 wrd <= '0' when opcode = opcode_st or opcode = opcode_stb or opcode = opcode_br or (opcode = opcode_jx and ir(2 downto 0) /= f_jal) or 
					(opcode = opcode_sys and (ir(4 downto 0) /= f_rds) and (ir(4 downto 0) /= f_getiid))
					or (opcode = opcode_in_out and ir(8) = '1') --Si es IN de E/S escriura en BR. Si es out no -> '1'
					else '1';
					
	 immed <= (7 downto 0 => ir(7)) & ir(7 downto 0) when opcode = opcode_mov or opcode = opcode_br
				else (9 downto 0 => ir(5)) & ir(5 downto 0);
 
	 wr_m <= '1' when opcode = opcode_st or opcode = opcode_stb
						else '0';
						
	 in_d <= "01" when opcode = opcode_ld or opcode = opcode_ldb else
				"10" when (opcode = opcode_jx) else
				"11" when (opcode = opcode_sys and ir(4 downto 0) = f_rds)
						else "00";
						
	 immed_x2 <= '1' when opcode = opcode_ld or opcode = opcode_st
						else '0';
						
	 word_byte <= '0' when opcode = opcode_ld or opcode = opcode_st
						else '1';
						
	-- Control del CONTROLADOR E/S
	
	addr_io <= ir(7 downto 0);
	
	rd_in <= '1' when opcode = opcode_in_out and ir(8) = '0'
						else '0';
						
	wr_out <= '1' when opcode = opcode_in_out and ir(8) = '1'
						else '0';
						
	in_op_mux <= '1' when (opcode = opcode_in_out and ir(8) = '0') or (opcode = opcode_sys and ir(4 downto 0) = f_getiid)
						else '0';
			
	-----SIGNALS DE SYSTEM----------------------------------------------
			
	--Aquests 3 nomes van a 1 si es la instruccio concreta
	ei <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_ei else '0';
	di <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_di else '0';	 
	reti <= '1' when opcode = opcode_sys and ir(4 downto 0) = f_reti else '0';	 
			
	--Ha de escribir en S(i) si es un WRS pero tmb en EI, DI (S7) i RETI (S7 <- S0)
	wrd_rsys <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_wrs or ir(4 downto 0) = f_ei or ir(4 downto 0) = f_di or ir(4 downto 0) = f_reti)	and modo_sistema = '1'				
					else '0';

	--Lee de REG_SYS en un RDS pero tmb en un RETI (PC <- S1)	
	a_sys <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_rds or ir(4 downto 0) = f_reti)
				else '0';

	wrd_tlbd <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_wrpd or ir(4 downto 0) = f_wrvd)
					else '0';
					
	wrd_tlbi <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_wrpi or ir(4 downto 0) = f_wrvi)
					else '0';
	
	virtual <= '1' when opcode = opcode_sys and (ir(4 downto 0) = f_wrvd or ir(4 downto 0) = f_wrvi)
					else '0';
				
	--------------------------------------------------------------------
	
	sys_call_b	<= '1' when opcode = opcode_jx and ir(2 downto 0) = f_calls else
						'0';
	
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
	 
	 ---Exceopcio sys instr quando user--
	 
	 exc_instr_sys <= '1' when (opcode = opcode_sys and modo_sistema = '0') else
							'0';
							
	-----TLB Excepcions --------
	excp_miss_tlbi <= '1' when miss_tlbi = '1' else 
							'0';
							
	excp_miss_tlbd <= '1' when miss_tlbd = '1' and (opcode = opcode_st or opcode = opcode_stb or opcode = opcode_ld or opcode = opcode_ldb) else
							'0';
							
	excp_v_tlbi <= '1' when v_i = '0' else '0';
	
	excp_v_tlbd <= '1' when v_d = '0' and (opcode = opcode_st or opcode = opcode_stb or opcode = opcode_ld or opcode = opcode_ldb) else
							'0'; 

END Structure;