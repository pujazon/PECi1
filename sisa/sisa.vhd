LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
			 LEDG		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		    LEDR		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
          SW        : in std_logic_vector(9 downto 0);
			 KEY : IN STD_LOGIC_VECTOR(3 downto 0);
			 --PINS de KEYBOARD
			 PS2_CLK : inout std_logic;
			 PS2_DAT : inout std_logic;
			 -- PINS de VGA
			 VGA_R : OUT STD_LOGIC_VECTOR (3 downto 0);
			 VGA_G : OUT STD_LOGIC_VECTOR (3 downto 0);			 
			 VGA_B : OUT STD_LOGIC_VECTOR (3 downto 0);
			 VGA_HS : OUT STD_LOGIC;
			 VGA_VS : OUT STD_LOGIC
			 );
END sisa;

ARCHITECTURE Structure OF sisa IS

COMPONENT MemoryController is
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
          vga_byte_m : out std_logic;
			 --Excepcion direccion mal alineada
			 mem_align :	out STD_logic
			 );
end COMPONENT;

-- Hay que ponerlas en el PORT MAP memoryContrller, Controlador_IO


COMPONENT controlador_IO IS
    PORT (boot    : IN  STD_LOGIC;
          CLOCK_50    : IN  STD_LOGIC;
          addr_io      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			 wr_out	:	IN STD_LOGIC;
          wr_io : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          rd_io : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
          rd_in : IN  STD_LOGIC;
          led_verdes      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          led_rojos      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			 HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          SW        : in std_logic_vector(9 downto 0);
			 KEY : IN STD_LOGIC_VECTOR(3 downto 0);
			 ps2_clk : inout std_logic;
			 ps2_data : inout std_logic;
		 	 --Signals per al cursor, VGA
			 vga_cursor : out std_logic_vector(15 downto 0);
			 vga_cursor_enable : out std_logic;
			 inta : IN  STD_LOGIC;
			 intr : OUT STD_LOGIC
			 );
END COMPONENT;

COMPONENT vga_controller is
    port(clk_50mhz      : in  std_logic; -- system clock signal
         reset          : in  std_logic; -- system reset
         blank_out      : out std_logic; -- vga control signal
         csync_out      : out std_logic; -- vga control signal
         red_out        : out std_logic_vector(7 downto 0); -- vga red pixel value
         green_out      : out std_logic_vector(7 downto 0); -- vga green pixel value
         blue_out       : out std_logic_vector(7 downto 0); -- vga blue pixel value
         horiz_sync_out : out std_logic; -- vga control signal
         vert_sync_out  : out std_logic; -- vga control signal
         --
         addr_vga          : in std_logic_vector(12 downto 0);
         we                : in std_logic;
         wr_data           : in std_logic_vector(15 downto 0);
         rd_data           : out std_logic_vector(15 downto 0);
         byte_m            : in std_logic;
         vga_cursor        : in std_logic_vector(15 downto 0);  -- simplemente lo ignoramos, este controlador no lo tiene implementado
         vga_cursor_enable : in std_logic);                     -- simplemente lo ignoramos, este controlador no lo tiene implementado
end COMPONENT;

COMPONENT proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  rd_io		: IN  STD_LOGIC_vector(15 DOWNTO 0);
		  --Excepcion direccion mal alineada
			 mem_align :	IN STD_logic;
			 intr		  : IN STD_LOGIC;
			 inta		  : OUT STD_LOGIC;
         addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
		  wr_io	   : OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  addr_io	:	OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  rd_in	:	OUT STD_LOGIC;
		  wr_out	:	OUT STD_LOGIC);
END COMPONENT;



	signal t_rd_in, t_wr_out,t_byte_m, t_wr_m, t_vga_we,
			 t_vga_cursor_enable,t_vga_byte_m,
			 t_mem_align : std_logic;
	signal t_rd_io, t_wr_io,t_addr_m, t_data_wr, t_datard_m,
			 t_vga_wr_data,t_vga_rd_data,t_vga_cursor : std_logic_vector(15 downto 0);
	signal counter_div_clk : std_logic_vector(2 downto 0) := "000";
	signal t_red, t_blue, t_green ,t_addr_io : STD_LOGIC_VECTOR(7 downto 0);
	signal t_vga_addr :  std_logic_vector(12 downto 0);
	signal t_inta, t_intr : STD_LOGIC;

BEGIN


	mem0: MemoryController port map (CLOCK_50 => CLOCK_50, byte_m => t_byte_m, we => t_wr_m, addr => t_addr_m,
								wr_data => t_data_wr, SRAM_DQ => SRAM_DQ, SRAM_ADDR => SRAM_ADDR, SRAM_UB_N => SRAM_UB_N,
								SRAM_LB_N => SRAM_LB_N, SRAM_CE_N => SRAM_CE_N, SRAM_OE_N => SRAM_OE_N, 
								SRAM_WE_N => SRAM_WE_N, rd_data => t_datard_m, 
								vga_addr => t_vga_addr, vga_we => t_vga_we, 
								vga_wr_data => t_vga_wr_data, vga_rd_data =>t_vga_rd_data , vga_byte_m => t_vga_byte_m,
								mem_align => t_mem_align);
								
	pro0: proc port map (boot => SW(9), clk => counter_div_clk(2), datard_m => t_datard_m, inta => t_inta, intr => t_intr,
						word_byte => t_byte_m, wr_m => t_wr_m, addr_m => t_addr_m, data_wr => t_data_wr,
						rd_io => t_rd_io, addr_io => t_addr_io, rd_in => t_rd_in, wr_out => t_wr_out, wr_io => t_wr_io,
						mem_align => t_mem_align);
						
						
	io: controlador_IO port map(boot => SW(9), CLOCK_50 => CLOCK_50, addr_io => t_addr_io,
											wr_out => t_wr_out, wr_io => t_wr_io, rd_in => t_rd_in, 
											rd_io => t_rd_io, led_verdes => LEDG, led_rojos => LEDR,
											ps2_clk => PS2_CLK, ps2_data => 	PS2_DAT, inta => t_inta, intr => t_intr,
											vga_cursor => t_vga_cursor, vga_cursor_enable => t_vga_cursor_enable,
											HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, SW => SW, KEY => KEY);
										
	vga: vga_controller port map(clk_50mhz => CLOCK_50, reset => SW(9),
											red_out => t_red, green_out => t_green, blue_out => t_blue,
											horiz_sync_out => VGA_HS, vert_sync_out => VGA_VS,
											addr_vga => t_vga_addr, we => t_vga_we, wr_data => t_vga_wr_data,
											rd_data => t_vga_rd_data, byte_m => t_vga_byte_m,
											vga_cursor => t_vga_cursor, vga_cursor_enable => t_vga_cursor_enable);	
--VGA PINES
	
	VGA_R <= t_red(3 downto 0);
	VGA_G <= t_green(3 downto 0);	
	VGA_B <= t_blue(3 downto 0);
	

	process(CLOCK_50, counter_div_clk)
	begin
		if (rising_edge(CLOCK_50)) then
			counter_div_clk <= counter_div_clk + "001";
		end if;
	end process;

END Structure;