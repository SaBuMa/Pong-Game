--***********************************************************--
--DEFINICIÓN DE LAS LIBRERÍAS 
--***********************************************************--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--***********************************************************--
--DEFINICION DEl ENTITY = ENTRADAS Y SALIDAS
--***********************************************************--
ENTITY timerDebounce IS
	GENERIC	(	N				:	INTEGER	:= 20);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					max_tick		: 	OUT	STD_LOGIC);

END ENTITY timerDebounce;
--***********************************************************--
--DEFINICION DE SEÑALES AUXILIARES
--***********************************************************--
ARCHITECTURE rt1 OF timerDebounce IS
	CONSTANT ONES			:	UNSIGNED (N-1 DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED (N-1 DOWNTO 0)	:=	(OTHERS => '0');
	
	SIGNAL count_s			:	UNSIGNED (N-1 DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED (N-1 DOWNTO 0);

BEGIN

--***********************************************************--
--DECLARACION LOGICA							   						 --
--***********************************************************--

--Para simulacion TB = 01001011: 1.5us
--Para pruebas en tarjeta = 1.6ms	:00010100010000111000
-- Para la tarjeta, los botones son activos en bajo
	-- NEXT STATE LOGIC
	count_next	<=		(OTHERS => '0')	WHEN	(syn_clr = '1')	ELSE
							count_s + 1			WHEN	(ena = '1' ) ELSE
							count_s;
	PROCESS (clk,rst)
		VARIABLE	temp	:	UNSIGNED(N-1 DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp :=	(OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (count_s /= "00010100010000111000") THEN
				temp := count_next;
			ELSIF (count_s ="00010100010000111000") THEN
				temp := ZEROS;
			END IF;
		END IF;
		count_s <=	temp;
	END PROCESS;
	
	--OUTPUT LOGIC
	max_tick <= '1' WHEN count_s = "00010100010000111000"  ELSE '0';

END ARCHITECTURE;