--***********************************************************--
--DEFINICIÓN DE LAS LIBRERÍAS 
--***********************************************************--
Library IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
--***********************************************************--
--DEFINICION DEl ENTITY = ENTRADAS Y SALIDAS
--***********************************************************--
ENTITY bolita_ctrl IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT(		
		clk 					: IN STD_LOGIC;
		rst					: IN STD_LOGIC;
		V_on					: IN STD_LOGIC;--
		PX_max				: IN STD_LOGIC;--
		PX_min				: IN STD_LOGIC;--
		PY_max				: IN STD_LOGIC;--
		PY_min				: IN STD_LOGIC;--
		Vel_max				: IN STD_LOGIC;--
		e_juego				: IN STD_LOGIC;
		PXcount				: IN UNSIGNED(N DOWNTO 0);
		PYcount				: IN UNSIGNED(N DOWNTO 0);
		
		posy_P1				: IN UNSIGNED(N DOWNTO 0);
		posy_P2				: IN UNSIGNED(N DOWNTO 0);
		
		e_PXcounter			: OUT STD_LOGIC;
		e_PYcounter			: OUT STD_LOGIC;
		e_Velcounter		: OUT STD_LOGIC;
		e_PuntajeP1			: OUT STD_LOGIC;
		e_PuntajeP2			: OUT STD_LOGIC;
		sclrPXcounter		: OUT STD_LOGIC;
		sclrPYcounter		: OUT STD_LOGIC;
		sclrVelcounter		: OUT STD_LOGIC;
		sclrPuntajeP1		: OUT STD_LOGIC;
		sclrPuntajeP2		: OUT STD_LOGIC;
		sumx					: OUT STD_LOGIC;
		sumy					: OUT STD_LOGIC;
		resx					: OUT STD_LOGIC;
		resy					: OUT STD_LOGIC;
		posbolitax			: OUT UNSIGNED(N DOWNTO 0);
		posbolitay			: OUT UNSIGNED(N DOWNTO 0);
		
		vel_juego			: OUT UNSIGNED(N-7 DOWNTO 0)
		
);
END ENTITY bolita_ctrl;

ARCHITECTURE functional OF bolita_ctrl IS

	TYPE state IS (s0, s1 , s2, s3, s4, s5, s6, s7, s8, S9, S10);
	SIGNAL estado_actual, siguiente_estado : state;
	SIGNAL posx_actual, posx_next : UNSIGNED (N DOWNTO 0);
	SIGNAL posy_actual, posy_next : UNSIGNED (N DOWNTO 0);
	SIGNAL sumx_actual, sumx_next : STD_LOGIC;
	SIGNAL sumy_actual, sumy_next : STD_LOGIC;
	SIGNAL resx_actual, resx_next : STD_LOGIC;
	SIGNAL resy_actual, resy_next : STD_LOGIC;
	SIGNAL Colision_p1, Colision_p2 : STD_LOGIC_VECTOR (N-9 DOWNTO 0);
	SIGNAL posxBfin					: UNSIGNED (N DOWNTO 0);
	SIGNAL posyP1_s1, posyP1_s2, posyP1_s3	: UNSIGNED (N DOWNTO 0);
	SIGNAL posyP2_s1, posyP2_s2, posyP2_s3	: UNSIGNED (N DOWNTO 0);
	SIGNAL vel_actual, vel_next, vel_sig	: UNSIGNED (N-7 DOWNTO 0);
	SIGNAL epuntajeP1_actual, epuntajeP1_next	: STD_LOGIC;
	SIGNAL epuntajeP2_actual, epuntajeP2_next	: STD_LOGIC;
--***********************************************************--
--DECLARACION LOGICA							   						 --
--***********************************************************--

BEGIN
posbolitax 	<= posx_actual;
posbolitay 	<= posy_actual;
sumx			<= sumx_actual;
sumy			<= sumy_actual;
resx			<= resx_actual;
resy			<= resy_actual;
posxBfin		<= PXcount+20;

posyP1_s1	<= posy_P1;
posyP1_s2	<= posy_P1+20;
posyP1_s3	<= posy_P1+40;

posyP2_s1	<= posy_P2;
posyP2_s2	<= posy_P2+20;
posyP2_s3	<= posy_P2+40;

--vel_sig		<= vel_actual+1;
vel_juego	<= vel_actual;

