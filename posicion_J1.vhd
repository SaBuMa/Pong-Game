LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY posicion_J1 IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					ena_down		: 	IN		STD_LOGIC;
					up				:	IN		STD_LOGIC;
					down			:	IN		STD_LOGIC;
					counter		: 	OUT	UNSIGNED (N DOWNTO 0)
					);
END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF posicion_J1 IS
	CONSTANT ONES			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '0');
	
	SIGNAL count_s			:	UNSIGNED (N DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED (N DOWNTO 0);
	
	SIGNAL pos_inicial	: 	UNSIGNED	(N DOWNTO 0);
	

BEGIN
	pos_inicial	<= "00011001000";
	-- NEXT STATE LOGIC
	count_next	<=		pos_inicial				WHEN	syn_clr = '1'				   ELSE
							count_s + 20			WHEN	(ena = '1' AND (up ='1' AND down ='0'))		ELSE
							count_s - 20			WHEN	(ena_down = '1' AND (up ='0' AND down ='1'))		ELSE
							count_s;
	PROCESS (clk,rst,pos_inicial)
		VARIABLE	temp	:	UNSIGNED(N DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp :=	pos_inicial;
		ELSIF (rising_edge(clk)) THEN
			IF(count_next >=0 AND count_next <=420) THEN
				IF ((ena = '1' AND up ='1' AND down ='0'))  THEN
					temp := count_next;
				ELSIF((ena_down = '1' AND (up ='0' AND down ='1'))) THEN
					temp := count_next;
				END IF;
			ELSIF (count_next < 0 AND count_next >=440) THEN
					count_s	<= count_next;
					temp := pos_inicial;
			END IF; 
		END IF;
		counter <=	temp;
		count_s <=	temp;
	END PROCESS;


	

END ARCHITECTURE;