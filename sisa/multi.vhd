library ieee;
USE ieee.std_logic_1164.all;
USE work.const_control.all;

entity multi is
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
end entity;

architecture Structure of multi is

    signal estado : ESTADO;

begin

	with estado select
		ei <= ei_l when DEMW,
				  '0' when others;
	with estado select
		di <= di_l when DEMW,
				  '0' when others;				  
	with estado select
		reti <= reti_l when DEMW,
				  '0' when others;
				  
	with estado select
		wrd_rsys <= wrd_rsys_l when DEMW,
				  '0' when others;
				  
	with estado select
		a_sys <= a_sys_l when DEMW,
				  '0' when others;

	with estado select
		wr_out <= wrout_l when DEMW,
				  '0' when others;

	with estado select
		ldpc <= '0' when FETCH,
				ldpc_l when others;
	
	with estado select
		wrd <= wrd_l when DEMW,
				  '0' when others;
				  
	with estado select
		wr_m <= wr_m_l when DEMW,
				  '0' when others;
				  
	with estado select
		word_byte <= w_b when DEMW,
				  '0' when others;
		
	with estado select
		ins_dad <= '0' when FETCH,
				  '1' when others;
				  
	with estado select
		ldir <= '1' when FETCH,
				  '0' when others;
				  
	with estado select
		intr_sys <= '1' when SYS,
						'0' when others;
	
	with estado select
		inta <= inta_l when DEMW,
					'0' when others;
					
	with estado select
		wrd_tlbd <= wrd_tlbd_l when DEMW,
						'0' when others;
						
	with estado select
		wrd_tlbi <= wrd_tlbi_l when DEMW,
						'0' when others;
						
	-- Graf d'estats
   process(clk, boot)
	begin
	
		if (boot = '1') then
			estado <= FETCH;
		elsif (rising_edge(clk)) then
			case estado is
				when FETCH =>
					estado <= DEMW;
					
				when DEMW =>
					if (system = '0') then 
						estado <= FETCH;
					else
						estado <= SYS;
					end if;
					
				when SYS => 
						estado <= FETCH;

			end case;
		end if;
	
	end process;

end Structure;