e_PuntajeP1	<=	epuntajeP1_actual;
e_PuntajeP2	<=	epuntajeP2_actual;

Colision_p1 <= 
					"01" WHEN (PXcount = TO_UNSIGNED(40, N)) AND (posyP1_s1 = PYcount AND posyP1_s2 /= PYcount AND posyP1_s3 /= PYcount) ELSE 
					"10" WHEN (PXcount = TO_UNSIGNED(40, N)) AND (posyP1_s1 /= PYcount AND posyP1_s2 = PYcount AND posyP1_s3 /= PYcount) ELSE 
					"11" WHEN (PXcount = TO_UNSIGNED(40, N)) AND (posyP1_s1 /= PYcount AND posyP1_s2 /= PYcount AND posyP1_s3 = PYcount) ELSE 
					"00";
					
Colision_p2 <= 
					"01" WHEN (posxBfin = TO_UNSIGNED(585, N)) AND (posyP2_s1 = PYcount AND posyP2_s2 /= PYcount AND posyP2_s3 /= PYcount) ELSE 
					"10" WHEN (posxBfin = TO_UNSIGNED(585, N)) AND (posyP2_s1 /= PYcount AND posyP2_s2 = PYcount AND posyP2_s3 /= PYcount) ELSE 
					"11" WHEN (posxBfin = TO_UNSIGNED(585, N)) AND (posyP2_s1 /= PYcount AND posyP2_s2 /= PYcount AND posyP2_s3 = PYcount) ELSE 
					"00";

Sequencial:PROCESS (rst, clk)
	BEGIN 
	
		IF (rst = '1') THEN
			posx_actual			<= "00100110110";
			posy_actual			<= "00011011100";
			sumx_actual			<= '0';
			sumy_actual			<= '0';
			resx_actual			<= '1';
			resy_actual			<= '0';
			vel_actual			<= "0001";
			epuntajeP1_actual	<= '0';
			epuntajeP2_actual	<= '0';
			estado_actual	<= s0;
		ELSIF (rising_edge(clk)) THEN
			posx_actual			<= posx_next;
			posy_actual			<= posy_next;
			sumx_actual			<= sumx_next;
			sumy_actual			<= sumy_next;
			resx_actual			<= resx_next;
			resy_actual			<= resy_next;
			vel_actual			<= vel_next;
			epuntajeP1_actual	<= epuntajeP1_next;
			epuntajeP2_actual	<= epuntajeP2_next;
			estado_actual	<= siguiente_estado;
		END IF;
		
	END PROCESS Sequencial;

Combinacional:PROCESS (estado_actual, vel_actual, vel_sig, V_on, PX_max, PX_min, PY_max, PY_min, Vel_max, e_juego, PXcount, PYcount,
posx_actual, posy_actual, sumx_actual, sumy_actual, resx_actual, resy_actual,
Colision_p1, Colision_p2, epuntajeP1_actual, epuntajeP2_actual
)

BEGIN
	CASE estado_actual IS
		WHEN s0	=>

			e_PXcounter		<='0';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			epuntajeP1_next<='0';
			epuntajeP2_next<='0';
			sclrPXcounter	<='1';
			sclrPYcounter	<='1';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= sumx_actual;
			sumy_next		<= sumy_actual;
			resx_next		<= resx_actual;	
			resy_next		<= resy_actual;
			posx_next		<= posx_actual;
			posy_next		<= posy_actual;
			vel_next			<= "0001";
			IF (e_juego='0') THEN
				siguiente_estado	<= s0;
			ELSIF (e_juego='1') THEN
				siguiente_estado	<= s1;
			END IF;	
		
		WHEN s1 	=>		 
			e_PXcounter		<='0';
			e_PYcounter		<='0';
			e_Velcounter	<='1';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='0';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= sumx_actual;
			sumy_next		<= sumy_actual;
			resx_next		<= resx_actual;	
			resy_next		<= resy_actual;
			posx_next		<= posx_actual;
			posy_next		<= posy_actual;
			vel_next			<= vel_actual;	
			IF (Vel_max = '1') THEN
				IF (sumx_actual='1' AND sumy_actual ='0' AND resx_actual='0' AND resy_actual ='0') THEN -- SUMA X HORIZONTAL
					IF(Colision_p2 /= "00" AND PX_max = '0') THEN
						siguiente_estado	<= s10;
					ELSIF(Colision_p2 = "00" AND PX_max = '1') THEN
						siguiente_estado	<=	s8;
					ELSE	
						siguiente_estado	<= s4;
					END IF;
