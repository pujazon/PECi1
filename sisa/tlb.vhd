LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.const_control.all;
USE work.const_logic.all;

ENTITY tlb IS
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
	r    : OUT STD_LOGIC;
	pagina_sys: OUT STD_LOGIC
);

END tlb;

ARCHITECTURE Structure OF tlb IS

   type vtlb_type is array(8 downto 0) of std_logic_vector(3 downto 0);   
	type ptlb_type is array(8 downto 0) of std_logic_vector(5 downto 0);
	
	
	signal vtlb: vtlb_type := (others => (others => '0'));
	signal ptlb: ptlb_type := (others => (others => '0'));
	
	signal t_addr : integer := 0;
	
BEGIN

	t_addr <= 0 when vtlb(0) = vtag else
				 1 when vtlb(1) = vtag else
				 2 when vtlb(2) = vtag else
				 3 when vtlb(3) = vtag else
				 4 when vtlb(4) = vtag else
				 5 when vtlb(5) = vtag else
				 6 when vtlb(6) = vtag else
				 7 when vtlb(7) = vtag else
				 8;
			
	pagina_sys <= '1' when (vtag(3) = '1') else '0';
	 
	 ptag <= ptlb(t_addr)(3 downto 0) when t_addr /= 8 else
				"0000";
				
	 v <= ptlb(t_addr)(5);  --Si no es cap, saltará miss tlb
			
	miss <= '1' when t_addr = 8 else '0';
			
	r <= ptlb(t_addr)(4);
				
	process(clk) begin
		if (boot = '1') then
			ptlb(0) <= "100000";
			ptlb(1) <= "100001";
			ptlb(2) <= "100010";
			ptlb(3) <= "101000";
			ptlb(4) <= "101100";
			ptlb(5) <= "101101";
			ptlb(6) <= "101110";
			ptlb(7) <= "101111";
			vtlb(0) <= "0000";
			vtlb(1) <= "0001";
			vtlb(2) <= "0010";
			vtlb(3) <= "1000";
			vtlb(4) <= "1100";
			vtlb(5) <= "1101";
			vtlb(6) <= "1110";
			vtlb(7) <= "1111";
		elsif(rising_edge(clk) and wrd = '1') then
			if (virt = '1') then
				vtlb(to_integer(unsigned(addr_d))) <= d(3 downto 0);
			else
				ptlb(to_integer(unsigned(addr_d))) <= d;
			end if;
		end if;
	end process;
	
END Structure;