--***********************************************************--
--        	PONTIFICIA UNIVERSIDAD JAVERIANA	             	 --
--        		DISEÑO EN FPGA						                --
--                   													 --
-- Nombres: Santiago Burgos									       --
-- Título: 												 --
-- Fecha: 16/02/2021                 								 --
--                                                           --
--***********************************************************--

--Este bloque se encarga de realizar la comparacion entre dos numeros binarios

--***********************************************************--
--DEFINICIÓN DE LAS LIBRERÍAS 
--***********************************************************--
Library IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
--***********************************************************--
--DEFINICION DEl ENTITY = ENTRADAS Y SALIDAS
--***********************************************************--
ENTITY vga IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT(		
		clk								: IN STD_LOGIC; 
		rst								: IN STD_LOGIC;
		ejuego							: IN STD_LOGIC;
		up_J1,up_J2						: IN STD_LOGIC;
		down_J1, down_J2				: IN STD_LOGIC;
		colorR, colorG, colorB		: OUT STD_LOGIC_VECTOR(N-7 DOWNTO 0);
		Hsync, Vsync					: OUT STD_LOGIC;
		sseg1, sseg2					: OUT STD_LOGIC_VECTOR(N-4 DOWNTO 0)
		
);
END ENTITY vga;

ARCHITECTURE functional OF vga IS
	------------------------------Señales VGA----------------------------------------
	SIGNAL video_on																			: STD_LOGIC;
	SIGNAL eHcounter_s, eVcounter_s														: STD_LOGIC;
	SIGNAL sclrHcounter_s, sclrVcounter_s											 	: STD_LOGIC;
	SIGNAL Ha_s, Hs_s, Hm_s, Velm_s														: STD_LOGIC;
	SIGNAL Va_s, Vs_s																			: STD_LOGIC;
	SIGNAL clk25																				: STD_LOGIC;
	SIGNAL Prio_img_s																			: STD_LOGIC_VECTOR(N-7 DOWNTO 0);
	SIGNAL Hc_s, Vc_s																			: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	--------------------------Señales bolita-----------------------------------------------------
	SIGNAL PXcount_s, PYcount_s															: UNSIGNED(N DOWNTO 0);
	SIGNAL Posx_s, PosY_s																	: INTEGER;
	SIGNAL ePXcounter_s, ePYcounter_s, eVelcounter_s								: STD_LOGIC;
	SIGNAL sclrPXcounter_s, sclrPYcounter_s, sclrVelcounter_s					: STD_LOGIC;
	SIGNAL PXmax_s, PXmin_s, sumx_s, resx_s											: STD_LOGIC;
	SIGNAL PYmax_s, PYmin_s, sumy_s, resy_s											: STD_LOGIC;
	SIGNAL posbolita_s																		: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL bolitax_s, bolitay_s															: UNSIGNED(N DOWNTO 0);
	SIGNAL posxBini_s, posxBfin_s, posyBini_s, posyBfin_s							: UNSIGNED(N DOWNTO 0);
	SIGNAL veljuego_s																			: UNSIGNED(N-7 DOWNTO 0);

--------------------------Señales paletas---------------------------------------------------------
	SIGNAL maxtickdebouncer_J1_up, maxtickdebouncer_J2_up							: STD_LOGIC;
	SIGNAL maxtickTres_J1_up, 	maxtickTres_J2_up										: STD_LOGIC;
	SIGNAL e_D_J1_up, e_D_J2_up															: STD_LOGIC;
	SIGNAL sclr_D_J1_up, sclr_D_J2_up													: STD_LOGIC;
	SIGNAL ena_timer_Tres_J1_up, ena_timer_Tres_J2_up 								: STD_LOGIC;
	SIGNAL sclr_timer_Tres_J1_up, sclr_timer_Tres_J2_up							: STD_LOGIC;
	SIGNAL enable_pos_J1_up, enable_pos_J2_up											: STD_LOGIC;
	SIGNAL maxtickdebouncer_J1_down, maxtickdebouncer_J2_down					: STD_LOGIC;
	SIGNAL maxtickTres_J1_down, 	maxtickTres_J2_down								: STD_LOGIC;
	SIGNAL e_D_J1_down, e_D_J2_down														: STD_LOGIC;
	SIGNAL sclr_D_J1_down, sclr_D_J2_down												: STD_LOGIC;
	SIGNAL ena_timer_Tres_J1_down, ena_timer_Tres_J2_down 						: STD_LOGIC;
	SIGNAL sclr_timer_Tres_J1_down, sclr_timer_Tres_J2_down						: STD_LOGIC;
	SIGNAL enable_pos_J1_down, enable_pos_J2_down									: STD_LOGIC;
	SIGNAL up_boton_J1, up_boton_J2														: STD_LOGIC;
	SIGNAL down_boton_J1, down_boton_J2													: STD_LOGIC;
	SIGNAL pos_paleta_J1_ini, posy_J1_s, pos_paleta_J2_ini, posy_J2_s			: UNSIGNED (N DOWNTO 0);
	
