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
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  		  : OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 reti_pc	  : IN StD_LOGIC_VECTOR(15 downto 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
			 wr_out	  : OUT STD_LOGIC;
			 br_n		  : OUT STD_LOGIC;
			 in_op_mux     : OUT  STD_LOGIC;
			 addr_io      : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
             rd_in : OUT  STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 --Signals para instrucciones de sistema-----
			 ei 	  : OUT  STD_LOGIC;
			 di 	  : OUT  STD_LOGIC;
			 reti	  : OUT  STD_LOGIC;
			 wrd_rsys : OUT STD_LOGIC;  
			 a_sys	 : OUT STD_LOGIC;
			 rds_bit  : OUT STD_LOGIC;
			 wrs_bit  : OUT STD_LOGIC;
			 getiid_bit  : OUT STD_LOGIC;
			 ---Excepcion instruccion ilegal--------------
			 instr_il : OUT STD_LOGIC;
			 ---------------------------------------------
			--- addr mem, solo quando datard_m lleva addr (por eso pillo el ir generado en el proces)
			dir_mem : OUT STD_LOGIC_VECTOR(15 downto 0)
			 );
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS

COMPONENT control_l IS
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
			--Signals para instrucciones de sistema-----
			ei_l 	  : IN  STD_LOGIC;
			di_l 	  : IN  STD_LOGIC;
			reti_l	  : IN  STD_LOGIC;
			wrd_rsys_l : IN STD_LOGIC; 
			a_sys_l	 : IN STD_LOGIC;
			rds_bit_l : IN STD_LOGIC;
			wrs_bit_l : IN STD_LOGIC;
			getiid_bit_l : IN STD_LOGIC;
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
			 rds_bit  : OUT STD_LOGIC;
			 wrs_bit  : OUT STD_LOGIC;
			 getiid_bit  : OUT STD_LOGIC;
			 load_pc_sys : OUT STD_LOGIC
			 ---------------------------------------------		
			 );
	end COMPONENT;

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter y del registro IR
	 
	 signal wrout_t,ldpc_c, wrd_c, wr_m_c, w_b_c,t_system : std_logic;
	 signal load_pc, load_ir, rds_bit_t, wrs_bit_t, getiid_bit_t : std_logic;
	 signal ir, new_pc, pc_calc, t_immed : std_logic_vector(15 downto 0);
	 signal tknbr : std_logic_vector(1 downto 0);
	 signal t_ei, t_di,t_reti, reti_multi, t_a_sys, t_wrd_rsys, load_pc_sys : STD_LOGIC;

BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC y del IR
	 
	 c0: control_l port map (ir => ir, op => op, f => f, ldpc => ldpc_c, wrd => wrd_c, addr_a => addr_a, addr_b => addr_b,
									 addr_d => addr_d, immed => t_immed, wr_m => wr_m_c, in_d => in_d, immed_x2 => immed_x2,
									 br_n => br_n, word_byte => w_b_c, z => z, tknbr => tknbr, in_op_mux => in_op_mux,
									 rd_in => rd_in, addr_io => addr_io, wr_out => wrout_t,
									 system => t_system,
									 ei => t_ei, di => t_di, reti => t_reti, a_sys => t_a_sys, wrd_rsys => t_wrd_rsys,
									 rds_bit => rds_bit_t, wrs_bit => wrs_bit_t, getiid_bit => getiid_bit_t,
									 instr_il => instr_il);
									 
									 
	 m0: multi port map (clk => clk, boot => boot, ldpc_l => ldpc_c, wrd_l => wrd_c, wr_m_l => wr_m_c, w_b => w_b_c,
								wrout_l => wrout_t, wr_out => wr_out,
								ei_l => t_ei, di_l => t_di, reti_l => t_reti, a_sys_l => t_a_sys, wrd_rsys_l => t_wrd_rsys,
								ldpc => load_pc, wrd => wrd, wr_m => wr_m, ldir => load_ir, 
								system => t_system, ins_dad => ins_dad, word_byte => word_byte,
								ei => ei, di => di, reti => reti, a_sys => a_sys, wrd_rsys => wrd_rsys,
								rds_bit_l => rds_bit_t, wrs_bit_l => wrs_bit_t, getiid_bit_l => getiid_bit_t,
								rds_bit => rds_bit, wrs_bit => wrs_bit, getiid_bit => getiid_bit,
								load_pc_sys => load_pc_sys);
	 
	 process(clk, boot, load_pc)
		begin
		if(boot = '1') then
			new_pc <= pc_inicial;
		elsif(rising_edge(clk)) then
			if(load_pc = '1' or load_pc_sys = '1') then
				new_pc <= pc_calc;
			end if;
			if(load_ir = '1') then
				ir <= datard_m;
			end if;
		end if;
	end process;
	
	immed <= t_immed;
	dir_mem <= ir;
	
	
--	--Si es RETI voldrem que el PC sigui el que surt de REGS que es REG_S_A_>
--	-- HAY CHAPUZA PQ SE tiENE QUE HACR SOLO EN ESTADO SYS, POR LO QUE ESTE MUX HACE DE DELAYER
--	with reti_multi select
--		reti_pc_final <= reti_pc when '1',
--					new_pc + x"0002" when others;
	
	with tknbr select
		pc_calc <= new_pc + x"0002" when "00",
					  new_pc + (x"0002") + (t_immed(14 downto 0) & '0') when "01",
					  aluout when "10",
					  reti_pc when "11",
					  new_pc when others;
	
	pc <= new_pc;

END Structure;