LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY mydff_P2 IS
GENERIC	(	N				:	INTEGER	:= 10);
	PORT(	clk		:	IN		STD_LOGIC;
			rst		:	IN		STD_LOGIC;
			ena_up	:	IN		STD_LOGIC;
			ena_dw	:	IN		STD_LOGIC;
			syn_clr	:	IN		STD_LOGIC;
			d			:	IN		UNSIGNED (N DOWNTO 0);
			q			:	OUT	UNSIGNED (N DOWNTO 0)); 

END mydff_P2;

ARCHITECTURE rtl OF mydff_P2 IS
begin
dffprn: PROCESS(clk,rst,d)
	BEGIN
		IF(rst='1') THEN
				q<="00011001000";	
		ELSIF (rising_edge(clk)) THEN
				IF(ena_up ='1' AND ena_dw='0') THEN
					q<=d;
				ELSIF(ena_up ='0' AND ena_dw='1') THEN
					q<=d;
				ELSIF(syn_clr='1')THEN
					q<=(OTHERS=>'0');
				END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;