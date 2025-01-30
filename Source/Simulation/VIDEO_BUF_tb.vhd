----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/24/2022 03:26:14 PM
-- Design Name: 
-- Module Name: Reg_To_CC1200_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library xil_defaultlib;
use work.drx_package.all;
--use xil_defaultlib.MATH_REAL.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity video_buf_tb is
--  Port ( );
end video_buf_tb;

architecture Behavioral of video_buf_tb is

	
COMPONENT CC1200_Controller is
	Port 
    (
        CLK 					: in STD_LOGIC;
        RESET 					: in STD_LOGIC;
        -- ZQ Signals
        ZQ_CC1200_RST			: in STD_LOGIC;
        ZQ_REG_CS				: in STD_LOGIC;
        ZQ_REG_IN				: in STD_LOGIC_VECTOR (23 downto 0);
        --Ram Signals
        GET_DATA_FROM_RAM		: out STD_LOGIC;
        RAM_DATA_IN				: in STD_LOGIC_VECTOR (23 downto 0);
		ram_data_in_valid		: in std_logic;
		cc1200_data_out			: out std_logic_vector(7 downto 0); 
		cc1200_data_out_valid	: out std_logic;
        -- CC1200 Signals
        CC1200_RST				: out STD_LOGIC;
        CC1200_CS				: out STD_LOGIC;
        CC1200_CLK				: out STD_LOGIC;
        CC1200_MOSI				: out STD_LOGIC;
        CC1200_MISO				: in STD_LOGIC;
        REG_OUT					: out STD_LOGIC_VECTOR (23 downto 0);
        CC1200_READY			: out STD_LOGIC;

        PACKET_LENGTH_IN_BYTES	: in STD_LOGIC_VECTOR (7 downto 0)
    );
end COMPONENT;