------------****************************************------------
				ELSIF (sumx_actual='0' AND sumy_actual ='0' AND resx_actual='1' AND resy_actual ='0') THEN -- RES X HORIZONTAL
					IF (Colision_p1 /= "00" AND PX_min = '0') THEN
						siguiente_estado	<= s9;--p1
					ELSIF(Colision_p1 = "00" AND PX_min = '1') THEN
						siguiente_estado	<=	s8;--punto
					ELSE
						siguiente_estado	<= s2;
					END IF;
------------****************************************------------
				ELSIF (sumx_actual='1' AND sumy_actual ='1' AND resx_actual='0' AND resy_actual ='0') THEN --SUM X y SUM Y
					IF(Colision_p2 /= "00" AND PX_max = '0' AND PY_max='0') THEN
						siguiente_estado	<= s10;
					ELSIF(Colision_p2 = "00" AND PX_max = '1' AND PY_max='0') THEN
						siguiente_estado	<=	s8;
					ELSIF (Colision_p2 = "00" AND PX_max = '0' AND PY_max='1') THEN
						siguiente_estado	<=	s3;
					ELSE
						siguiente_estado	<= s5;
					END IF;
------------****************************************------------
				ELSIF (sumx_actual='0' AND sumy_actual ='0' AND resx_actual='1' AND resy_actual ='1') THEN -- RESTA X y RESTA Y
					IF (Colision_p1 /= "00" AND PX_min = '0'AND PY_min = '0') THEN
						siguiente_estado	<= s9;--p1
					ELSIF(Colision_p1 = "00" AND PX_min = '1' AND PY_min = '0') THEN
						siguiente_estado	<=	s8;--p1
					ELSIF(Colision_p1 = "00" AND PX_min = '0' AND PY_min = '1') THEN
						siguiente_estado	<=	s7;
					ELSE
						siguiente_estado	<= s6;
					END IF;
------------****************************************------------
				ELSIF (sumx_actual='1' AND sumy_actual ='0' AND resx_actual='0' AND resy_actual ='1') THEN -- SUM X RES Y
					IF(Colision_p2 /= "00" AND PX_max = '0' AND PY_min='0') THEN
						siguiente_estado	<= s10;
					ELSIF(Colision_p2 = "00" AND PX_max = '1' AND PY_min='0') THEN
						siguiente_estado	<=	s8;
					ELSIF (Colision_p2 = "00" AND PX_max = '0' AND PY_min='1') THEN
						siguiente_estado	<= s5;
					ELSE
						siguiente_estado	<= s3;
					END IF;
