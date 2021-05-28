LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY vga_tb IS
GENERIC	(	B				:	INTEGER	:= 4);
	END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF vga_tb IS

	-- SIGNAL count_s		:	INTEGER RANGE 0 to (2**N-1);
	
	----------------------ENTRADAS Y SALIDAS-------------------------------------------------
	SIGNAL	clk_tb			:	STD_LOGIC:='0';
	SIGNAL	clk25_tb			:	STD_LOGIC:='0';
	SIGNAL	rst_tb			: 	STD_LOGIC;
	SIGNAL	ejuego_tb			: 	STD_LOGIC;
	SIGNAL colorR_tb 		: 	STD_LOGIC_VECTOR(B-1 DOWNTO 0);
	SIGNAL colorG_tb		: 	STD_LOGIC_VECTOR(B-1 DOWNTO 0);
	SIGNAL colorB_tb		: 	STD_LOGIC_VECTOR(B-1 DOWNTO 0);
	SIGNAL Hsync_tb, VSync_tb			:  STD_LOGIC;
	SIGNAL up_J1_tb,up_J2_tb					:  STD_LOGIC;
	SIGNAL down_J1_tb, down_J2_tb				:  STD_LOGIC;
	------------------------------------------------------------------------------------------
	

BEGIN
	--CLOCK GENERATION:------------------------
	clk_tb <= not clk_tb after 10ns; -- 50MHz clock generation
	clk25_tb <= not clk25_tb after 20ns;
	
	DUT:	ENTITY work.vga
	PORT MAP(	clk				=>	clk_tb,
					--clk25				=>	clk25_tb,
					rst				=> rst_tb,
					ejuego			=> ejuego_tb,
					up_J1				=> up_J1_tb,
					up_J2				=> up_J2_tb,
					down_J1			=> down_J1_tb,
					down_J2			=> down_J2_tb,
					colorR		=> colorR_tb,
					colorG		=> colorG_tb,
					colorB		=> colorB_tb,
					Hsync			=> Hsync_tb,
					VSync			=> Vsync_tb				
				);
	--Input signal generation
	signal_generation: PROCESS
	BEGIN
		
		-- TEST VECTOR 1
		rst_tb	  		<= '1';
		WAIT FOR 200 ns;
		
		-- TEST VECTOR 2
		rst_tb	  		<= '0';
		WAIT FOR 30 ms;
		
--		-- TEST VECTOR 3
--		rst_tb	  		<= '0';
--		eHcounter_tb	<= '0';
--		eVcounter_tb	<= '0';
--		sclrHcounter_tb<= '1';
--		sclrVcounter_tb<= '1';
--		WAIT FOR 200 ns;
--		
--		-- TEST VECTOR 4
--		rst_tb	  		<= '1';
--		eHcounter_tb	<= '0';
--		eVcounter_tb	<= '0';
--		sclrHcounter_tb<= '1';
--		sclrVcounter_tb<= '1';
--		WAIT FOR 200 ns;
--		
--		-- TEST VECTOR 5
--		rst_tb	  		<= '1';
--		eHcounter_tb	<= '0';
--		eVcounter_tb	<= '0';
--		sclrHcounter_tb<= '1';
--		sclrVcounter_tb<= '1';
--		WAIT FOR 200 ns;
		
		
	END PROCESS;
	
END ARCHITECTURE;