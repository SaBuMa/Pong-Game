LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY Vel_counter IS
	GENERIC	(	N				:	INTEGER	:= 24);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					vel_juego	: 	IN		UNSIGNED(N-21 DOWNTO 0);
					vel_max 		:	OUT	STD_LOGIC
					);
END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF Vel_counter IS
	CONSTANT ONES			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '0');
	
	SIGNAL count_s			:	UNSIGNED (N DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED (N DOWNTO 0);


BEGIN
	-- NEXT STATE LOGIC
	count_next	<=		(OTHERS => '0')			WHEN	syn_clr = '1'  ELSE
							count_s + vel_juego		WHEN	(ena = '1' )		ELSE
							count_s;
	PROCESS (clk,rst,ena)
		VARIABLE	temp	:	UNSIGNED(N DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp :=	(OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			IF (count_next /= TO_UNSIGNED(50000000,N) AND ena = '1') THEN
				temp := count_next;
			ELSIF (count_next = TO_UNSIGNED(50000000,N) AND ena = '1') THEN
				temp := ZEROS;
			ELSIF (syn_clr ='1') THEN
				temp := ZEROS;
			END IF;
		END IF;

		count_s <=	temp;
	END PROCESS;
	
	vel_max		<= '1' WHEN count_next = TO_UNSIGNED(50000000,N)	ELSE '0';

END ARCHITECTURE;