------------****************************************------------
				ELSIF (sumx_actual='0' AND sumy_actual ='1' AND resx_actual='1' AND resy_actual ='0') THEN -- RES X y SUMA Y 
					IF (Colision_p1 /= "00" AND PX_min = '0'AND PY_max = '0') THEN
						siguiente_estado	<= s9;
					ELSIF(Colision_p1 = "00" AND PX_min = '1' AND PY_max = '0') THEN
						siguiente_estado	<=	s8;
					ELSIF (Colision_p1 = "00" AND PX_min = '0' AND PY_max = '1') THEN
						siguiente_estado	<= s6;
					ELSE
						siguiente_estado	<= s7;
					END IF;
				ELSE
					siguiente_estado	<= s8;
				END IF;
			ELSIF (Vel_max = '0') THEN
					siguiente_estado <= s1;	
			END IF;
	
	WHEN s2 	=>		 -- este es x-- y deshabilitado
			e_PXcounter		<='1';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '0';
			sumy_next		<= '0';
			resx_next		<= '1';	
			resy_next		<= '0';
			posx_next		<= PXcount;
			posy_next		<= posy_actual;
			vel_next			<= vel_actual;
			siguiente_estado	<= s1;

			
	WHEN s3 	=>	-- EN ESTE ESTADO X++ Y --	 
			e_PXcounter		<='1';
			e_PYcounter		<='1';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '1';
			sumy_next		<= '0';
			resx_next		<= '0';	
			resy_next		<= '1';
			posx_next		<= PXcount;
			posy_next		<= PYcount;
			vel_next			<= vel_actual;
			siguiente_estado	<= s1;
			
	WHEN s4 	=>	-- EN ESTE ESTADO X++ Y deshabilitado 
			e_PXcounter		<='1';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '1';
			sumy_next		<= '0';
			resx_next		<= '0';	
			resy_next		<= '0';
			posx_next		<= PXcount;
			posy_next		<= posy_actual;
			vel_next			<= vel_actual;
			siguiente_estado	<= s1;
	
	WHEN s5 	=>	-- EN ESTE ESTADO X++ Y ++	 
			e_PXcounter		<='1';
			e_PYcounter		<='1';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '1';
			sumy_next		<= '1';
			resx_next		<= '0';	
			resy_next		<= '0';
			posx_next		<= PXcount;
			posy_next		<= PYcount;
			vel_next			<= vel_actual;
			siguiente_estado	<=	s1;

	WHEN s6 	=>	-- EN ESTE ESTADO X-- Y --	 
			e_PXcounter		<='1';
			e_PYcounter		<='1';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '0';
			sumy_next		<= '0';
			resx_next		<= '1';	
			resy_next		<= '1';
			posx_next		<= PXcount;
			posy_next		<= PYcount;
			vel_next			<= vel_actual;
			siguiente_estado	<=	s1;
	
	WHEN s7 	=>	-- EN ESTE ESTADO X-- Y++	 
			e_PXcounter		<='1';
			e_PYcounter		<='1';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '0';
			sumy_next		<= '1';
			resx_next		<= '1';	
			resy_next		<= '0';
			posx_next		<= PXcount;
			posy_next		<= PYcount;
			vel_next			<= vel_actual;
			siguiente_estado	<= s1;
	
	WHEN s8 	=>	-- PUNTAJE	 
			e_PXcounter		<='0';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= '0';
			sumy_next		<= '0';
			resx_next		<= '1';	
			resy_next		<= '0';
			posx_next		<= "00100110110";
			posy_next		<= "00011011100";
			vel_next			<= vel_actual;
			IF (PX_max ='0' AND PX_min ='1') THEN
				epuntajeP1_next<='0';
				epuntajeP2_next<='1';
			ELSIF (PX_max ='1' AND PX_min ='0')THEN
				epuntajeP1_next<='1';
				epuntajeP2_next<='0';
			ELSE	
				epuntajeP1_next<='0';
				epuntajeP2_next<='0';
			END IF;
			siguiente_estado	<= s0;
			
	WHEN s9 	=>	-- Colision P1	 
			e_PXcounter		<='0';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			epuntajeP1_next<=epuntajeP1_actual;
			epuntajeP2_next<=epuntajeP2_actual;
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= sumx_actual;
			sumy_next		<= sumy_actual;
			resx_next		<= resx_actual;	
			resy_next		<= resy_actual;
			posx_next		<= posx_actual;
			posy_next		<= posy_actual;
			vel_next			<= vel_actual+2;
			IF (Colision_p1 = "01" AND PX_min='0') THEN
				siguiente_estado	<= s3;
			ELSIF (Colision_p1 = "10" AND PX_min='0') THEN
				siguiente_estado	<= s4;
			ELSIF (Colision_p1 = "11" AND PX_min='0') THEN
				siguiente_estado	<= s5;	
			ELSE
				siguiente_estado	<= s8;
			END IF;


	WHEN s10 	=>	-- Colision P2	 
			e_PXcounter		<='0';
			e_PYcounter		<='0';
			e_Velcounter	<='0';
			epuntajeP1_next<='0';
			epuntajeP2_next<='0';
			sclrPXcounter	<='0';
			sclrPYcounter	<='0';
			sclrVelcounter	<='1';
			sclrPuntajeP1	<='0';
			sclrPuntajeP2	<='0';
			sumx_next		<= sumx_actual;
			sumy_next		<= sumy_actual;
			resx_next		<= resx_actual;	
			resy_next		<= resy_actual;
			posx_next		<= posx_actual;
			posy_next		<= posy_actual;
			vel_next			<= vel_actual;
			IF (Colision_p2 = "01" AND PX_max='0') THEN
				siguiente_estado	<= s6;
			ELSIF (Colision_p2 = "10" AND PX_max='0') THEN
				siguiente_estado	<= s2;
			ELSIF (Colision_p2 = "11" AND PX_max='0') THEN
				siguiente_estado	<= s7;
			ELSE
				siguiente_estado	<= s8;
			END IF;
	
		END CASE;
		
	END PROCESS Combinacional;

END ARCHITECTURE functional;	

