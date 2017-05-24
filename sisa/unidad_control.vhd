LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.const_control.all;


ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			  : IN  STD_LOGIC;
			 aluout	  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 intr		  : IN STD_LOGIC;
			 int_enable : IN STD_LOGIC;
			 mem_align :	IN STD_logic;
			 div_zero  : IN STD_LOGIC;
			 excepcion_mem_sys: in std_LOGIC;
			 modo_sistema : IN STD_LOGIC;
			 inta		  : OUT STD_LOGIC;
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  		  : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
			 wr_out	  : OUT STD_LOGIC;
			 br_n		  : OUT STD_LOGIC;
			 in_op_mux : OUT  STD_LOGIC;
			 addr_io   : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
          rd_in 	  : OUT  STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 --Signals para instrucciones de sistema-----
			 ei 	  : OUT  STD_LOGIC;
			 di 	  : OUT  STD_LOGIC;
			 reti	  : OUT  STD_LOGIC;
			 wrd_rsys : OUT STD_LOGIC;  
			 a_sys	 : OUT STD_LOGIC;
			 intr_sys : OUT STD_LOGIC;
			 exc_code : OUT STD_LOGIC_VECTOR(3 downto 0);
			 wrd_tlbi : OUT STD_LOGIC;
			 wrd_tlbd : OUT STD_LOGIC;
			 virtual  : OUT STD_LOGIC;
			-----------TLB------------
			 miss_tlbd : IN STD_LOGIC;
			 miss_tlbi : IN STD_LOGIC;
			 v_i : IN STD_LOGIC;
			 v_d : IN STD_LOGIC;
			 r_d : IN STD_LOGIC
			 );
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS

COMPONENT control_l IS
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
			 r_d : IN STD_LOGIC;
			 excp_miss_tlbi : OUT STD_LOGIC;
			 excp_miss_tlbd : OUT STD_LOGIC;
			 excp_v_tlbi : OUT STD_LOGIC;
			 excp_v_tlbd : OUT STD_LOGIC;
			 excp_r_tlbd : OUT STD_LOGIC
			 );
END COMPONENT;
		
	COMPONENT excepcions_controller IS
	PORT(
			clk: IN STD_LOGIC;
			instr_il : IN STD_LOGIC;
			mem_align :	IN STD_LOGIC;
			div_zero : IN STD_LOGIC;
			system_l:	IN STD_LOGIC;
			exc_instr_sys : IN STD_LOGIC;
			sys_call_b : IN STD_LOGIC;
			excp_miss_tlbd : IN STD_LOGIC;
			excp_miss_tlbi : IN STD_LOGIC;
			excp_v_tlbi : IN STD_LOGIC;
			excp_v_tlbd : IN STD_LOGIC;
			excp_r_tlbd : IN STD_LOGIC;
			excp_sys_tlbi : IN STD_LOGIC;
			excp_sys_tlbd : IN STD_LOGIC;
			exc_code : OUT STD_LOGIC_VECTOR(3 downto 0);
			system	: OUT STD_LOGIC
	);
	END COMPONENT;	
	
	COMPONENT multi is
port(clk       : IN  STD_LOGIC;
	 	   system 	 : in STD_LOGIC; 
         boot      : IN  STD_LOGIC;
			wrout_l  : IN STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
			--------TLB------------------
			excp_miss_tlbi_l : IN STD_LOGIC;
			excp_v_tlbi_l : IN STD_LOGIC;
		   excepcion_mem_sys: in std_LOGIC;
			excp_sys_tlbi : OUT STD_LOGIC;
			excp_sys_tlbd : OUT STD_LOGIC;
			--Signals para instrucciones de sistema-----
			ei_l 	  : IN  STD_LOGIC;
			di_l 	  : IN  STD_LOGIC;
			reti_l	  : IN  STD_LOGIC;
			wrd_rsys_l : IN STD_LOGIC; 
			a_sys_l	 : IN STD_LOGIC;
			 ---------------------------------------------	
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
			wr_out	 : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
			 --Signals para instrucciones de sistema-----
			 ei 	  : OUT  STD_LOGIC;
			 di 	  : OUT  STD_LOGIC;
			 reti	  : OUT  STD_LOGIC;
			 wrd_rsys : OUT STD_LOGIC;
			 a_sys	 : OUT STD_LOGIC;
			 intr_sys : OUT STD_LOGIC;
			 inta : OUT STD_LOGIC;
			 inta_l : IN STD_LOGIC;
			 wrd_tlbi : OUT STD_LOGIC;
			 wrd_tlbd : OUT STD_LOGIC;
			 wrd_tlbi_l : IN STD_LOGIC;
			 wrd_tlbd_l : IN STD_LOGIC
			 ---------------------------------------------		
			 );
	end COMPONENT;

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter y del registro IR
	 
	 signal wrout_t,ldpc_c, wrd_c, wr_m_c, w_b_c,t_system, t_system_l : std_logic;
	 signal load_pc, load_ir : std_logic;
	 signal ir, new_pc, pc_calc_t, pc_calc, t_immed : std_logic_vector(15 downto 0);
	 signal tknbr : std_logic_vector(1 downto 0);
	 signal t_ei, t_di,t_reti, reti_multi, t_a_sys, t_wrd_rsys : STD_LOGIC;
	 signal intr_sys_t, inta_t, instr_il_t : STD_LOGIC;
	 signal sys_call_b_t, t_exc_instr_sys, excp_r_tlbd_tt : STD_LOGIC;
	 signal wrd_tlbd_t, wrd_tlbi_t, excp_r_tlbd_t : STD_LOGIC;
	 signal excp_v_tlbd_t, excp_v_tlbi_t, excp_v_tlbi_tt, excp_v_tlbd_tt : STD_LOGIC;
	 signal excp_miss_tlbd_t, excp_miss_tlbi_t, excp_miss_tlbd_tt, excp_miss_tlbi_tt,excp_miss_tlbd_l,excp_miss_tlbi_l : STD_LOGIC;
	 signal excp_sys_tlbi_t, excp_sys_tlbd_t : STD_LOGIC;
	 
	 
BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC y del IR
	 
	 e0: excepcions_controller port map(clk => clk, instr_il => instr_il_t, mem_align => mem_align, div_zero => div_zero, system_l => t_system_l,
													system => t_system, exc_code => exc_code, sys_call_b => sys_call_b_t,
													exc_instr_sys => t_exc_instr_sys,
													excp_miss_tlbd => excp_miss_tlbd_t, excp_miss_tlbi => excp_miss_tlbi_t,
													excp_v_tlbd => excp_v_tlbd_t,excp_v_tlbi => excp_v_tlbi_t,
													excp_r_tlbd => excp_r_tlbd_t, excp_sys_tlbi => excp_sys_tlbi_t,
													excp_sys_tlbd => excp_sys_tlbd_t);
	 
	 c0: control_l port map (ir => ir, op => op, f => f, ldpc => ldpc_c, wrd => wrd_c, addr_a => addr_a, addr_b => addr_b,
									 addr_d => addr_d, immed => t_immed, wr_m => wr_m_c, in_d => in_d, immed_x2 => immed_x2,
									 br_n => br_n, word_byte => w_b_c, z => z, tknbr => tknbr, in_op_mux => in_op_mux,
									 rd_in => rd_in, addr_io => addr_io, wr_out => wrout_t,
									 system => t_system_l, intr => intr, inta => inta_t, int_enable => int_enable,
									 ei => t_ei, di => t_di, reti => t_reti, a_sys => t_a_sys, wrd_rsys => t_wrd_rsys,
									 instr_il => instr_il_t, sys_call_b => sys_call_b_t,
									 modo_sistema => modo_sistema, wrd_tlbd => wrd_tlbd_t, wrd_tlbi => wrd_tlbi_t, virtual => virtual,
									 exc_instr_sys => t_exc_instr_sys, miss_tlbd => miss_tlbd, miss_tlbi => miss_tlbi,
									 excp_miss_tlbd => excp_miss_tlbd_t, excp_miss_tlbi => excp_miss_tlbi_t,
									 v_i => v_i, v_d => v_d, excp_v_tlbd => excp_v_tlbd_t, excp_v_tlbi => excp_v_tlbi_t,
									 r_d => r_d, excp_r_tlbd => excp_r_tlbd_t);
									 
									 
	 m0: multi port map (clk => clk, boot => boot, ldpc_l => ldpc_c, wrd_l => wrd_c, wr_m_l => wr_m_c, w_b => w_b_c,
								wrout_l => wrout_t, wr_out => wr_out, intr_sys => intr_sys_t,
								ei_l => t_ei, di_l => t_di, reti_l => t_reti, a_sys_l => t_a_sys, wrd_rsys_l => t_wrd_rsys,
								ldpc => load_pc, wrd => wrd, wr_m => wr_m, ldir => load_ir, inta_l => inta_t, inta => inta,
								system => t_system, ins_dad => ins_dad, word_byte => word_byte,
								ei => ei, di => di, reti => reti, a_sys => a_sys, wrd_rsys => wrd_rsys,
								wrd_tlbd_l => wrd_tlbd_t, wrd_tlbd => wrd_tlbd, wrd_tlbi_l => wrd_tlbi_t, wrd_tlbi => wrd_tlbi,
								excp_v_tlbi_l => excp_v_tlbi_t, excp_miss_tlbi_l => excp_miss_tlbi_t,
								excepcion_mem_sys => excepcion_mem_sys, excp_sys_tlbi => excp_sys_tlbi_t,
								excp_sys_tlbd => excp_sys_tlbd_t);
	 
	 process(clk, boot, load_pc)
		begin
		if(boot = '1') then
			new_pc <= pc_inicial;
		elsif(rising_edge(clk)) then
			if(load_pc = '1') then
				new_pc <= pc_calc;
			end if;
			if(load_ir = '1') then
				ir <= datard_m;
			end if;
		end if;
	end process;
	
	
	immed <= t_immed;
	intr_sys <= intr_sys_t;
	
	with intr_sys_t select
		pc_calc <= pc_calc_t when '0',
						aluout when others;
	
	with tknbr select
		pc_calc_t <= new_pc + x"0002" when "00",
					  new_pc + (x"0002") + (t_immed(14 downto 0) & '0') when "01",
					  aluout when "10",
					  new_pc when others;
	
	pc <= new_pc;

END Structure;