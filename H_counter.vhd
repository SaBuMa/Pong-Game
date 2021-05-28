LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY H_counter IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					H_activo 	: 	OUT	STD_LOGIC;
					H_sync		:	OUT	STD_LOGIC;
					H_max 		:	OUT	STD_LOGIC;
					counter		: 	OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0)
					);
END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF H_counter IS
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
			IF (count_s /= "1100100000" AND ena = '1') THEN
				temp := count_next;
			ELSIF (count_s = "1100100000" AND ena = '1') THEN
				temp := ZEROS;
			END IF;
		END IF;
		counter <=	STD_LOGIC_VECTOR(temp);
		count_s <=	temp;
	END PROCESS;
	
	--OUTPUT LOGIC
--	H_max		<= '1' WHEN count_s = "1100100000"	ELSE '0';--800 PULSOS/PIXELES
--	HB_porch <= '1' WHEN (count_s >= "0000000000" AND count_s <= "0000110000")	ELSE '0';--0 A 48 PULSOS/PIEXELES para el Back Porch Horizontal
--	H_activo <= '1' WHEN (count_s >= "0000110000" AND count_s <= "1010110000")	ELSE '0';--48 A 48+640=688 PULSOS/PIEXELES para el Back Porch Horizontal
--	HF_porch <= '1' WHEN (count_s >=	"1010110000" AND count_s <= "1011000000")	ELSE '0';--688 A 16+48+640=704 PULSOS/PIEXELES para el Front Porch Horizontal
--	H_sync	<= '0' WHEN (count_s >= "1011000000" AND count_s <= "1100100000")	ELSE '1';--704 A 96+16+48+640=800 PULSOS/PIEXELES para el syncronizacion Horizontal
--	
--	H_max		<= '1' WHEN count_s = "1100100000"	ELSE '0';--800 PULSOS/PIXELES
--	H_activo	<= '1' WHEN (count_s >= "0000000000" AND count_s <= "1010000000")	ELSE '0';--0 A 640
--	HF_porch	<= '1' WHEN (count_s >= "1010000000" AND count_s <= "1010010000")	ELSE '0';--640 A 16+640=656
--	H_sync	<= '0' WHEN (count_s >= "1010010000" AND count_s <= "1011110000")	ELSE '1';--656 A 96+16+640=752
--	HB_porch <= '1' WHEN (count_s >= "1011110000" AND count_s <= "1100100000")	ELSE '0';--752 A 48+96+16+640=800 PULSOS/PIEXELES para el Back Porch Horizontal
--	
	H_max		<= '1' WHEN count_s = TO_UNSIGNED(800,N)	ELSE '0';--800 PULSOS/PIXELES
	H_sync	<= '0' WHEN (count_s >= TO_UNSIGNED(0,N) AND count_s <= TO_UNSIGNED(96,N))	ELSE '1';--0 A 96 
--	HB_porch <= '1' WHEN (count_s >= TO_UNSIGNED(96,N) AND count_s <= TO_UNSIGNED(144,N)) ELSE '0';--96 A 48+96 PULSOS/PIEXELES para el Back Porch Horizontal
	H_activo <= '1' WHEN (count_s >= TO_UNSIGNED(144,N) AND count_s <= TO_UNSIGNED(784,N))	ELSE '0';--48 A 48+640=688 PULSOS/PIEXELES para el Back Porch Horizontal	
--	HF_porch <= '1' WHEN (count_s >=	TO_UNSIGNED(784,N) AND count_s <= TO_UNSIGNED(800,N))	ELSE '0';--688 A 16+48+640=704 PULSOS/PIEXELES para el Front Porch Horizontal

END ARCHITECTURE;