--Group 10: Daniel Kim and Hassan Khaled Nada


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------

	
	
	--For part F simulation
	
	--sim_sm_clken, sim_blink_sig 		: out std_logic;
	--ns_red_a, ns_green_d, ns_yellow_g, ew_red_a, ew_green_d, ew_yellow_g		: out std_logic;
	
	
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
          clk        	: in  	std_logic := '0'; 
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT				: out	std_logic_vector(6 downto 0);
			 DIG2				: out	std_logic;
			 DIG1				: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin 		   : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

   component pb_filters port (
			clkin						: in std_logic; --global clock input
			rst_n						: in std_logic; 
			rst_n_filtered			: out std_logic;
			pb_n						: in  std_logic_vector (3 downto 0);
			pb_n_filtered			: out	std_logic_vector(3 downto 0)							 
 );
   end component;

	
	
	
	---------------------
--	WORK STARTS HERE:	
	---------------------
	
	component pb_inverters port (
			rst_n					: in  std_logic; --active low global reset input
			rst				   : out	std_logic; --rst output					 
			pb_n_filtered	   : in  std_logic_vector (3 downto 0); --filtered pb_n inputs from pb_filters
			pb						: out	std_logic_vector(3 downto 0)	--inverted pb output							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic; --global clock input
			reset					: in std_logic; --active low global reset input
			din					: in std_logic; --input for pb(0)/pb(1)
			dout					: out std_logic --the synchronized output for the holding register
  );
end component; 

  component holding_register port (
			clk					: in std_logic; --global clock input
			reset					: in std_logic; --active low global reset input
			register_clr		: in std_logic; --input for the register to clear its holding value
			din					: in std_logic; --input for the value to be held
			dout					: out std_logic --output to signal whether or not a value is being held
  );
end component;	

component state_machine port (
			clk_input, synch_rst, sm_clken, blink_sig 	: IN std_logic; --state machine inputs for the global clock, active low synchronous reset, state machine clock enabler, and the blinking 
																							 --signal respectfully

			ns_request, ew_request								: IN std_logic; --inputs for north/south and east/west requests from pedestrians

			ns_green, ns_yellow, ns_red						: OUT std_logic; --outputs for north/south intersection lights (green, yellow, and red)
			ew_green, ew_yellow, ew_red						: OUT std_logic; --outputs for east/west intersection lights (green, yellow, and red)

			ns_crossing, ns_clear								: OUT std_logic; --outputs for north/south intersection crossing signal and the clearing functionality of the crossing signal
			ew_crossing, ew_clear								: OUT std_logic; --outputs for east/west intersection crossing signal and the clearing functionality of the crossing signal
			
			state_num												: OUT std_logic_vector (3 downto 0) --4 bit binary number for the current state number
	);
end component;



----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode											: boolean := TRUE;  -- set to FALSE for LogicalStep board downloads							-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			   : std_logic; --signal for global reset, reset for rst_n_filtered component, and synchronous reset
	SIGNAL sm_clken, blink_sig								: std_logic; --signal for state machine clock enable and the blinking signal 
	SIGNAL pb_n_filtered, pb								: std_logic_vector(3 downto 0); --signals for filtered push buttons
	

	signal ns_green, ns_yellow, ns_red					: std_logic; --signals for ns green, yellow, and red lights
	signal ns_request, ns_crossing, ns_clear			: std_logic; --signals for ns pedestrian request, pedestrian crossing signal, and clear for registers
	
	
	signal ew_green, ew_yellow, ew_red					: std_logic; --signals for ew green, yellow, and red lights
	signal ew_request, ew_crossing, ew_clear			: std_logic; --sigals for ew pedestrian request, pedestrian crossing signal, and clear for registers
	

	signal ns_in, ew_in										: std_logic; --signals for ns and ew data inputs for segment7_mux
	signal ns_out, ew_out									: std_logic_vector (6 downto 0); --signals for ns and ew data outputs for DIG1 and DIG 2
	
	signal state_num											: std_logic_vector (3 downto 0); --signal for 4bit binary number for leds4-7
		

BEGIN
----------------------------------------------------------------------------------------------------


--INSTANCES: 
INST0: pb_filters					port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters				port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: synchronizer     		port map (clkin_50, '0', rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST3: clock_generator 			port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);


INST4: synchronizer 				port map(clkin_50, synch_rst, pb(0), ns_request);
INST5: holding_register			port map(clkin_50, synch_rst, ns_clear, ns_request, ns_in);

INST6: synchronizer				port map(clkin_50, synch_rst, pb(1), ew_request);
INST7: holding_register			port map(clkin_50, synch_rst, ew_clear, ew_request, ew_in);

INST8: state_machine 			port map(

													clkin_50, synch_rst, sm_clken, blink_sig, 
													
													ns_in, ew_in, 
																										
													ns_green, ns_yellow, ns_red, 
													ew_green, ew_yellow, ew_red,
													
													
													leds(0), ns_clear, 
													leds(2), ew_clear,
													
													state_num);

INST9: segment7_mux port map(clkin_50, ns_out, ew_out, seg7_data, seg7_char2, seg7_char1);



leds(1) <= ns_in;	--light up led(1) to signal that ns pedestrian has requested to cross
leds(3) <= ew_in; --light up led(3) to signal that ew pedestrian has requested to cross
leds(7 downto 4) <= state_num; --light up leds(7-4) to signal the state number in binary										

ns_out <= (ns_yellow & "00" & ns_green & "00" & ns_red); --signal concatenations to drive segment values to segment7 mux DIG2
ew_out <= (ew_yellow & "00" & ew_green & "00" & ew_red); --signal concatenations to drive segment values to segment7 mux for DIG1




--for part F simulation:
--sim_sm_clken <= sm_clken;
--sim_blink_sig <= blink_sig; 				
--ns_red_a <= ns_red;
--ns_green_d <= ns_green;
--ns_yellow_g <= ns_yellow;
--ew_red_a <= ew_red;
--ew_green_d <= ew_green;
--ew_yellow_g <= ew_yellow;


END SimpleCircuit;
