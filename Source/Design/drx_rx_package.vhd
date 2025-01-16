----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use ieee.math_real.all;

package drx_rx_package is
 
constant COLOR_WIDTH 		: integer := 4;
constant NUM_OF_CHANNELS 	: integer := 4;
constant IMAGE_ROWS	 		: integer := 480;
constant IMAGE_COLS	 		: integer := 640;
constant DECIMATION_FACTOR	: integer := 4;

constant NUM_OF_PIXELS_PER_CHANNEL 	: integer := (IMAGE_ROWS/DECIMATION_FACTOR)*(IMAGE_COLS/DECIMATION_FACTOR); 
constant NUM_OF_BYTES_PER_LINE 		: integer := (3*(IMAGE_COLS/DECIMATION_FACTOR)/NUM_OF_CHANNELS)/2; 


type t_FROM_FIFO is record
	wr_full  : std_logic;
	rd_empty : std_logic;
end record t_FROM_FIFO;  

subtype pixel is std_logic_vector(COLOR_WIDTH*3-1 downto 0);
type pixels_array is array (integer range <>) of pixel;

end package drx_rx_package;

-- Package Body Section
package body drx_rx_package is
   
	
   
end package body drx_rx_package;