LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY pulsadores IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		keys:		IN STD_LOGIC_VECTOR(3 downto 0);
		intr:		OUT STD_LOGIC;
		rd_keys: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END pulsadores;

ARCHITECTURE Structure OF pulsadores IS
	signal state: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	signal current_interrupt: STD_LOGIC := '0';
BEGIN
	process(clk)
	begin
		if (boot = '1') then
			state <= keys;
			current_interrupt <= '0';
		elsif (rising_edge(clk)) then
			if (current_interrupt = '1') then
				if(inta = '1') then
					current_interrupt <= '0';
				end if;
			else
				if(keys /= state) then
					current_interrupt <= '1';
				end if;
				state <= keys;
			end if;
		end if;
	end process;
	rd_keys <= state;
	intr <= current_interrupt;
END ARCHITECTURE;

ENTITY interruptores IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		switch:		IN STD_LOGIC_VECTOR(9 downto 0);
		intr:		OUT STD_LOGIC;
		rd_switch: OUT STD_LOGIC_VECTOR(9 downto 0)
	);
END interruptores;

ARCHITECTURE Structure OF interruptores IS
	signal state: STD_LOGIC_VECTOR(9 downto 0) := x"00";
	signal current_interrupt: STD_LOGIC := '0';
BEGIN
	process(clk)
	begin
		if (boot = '1') then
			state <= switch;
			current_interrupt <= '0';
		elsif (rising_edge(clk)) then
			if (current_interrupt = '1') then
				if(inta = '1') then
					current_interrupt <= '0';
				end if;
			else
				if(switch /= state) then
					current_interrupt <= '1';
				end if;
				state <= switch;
			end if;
		end if;
	end process;
	rd_switch <= state;
	intr <= current_interrupt;
END ARCHITECTURE;

ENTITY timer IS
	PORT(
		boot: 	IN STD_LOGIC;
		CLOCK_50:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		intr:		OUT STD_LOGIC
	);
END timer;

ARCHITECTURE Structure OF timer IS
	signal current_interrupt: STD_LOGIC := '0';
	constant max_val: STD_LOGIC_VECTOR(23 downto 0) := x"2625A0";
	signal count: STD_LOGIC_VECTOR(23 downto 0);
BEGIN
	process(CLOCK_50) begin
		if (rising_edge(CLOCK_50)) then
			if (count >= max_val) then
				current_interrupt <= '1';
				count <= x"000000";
			else
				count <= count + 1;
			end if;
			
			if (inta = '1') then
				current_interrupt <= '0';
			end if;
		end if;
	end process;
	intr <= current_interrupt;
END ARCHITECTURE;