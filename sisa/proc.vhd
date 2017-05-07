LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  rd_io		: IN  STD_LOGIC_vector(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
		  wr_io	   : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  addr_io	:	OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  rd_in	:	OUT STD_LOGIC;
		  wr_out	:	OUT STD_LOGIC);
END proc;

ARCHITECTURE Structure OF proc IS

COMPONENT unidad_control IS
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
			 system 	 : OUT STD_LOGIC;  
			 a_sys	 : OUT STD_LOGIC
			 ---------------------------------------------			 
			 );
END COMPONENT;

COMPONENT datapath IS
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
			 ---------------------------------------------
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
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 z			 : OUT STD_LOGIC;
			 aluout   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	         wr_io	 : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

	 
	 
		signal t_rd_in, t_in_op_mux, t_wrd, t_ins_dad, t_immed_x2, t_wr_m, t_word_byte, t_br_n, t_z : STD_LOGIC;
		signal t_addr_a,  t_addr_b, t_addr_d, t_op: STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal t_immed, t_pc, t_aluout : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal t_f : STD_LOGIC_VECTOR(4 downto 0);
		signal t_in_d : STD_LOGIC_VECTOR(1 DOWNTO 0);
		signal t_addr_io : STD_LOGIC_VECTOR(7 downto 0);
		signal t_ei, t_di,t_reti, t_a_sys, t_wrd_rsys : STD_LOGIC;

	 
BEGIN

	c0: unidad_control port map(	boot => boot, clk => clk, datard_m => datard_m, op => t_op, f => t_f,
											addr_a => t_addr_a, addr_b => t_addr_b, addr_d =>t_addr_d, 
											immed => t_immed, pc => t_pc,	wrd=> t_wrd, ins_dad => t_ins_dad,
											in_d => t_in_d, immed_x2 =>t_immed_x2, z => t_z, aluout => t_aluout,
											wr_m => t_wr_m, br_n => t_br_n, word_byte => t_word_byte,
											rd_in => rd_in, wr_out => wr_out, in_op_mux => t_in_op_mux, addr_io => addr_io,
											ei => t_ei, di => t_di, reti => t_reti, a_sys => t_a_sys, wrd_rsys => t_wrd_rsys);
											
	e0: datapath port map(	clk => clk, op => t_op, f => t_f, wrd => t_wrd, in_op_mux => t_in_op_mux, addr_a => t_addr_a, 
									addr_b => t_addr_b, addr_d => t_addr_d, immed => t_immed, aluout => t_aluout, rd_io => rd_io,
									immed_x2 => t_immed_x2, datard_m => datard_m, ins_dad => t_ins_dad,
									pc => t_pc, in_d => t_in_d, br_n => t_br_n, addr_m => addr_m, data_wr => data_wr, z => t_z,
									wr_io => wr_io,
									ei => t_ei, di => t_di, reti => t_reti, a_sys => t_a_sys, wrd_rsys => t_wrd_rsys);
											
	wr_m <= t_wr_m;
		
	word_byte <= t_word_byte;


END Structure;