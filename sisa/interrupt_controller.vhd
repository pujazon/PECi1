library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY interrupt_controller IS
	PORT(
		boot: 	IN STD_LOGIC;
		clk:  	IN STD_LOGIC;
		inta:		IN STD_LOGIC;
		key_intr:	IN STD_LOGIC;
		timer_intr: IN STD_LOGIC;
		switch_intr: IN STD_LOGIC;
		ps2_intr:	IN STD_LOGIC;
		key_inta:	OUT STD_LOGIC;
		timer_inta: OUT STD_LOGIC;
		switch_inta: OUT STD_LOGIC;
		ps2_inta:	OUT STD_LOGIC;
		intr:		OUT STD_LOGIC;
		iid:		OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END interrupt_controller;

ARCHITECTURE Structure OF interrupt_controller IS
	signal curr_iid: STD_LOGIC_VECTOR(7 downto 0);
	signal intr_t: STD_LOGIC;
BEGIN
	intr_t <= '1' when (key_intr = '1' or ps2_intr = '1' or switch_intr = '1' or timer_intr = '1') else '0';
	
	intr <= intr_t;
	
	curr_iid <= x"00" when timer_intr = '1' else
					x"01" when key_intr = '1' else
					x"02" when switch_intr = '1' else
					x"03" when ps2_intr = '1' else
					x"CA";
		
	process(clk, intr_t, curr_iid) begin
		if (rising_edge(clk) and intr_t = '1') then
			iid <= curr_iid;
		end if;
		if (rising_edge(clk)) then
			if (inta = '1') then
				if (timer_intr = '1') then
					timer_inta <= '1';
				elsif (key_intr = '1') then
					key_inta <= '1';
				elsif (switch_intr = '1') then
					switch_inta <= '1';
				elsif (ps2_intr = '1') then
					ps2_inta <= '1';
				end if;
			else
				timer_inta <= '0';
				key_inta <= '0';
				switch_inta <= '0';
				ps2_inta <= '0';
			end if;
		end if;
	end process;
END Structure;