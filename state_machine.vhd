--Group 10: Daniel Kim and Hassan Khaled Nada


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--MOORE STATE MACHINE


Entity State_Machine IS Port
(
			clk_input, synch_rst, sm_clken, blink_sig 	: IN std_logic; --state machine inputs for the global clock, active low synchronous reset, state machine clock enabler, and the blinking 
																							 --signal respectfully

			ns_request, ew_request								: IN std_logic; --inputs for north/south and east/west requests from pedestrians

			ns_green, ns_yellow, ns_red						: OUT std_logic; --outputs for north/south intersection lights (green, yellow, and red)
			ew_green, ew_yellow, ew_red						: OUT std_logic; --outputs for east/west intersection lights (green, yellow, and red)

			ns_crossing, ns_clear								: OUT std_logic; --outputs for north/south intersection crossing signal and the clearing functionality of the crossing signal
			ew_crossing, ew_clear								: OUT std_logic; --outputs for east/west intersection crossing signal and the clearing functionality of the crossing signal
			
			state_num												: OUT std_logic_vector (3 downto 0) --4 bit binary number for the current state number

 );
END ENTITY;
 

 Architecture SM of State_Machine is

 TYPE states IS (S0, S1, S2, S3, S4, S5, S6, S7, s8, s9, s10, s11, s12, s13, s14, s15);   -- list of all the states
 SIGNAL current_state, next_state	:  states;     	-- signals of type states
 

 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN --if input clock is on a rising edge
		IF (synch_rst = '1') THEN --and if the synchronous reset is enabled
			current_state <= S0; --go back to initial state 0
		ELSIF (synch_rst = '0' AND sm_clken = '1') THEN		--else if the synchronous reset is NOT enabled and the clock enabler is enabled
			current_state <= next_State; --then move to next state
		END IF;
	END IF;
END PROCESS;	





Transition_Section: PROCESS (current_state) 

BEGIN
  CASE current_state IS
        WHEN S0 =>	--At s0, if ew_request is activated and ns_request is not, then skip to s6 state. Else, transition normally to next state. 

					IF(ns_request = '0' AND ew_request = '1') THEN
						next_state <= S6; 
					ELSE
						next_state <= S1;
					END IF;

        WHEN S1 =>	--At s1, if ew_request is activated and ns_request is not, then skip to s6 state. Else, transition normally to next state. 

					IF(ns_request = '0' AND ew_request = '1') THEN
						next_state <= S6;
					ELSE
						next_state <= S2;
					END IF;

         WHEN S2 =>	--Transition normally to next chronological state.
					next_state <= S3;
				
         WHEN S3 =>	--Transition normally to next chronological state.
					next_state <= S4;

         WHEN S4 =>	--Transition normally to next chronological state.
					next_state <= S5;

         WHEN S5 =>	--Transition normally to next chronological state.
					next_state <= S6;
				
         WHEN S6 =>	--Transition normally to next chronological state.
					next_state <= S7;
				
         WHEN S7 =>	--Transition normally to next chronological state.
					next_state <= S8;
				
				
				
		WHEN s8 => --At s8, if ew_request is not active and ns_request is activated, then skip to s14 state. Else, transition normally to next state. 

					IF(ns_request = '1' AND ew_request = '0') THEN
						next_state <= s14;
					ELSE
						next_state <= s9;
					END IF;
				
		WHEN s9 => --At s9, if ew_request is not active and ns_request is activated, then skip to s14 state. Else, transition normally to next state. 

					IF(ns_request = '1' AND ew_request = '0') THEN
						next_state <= s14;
					ELSE
						next_state <= s10;
					END IF;
				
			WHEN s10 => --Transition normally to next chronological state.
					next_state <= s11;
				
			WHEN s11 => --Transition normally to next chronological state.
					next_state <= s12;
				
			WHEN s12 => --Transition normally to next chronological state.
					next_state <= s13;
				
			WHEN s13 => --Transition normally to next chronological state.
					next_state <= s14;
				
			WHEN s14 => --Transition normally to next chronological state.
					next_state <= s15;
				
			WHEN s15 => --Transition back to s0 to restart state sequence.
					next_state <= s0;		
					
	  END CASE;
 END PROCESS;
 


Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
		
	  
	WHEN S0 => --in state 0, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7
		
			ns_green <= blink_sig;
			ns_yellow <= '0'; 
			ns_red <= '0';
			ns_clear <= '0';
			ns_crossing <= '0'; 
			
			ew_green <= '0'; 
			ew_yellow <= '0'; 
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0000";
			
	WHEN S1 =>	--in state 1, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= blink_sig;
			ns_yellow <= '0';
			ns_red <= '0';
			ns_clear <= '0';		
			ns_crossing <= '0';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0001";

	WHEN S2 =>	--in state 2, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '1';
			ns_yellow <= '0';
			ns_red <= '0';
			ns_clear <= '0';		
			ns_crossing <= '1';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0010";
			
	WHEN S3 =>		--in state 3, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '1';
			ns_yellow <= '0';
			ns_red <= '0';
			ns_clear <= '0';
			ns_crossing <= '1';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0011";

	WHEN S4 =>	--in state 4, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '1';
			ns_yellow <= '0';
			ns_red <= '0';
			ns_clear <= '0';
			ns_crossing <= '1';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0100";

	WHEN S5 =>	--in state 5, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '1';
			ns_yellow <= '0';
			ns_red <= '0';
			ns_clear <= '0';
			ns_crossing <= '1';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0101";
				
	WHEN S6 =>	--in state 6, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '1';
			ns_red <= '0';
			ns_clear <= '1';
			ns_crossing <= '0';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0110";

	WHEN S7 =>	--in state 7, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '1';
			ns_red <= '0';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '0';
			ew_yellow <= '0';
			ew_red <= '1';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "0111";

	WHEN S8 =>  --in state 8, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

 			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
	
			ew_green <= blink_sig;
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "1000";

	WHEN S9 =>  --in state 9, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

 			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
	
			ew_green <= blink_sig;
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "1001";

	WHEN S10 =>  --in state 10, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '1';
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '1';
			
			state_num <= "1010";
	  

	WHEN S11 =>  --in state 11, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '1';
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '1';
			
			state_num <= "1011";

	WHEN S12 =>  --in state 12, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '1';
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '1';
			
			state_num <= "1100";

	WHEN S13 =>  --in state 13, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '1';
			ew_yellow <= '0';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '1';
			
			state_num <= "1101";

	WHEN S14 =>  --in state 14, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '0';
			ew_yellow <= '1';
			ew_red <= '0';
			ew_clear <= '1';		
			ew_crossing <= '0';
			
			state_num <= "1110";
	  
	  
	  
	WHEN S15 =>  --in state 15, enable/disable the signals for g/y/r lights and clear/crossing signals for ns and ew direction in desired states and display state num for leds4-7

			ns_green <= '0';
			ns_yellow <= '0';
			ns_red <= '1';
			ns_clear <= '0';
			ns_crossing <= '0';
			
			ew_green <= '0';
			ew_yellow <= '1';
			ew_red <= '0';
			ew_clear <= '0';		
			ew_crossing <= '0';
			
			state_num <= "1111";
	  
			
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
