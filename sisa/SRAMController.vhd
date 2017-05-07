library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SRAMController is
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
          WR          : in    std_logic := '0';
          byte_m      : in    std_logic := '0');
end SRAMController;

architecture comportament of SRAMController is
	type MEM_ESTADO is (RD, ES);
	
	signal estado : MEM_ESTADO := RD;
begin
	SRAM_CE_N <= '0';
	SRAM_OE_N <= '0';
	
	SRAM_UB_N <= '0' when estado = RD or byte_m = '0' or address(0) = '1' else '1';
	SRAM_LB_N <= '0' when estado = RD or byte_m = '0' or address(0) = '0' else '1';
	
	SRAM_WE_N <= '1' when estado = RD or WR = '0' else '0';
	
	SRAM_ADDR <="000" & address(15 downto 1);
	SRAM_DQ <= (others =>'Z') when estado = RD else 
					dataToWrite when byte_m = '0' else
					"ZZZZZZZZ" & dataToWrite(7 downto 0) when address(0) = '0' else
					dataToWrite(7 downto 0) & "ZZZZZZZZ";
	
	dataReaded <= SRAM_DQ when byte_m = '0' else
						((7 downto 0 => SRAM_DQ(7)) & SRAM_DQ(7 downto 0)) when address(0) = '0' else
						((7 downto 0 => SRAM_DQ(15)) & SRAM_DQ(15 downto 8)); 
	
	process(clk, estado)
	begin
		if (rising_edge(clk)) then
			if (WR = '1') then 
				estado <= ES;
			else
				estado <= RD;
			end if;
--			if (estado = RD or byte_m = '0' or address(0) = '0') then
--				SRAM_UB_N <= '0';
--			else
--				SRAM_UB_N <= '1';
--			end if;
--			if (estado = RD or byte_m = '0' or address(0) = '1') then
--				SRAM_LB_N <= '0';
--			else
--				SRAM_LB_N <= '1';
--			end if;
		end if;
	end process;

		
end comportament;