--------------------------Señales puntaje---------------------------------------------------------
	SIGNAL epuntajeP1_S, epuntajeP2_S													: STD_LOGIC;
	SIGNAL sclrpuntajeP1_s, sclrpuntajeP2_s											: STD_LOGIC;
	SIGNAL P1max_s, P2max_s, GG															: STD_LOGIC;
	SIGNAL puntajeP1_s, puntajeP2_s														: STD_LOGIC_VECTOR(N-7 DOWNTO 0);
	
--***********************************************************--
--DECLARACION LOGICA							   						 --
--***********************************************************--
BEGIN
--colorR<= (OTHERS =>'1') WHEN (prio_img_s	= "00" OR prio_img_s	= "01" OR prio_img_s	= "10") ELSE (OTHERS =>'0');
--colorG<=	(OTHERS =>'0') WHEN (video_on='1') ELSE (OTHERS =>'1');
--colorB<=	(OTHERS =>'0') WHEN (video_on='1') ELSE (OTHERS =>'1');
colorR<= (OTHERS =>'1') WHEN (prio_img_s	= "0000" OR prio_img_s	= "0001" OR prio_img_s	= "0010" OR
										prio_img_s	= "0011" OR prio_img_s	= "0100" OR prio_img_s	= "0101" OR
										prio_img_s	= "0110" OR prio_img_s	= "0111"
										) ELSE (OTHERS =>'0');
colorG<=	(OTHERS =>'0') WHEN (video_on='1') ELSE (OTHERS =>'1');
colorB<=	(OTHERS =>'0') WHEN (video_on='1') ELSE (OTHERS =>'1');
 
video_on <= Ha_s AND Va_s;
Hsync	<=Hs_s;
Vsync	<=Vs_s;
GG <= rst OR (P1max_s XOR P2max_s);
Posx_s	<= (to_integer(UNSIGNED(Hc_s)))- 144 WHEN (video_on	=	'1') ELSE 0;
PosY_s	<= (to_integer(UNSIGNED(Vc_s)))- 35  WHEN (video_on	=	'1') ELSE 0;
-----------------------------------------------
--*********************************
------------------------------------------MANEJO DE VGA------------------------------------------

Control_VGA: ENTITY work.vga_ctrl
	PORT 	MAP(	
		clk 				=> clk,
		rst				=> rst,
		V_on				=> video_on,
		PosX				=> Posx_s,
		PosY				=> PosY_s,
		bolitax			=> bolitax_s,
		bolitay			=> bolitay_s,
		P1					=> posy_J1_s,
		P2					=> posy_J2_s,
		Prio_img			=> Prio_img_s		
	);
	
Clock_25: ENTITY work.pll25
	PORT 	MAP(		
		inclk0		=> clk,	
		c0				=> clk25	
	);

ContadorHorizontal: ENTITY work.H_counter
	PORT MAP(	
		
		clk			=> clk25,		 	--IN
		rst			=> rst,  		 	--IN
		ena			=> '1',				--IN
		syn_clr		=> '0',				--IN		 
		H_activo 	=> Ha_s,		 		--OUT
		H_sync		=> Hs_s,				--OUT
		H_max			=> Hm_s,				--OUT
		counter		=>	Hc_s				--OUT	9 to 0
	);