COMPONENT VIDEO_BUF is
    Generic (
		DATA_IN_WIDTH  : INTEGER range 4 to 10 := 8;
		COLOR_WIDTH : INTEGER range 1 to 8 := 4
	);
    Port 
	( 
		W_CLK                   : in STD_LOGIC;
		W_RESET                 : in STD_LOGIC;
		SW_DETECTED_0           : in STD_LOGIC;
		SW_DETECTED_1           : in STD_LOGIC;
		SW_DETECTED_2           : in STD_LOGIC;
		SW_DETECTED_3           : in STD_LOGIC;
		SW_OPPOSITE_DIRECT_0    : in STD_LOGIC;
		SW_OPPOSITE_DIRECT_1    : in STD_LOGIC;
		SW_OPPOSITE_DIRECT_2    : in STD_LOGIC;
		SW_OPPOSITE_DIRECT_3    : in STD_LOGIC;
		END_OF_PACKET_0         : in STD_LOGIC;
		END_OF_PACKET_1         : in STD_LOGIC;
		END_OF_PACKET_2         : in STD_LOGIC;
		END_OF_PACKET_3         : in STD_LOGIC;
		DATA_VALID_0            : in STD_LOGIC;
		DATA_VALID_1            : in STD_LOGIC;
		DATA_VALID_2            : in STD_LOGIC;
		DATA_VALID_3            : in STD_LOGIC;
		DATA_IN_0               : in STD_LOGIC_VECTOR (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_1               : in STD_LOGIC_VECTOR (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_2               : in STD_LOGIC_VECTOR (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_3               : in STD_LOGIC_VECTOR (DATA_IN_WIDTH-1 downto 0);
		R_CLK                   : in STD_LOGIC;
		R_RESET                 : in STD_LOGIC;
		vtc_active_video        : in STD_LOGIC;
		vtc_hsync               : in STD_LOGIC;
		vtc_vsync               : in STD_LOGIC;
		RGB_OUT                 : out STD_LOGIC_VECTOR (23 downto 0);
		ACTIVE_VIDEO_OUT        : out STD_LOGIC;
		HSYNC_OUT               : out STD_LOGIC;
		VSYNC_OUT               : out STD_LOGIC;

		sw_time_out				: in STD_LOGIC_VECTOR (31 downto 0);
		min_frame_sw_detected	: in STD_LOGIC_VECTOR (10 downto 0);
		upsamp_factor			: in std_logic_vector(3 downto 0);
		black_video_buf_out		: out std_logic_vector(3 downto 0);
		rssi_acc_0				: out std_logic_vector(11 downto 0);
		rssi_acc_1				: out std_logic_vector(11 downto 0);
		rssi_acc_2				: out std_logic_vector(11 downto 0);
		rssi_acc_3				: out std_logic_vector(11 downto 0)
	);
end COMPONENT;

-- procedure UNIFORM(variable SEED1, SEED2 : inout POSITIVE;
--                   variable X : out REAL);
				  

-- impure function rand_real(min_val, max_val : real) return real is
-- 	variable r : real;
-- 	variable seed1, seed2 : integer := 999;
-- begin
-- 	UNIFORM(seed1, seed2, r);
-- 	return r * (max_val - min_val) + min_val;
-- end function;

-- signal test : real;

constant PACKET_TIME : integer := 1500;
signal W_CLK : STD_LOGIC := '0';
signal R_CLK : STD_LOGIC := '0';
signal RESET : STD_LOGIC := '1';
signal GET_DATA_FROM_RAM : STD_LOGIC;
signal GET_DATA_FROM_RAM_cnt : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

type spi_state_type is
	(
	   idle,                -- 0
	   read_data,			-- 1
	   send_data		   -- 2
	);
signal spi_state : spi_state_type;

signal start_packet : std_logic;
signal time_cnt		 : std_logic_vector(31 downto 0);
signal data_cnt		 : std_logic_vector(9 downto 0);
signal bit_cnt		 : std_logic_vector(3 downto 0);
signal sw_cnt		 : std_logic_vector(9 downto 0);

signal SW_DETECTED_0 : std_logic;
signal SW_DETECTED_1 : std_logic;
signal SW_DETECTED_2 : std_logic;
signal SW_DETECTED_3 : std_logic;

signal SW_OPPOSITE_DIRECT_0 : std_logic;
signal SW_OPPOSITE_DIRECT_1 : std_logic;
signal SW_OPPOSITE_DIRECT_2 : std_logic;
signal SW_OPPOSITE_DIRECT_3 : std_logic;

signal DATA_VALID_0 : std_logic;
signal DATA_VALID_1 : std_logic;
signal DATA_VALID_2 : std_logic;
signal DATA_VALID_3 : std_logic;

signal DATA_IN_0 : std_logic_vector(7 downto 0);
signal DATA_IN_1 : std_logic_vector(7 downto 0);
signal DATA_IN_2 : std_logic_vector(7 downto 0);
signal DATA_IN_3 : std_logic_vector(7 downto 0);

signal spi_cnt			: std_logic_vector(2 downto 0);
signal spi_sr			: std_logic_vector(7 downto 0);
signal spi_bytes_cnt	: std_logic_vector(2 downto 0);

signal CC1200_CS	: std_logic;
signal CC1200_CLK	: std_logic;
signal CC1200_MOSI	: std_logic;
signal CC1200_MISO	: std_logic;

signal CC1200_CLK_s		: std_logic;
signal CC1200_CLK_rise	: std_logic;
signal CC1200_CLK_fall	: std_logic;
signal CC1200_CS_s		: std_logic;
signal CC1200_CS_rise	: std_logic;
signal CC1200_CS_fall	: std_logic;
signal ZQ_REG_CS : STD_LOGIC := '0';
signal ZQ_REG_IN : STD_LOGIC_VECTOR (23 downto 0);
signal CC1200_READY : STD_LOGIC;
signal CC1200_GPIO_0 : STD_LOGIC;
signal vtc_active_video : STD_LOGIC := '0';

begin

W_CLK <= not W_CLK after 5 ns;
R_CLK <= not R_CLK after 20 ns;
RESET <= '0' after 200ns;
vtc_active_video <= '1' after 5ms;

-- stimulus : process begin
-- 	SW_DETECTED_0	<= '0';
-- 	SW_DETECTED_1	<= '0';
-- 	SW_DETECTED_2	<= '0';
-- 	SW_DETECTED_3	<= '0';
-- 	ZQ_REG_IN		<= x"000000";
-- 	wait until RESET = '0';
-- 	wait for 50us;

-- 	wait until W_CLK = '1';
-- 	for j in 0 to 10 loop
-- 		SW_DETECTED_0	<= '1';
-- 		-- SW_DETECTED_3	<= '1';
-- 		for i in 0 to 10 loop
-- 			ZQ_REG_IN 	<= x"3d0000";
-- 			ZQ_REG_CS 	<= '1';
-- 			wait until W_CLK = '1';
-- 			ZQ_REG_CS 	<= '0';
-- 			wait for 2us;
-- 			ZQ_REG_IN 	<= x"ff0000";
-- 			ZQ_REG_CS 	<= '1';
-- 			wait until W_CLK = '1';
-- 			ZQ_REG_CS 	<= '0';
-- 			wait for 8us;
-- 		end loop;
-- 		wait for 20us;
-- 		SW_DETECTED_0	<= '0';
		
-- 		wait for 20us;
-- 	end loop;
-- 	-- wait until W_CLK = '1';
-- 	-- SW_DETECTED_3	<= '1';
-- 	-- wait until W_CLK = '1';
-- 	-- SW_DETECTED_3	<= '0';
	
-- end process stimulus;

process(W_CLK, RESET) begin
	if RESET = '1' then
		CC1200_CLK_s		<= '0';
		CC1200_CS_s			<= '1';
	elsif rising_edge(W_CLK) then
		CC1200_CLK_s		<= CC1200_CLK;
		CC1200_CS_s			<= CC1200_CS;
	end if;
end process;

CC1200_CLK_rise		<= CC1200_CLK and not(CC1200_CLK_s);
CC1200_CLK_fall		<= CC1200_CLK_s and not(CC1200_CLK);

CC1200_CS_rise		<= CC1200_CS and not(CC1200_CS_s);
CC1200_CS_fall		<= CC1200_CS_s and not(CC1200_CS);

-- SPI: process(W_CLK, reset) 
-- 	variable j : integer := 0;
-- 	begin
-- 	if rising_edge(W_CLK) then
-- 		if reset = '1' then
-- 			spi_cnt					<= (others => '0');
-- 			spi_sr					<= (others => '1');
-- 			spi_bytes_cnt			<= (others => '0');
-- 			spi_state				<= idle;
-- 		else
-- 			case spi_state is
-- 				when idle =>
-- 					if (CC1200_CS_fall = '1') then		
-- 						spi_state				<= read_data;
-- 						spi_sr					<= (others => '0');
-- 					else			
-- 						spi_cnt					<= (others => '0');	
-- 						spi_sr					<= (others => '1');	
-- 					end if;
					
-- 				when read_data =>
-- 					if (CC1200_CLK_rise = '1') then		
-- 						if (spi_cnt = 7) then		
-- 							if ((spi_sr(spi_sr'high-1 downto 0) & CC1200_MOSI = x"ff")) then		
-- 								spi_cnt			<= (others => '0');
-- 								spi_sr			<= std_logic_vector(to_unsigned(j, spi_sr'length));
-- 								spi_state		<= send_data;
-- 							end if;
-- 						else			
-- 							spi_cnt				<= spi_cnt + 1;
-- 							spi_sr				<= spi_sr(spi_sr'high-1 downto 0) & CC1200_MOSI;
-- 						end if;
-- 					end if;
			
-- 				when send_data =>
-- 					if (CC1200_CLK_fall = '1') then		
-- 						if (spi_cnt = 7) then
-- 							if (spi_bytes_cnt = CC1200_FIFO_TH - 1) then
-- 								spi_bytes_cnt		<= (others => '0');
-- 								spi_state			<= idle;
-- 							else
-- 								spi_cnt				<= (others => '0');
-- 								spi_bytes_cnt		<= spi_bytes_cnt + 1;
-- 								j					:= j + 1;
-- 								spi_sr				<= std_logic_vector(to_unsigned(j, spi_sr'length));
-- 							end if;
-- 						else			
-- 							spi_cnt					<= spi_cnt + 1;	
-- 							spi_sr					<= spi_sr(spi_sr'high-1 downto 0) & '0';	
-- 						end if;
-- 					end if;
			
-- 			end case;
-- 		end if;
-- 	end if;
-- end process;

CC1200_MISO				<= spi_sr(spi_sr'high);

stimulus : process begin
	DATA_IN_0		<= (others => '0');
	DATA_VALID_0	<= '0';
	SW_DETECTED_0	<= '0';
	wait until RESET = '0';
	wait for 50us;

	wait until W_CLK = '1';
	for j in 0 to 20 loop
		SW_DETECTED_0	<= '1';
		-- SW_DETECTED_3	<= '1';
		for i in 0 to 66 loop
			DATA_IN_0		<= std_logic_vector(to_unsigned(i, DATA_IN_0'length));
			DATA_VALID_0	<= '1';
			wait until W_CLK = '1';
			DATA_VALID_0	<= '0';
			wait for 1us;
		end loop;
		wait for 20us;
		SW_DETECTED_0	<= '0';
		
		wait for 20us;
	end loop;
	-- wait until W_CLK = '1';
	-- SW_DETECTED_3	<= '1';
	-- wait until W_CLK = '1';
	-- SW_DETECTED_3	<= '0';
	
end process stimulus;


uut: VIDEO_BUF PORT MAP (
    W_CLK                	=> W_CLK,
	W_RESET              	=> RESET,
	SW_DETECTED_0        	=> SW_DETECTED_0,
	SW_DETECTED_1        	=> SW_DETECTED_1,
	SW_DETECTED_2        	=> SW_DETECTED_2,
	SW_DETECTED_3        	=> SW_DETECTED_3,
	SW_OPPOSITE_DIRECT_0 	=> SW_OPPOSITE_DIRECT_0,
	SW_OPPOSITE_DIRECT_1 	=> '0',
	SW_OPPOSITE_DIRECT_2 	=> '0',
	SW_OPPOSITE_DIRECT_3 	=> '0',
	END_OF_PACKET_0      	=> '0',
	END_OF_PACKET_1      	=> '0',
	END_OF_PACKET_2      	=> '0',
	END_OF_PACKET_3      	=> '0',
	DATA_VALID_0         	=> DATA_VALID_0,
	DATA_VALID_1         	=> DATA_VALID_1,
	DATA_VALID_2         	=> DATA_VALID_2,
	DATA_VALID_3         	=> DATA_VALID_3,
	DATA_IN_0            	=> DATA_IN_0,
	DATA_IN_1            	=> DATA_IN_1,
	DATA_IN_2            	=> DATA_IN_2,
	DATA_IN_3            	=> DATA_IN_3,
	R_CLK                	=> R_CLK,
	R_RESET              	=> RESET,
	vtc_active_video     	=> vtc_active_video     ,
	vtc_hsync            	=> '0'            ,
	vtc_vsync            	=> '0'            ,
	RGB_OUT              	=> open              ,
	ACTIVE_VIDEO_OUT     	=> open,
	HSYNC_OUT            	=> open,
	VSYNC_OUT            	=> open,
	sw_time_out				=> std_logic_vector(to_unsigned(480*PACKET_TIME, 32)),
	min_frame_sw_detected	=> std_logic_vector(to_unsigned(200, 11)),
	upsamp_factor			=> std_logic_vector(to_unsigned(4, 4)),
	black_video_buf_out		=> open,
	rssi_acc_0				=> open,
	rssi_acc_1				=> open,
	rssi_acc_2				=> open,
	rssi_acc_3				=> open
);


CC1200_Controller_i: CC1200_Controller 
PORT MAP 
(
	CLK 					=> W_CLK,
	RESET                   => RESET,
	ZQ_CC1200_RST 			=> RESET,
	ZQ_REG_CS				=> ZQ_REG_CS,
	ZQ_REG_IN				=> ZQ_REG_IN,
	GET_DATA_FROM_RAM 		=> GET_DATA_FROM_RAM,
	RAM_DATA_IN				=> x"000000",
	ram_data_in_valid		=> '0',
	cc1200_data_out			=> open,
	cc1200_data_out_valid	=> open,
	CC1200_CS				=> CC1200_CS,
	CC1200_CLK				=> CC1200_CLK,
	CC1200_MOSI				=> CC1200_MOSI,
	CC1200_MISO				=> CC1200_MISO,
	REG_OUT					=> open,
	CC1200_READY			=> CC1200_READY,
	PACKET_LENGTH_IN_BYTES	=> x"06"	
);

end Behavioral;
