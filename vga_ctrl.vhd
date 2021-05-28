  --*********************--
--DEFINICIÓN DE LAS LIBRERÍAS 
--*********************--
Library IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
--*********************--
--DEFINICION DEl ENTITY = ENTRADAS Y SALIDAS
--*********************--
ENTITY vga_ctrl IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT(		
		clk 							: IN STD_LOGIC;
		rst							: IN STD_LOGIC;
		V_on							: IN STD_LOGIC;
		PosX, PosY					: IN INTEGER;
		bolitax						: IN UNSIGNED(N DOWNTO 0);
		bolitay						: IN UNSIGNED(N DOWNTO 0);
		P1								: IN UNSIGNED(N DOWNTO 0);
		P2								: IN UNSIGNED(N DOWNTO 0);
		Prio_img						: OUT STD_LOGIC_VECTOR (N-7 DOWNTO 0)

);
END ENTITY vga_ctrl;

ARCHITECTURE functional OF vga_ctrl IS

	TYPE state IS (s0, s1, s2, s3, s4);
	SIGNAL estado_actual, siguiente_estado : state;
	SIGNAL posxB_ini, posxB_fin, posyB_ini, posyB_fin 							: UNSIGNED (N DOWNTO 0) ;
	SIGNAL posxP1_ini, posxP1_fin, posyP1_ini,posyP1_fin						: UNSIGNED (N DOWNTO 0) ;
	SIGNAL posxP2_ini, posxP2_fin, posyP2_fin,posyP2_ini 						: UNSIGNED (N DOWNTO 0) ;
	
	SIGNAL posxL_ini, posxL_fin, posyL_ini,posyL_fin 							: INTEGER ;
	SIGNAL posxR_ini, posxR_fin, posyR_ini,posyR_fin							: INTEGER ;
	SIGNAL posxU_ini, posxU_fin, posyU_fin,posyU_ini 							: INTEGER ;
	SIGNAL posxD_ini, posxD_fin, posyD_fin,posyD_ini 							: INTEGER ;
	SIGNAL posxM_ini, posxM_fin, posyM_fin,posyM_ini 							: INTEGER ;
	
	SIGNAL ConB_1, ConB_2, ConB_3, ConB_4, ConB_5, ConB_6, ConB_7			:STD_LOGIC; --
	SIGNAL ConP1_1, ConP1_2, ConP1_3, ConP1_4, ConP1_5, ConP1_6, ConP1_7 :STD_LOGIC; --  
	SIGNAL ConP2_1, ConP2_2, ConP2_3, ConP2_4, ConP2_5, ConP2_6, ConP2_7 :STD_LOGIC;
	SIGNAL ConbordeL_1, ConbordeL_2, ConbordeL_3, ConbordeL_4, ConbordeL_5, ConbordeL_6, ConbordeL_7			:STD_LOGIC; --
	SIGNAL ConbordeR_1, ConbordeR_2, ConbordeR_3, ConbordeR_4, ConbordeR_5, ConbordeR_6, ConbordeR_7			:STD_LOGIC;
	SIGNAL ConbordeU_1, ConbordeU_2, ConbordeU_3, ConbordeU_4, ConbordeU_5, ConbordeU_6, ConbordeU_7			:STD_LOGIC;
	SIGNAL ConbordeD_1, ConbordeD_2, ConbordeD_3, ConbordeD_4, ConbordeD_5, ConbordeD_6, ConbordeD_7			:STD_LOGIC;
	SIGNAL ConM_1, ConM_2, ConM_3, ConM_4, ConM_5, ConM_6, ConM_7			:STD_LOGIC;
--***********************************************************--
--DECLARACION LOGICA							   						 --
--***********************************************************--

BEGIN

ConB_1	<= '1' WHEN (PosX) >= 	(to_integer(posxB_ini)) ELSE '0';
ConB_2	<= '1' WHEN (PosX) < 	(to_integer(posxB_fin)) ELSE '0'; 
ConB_3	<= '1' WHEN (PosY) >=	(to_integer(posyB_ini)) ELSE '0';
ConB_4	<= '1' WHEN (PosY) < 	(to_integer(posyB_fin)) ELSE '0';
ConB_5	<= ConB_1 AND ConB_2;
ConB_6	<= ConB_3 AND ConB_4;
ConB_7	<= ConB_5 AND ConB_6;

ConP1_1	<= '1' WHEN (PosX) >= 	(to_integer(posxP1_ini)) ELSE '0';
ConP1_2	<= '1' WHEN (PosX) < 	(to_integer(posxP1_fin)) ELSE '0'; 
ConP1_3	<= '1' WHEN (PosY) >=	(to_integer(posyP1_ini)) ELSE '0';
ConP1_4	<= '1' WHEN (PosY) <		(to_integer(posyP1_fin)) ELSE '0';
ConP1_5	<= ConP1_1 AND ConP1_2;
ConP1_6	<= ConP1_3 AND ConP1_4;
ConP1_7	<= ConP1_5 AND ConP1_6;

ConP2_1	<= '1' WHEN (PosX) >= 	(to_integer(posxP2_ini)) ELSE '0';
ConP2_2	<= '1' WHEN (PosX) < 	(to_integer(posxP2_fin)) ELSE '0'; 
ConP2_3	<= '1' WHEN (PosY) >=	(to_integer(posyP2_ini)) ELSE '0';
ConP2_4	<= '1' WHEN (PosY) <		(to_integer(posyP2_fin)) ELSE '0';
ConP2_5	<= ConP2_1 AND ConP2_2;
ConP2_6	<= ConP2_3 AND ConP2_4;
ConP2_7	<= ConP2_6 AND ConP2_5;

