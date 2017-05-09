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
BEGIN
	intr <= key_intr or ps2_intr or switch_intr or timer_intr;
	
	curr_iid <= x"00" when timer_intr = '1' else
					x"01" when key_intr = '1' else
					x"02" when switch_intr = '1' else
					x"03" when ps2_intr = '1' else
					x"FF";
	
	timer_inta <= inta and timer_intr;
	key_inta <= inta and key_intr and (not timer_intr);
	switch_inta <= inta and switch_intr and (not key_intr) and (not timer_intr);
	ps2_inta <= inta and ps2_intr and (not switch_intr) and (not key_intr) and (not timer_intr);
	
	process(clk) begin
		if (rising_edge(clk)) then
			iid <= curr_iid;
		end if;
	end process;
END Structure;