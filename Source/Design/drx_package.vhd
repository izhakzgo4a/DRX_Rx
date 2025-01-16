----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use ieee.math_real.all;

package drx_package is
 
constant FRAME_RATE 		: integer := 1;
constant COLOR_WIDTH 		: integer := 4;
constant NUM_OF_CHANNELS 	: integer := 4;
constant IMAGE_ROWS	 		: integer := 480;
constant IMAGE_COLS	 		: integer := 640;
constant DECIMATION_FACTOR	: integer := 4;
constant CC1200_FIFO_TH		: integer := 6;
constant CC1200_REG_WIDTH	: integer := 24;
constant ROW_START_ADDR_LEN	: integer := 2;

constant NUM_OF_PIXELS_PER_CHANNEL 		: integer := (IMAGE_ROWS/DECIMATION_FACTOR)*(IMAGE_COLS/DECIMATION_FACTOR)/4; 
constant PAYLOAD_LENGTH 				: integer := (3*(IMAGE_COLS/DECIMATION_FACTOR)/NUM_OF_CHANNELS)/2 + ROW_START_ADDR_LEN; 
constant PACKET_ZERO_PAD_BYTES	 		: integer := (CC1200_FIFO_TH - (PAYLOAD_LENGTH mod CC1200_FIFO_TH)) mod CC1200_FIFO_TH; 
constant TOTAL_PACKET_LEN		 		: integer := PAYLOAD_LENGTH + PACKET_ZERO_PAD_BYTES;


type t_FROM_FIFO is record
	wr_full  : std_logic;
	rd_empty : std_logic;
end record t_FROM_FIFO;  

subtype pixel is std_logic_vector(COLOR_WIDTH*3-1 downto 0);
type pixels_array is array (integer range <>) of pixel;
type spi_access_type is (COMMAND_STROBE, REGISTER_SPACE, EXTENDED_ADDRESS, DIRECT_MEMORY_ACCESS, STANDARD_FIFO_ACCESS);

-------------------- std_logic_vector arrays --------------------------------
	type stdl2_arr is array (integer range <>) of std_logic_vector(1 downto 0);
	type stdl3_arr is array (integer range <>) of std_logic_vector(2 downto 0);
	type stdl4_arr is array (integer range <>) of std_logic_vector(3 downto 0);
	type stdl5_arr is array (integer range <>) of std_logic_vector(4 downto 0);
	type stdl6_arr is array (integer range <>) of std_logic_vector(5 downto 0);
	type stdl7_arr is array (integer range <>) of std_logic_vector(6 downto 0);
	type stdl8_arr is array (integer range <>) of std_logic_vector(7 downto 0);
	type stdl9_arr is array (integer range <>) of std_logic_vector(8 downto 0);
	type stdl10_arr is array (integer range <>) of std_logic_vector(9 downto 0);
	type stdl11_arr is array (integer range <>) of std_logic_vector(10 downto 0);
	type stdl12_arr is array (integer range <>) of std_logic_vector(11 downto 0);
	type stdl13_arr is array (integer range <>) of std_logic_vector(12 downto 0);
	type stdl14_arr is array (integer range <>) of std_logic_vector(13 downto 0);
	type stdl15_arr is array (integer range <>) of std_logic_vector(14 downto 0);
	type stdl16_arr is array (integer range <>) of std_logic_vector(15 downto 0);
	type stdl17_arr is array (integer range <>) of std_logic_vector(16 downto 0);
	type stdl18_arr is array (integer range <>) of std_logic_vector(17 downto 0);
	type stdl19_arr is array (integer range <>) of std_logic_vector(18 downto 0);
	type stdl20_arr is array (integer range <>) of std_logic_vector(19 downto 0);
	type stdl21_arr is array (integer range <>) of std_logic_vector(20 downto 0);
	type stdl22_arr is array (integer range <>) of std_logic_vector(21 downto 0);
	type stdl23_arr is array (integer range <>) of std_logic_vector(22 downto 0);
	type stdl24_arr is array (integer range <>) of std_logic_vector(23 downto 0);
	type stdl25_arr is array (integer range <>) of std_logic_vector(24 downto 0);
	type stdl26_arr is array (integer range <>) of std_logic_vector(25 downto 0);
	type stdl27_arr is array (integer range <>) of std_logic_vector(26 downto 0);
	type stdl28_arr is array (integer range <>) of std_logic_vector(27 downto 0);
	type stdl29_arr is array (integer range <>) of std_logic_vector(28 downto 0);
	type stdl30_arr is array (integer range <>) of std_logic_vector(29 downto 0);
	type stdl31_arr is array (integer range <>) of std_logic_vector(30 downto 0);
	type stdl32_arr is array (integer range <>) of std_logic_vector(31 downto 0);
	type stdl33_arr is array (integer range <>) of std_logic_vector(32 downto 0);
	type stdl34_arr is array (integer range <>) of std_logic_vector(33 downto 0);
	type stdl35_arr is array (integer range <>) of std_logic_vector(34 downto 0);
	type stdl36_arr is array (integer range <>) of std_logic_vector(35 downto 0);
	type stdl37_arr is array (integer range <>) of std_logic_vector(36 downto 0);
	type stdl38_arr is array (integer range <>) of std_logic_vector(37 downto 0);
	type stdl39_arr is array (integer range <>) of std_logic_vector(38 downto 0);
	type stdl40_arr is array (integer range <>) of std_logic_vector(39 downto 0);
	type stdl41_arr is array (integer range <>) of std_logic_vector(40 downto 0);
	type stdl42_arr is array (integer range <>) of std_logic_vector(41 downto 0);
	type stdl43_arr is array (integer range <>) of std_logic_vector(42 downto 0);
	type stdl44_arr is array (integer range <>) of std_logic_vector(43 downto 0);
	type stdl45_arr is array (integer range <>) of std_logic_vector(44 downto 0);
	type stdl46_arr is array (integer range <>) of std_logic_vector(45 downto 0);
	type stdl47_arr is array (integer range <>) of std_logic_vector(46 downto 0);
--------------------------------------------------------------------------------


function and_reduct(slv : in std_logic_vector) return std_logic;
function or_reduct(slv : in std_logic_vector) return std_logic;

end package drx_package;

-- Package Body Section
package body drx_package is
   
function and_reduct(slv : in std_logic_vector) return std_logic is
	variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
	begin
		for i in slv'range loop
			res_v := res_v and slv(i);
		end loop;
		return res_v;
end function;	
   
function or_reduct(slv : in std_logic_vector) return std_logic is
	variable res_v : std_logic := '0';  -- Null slv vector will also return '1'
	begin
		for i in slv'range loop
			res_v := res_v or slv(i);
		end loop;
		return res_v;
end function;	


end package body drx_package;