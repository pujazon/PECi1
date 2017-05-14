LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;


ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
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
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			 : OUT STD_LOGIC;
			 aluout   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	       wr_io	 : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 div_zero : OUT STD_LOGIC;
			 int_enable : OUT STD_LOGIC);
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
    PORT (clk    : IN  STD_LOGIC;
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
			 addr_m : IN STD_LOGIC_VECTOR(15 downto 0));
	END COMPONENT;
	
	
	
	signal alu_out, reg_a_gen, reg_a, reg_a_sys, reg_b, d_in_S, addr_m_t : STD_LOGIC_VECTOR (15 downto 0);
	signal reg_in, reg_in_t, immed_out, y_alu : STD_LOGIC_VECTOR (15 downto 0);
	signal t_intr_sys : STD_LOGIC;
	--signal t_code_excep : STD_LOGIC_VECTOR (3 downto 0);
	 
BEGIN

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

	 reg0: regfile port map (clk => clk, wrd => wrd, d => reg_in, addr_a => addr_a, addr_b => addr_b, 
									 addr_d => addr_d, a => reg_a_gen, b => reg_b);
	
	
	 regS: regfile_system port map (clk => clk, wrd => wrd_rsys, d => d_in_S, addr_a => addr_a, 
												addr_d => addr_d, a => reg_a_sys, exc_code => exc_code,
												ei => ei, di => di, reti => reti, addr_m => addr_m_t,
												intr_sys => intr_sys, int_enable => int_enable
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
		addr_m_t <= pc when '0',
					alu_out when others;
	
	addr_m <= addr_m_t;
	
	data_wr <= reg_b;
	
	wr_io <= reg_b; --El wr_io valdra lo que sale del registro port B, 
					--pero habra que controlar si hace algo en en funcion si OUT o no en controlador IO
	

END Structure;