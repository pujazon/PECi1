library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity MemoryController is    
port (CLOCK_50  : in  std_logic;
	       addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
			 --read_only : in  std_logic;
          -- señales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
			 --Signals para controlar RAM de la VGA
			 vga_addr : out std_logic_vector(12 downto 0);
			 vga_we : out std_logic;
			 vga_wr_data : out std_logic_vector(15 downto 0);
			 vga_rd_data : in std_logic_vector(15 downto 0);
          vga_byte_m : out std_logic;
			 --Excepcion direccion mal alineada
			 mem_align :	out STD_logic;
			 ---Excepcion acceso memoria sistema sin ser privilegiado---
			 modo_sistema : IN STD_LOGIC;
			 --excepcion_prot : OUT STD_LOGIC;
--			 excepcion_mem_sys : OUT STD_LOGIC;
				--Aqui mira si la dir era de sys i tu siendo modo usuario 
			 tlb_sys_user	: OUT STD_LOGIC
			 );
end MemoryController;

--!! AL MEMORY CONTROLLER LE LLEGA UNA DIRECCION (ADDR).
--SI TRABAJAMOS CON LA VGA ( -> ADDR PERTENECE A A000,BFFFF,
		--EL OUT ADDR_VGA SERA LA TRADUCCION DE ESTA (PUES 0000 SI A000 ETC)

architecture comportament of MemoryController is


COMPONENT SRAMController is
    port (clk         : in    std_logic;
          -- señales para la placa de desarrollo
          SRAM_ADDR   : out   std_logic_vector(17 downto 0);
          SRAM_DQ     : inout std_logic_vector(15 downto 0);
          SRAM_UB_N   : out   std_logic;
          SRAM_LB_N   : out   std_logic;
          SRAM_CE_N   : out   std_logic := '1';
          SRAM_OE_N   : out   std_logic := '1';
          SRAM_WE_N   : out   std_logic := '1';
          -- señales internas del procesador
          address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
          dataReaded  : out   std_logic_vector(15 downto 0);
          dataToWrite : in    std_logic_vector(15 downto 0);
          WR          : in    std_logic;
          byte_m      : in    std_logic := '0');
end COMPONENT;

	signal we_t, ld_st_i: std_logic;
	signal t_rd_data: std_logic_vector(15 downto 0);
	
begin

	we_t <= '0' when addr >= x"C000" or (modo_sistema = '0' and (addr >= x"8000" and addr <= x"FFFF"))
					else we;

	rd_data <= vga_rd_data when(addr >= x"A000" and addr <= x"BFFF") else
					 t_rd_data;
					 
   mem_align <= '1' when (byte_m = '0' and addr(0) = '1') else
					 '0';
			--Esto lo haciamos antes, pero ahora es la 12 con la TLB de Instrucciones. 
			--Al fin i al cabo esto no era mas que mirar que el ultimo bit de addr fuese '1'
--   excepcion_mem_sys <= '1' when (modo_sistema = '0' and (addr >= x"8000" and addr <= x"FFFF")) else
--								'0';
	
	--excepcion_prot <= '1' when we_t = '1' and read_only = '1' else '0';

	sram: SRAMController port map(SRAM_ADDR => SRAM_ADDR, SRAM_DQ => SRAM_DQ, SRAM_UB_N => SRAM_UB_N,
											SRAM_LB_N => SRAM_LB_N, SRAM_CE_N => SRAM_CE_N, SRAM_OE_N => SRAM_OE_N,
											SRAM_WE_N => SRAM_WE_N,address => addr, WR => we_t, byte_m => byte_m,
											clk => CLOCK_50, dataToWrite => wr_data, dataReaded => t_rd_data);
											
	--OUTPUT PARA VGA
	
			 vga_addr <= addr(12 downto 0);
			 
			 vga_we <= '1' when (we = '1' and (addr >= x"A000" and addr <= x"BFFF")) else
						  '0';
						  
			 vga_byte_m <= byte_m;
			 vga_wr_data <= wr_data;
			 
	-- tlb
	
	tlb_sys_user <= '1' when (addr(15) = '1' and modo_sistema = '0') else
						 '0';
			 
end comportament;
