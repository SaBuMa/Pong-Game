LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------
ENTITY PixelY_counter IS
	GENERIC	(	N				:	INTEGER	:= 10);
	PORT 		(	clk			: 	IN		STD_LOGIC;
					rst			: 	IN		STD_LOGIC;
					ena			: 	IN		STD_LOGIC;
					syn_clr		:	IN		STD_LOGIC;
					sumy			:	IN		STD_LOGIC;
					resy			:	IN		STD_LOGIC;
					Y_min 		:	OUT	STD_LOGIC;
					Y_max 		:	OUT	STD_LOGIC;
					counter		: 	OUT	UNSIGNED(N DOWNTO 0)
					);
END ENTITY;
------------------------------------
ARCHITECTURE rt1 OF PixelY_counter IS
	CONSTANT ONES			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '1');
	CONSTANT ZEROS			:	UNSIGNED (N DOWNTO 0)	:=	(OTHERS => '0');
	
	SIGNAL count_s			:	UNSIGNED (N DOWNTO 0);
	SIGNAL count_next		:	UNSIGNED (N DOWNTO 0);
	SIGNAL pos_inicial	: 	UNSIGNED	(N DOWNTO 0);

BEGIN
	pos_inicial	<=	"00011011100";
	-- NEXT STATE LOGIC
	count_next	<=		(pos_inicial)	WHEN	syn_clr = '1'  ELSE
							count_s + 20	WHEN	(ena = '1' AND sumy='1')		ELSE
							count_s - 20	WHEN	(ena = '1' AND resy='1')		ELSE
							count_s;
	PROCESS (clk,rst,ena, pos_inicial)
		VARIABLE	temp	:	UNSIGNED(N DOWNTO 0);
	BEGIN
		IF(rst = '1') THEN
			temp :=	(pos_inicial);
		ELSIF (rising_edge(clk)) THEN
			IF (ena = '1' AND (sumy='1' XOR resy='1')) THEN
				temp := count_next;
			ELSIF (syn_clr = '1') THEN
				temp := pos_inicial;
			END IF;
		END IF;
		counter <=	temp;
		count_s <=	temp;
	END PROCESS;
	
	--OUTPUT LOGIC
	Y_max		<= '1' WHEN count_next =  TO_UNSIGNED(440,N)	ELSE '0';
	Y_min		<= '1' WHEN count_next =  TO_UNSIGNED(20,N)	ELSE '0';

	
END ARCHITECTURE;