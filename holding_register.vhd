--Group 10: Daniel Kim and Hassan Khaled Nada


library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic; --global clock input
			reset					: in std_logic; --active low global reset input
			register_clr		: in std_logic; --input for the register to clear its holding value
			din					: in std_logic; --input for the value to be held
			dout					: out std_logic --output to signal whether or not a value is being held
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; --signal to keep track of synchronizer register values
	signal prev				: std_logic; --signal for previous state


BEGIN

	prev <= ((din OR sreg) AND (NOT(register_clr OR reset))); --assigns previous state to input logic of din, sreg, clr, and rst of holding register


process (clk) is 
begin


	if (rising_edge(clk)) then --if clock is on a rising edge
		if (reset = '1') then --and if reset is enabled
			sreg <= '0'; --then reset sreg value
			
		else sreg <= prev; --else, assign sreg to prev value
		
		end if;
		
	end if;
	
	
end process;

dout <= sreg; --assign holding registers output to sreg
	

end;