ContadorVertical: ENTITY work.V_counter
	PORT MAP(	
		
		clk			=> clk25,			--IN
		rst			=> rst,				--IN
		ena			=>	Hm_s,				--IN
		syn_clr		=> '0',				--IN
		V_activo 	=> Va_s,				--OUT
		V_sync		=> Vs_s,				--OUT
		V_Counter	=> Vc_s				--OUT	9 to 0
	);	
--------------------------------------------------- FIN MANEJO VGA------------------------------------------

-------------------------------------------------MANEJO BOLITA------------------------------------------------
--				
ContadorPixelX: ENTITY work.PixelX_counter
	PORT MAP(	
		
		clk			=> clk,					--IN
		rst			=> GG,					--IN
		ena			=> ePXcounter_s,		--IN
		syn_clr		=> sclrPXcounter_s,	--IN
		sumx			=> sumx_s,				--IN
		resx			=> resx_s,				--IN
		X_max			=> PXmax_s,				--OUT
		X_min			=> PXmin_s,				--OUT
		counter		=>	PXcount_s			--OUT 9 TO 0
	);
	
ContadorPixelY: ENTITY work.PixelY_counter
	PORT MAP(	
		
		clk			=> clk,					--IN
		rst			=> GG,					--IN
		ena			=> ePYcounter_s,		--IN
		syn_clr		=> sclrPYcounter_s,	--IN
		sumy			=> sumy_s,				--IN
		resy			=> resy_s,				--IN
		Y_min			=> PYmin_s,				--OUT
		Y_max			=> PYmax_s,				--OUT
		counter		=>	PYcount_s			--OUT 9 TO 0
	);
	
ContadorVelocidad: ENTITY work.Vel_counter
	PORT MAP(	
		
		clk			=> clk,					--IN
		rst			=> GG,					--IN
		ena			=> eVelcounter_s,		--IN
		syn_clr		=> sclrVelcounter_s,	--IN
		vel_juego	=> veljuego_s,
		vel_max		=> Velm_s				--OUT
	);
	
Control_Bolita: ENTITY work.bolita_ctrl
	PORT 	MAP(	
		clk 				=> clk,
		rst				=> GG,
		V_on				=> video_on,
		PX_max			=> PXmax_s,
		PX_min			=> PXmin_s,
		PY_max			=> PYmax_s,
		PY_min			=> PYmin_s,
		Vel_max			=> Velm_s,
		e_juego			=> ejuego,
		PXcount			=> PXcount_s,
		PYcount			=> PYcount_s,
		
		posy_P1			=> posy_J1_s,
		posy_P2			=> posy_J2_s,
		
		e_PXcounter		=> ePXcounter_s,
		e_PYcounter		=> ePYcounter_s,
		e_Velcounter	=> eVelcounter_s,
		e_PuntajeP1		=> epuntajeP1_S,
		e_PuntajeP2		=> epuntajeP2_S,
		sclrPXcounter	=> sclrPXcounter_s,
		sclrPYcounter	=> sclrPYcounter_s,
		sclrVelcounter	=> sclrVelcounter_s,
		sclrPuntajeP1	=> sclrpuntajeP1_s,
		sclrPuntajeP2	=> sclrpuntajeP2_s,
		sumx				=> sumx_s,
		sumy				=> sumy_s,
		resx				=> resx_s,
		resy				=> resy_s,
		posbolitax		=> bolitax_s,
		posbolitay		=> bolitay_s,
		
		vel_juego		=> veljuego_s
	);
	
--------------------------------------------FIN MANEJO BOLITA------------------------------------------------

--------------------------CONTADORES DE BOTONES------------------------------------------------------
timerDebounce_J1_up: ENTITY work.timerDebounce
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>e_D_J1_up,
		syn_clr		=>sclr_D_J1_up,
		max_tick		=>maxtickdebouncer_J1_up
	);
	
timerDebounce_J2_up: ENTITY work.timerDebounceJ2
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>e_D_J2_up,
		syn_clr		=>sclr_D_J2_up,
		max_tick		=>maxtickdebouncer_J2_up
	);
	
