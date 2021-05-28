--*********************--
--        	PONTIFICIA UNIVERSIDAD JAVERIANA	             	 --
--        		DISEÑO EN FPGA						                --
--                   													 --
-- Nombres: Santiago Burgos									       --
-- Título: 												 --
-- Fecha: 16/02/2021                 								 --
--                                                           --
--*********************--

--Este bloque se encarga de realizar el control de señales --> Maquina de estados

--*********************--
--DEFINICIÓN DE LAS LIBRERÍAS 
--*********************--
Library IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
--*********************--
--DEFINICION DEl ENTITY = ENTRADAS Y SALIDAS
--*********************--
ENTITY paleta_J1_ctrl IS
	PORT(		
		clk 							: IN STD_LOGIC;
		rst							: IN STD_LOGIC;
		max_tick_debouncer_up	: IN STD_LOGIC;
		up								: IN STD_LOGIC;
		maxtickTres_ctrl_up		: IN STD_LOGIC;
		ena_debouncer_up			: OUT STD_LOGIC;
		syn_clr_debouncer_up		: OUT STD_LOGIC;
		ena_timer_Tres_ctrl_up	: OUT STD_LOGIC;
		sclr_timer_Tres_ctrl_up	: OUT STD_LOGIC;
		ena_pos_J1_up				: OUT STD_LOGIC;
		up_boton						: OUT STD_LOGIC
);
END ENTITY paleta_J1_ctrl;
--*********************--
--DEFINICION DE SEÑALES AUXILIARES
--*********************--
ARCHITECTURE functional OF paleta_J1_ctrl IS
	TYPE state IS (s0, s1 , s2);
	SIGNAL estado_actual, siguiente_estado : state;
	SIGNAL ena_actual, ena_next 		:STD_LOGIC;
	SIGNAL boton_actual, boton_next	:STD_LOGIC;
--*********************--
--DECLARACION LOGICA							   						 --
--*********************--
BEGIN

ena_pos_J1_up	<= ena_actual;
up_boton			<= boton_actual;

Sequencial:PROCESS (rst, clk)
	
	BEGIN 
		IF (rst = '1') THEN
			estado_actual	<= s0;
			ena_actual		<= '0';
			boton_actual	<= '0';
		ELSIF (rising_edge(clk)) THEN
			ena_actual		<= ena_next;
			boton_actual	<= boton_next;
			estado_actual <= siguiente_estado;
			
		END IF;
	END PROCESS Sequencial;
	
Combinacional:PROCESS (estado_actual, max_tick_debouncer_up, up, maxtickTres_ctrl_up, ena_actual, boton_actual)

	BEGIN
		
		CASE estado_actual IS
		
			WHEN s0	=>--Estado inicial en donde se espera a que se oprima un boton
				ena_debouncer_up			<='0';
				syn_clr_debouncer_up		<='1';
				sclr_timer_Tres_ctrl_up	<='1';
				ena_timer_Tres_ctrl_up	<='0';
				ena_next						<='0';
				boton_next 					<='0';
				IF (up = '0') THEN --- 1 boton arriba de la tarjeta
					siguiente_estado<= s0;
				ELSIF (up ='1') THEN	--- 0 boton oprimido de la tarjeta
					siguiente_estado <= s1;
				END IF;
				
			WHEN s1 	=>--Estado en donde se realiza el conteo de 1.6ms 
				syn_clr_debouncer_up		<='0'; 
				sclr_timer_Tres_ctrl_up	<='0';
				ena_timer_Tres_ctrl_up	<='0';
				ena_debouncer_up			<='1';
				ena_next						<=ena_actual;
				boton_next 					<=boton_actual;

					IF (max_tick_debouncer_up = '1') THEN
 						IF(up ='1') THEN
							siguiente_estado <= s2;
						ELSE
							siguiente_estado	<= s0;
						END IF;
					ELSIF (max_tick_debouncer_up = '0')THEN
						siguiente_estado<=s1;
					END IF;
				
			WHEN s2 	=>--Estado en donde se lleva la cuenta de cuantos 1.6ms han pasado para asi confirmar si el boton ha sido oprimido y asi encender o apagar el led
				ena_debouncer_up			<='0';
				ena_timer_Tres_ctrl_up	<='1';
				syn_clr_debouncer_up		<='1';
				sclr_timer_Tres_ctrl_up	<='0';
				IF (maxtickTres_ctrl_up='1')THEN
					IF (up='0') THEN
						ena_next			<= '1';
						boton_next 		<= '1';
						siguiente_estado<=s0;
					ELSE
						ena_next			<='0';
						boton_next 		<='0';
						siguiente_estado<=s2;
					END IF;
				ELSE
					ena_next			<='0';
					boton_next 		<='0';
					siguiente_estado<=s1;
				END IF;

		END CASE;
	END PROCESS Combinacional;
END ARCHITECTURE functional;