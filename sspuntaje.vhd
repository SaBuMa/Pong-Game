LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------
ENTITY sspuntaje IS 
GENERIC	(	N				:	INTEGER	:= 6);
PORT ( 
		puntaje_P1	:  IN STD_LOGIC_VECTOR(N-3 DOWNTO 0);
		puntaje_P2	:  IN STD_LOGIC_VECTOR(N-3 DOWNTO 0);
		sseg_1		:  OUT STD_LOGIC_VECTOR(N DOWNTO 0);
		sseg_2		:  OUT STD_LOGIC_VECTOR(N DOWNTO 0)

		);
END ENTITY sspuntaje;
--------------------------------------------------------
ARCHITECTURE functional OF sspuntaje IS



 BEGIN 	
	
WITH puntaje_P1 SELECT 
			sseg_1 <= 	"1000000" WHEN "0000" , -- numero 00
							"1111001" WHEN "0001" , -- numero 01
							"0100100" WHEN "0010" , -- numero 02	
							"0110000" WHEN "0011" , -- numero 03	
							"0011001" WHEN "0100" , -- numero 04
							"0010010" WHEN "0101" , -- numero 05
							"0000010" WHEN "0110" , -- numero 06
							"1111000" WHEN "0111" , -- numero 07
							"0000000" WHEN "1000" , -- numero 08
							"0010000" WHEN "1001" , -- numero 09
							"0000110" WHEN  OTHERS; -- Letra E para error
							
WITH puntaje_P2 SELECT 
			sseg_2 <= 	"1000000" WHEN "0000" , -- numero 00
							"1111001" WHEN "0001" , -- numero 01
							"0100100" WHEN "0010" , -- numero 02	
							"0110000" WHEN "0011" , -- numero 03	
							"0011001" WHEN "0100" , -- numero 04
							"0010010" WHEN "0101" , -- numero 05
							"0000010" WHEN "0110" , -- numero 06
							"1111000" WHEN "0111" , -- numero 07
							"0000000" WHEN "1000" , -- numero 08
							"0010000" WHEN "1001" , -- numero 09
							"0000110" WHEN  OTHERS; -- Letra E para error
	

END ARCHITECTURE functional;