--Bloque auxiliar que se encarga llevar la cuenta de cuantas veces se ha cumplido el tiempo de 1.6ms para detectar adecuadamente la pulsacion de un boton
timerTres_J1_up: ENTITY work.timerTres
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>ena_timer_Tres_J1_up,
		syn_clr		=>sclr_timer_Tres_J1_up,
		max_tick		=>maxtickTres_J1_up
	);	

timerTres_J2_up: ENTITY work.timerTresJ2
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>ena_timer_Tres_J2_up,
		syn_clr		=>sclr_timer_Tres_J2_up,
		max_tick		=>maxtickTres_J2_up
	);	

timerDebounce_J1_down: ENTITY work.timerDebounce
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>e_D_J1_down,
		syn_clr		=>sclr_D_J1_down,
		max_tick		=>maxtickdebouncer_J1_down
	);
	
timerDebounce_J2_down: ENTITY work.timerDebounceJ2
	PORT MAP(	
		clk			=>clk,
		rst			=>GG,
		ena			=>e_D_J2_down,
		syn_clr		=>sclr_D_J2_down,
		max_tick		=>maxtickdebouncer_J2_down
	);
	
--Bloque auxiliar que se encarga llevar la cuenta de cuantas veces se ha cumplido el tiempo de 1.6ms para detectar adecuadamente la pulsacion de un boton
timerTres_J1_down: ENTITY work.timerTres
	PORT MAP(	
	   clk			=>clk,
		rst			=>GG,
		ena			=>ena_timer_Tres_J1_down,
		syn_clr		=>sclr_timer_Tres_J1_down,
		max_tick		=>maxtickTres_J1_down
	);	

timerTres_J2_down: ENTITY work.timerTresJ2
	PORT MAP(	
	   clk			=>clk,
		rst			=>GG,
		ena			=>ena_timer_Tres_J2_down,
		syn_clr		=>sclr_timer_Tres_J2_down,
		max_tick		=>maxtickTres_J2_down
	);
	
-------------------------- FIN CONTADORES DE BOTONES------------------------------------------------------	

-------------------------CONTROLES PALETAS----------------------------------------------------------------
Paleta_1_ctrl: ENTITY work.paleta_J1_ctrl
	PORT MAP(	
		clk 								=>clk,	
		rst								=>GG,					
		max_tick_debouncer_up		=>maxtickdebouncer_J1_up,
		up									=>up_J1,
		maxtickTres_ctrl_up			=>	maxtickTres_J1_up,
		ena_debouncer_up				=>e_D_J1_up,
		syn_clr_debouncer_up			=>sclr_D_J1_up,
		ena_timer_Tres_ctrl_up		=>ena_timer_Tres_J1_up,
		sclr_timer_Tres_ctrl_up		=>sclr_timer_Tres_J1_up,
		ena_pos_J1_up					=> enable_pos_J1_up,
		up_boton							=> up_boton_J1
		);
		
Paleta_1_ctrl_down: ENTITY work.paleta_J1_ctrl_down
	PORT MAP(	
		clk 								=>clk,	
		rst								=>GG,					
		max_tick_debouncer_down		=> maxtickdebouncer_J1_down,
		down								=>down_J1,
		maxtickTres_ctrl_down		=> maxtickTres_J1_down,
		ena_debouncer_down			=> e_D_J1_down,
		syn_clr_debouncer_down		=> sclr_D_J1_down,
		ena_timer_Tres_ctrl_down	=> ena_timer_Tres_J1_down,
		sclr_timer_Tres_ctrl_down	=> sclr_timer_Tres_J1_down,
		ena_pos_J1_down				=> enable_pos_J1_down,
		down_boton						=> down_boton_J1
		);

Paleta_2_ctrl: ENTITY work.paleta_J2_ctrl
	PORT MAP(	
		clk 								=>clk,	
		rst								=>GG,					
		max_tick_debouncer_up		=>maxtickdebouncer_J2_up,
		up									=>up_J2,
		maxtickTres_ctrl_up			=>	maxtickTres_J2_up,
		ena_debouncer_up				=>e_D_J2_up,
		syn_clr_debouncer_up			=>sclr_D_J2_up,
		ena_timer_Tres_ctrl_up		=>ena_timer_Tres_J2_up,
		sclr_timer_Tres_ctrl_up		=>sclr_timer_Tres_J2_up,
		ena_pos_J2_up					=> enable_pos_J2_up,
		up_boton							=> up_boton_J2
		);

