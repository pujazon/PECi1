LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE work.const_control.all;
USE work.const_logic.all;


ENTITY datapath IS
    PORT (boot   : IN  STD_LOGIC;
			 clk      : IN  STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  		 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
			 --Signals para instrucciones de sistema-----
			 ei 	  : IN  STD_LOGIC;
			 di 	  : IN  STD_LOGIC;
			 reti	  : IN  STD_LOGIC;
			 wrd_rsys : IN STD_LOGIC; 
			 a_sys	 : IN STD_LOGIC;
			 intr_sys : IN STD_LOGIC;
			 in_op_mux  : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 rd_io	 : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			 br_n		 : IN  STD_LOGIC;
			 exc_code : IN STD_LOGIC_VECTOR(3 downto 0);
			 wrd_tlbi : IN STD_LOGIC;
			 wrd_tlbd : IN STD_LOGIC;
			 virtual  : IN STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			 : OUT STD_LOGIC;
			 aluout   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	       wr_io	 : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 div_zero : OUT STD_LOGIC;
			 int_enable : OUT STD_LOGIC;
			 modo_sistema : OUT STD_LOGIC;
			 miss_tlbd : OUT STD_LOGIC;
			 miss_tlbi : OUT STD_LOGIC;
			 v_i : OUT STD_LOGIC;
			 v_d : OUT STD_LOGIC;
			 r_i: OUT STD_LOGIC;
			 r_d: OUT STD_LOGIC);
END datapath;


ARCHITECTURE Structure OF datapath IS

	COMPONENT alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			 f  : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
			 z  : OUT STD_LOGIC;			 
			 div_zero	: OUT STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT regfile_system IS
    PORT (boot   : IN  STD_LOGIC;
			 clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
			 ei 	  : IN  STD_LOGIC;
			 di 	  : IN  STD_LOGIC;
			 reti	  : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);			
			 exc_code : IN STD_LOGIC_VECTOR(3 downto 0);
			 intr_sys	: IN STD_LOGIC;
			 int_enable : OUT STD_LOGIC;
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 addr_m : IN STD_LOGIC_VECTOR(15 downto 0);
			 modo_sistema: OUT STD_LOGIC);
	END COMPONENT;
	
	
	COMPONENT tlb IS
	PORT (
		clk  : IN STD_LOGIC;
		boot : IN STD_LOGIC;
		vtag : IN STD_logic_vector(3 downto 0);
		ptag : OUT STD_logic_vector(3 downto 0);
		d    : IN STD_LOGIC_vector (5 downto 0);
		addr_d : IN STD_LOGIC_VECTOR(2 downto 0);
		wrd  : IN STD_LOGIC;
		virt : IN STD_LOGIC;
		v    : OUT STD_LOGIC;
		miss : OUT STD_LOGIC;
		r    : OUT STD_LOGIC
	);

	END COMPONENT;
	
	
	signal alu_out, reg_a_gen, reg_a, reg_a_sys, reg_b, d_in_S, addr_m_t, in_addr_m : STD_LOGIC_VECTOR (15 downto 0);
	signal reg_in, reg_in_t, immed_out, y_alu : STD_LOGIC_VECTOR (15 downto 0);
	signal t_intr_sys, t_modo_sistema : STD_LOGIC;
	signal v_t_i, v_t_d, r_t_i, r_t_d: STD_LOGIC;

	signal trans_tlbd, trans_tlbi : STD_LOGIC_VECTOR(3 downto 0);
	--signal t_code_excep : STD_LOGIC_VECTOR (3 downto 0);
	 
BEGIN

	-- lAS TLB: 1 INSTR 1 DADES--
	-- FALTA IMPLEMENTAR LOS INPUTS DE LA TLB --
	
	 tlb_i: tlb port map(clk => clk, boot => boot, vtag => pc(15 downto 12), d => reg_b(5 downto 0), ptag => trans_tlbi,
								addr_d => reg_a(2 downto 0), v => v_i, r => r_i, wrd => wrd_tlbi, virt => virtual,
								miss => miss_tlbi);

								
	 tlb_d: tlb port map(clk => clk, boot => boot, vtag => alu_out(15 downto 12), d => reg_b(5 downto 0), ptag => trans_tlbd,
								addr_d => reg_a(2 downto 0), v => v_t_d, r => r_t_d, wrd => wrd_tlbd, virt => virtual,
								miss => miss_tlbd);
	 

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

	 reg0: regfile port map (clk => clk, wrd => wrd, d => reg_in, addr_a => addr_a, addr_b => addr_b, 
									 addr_d => addr_d, a => reg_a_gen, b => reg_b);
	
	
	 regS: regfile_system port map (clk => clk, wrd => wrd_rsys, d => d_in_S, addr_a => addr_a, 
												addr_d => addr_d, a => reg_a_sys, exc_code => exc_code,
												ei => ei, di => di, reti => reti, addr_m => in_addr_m,
												intr_sys => intr_sys, int_enable => int_enable, boot => boot,
												modo_sistema => modo_sistema
												); 
												
	-- Ahora con REG_SYS hay que elegir en reg_a que va si el de general o el de systema.
	
	with a_sys select
		reg_a <= reg_a_sys when '1',
					reg_a_gen when others;
	
	 alu0: alu port map (x => reg_a, y => y_alu, op => op, w => alu_out, f => f, z => z, div_zero => div_zero);

	 
	 -- Seleccionem que entra pel port D del banc de registres (alu/memoria) TODO
	 with in_d select
		reg_in_t <= alu_out when "00",
					 datard_m when "01",
					 reg_a_sys when "11",--Si es RDS en REG0 ira lo que lea de REGS
					 pc + x"0002" when others;
					 
	--Mirem si la intruccio de sistema es WRS per tant la dada input REGS ha de ser registre de REG0 o no
	
	with intr_sys select
		d_in_S <= reg_a_gen when '0',
					pc when others;
						 
	--Entrara a REGFILE PARA ESCRIBIR O lo controlado antes o rd_io si es IN
	with in_op_mux select
		reg_in <= 	rd_io when '1',
					reg_in_t when others;
	
	
		aluout <= alu_out when intr_sys = '0' and reti = '0' else
					reg_a_sys;
					 
	 -- Decidim multiplicar o no en funcio de immed_x2
	 with immed_x2 select
		immed_out <= immed when '0',
						immed(14 downto 0) & '0' when others;
						
	-- Decidim si entra b o immed a la ALU.
	
	with br_n select
		y_alu <= reg_b when '0',
					immed_out when others;
	
	-- Seleccionem entrada de adreces memoria en funcio de ins_dad (1 ALU/ 0 PC)
	 with ins_dad select
		addr_m_t <= trans_tlbi & pc(11 downto 0) when '0',
					trans_tlbd & alu_out(11 downto 0) when others;
					
	in_addr_m <= reg_a_gen when exc_code = calls_code else
				addr_m_t; 
	
	addr_m <= addr_m_t;
	
	data_wr <= reg_b;
	
	wr_io <= reg_b; --El wr_io valdra lo que sale del registro port B, 
					--pero habra que controlar si hace algo en en funcion si OUT o no en controlador IO
	


END Structure;