ConbordeL_1	<= '1' WHEN (PosX) >= 	posxL_ini ELSE '0';
ConbordeL_2	<= '1' WHEN (PosX) <= 	posxL_fin ELSE '0'; 
ConbordeL_3	<= '1' WHEN (PosY) >=	posyL_ini ELSE '0';
ConbordeL_4	<= '1' WHEN (PosY) <= 	posyL_fin ELSE '0';
ConbordeL_5	<= ConbordeL_1 AND ConbordeL_2;
ConbordeL_6	<= ConbordeL_3 AND ConbordeL_4;
ConbordeL_7	<= ConbordeL_5 AND ConbordeL_6;

ConbordeR_1	<= '1' WHEN (PosX) >= 	posxR_ini ELSE '0';
ConbordeR_2	<= '1' WHEN (PosX) <= 	posxR_fin ELSE '0'; 
ConbordeR_3	<= '1' WHEN (PosY) >=	posyR_ini ELSE '0';
ConbordeR_4	<= '1' WHEN (PosY) <= 	posyR_fin ELSE '0';
ConbordeR_5	<= ConbordeR_1 AND ConbordeR_2;
ConbordeR_6	<= ConbordeR_3 AND ConbordeR_4;
ConbordeR_7	<= ConbordeR_5 AND ConbordeR_6;

ConbordeU_1	<= '1' WHEN (PosX) >= 	posxU_ini ELSE '0';
ConbordeU_2	<= '1' WHEN (PosX) <= 	posxU_fin ELSE '0'; 
ConbordeU_3	<= '1' WHEN (PosY) >=	posyU_ini ELSE '0';
ConbordeU_4	<= '1' WHEN (PosY) <=	posyU_fin ELSE '0';
ConbordeU_5	<= ConbordeU_1 AND ConbordeU_2;
ConbordeU_6	<= ConbordeU_3 AND ConbordeU_4;
ConbordeU_7	<= ConbordeU_5 AND ConbordeU_6;

ConbordeD_1	<= '1' WHEN (PosX) >= 	posxD_ini ELSE '0';
ConbordeD_2	<= '1' WHEN (PosX) <=	posxD_fin ELSE '0'; 
ConbordeD_3	<= '1' WHEN (PosY) >=	posyD_ini ELSE '0';
ConbordeD_4	<= '1' WHEN (PosY) <=	posyD_fin ELSE '0';
ConbordeD_5	<= ConbordeD_1 AND ConbordeD_2;
ConbordeD_6	<= ConbordeD_3 AND ConbordeD_4;
ConbordeD_7	<= ConbordeD_5 AND ConbordeD_6;

ConM_1	<= '1' WHEN (PosX) >= 	posxM_ini ELSE '0';
ConM_2	<= '1' WHEN (PosX) <=	posxM_fin ELSE '0'; 
ConM_3	<= '1' WHEN (PosY) >=	posyM_ini ELSE '0';
ConM_4	<= '1' WHEN (PosY) <=	posyM_fin ELSE '0';
ConM_5	<= ConM_1 AND ConM_2;
ConM_6	<= ConM_3 AND ConM_4;
ConM_7	<= ConM_5 AND ConM_6;



posxB_ini	<= bolitax;
posxB_fin	<= posxB_ini+20;
posyB_ini	<= bolitay;
posyB_fin	<= posyB_ini+20;

posxP1_ini	<= TO_UNSIGNED(20,N+1);
posxP1_fin	<= posxP1_ini+15;
posyP1_ini	<= P1;
posyP1_fin	<= posyP1_ini+60;

posxP2_ini	<= TO_UNSIGNED(600,N+1);
posxP2_fin	<= posxP2_ini+15;
posyP2_ini	<= P2;
posyP2_fin	<= posyP2_ini+60;

posxL_ini	<= 0;
posxL_fin	<= 4;
posyL_ini	<= 0;
posyL_fin	<= 480;

posxR_ini	<= 636;
posxR_fin	<= 640;
posyR_ini	<= 0;
posyR_fin	<= 480;

posxU_ini	<= 0;
posxU_fin	<= 640;
posyU_ini	<= 0;
posyU_fin	<= 4;

posxD_ini	<= 0;
posxD_fin	<= 640;
posyD_ini	<= 476;
posyD_fin	<= 480;

posxM_ini	<= 318;
posxM_fin	<= 322;
posyM_ini	<= 0;
posyM_fin	<= 480;

Prio_img	<= "0000" WHEN (V_on ='1' AND (conB_7 = '1') ) ELSE
				"0001" WHEN (V_on ='1' AND (ConP1_7 = '1') ) ELSE
				"0010" WHEN (V_on ='1' AND (ConP2_7 = '1') ) ELSE
				"0011" WHEN (V_on ='1' AND (ConbordeL_7 = '1') ) ELSE
				"0100" WHEN (V_on ='1' AND (ConbordeR_7 = '1') ) ELSE
				"0101" WHEN (V_on ='1' AND (ConbordeU_7 = '1') ) ELSE
				"0110" WHEN (V_on ='1' AND (ConbordeD_7 = '1') ) ELSE
				"0110" WHEN (V_on ='1' AND (ConM_7 = '1') ) ELSE
				(OTHERS => '1');

END ARCHITECTURE functional;