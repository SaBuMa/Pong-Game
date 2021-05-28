LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY puntajeP2 IS
	GENERIC	(	N				:	INTEGER	:= 4);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					puntaje_max	:	OUT	STD_LOGIC;
					counter		: 	OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0)
					);
END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF puntajeP2 IS
	CONSTANT ONES			:	UNSIGNED (N-1 DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED (N-1 DOWNTO 0)	:=	(OTHERS => '0');
	
	SIGNAL count_s			:	UNSIGNED (N-1 DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED (N-1 DOWNTO 0);

BEGIN
	-- NEXT STATE LOGIC
	count_next	<=		(OTHERS => '0')	WHEN	syn_clr = '1'  ELSE
							count_s + 1			WHEN	(ena = '1')		ELSE
							count_s;
	PROCESS (clk,rst,ena)
		VARIABLE	temp	:	UNSIGNED(N-1 DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp :=	(OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (count_s /= TO_UNSIGNED(10,N) AND ena = '1') THEN
				temp := count_next;
			ELSIF (count_s = TO_UNSIGNED(10,N) AND ena = '1') THEN
				temp := ZEROS;
			END IF;
		END IF;
		counter <=	STD_LOGIC_VECTOR(temp);
		count_s <=	temp;
	END PROCESS;
	
	puntaje_max		<= '1' WHEN count_next = TO_UNSIGNED(10,N)	ELSE '0';
END ARCHITECTURE;