--Group 10: Daniel Kim and Hassan Khaled Nada


library ieee;
use ieee.std_logic_1164.all;


entity PB_inverters is port (
		rst_n					: in  std_logic; --active low global reset input
		rst				   : out	std_logic; --rst output					 
		pb_n_filtered	   : in  std_logic_vector (3 downto 0); --filtered pb_n inputs from pb_filters
		pb						: out	std_logic_vector(3 downto 0)	--inverted pb output							 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
rst <= NOT(rst_n); --inverts the reset
pb <= NOT(pb_n_filtered); --inverts filtered pb's


end ckt;