Paleta_2_ctrl_down: ENTITY work.paleta_J2_ctrl_down
	PORT MAP(	
		clk 								=>clk,	
		rst								=>GG,					
		max_tick_debouncer_down		=> maxtickdebouncer_J2_down,
		down								=>down_J2,
		maxtickTres_ctrl_down		=> maxtickTres_J2_down,
		ena_debouncer_down			=> e_D_J2_down,
		syn_clr_debouncer_down		=> sclr_D_J2_down,
		ena_timer_Tres_ctrl_down	=> ena_timer_Tres_J2_down,
		sclr_timer_Tres_ctrl_down	=> sclr_timer_Tres_J2_down,
		ena_pos_J2_down				=> enable_pos_J2_down,
		down_boton						=> down_boton_J2
		);
	
movimiento_J1:	ENTITY work.posicion_J1
	PORT MAP	(	
		clk								=> clk,
		rst								=> GG,
		syn_clr							=> '0', ----CAMBIAR
		ena								=> enable_pos_J1_up,
		ena_down							=> enable_pos_J1_down,
		up									=> up_boton_J1,
		down								=> down_boton_J1,
		counter							=> pos_paleta_J1_ini
	);

movimiento_J2:	ENTITY work.posicion_J2
	PORT MAP	(	
		clk								=> clk,
		rst								=> GG,
		syn_clr							=> '0', ----CAMBIAR
		ena								=> enable_pos_J2_up,
		ena_down							=> enable_pos_J2_down,
		up									=> up_boton_J2,
		down								=> down_boton_J2,
		counter							=> pos_paleta_J2_ini
	);
	
DFF_P1: ENTITY work.mydff_P1
	PORT MAP(	
		
		clk								=> clk,						--IN
		rst								=> GG,   					--IN
		ena_up							=> up_boton_J1,			--IN
		ena_dw							=> down_boton_J1,			--IN
		syn_clr							=> '0',						--IN
		d									=>	pos_paleta_J1_ini,	--IN
		q									=>	posy_J1_s				--OUT 	13 to 0
		);
		
DFF_P2: ENTITY work.mydff_P2
	PORT MAP(	
		
		clk								=> clk,						--IN
		rst								=> GG,   					--IN
		ena_up							=> up_boton_J2,			--IN
		ena_dw							=> down_boton_J2,			--IN
		syn_clr							=> '0',						--IN
		d									=>	pos_paleta_J2_ini,	--IN
		q									=>	posy_J2_s				--OUT 	13 to 0
		);
		
-------------------------- FIN CONTROLES PALETAS------------------------------------------------------	

-------------------------PUNTAJE----------------------------------------------------------------
PUNTAJE_P1: ENTITY work.puntajeP1
	PORT MAP(	
		
		clk			=> clk,					--IN
		rst			=> GG,					--IN
		ena			=> epuntajeP1_S,		--IN
		syn_clr		=> sclrpuntajeP1_s,	--IN
		puntaje_max	=> P1max_s,				--OUT
		counter		=>	puntajeP1_s			--OUT 9 TO 0
	);

PUNTAJE_P2: ENTITY work.puntajeP2
	PORT MAP(	
		
		clk			=> clk,					--IN
		rst			=> GG,					--IN
		ena			=> epuntajeP2_S,		--IN
		syn_clr		=> sclrpuntajeP2_s,	--IN
		puntaje_max	=> P2max_s,				--OUT
		counter		=>	puntajeP2_s			--OUT 9 TO 0
	);

SSEGMENT: ENTITY work.sspuntaje
	PORT MAP(	
		
		puntaje_P1	=> puntajeP1_s,
		puntaje_P2	=> puntajeP2_s,
		sseg_1		=> sseg1,   	
		sseg_2		=> sseg2	
		);

END ARCHITECTURE functional;