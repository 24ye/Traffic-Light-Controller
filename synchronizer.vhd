--Group 10: Daniel Kim and Hassan Khaled Nada


library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk					: in std_logic; --global clock input
			reset					: in std_logic; --active low global reset input
			din					: in std_logic; --input for pb(0)/pb(1)
			dout					: out std_logic --the synchronized output for the holding register
  );
end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); --signal to keep track of synchronizer register values

BEGIN



process (clk) is
begin

	if (rising_edge(clk)) then --if clk is on a rising edge
		if (reset = '1') then --and if reset input is enabled
			sreg <= "00"; --then reset sreg value
				
		else
				sreg (1 downto 0) <= sreg(0) & din; --else, assigns the value of next sreg register value to initial value and data input
				
		end if;
	end if;
	
	dout <= sreg(1); --assigns the synchronous output to the next sreg register value
	
end process;


end circuit;