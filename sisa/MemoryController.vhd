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
          vga_byte_m : out std_logic:
			 --Excepcion direccion mal alineada
			 mem_align :	out STD_logic
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

	signal we_t: std_logic;
	signal t_rd_data: std_logic_vector(15 downto 0);
	
begin

	we_t <= '0' when addr >= x"C000" else we;

	rd_data <= vga_rd_data when(addr >= x"A000" and addr <= x"BFFF") else
					 t_rd_data;
					 
   mem_align <= '1' when (byte_m = '0' and byte_m(0) = '1') else
					 '0';

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
			 
end comportament;
