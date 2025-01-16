----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2022 01:34:46 PM
-- Design Name: 
-- Module Name: VIDEO_BUF - Behavioral
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
use work.drx_package.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity VIDEO_BUF is
   Generic 
   (
      DATA_IN_WIDTH  : INTEGER range 4 to 10 := 8;
      COLOR_WIDTH    : INTEGER range 1 to 8 := 4
   );
   Port 
   ( 
		W_CLK                   : in std_logic;
		W_RESET                 : in std_logic;
		SW_DETECTED_0           : in std_logic;
		SW_DETECTED_1           : in std_logic;
		SW_DETECTED_2           : in std_logic;
		SW_DETECTED_3           : in std_logic;
		SW_OPPOSITE_DIRECT_0    : in std_logic;
		SW_OPPOSITE_DIRECT_1    : in std_logic;
		SW_OPPOSITE_DIRECT_2    : in std_logic;
		SW_OPPOSITE_DIRECT_3    : in std_logic;
		END_OF_PACKET_0         : in std_logic;
		END_OF_PACKET_1         : in std_logic;
		END_OF_PACKET_2         : in std_logic;
		END_OF_PACKET_3         : in std_logic;
		DATA_VALID_0            : in std_logic;
		DATA_VALID_1            : in std_logic;
		DATA_VALID_2            : in std_logic;
		DATA_VALID_3            : in std_logic;
		DATA_IN_0               : in std_logic_vector (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_1               : in std_logic_vector (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_2               : in std_logic_vector (DATA_IN_WIDTH-1 downto 0);
		DATA_IN_3               : in std_logic_vector (DATA_IN_WIDTH-1 downto 0);
		R_CLK                   : in std_logic;
		R_RESET                 : in std_logic;
		vtc_active_video        : in std_logic;
		vtc_hsync               : in std_logic;
		vtc_vsync               : in std_logic;
		RGB_OUT                 : out std_logic_vector (23 downto 0);
		ACTIVE_VIDEO_OUT        : out std_logic;
		HSYNC_OUT               : out std_logic;
		VSYNC_OUT               : out std_logic;

		sw_time_out				: in std_logic_vector (31 downto 0);
		min_frame_sw_detected	: in std_logic_vector (10 downto 0);
		upsamp_factor			: in std_logic_vector (3 downto 0);
		black_video_buf_out		: out std_logic_vector (3 downto 0)
   );
end VIDEO_BUF;

architecture Behavioral of VIDEO_BUF is

COMPONENT VIDEO_BUF_0 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

COMPONENT VIDEO_BUF_1 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

COMPONENT VIDEO_BUF_2 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

COMPONENT VIDEO_BUF_3 IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

COMPONENT video_buf_line_start_addr_rom
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0); 
    douta : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;

COMPONENT vio_1
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

COMPONENT video_buf_full
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END COMPONENT;

component linspace is
	Generic 
	(
		D_WIDTH  		: integer := 4;
		NUM_OF_SAMP		: integer := 3
	);
	Port 
	( 
		clk						: in std_logic;
		reset					: in std_logic;
		p_start					: in pixel;
		p_stop					: in pixel;
		data_valid				: in std_logic;
		upsamp_factor			: in std_logic_vector(3 downto 0);
		restored_points			: inout pixels_array(0 to NUM_OF_SAMP-1);
		restored_points_valid	: out std_logic 
	);
end component;

signal WE						: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal RGBCounter				: stdl2_arr(0 to NUM_OF_CHANNELS-1);
signal color_keep				: stdl4_arr(0 to NUM_OF_CHANNELS-1);

signal DataToRead				: std_logic_vector(11 downto 0);
signal R_Data					: stdl12_arr(0 to NUM_OF_CHANNELS-1);

signal DATA_IN					: stdl8_arr(NUM_OF_CHANNELS-1 downto 0);
signal DATA_VALID				: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED				: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED_s1			: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED_s2			: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED_s3			: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED_rise			: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);
signal SW_DETECTED_fall			: std_logic_vector(NUM_OF_CHANNELS-1 downto 0);


signal line_start_addr_temp : stdl13_arr(0 to NUM_OF_CHANNELS-1);
signal line_start_addr      : stdl10_arr(0 to NUM_OF_CHANNELS-1);
signal line_bytes_cnt    : stdl7_arr(0 to NUM_OF_CHANNELS-1);
signal rom_out_cnt    : std_logic_vector(NUM_OF_CHANNELS-1 downto 0);

signal time_counter                 : std_logic_vector(31 downto 0);

signal black_video_buf  : std_logic_vector(3 downto 0);
type sw_cnt_arr is array (0 to 3) of std_logic_vector(9 downto 0);
signal sw_cnt           : sw_cnt_arr;

type video_buf_write_state_type is
(
   wait_for_sw,                        -- 0   
   read_packet_start_addr,             -- 1         
   read_correct_packet_start_addr,     -- 2         
   read_packet,                        -- 3
   increment_addr,                     -- 4        
   read_packet_padding                 -- 5
);
type  video_buf_write_state_arr is array (0 to NUM_OF_CHANNELS-1) of video_buf_write_state_type;  
signal video_buf_write_state		 : video_buf_write_state_arr;

signal video_buf_we			: std_logic_vector(3 downto 0);
signal video_buf_black_we	: std_logic_vector(3 downto 0);

signal video_buf_black_addr	: stdl13_arr(0 to NUM_OF_CHANNELS-1);
signal WriteAddress			: stdl13_arr(0 to NUM_OF_CHANNELS-1);
signal video_buf_wr_addr		: stdl13_arr(0 to NUM_OF_CHANNELS-1);

signal video_buf_black_din	: stdl12_arr(0 to NUM_OF_CHANNELS-1);
signal DataToWrite			: stdl12_arr(0 to NUM_OF_CHANNELS-1);
signal video_buf_din		: stdl12_arr(0 to NUM_OF_CHANNELS-1);

type video_buf_blacking_state_type is
(
   idle,                -- 0
   blacking_video_buf   -- 1
);
type video_buf_blacking_state_arr is array (0 to 3) of video_buf_blacking_state_type;
signal video_buf_blacking_state : video_buf_blacking_state_arr;

signal diag_mask : std_logic_vector(3 downto 0);
signal video_buf_wr_vio : std_logic;

type linear_interpolation_state_type is
(
	idle,								-- 0
	read_points_from_video_buf, 		-- 1
	wait_for_linspace_valid,			-- 2
	fill_row,							-- 3
	read_points_from_video_buf_full,	-- 4
	fill_col,							-- 5
	delay_state							-- 6
);
signal linear_interpolation_state 		: linear_interpolation_state_type;
signal linear_interpolation_next_state 	: linear_interpolation_state_type;

signal video_buf_full_we			: std_logic;
signal video_buf_full_addra			: std_logic_vector(18 downto 0);
signal video_buf_full_addrb			: std_logic_vector(18 downto 0);
signal video_buf_full_din			: pixel;
signal video_buf_full_douta			: pixel;
signal video_buf_full_doutb			: pixel;
signal video_buf_full_keep_addr		: std_logic_vector(18 downto 0);

signal active_video_out_s1 			: std_logic;
signal active_video_out_s2 			: std_logic;
signal linspace_p_start	    		: pixel;
signal linspace_p_stop				: pixel;
signal linspace_din_valid			: std_logic;
signal linspace_points				: pixels_array(0 to 2);
signal restored_points				: pixels_array(0 to 4);
signal points_valid					: std_logic;
signal linspace_points_valid		: std_logic;
signal start_interpolation			: std_logic;
signal ram_init_vio			 		: std_logic;
signal start_interpolation_vio 		: std_logic;
signal start_interpolation_vio_s	: std_logic;
signal start_interpolation_vio_rise	: std_logic;


signal read_points_cnt				: std_logic;
signal dec_row_pixels_cnt			: std_logic_vector(9 downto 0);
signal full_row_pixels_cnt			: std_logic_vector(9 downto 0);
signal fill_pix_cnt					: std_logic_vector(9 downto 0);
signal delay						: std_logic_vector(2 downto 0);
signal delay_cnt					: std_logic_vector(delay'high downto 0);

signal wr_rows_cnt					: std_logic_vector(8 downto 0);
signal rd_rows_cnt					: std_logic_vector(8 downto 0);
signal video_buf_rd_addr			: std_logic_vector(14 downto 0);
signal wr_row_pix_cnt				: std_logic_vector(9 downto 0);
signal rd_row_pix_cnt				: std_logic_vector(9 downto 0);
signal wr_pix_cnt					: std_logic_vector(18 downto 0);
signal rd_pix_cnt					: std_logic_vector(18 downto 0);
signal dec_pix_cnt					: std_logic_vector(2 downto 0);
signal wr_diag_sel					: std_logic_vector(1 downto 0);
signal rd_diag_sel					: std_logic_vector(1 downto 0);
-- signal upsamp_factor				: std_logic_vector(3 downto 0);

attribute MARK_DEBUG : string;
attribute MARK_DEBUG of linear_interpolation_state	: signal is "TRUE";
attribute MARK_DEBUG of start_interpolation	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_rd_addr	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_we	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_black_we	: signal is "TRUE";
attribute MARK_DEBUG of black_video_buf	: signal is "TRUE";
attribute MARK_DEBUG of R_Data	: signal is "TRUE";
attribute MARK_DEBUG of SW_DETECTED_0	: signal is "TRUE";
attribute MARK_DEBUG of SW_DETECTED_1	: signal is "TRUE";
attribute MARK_DEBUG of SW_DETECTED_2	: signal is "TRUE";
attribute MARK_DEBUG of SW_DETECTED_3	: signal is "TRUE";
attribute MARK_DEBUG of DATA_IN_0	: signal is "TRUE";
attribute MARK_DEBUG of DATA_IN_1	: signal is "TRUE";
attribute MARK_DEBUG of DATA_IN_2	: signal is "TRUE";
attribute MARK_DEBUG of DATA_IN_3	: signal is "TRUE";
attribute MARK_DEBUG of DATA_VALID_0	: signal is "TRUE";
attribute MARK_DEBUG of DATA_VALID_1	: signal is "TRUE";
attribute MARK_DEBUG of DATA_VALID_2	: signal is "TRUE";
attribute MARK_DEBUG of DATA_VALID_3	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_write_state	: signal is "TRUE";
attribute MARK_DEBUG of WE	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_din	: signal is "TRUE";
attribute MARK_DEBUG of video_buf_wr_addr	: signal is "TRUE";
attribute MARK_DEBUG of line_bytes_cnt	: signal is "TRUE";
attribute MARK_DEBUG of RGBCounter	: signal is "TRUE";
attribute MARK_DEBUG of SW_DETECTED_rise	: signal is "TRUE";
attribute MARK_DEBUG of line_start_addr_temp	: signal is "TRUE";
attribute MARK_DEBUG of line_start_addr	: signal is "TRUE";

attribute MARK_DEBUG of vtc_active_video			: signal is "TRUE";
attribute MARK_DEBUG of vtc_hsync       			: signal is "TRUE";
attribute MARK_DEBUG of vtc_vsync       			: signal is "TRUE";
attribute MARK_DEBUG of RGB_OUT         			: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_we			: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_addra		: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_addrb		: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_din			: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_douta		: signal is "TRUE";
attribute MARK_DEBUG of video_buf_full_doutb		: signal is "TRUE";

begin


SW_DETECTED		<= SW_DETECTED_3 & SW_DETECTED_2 & SW_DETECTED_1 & SW_DETECTED_0;
DATA_VALID		<= DATA_VALID_3 & DATA_VALID_2 & DATA_VALID_1 & DATA_VALID_0;
DATA_IN(0)		<= DATA_IN_0;
DATA_IN(1)		<= DATA_IN_1;
DATA_IN(2)		<= DATA_IN_2;
DATA_IN(3)		<= DATA_IN_3;

write_data_gen : for i in 0 to NUM_OF_CHANNELS-1 generate

	process(W_CLK) begin
	   	if rising_edge (W_CLK) then
		  	if W_RESET = '1' then
				SW_DETECTED_s1(i)     <= '0';
				SW_DETECTED_s2(i)     <= '0';
				SW_DETECTED_s3(i)     <= '0';
		  	else
				SW_DETECTED_s1(i)    <= SW_DETECTED(i);
				SW_DETECTED_s2(i)    <= SW_DETECTED_s1(i);
				SW_DETECTED_s3(i)    <= SW_DETECTED_s2(i);
		  	end if;
	   	end if ;
	end process ;

	SW_DETECTED_rise(i)  <= SW_DETECTED_s2(i) and (not SW_DETECTED_s3(i));
	SW_DETECTED_fall(i)  <= not(SW_DETECTED_s3(i)) and SW_DETECTED_s2(i);

	Write : process (W_CLK) begin
		if rising_edge (W_CLK) then
			if W_RESET = '1' then
				WriteAddress(i)              <= (others => '1');
				line_start_addr_temp(i)      <= (others => '0');
				DataToWrite(i)               <= (others => '0');
				WE(i)                        <= '0';
				RGBCounter(i)                <= (others => '0');
				color_keep(i)                <= (others => '0');
				line_bytes_cnt(i)            <= (others => '0');
				rom_out_cnt(i)               <= '0';
				video_buf_write_state(i)     <= wait_for_sw; 
			else
				case(video_buf_write_state(i)) is
					when wait_for_sw =>
						if SW_DETECTED_rise(i) = '1' then
							video_buf_write_state(i)					<= read_packet_start_addr;
						end if ;
						
						WE(i) <= '0';

					when read_packet_start_addr =>
						if DATA_VALID(i) = '1' then
							if line_bytes_cnt(i) = 0 then
								line_start_addr_temp(i)(12 downto 8)		<= DATA_IN(i)(4 downto 0);
							elsif line_bytes_cnt(i) = 1 then
								line_start_addr_temp(i)(7 downto 0)		<= DATA_IN(i);
								video_buf_write_state(i)				<= read_correct_packet_start_addr;
							end if ;
							line_bytes_cnt(i)							<= line_bytes_cnt(i) + 1;
						end if ;
					
					when read_correct_packet_start_addr =>
						if rom_out_cnt(i) = '1' then
							rom_out_cnt(i)								<= '0';
							WriteAddress(i)								<= line_start_addr(i) & "000";
							video_buf_write_state(i)					<= read_packet;
						else
							rom_out_cnt(i)								<= '1';
						end if ;                  

					when read_packet =>
						if DATA_VALID(i) = '1' then
							if RGBCounter(i) = 0 then
								WE(i) <= '0';
								DataToWrite(i)(11 downto 4)				<= DATA_IN(i);                    -- R + G
								RGBCounter(i)							<= RGBCounter(i) + 1;
								-- if line_bytes_cnt(i) = PAYLOAD_LENGTH + 1 then
								-- video_buf_write_state(i)                <= read_packet_padding;
								-- end if;
							elsif RGBCounter(i) = 1 then
								DataToWrite(i)(3 downto 0)				<= DATA_IN(i) (7 downto 4);       -- B
								color_keep(i)							<= DATA_IN(i) (3 downto 0);       -- R of next pixel
								RGBCounter(i)							<= RGBCounter(i) + 1;
								WE(i)									<= '1';
								video_buf_write_state(i)				<= increment_addr;
							elsif RGBCounter(i) = 2 then
								DataToWrite(i)							<= color_keep(i) & DATA_IN(i);     -- RGB
								RGBCounter(i)							<= (others => '0');
								WE(i)									<= '1';              -- Write DataToWrite into the BRAM
								video_buf_write_state(i)				<= increment_addr;
							end if;
							line_bytes_cnt(i)							<= line_bytes_cnt(i) + 1;
						end if ;

					when increment_addr =>
						WE(i)                                    <= '0';
						if line_bytes_cnt(i) = PAYLOAD_LENGTH then
							video_buf_write_state(i)                	<= read_packet_padding;
						else
							WriteAddress(i)								<= WriteAddress(i) + 1;
							video_buf_write_state(i)					<= read_packet;
						end if;

					when read_packet_padding =>
						if DATA_VALID(i) = '1' then
							if line_bytes_cnt(i) = TOTAL_PACKET_LEN - 1 then
								line_bytes_cnt(i)						<= (others => '0');
								video_buf_write_state(i)				<= read_packet_start_addr;
							else
								line_bytes_cnt(i)						<= line_bytes_cnt(i) + 1;
							end if;
						end if;
				end case ;
			end if;
		end if;
	end process;
end generate write_data_gen;

process (W_CLK) begin
	if rising_edge (W_CLK) then
		if W_RESET = '1' then
			start_interpolation				<= '0';  
		else
			if (video_buf_we(3) = '1' and video_buf_wr_addr(3) = (NUM_OF_PIXELS_PER_CHANNEL-1)) then		
				start_interpolation			<= '1';
			else			
				start_interpolation			<= '0';
			end if;
		end if;
	end if;
end process;  	

Sync : process (R_CLK)
begin
	if rising_edge (R_CLK) then
		if R_RESET = '1' then
			active_video_out_s1		<= '0';
			active_video_out_s2		<= '0';
			ACTIVE_VIDEO_OUT		<= '0';
			HSYNC_OUT				<= '0';
			VSYNC_OUT				<= '0';
        else
			active_video_out_s1		<= vtc_active_video;
			active_video_out_s2		<= active_video_out_s1;
			ACTIVE_VIDEO_OUT		<= active_video_out_s2;
			HSYNC_OUT				<= vtc_hsync;
			VSYNC_OUT				<= vtc_vsync;
        end if;
	end if;
end process;

Read : process (R_CLK)
begin
    if rising_edge (R_CLK) then
       	if R_RESET = '1' then
			video_buf_full_addrb 	<= (others => '0');
          	RGB_OUT        			<= (others => '0');
       	elsif vtc_active_video = '1' then
			RGB_OUT(23 downto 20)			<= video_buf_full_doutb(COLOR_WIDTH*3-1 downto COLOR_WIDTH*2);
			RGB_OUT(15 downto 12)			<= video_buf_full_doutb(COLOR_WIDTH*2-1 downto COLOR_WIDTH);
			RGB_OUT(7 downto 4)				<= video_buf_full_doutb(COLOR_WIDTH-1 downto 0);
			if video_buf_full_addrb /= IMAGE_COLS*IMAGE_ROWS - 1 then
				video_buf_full_addrb		<= video_buf_full_addrb + 1;
			else
				video_buf_full_addrb		<= (others => '0');
			end if;
       	end if;
    end if;
end process;



process (W_CLK)
begin
   if rising_edge (W_CLK) then
      if W_RESET = '1' then
         time_counter                  <= (others => '0');  
      else
         if time_counter = sw_time_out+3 then
            time_counter               <= (others => '0');
         else
            time_counter               <= time_counter + 1; 
         end if ;
      end if;
   end if;
end process;  

sw_time_out_gen: for i in 0 to 3 generate
	process(W_CLK)
	begin
	if rising_edge (W_CLK) then
		if W_RESET = '1' then
			sw_cnt(i)     				<= (others => '1');
			black_video_buf(i)         	<= '0';
		elsif (SW_DETECTED_rise(i) = '1') then
			sw_cnt(i)     				<= sw_cnt(i) + 1;
			black_video_buf(i)          <= '0';
		elsif (time_counter = sw_time_out) then
			if sw_cnt(i) < min_frame_sw_detected then
				black_video_buf(i)		<= '1';
			else
				black_video_buf(i)		<= '0';
			end if ;
			sw_cnt(i)  					<= (others => '0');
		else
		end if;
	end if;
   end process ;
end generate sw_time_out_gen;

black_video_buf_out		<= black_video_buf;


video_buf_blacking_gen: for i in 0 to 3 generate
	process(W_CLK)
	begin
		if rising_edge (W_CLK) then
			if W_RESET = '1' then
				video_buf_black_we(i)                            <= '0';
				video_buf_black_addr(i)     <= (others => '0');
				video_buf_blacking_state(i)                      <= idle;
			else
				case( video_buf_blacking_state(i) ) is
					when idle =>
						if black_video_buf(i) = '1' then
							video_buf_blacking_state(i)         <= blacking_video_buf;
						else
							video_buf_black_we(i)               <= '0';
						end if ;
				
					when blacking_video_buf =>
						if black_video_buf(i) = '1' then
							if video_buf_black_addr(i) = NUM_OF_PIXELS_PER_CHANNEL then
								video_buf_black_we(i)       <= '0';
								video_buf_black_addr(i) 	<= (others => '0');
							else
								video_buf_black_we(i)       <= '1';
								video_buf_black_addr(i) 	<= video_buf_black_addr(i) + 1;
							end if ;
						else
							video_buf_blacking_state(i)         <= idle;	
						end if ;
				end case ;
			end if;
		end if;
	end process ;
	
	
	-- video_buf_we(i)			<= '0' when ram_init_vio = '0' else video_buf_black_we(i) 	when black_video_buf(i) = '1' else WE(i);
	video_buf_we(i)			<= video_buf_black_we(i) 	when black_video_buf(i) = '1' else WE(i);
	-- video_buf_we(i)			<= '0';
	video_buf_wr_addr(i)	<= video_buf_black_addr(i) 	when black_video_buf(i) = '1' else WriteAddress(i);
	video_buf_din(i)		<= (others => '0') 			when black_video_buf(i) = '1' else DataToWrite(i);
end generate video_buf_blacking_gen;

rd_diag_sel		<= video_buf_rd_addr(1 downto 0) - rd_rows_cnt(1 downto 0);
DataToRead		<=	R_Data(0) when rd_diag_sel = 0 else
					R_Data(1) when rd_diag_sel = 1 else
					R_Data(2) when rd_diag_sel = 2 else
					R_Data(3) when rd_diag_sel = 3 else (others => '0');

ram_0 : VIDEO_BUF_0 PORT MAP 
(
   clka      => W_CLK,
   wea(0)    => video_buf_we(0),
   addra     => video_buf_wr_addr(0),
   dina      => video_buf_din(0),
   clkb      => W_CLK,
   addrb     => video_buf_rd_addr(video_buf_rd_addr'high downto 2),
   doutb     => R_Data(0)
);
                         
ram_1 : VIDEO_BUF_1 PORT MAP 
(
   clka      => W_CLK,
   wea(0)    => video_buf_we(1),
   addra     => video_buf_wr_addr(1),
   dina      => video_buf_din(1),
   clkb      => W_CLK,
   addrb     => video_buf_rd_addr(video_buf_rd_addr'high downto 2),
   doutb     => R_Data(1)
);   
                         
ram_2 : VIDEO_BUF_2 PORT MAP 
(
   clka      => W_CLK,
   wea(0)    => video_buf_we(2),
   addra     => video_buf_wr_addr(2),
   dina      => video_buf_din(2),
   clkb      => W_CLK,
   addrb     => video_buf_rd_addr(video_buf_rd_addr'high downto 2),
   doutb     => R_Data(2)
);    
                         
ram_3 : VIDEO_BUF_3 PORT MAP 
(
   clka      => W_CLK,
   wea(0)    => video_buf_we(3),
   addra     => video_buf_wr_addr(3),
   dina      => video_buf_din(3),
   clkb      => W_CLK,
   addrb     => video_buf_rd_addr(video_buf_rd_addr'high downto 2),
   doutb     => R_Data(3)
);   

video_buf_line_start_addr_rom_gen : for i in 0 to NUM_OF_CHANNELS-1 generate
	video_buf_line_start_addr_rom_i : video_buf_line_start_addr_rom
	PORT MAP (
	clka   => W_CLK,
	addra  => line_start_addr_temp(i),
	douta  => line_start_addr(i)
	);
end generate video_buf_line_start_addr_rom_gen;

-- video_buf_line_start_addr_rom_0 : video_buf_line_start_addr_rom
-- PORT MAP (
--   clka   => W_CLK,
--   addra  => line_start_addr_temp_0,
--   douta  => line_start_addr_0
-- );

-- video_buf_line_start_addr_rom_1 : video_buf_line_start_addr_rom
-- PORT MAP (
--   clka   =>  W_CLK,
--   addra  =>  line_start_addr_temp_1,
--   douta  =>  line_start_addr_1
-- );

-- video_buf_line_start_addr_rom_2 : video_buf_line_start_addr_rom
-- PORT MAP (
--    clka   =>  W_CLK,
--    addra  =>  line_start_addr_temp_2,
--    douta  =>  line_start_addr_2
-- );

-- video_buf_line_start_addr_rom_3 : video_buf_line_start_addr_rom
-- PORT MAP (
--    clka   =>  W_CLK,
--    addra  =>  line_start_addr_temp_3,
--    douta  =>  line_start_addr_3
-- );



-- fill image with linear interpolation between pixels
process(W_CLK) begin
	if rising_edge(W_CLK) then
		if W_RESET = '1' then
			restored_points 				<= (others=>(others=>'0'));
			video_buf_rd_addr				<= (others => '0');
			linspace_p_start				<= (others => '0');
			linspace_p_stop					<= (others => '0');
			linspace_din_valid				<= '0';
			read_points_cnt					<= '0';
			full_row_pixels_cnt				<= (others => '0');
			dec_row_pixels_cnt				<= (others => '0');
			fill_pix_cnt					<= (others => '0');
			rd_rows_cnt						<= (others => '0');
			video_buf_full_we				<= '0';
			video_buf_full_addra			<= (others => '0');
			video_buf_full_keep_addr		<= (others => '0');
			delay_cnt						<= (others => '0');
			delay							<= std_logic_vector(to_unsigned(1, delay'length));
			video_buf_full_din				<= (others => '0');
			linear_interpolation_state		<= idle;
		else
			case(linear_interpolation_state) is
				
				when idle =>
					if ((start_interpolation or start_interpolation_vio_rise) = '1') then		
						linear_interpolation_state		<= read_points_from_video_buf;
					else			
						video_buf_rd_addr				<= (others => '0');	
						dec_row_pixels_cnt				<= (others => '0');
						full_row_pixels_cnt				<= (others => '0');
						rd_rows_cnt						<= (others => '0');
						video_buf_full_we				<= '0';
						video_buf_full_addra			<= (others => '0');
					end if;
					
						
				when read_points_from_video_buf =>
					video_buf_full_we							<= '0';	
					if read_points_cnt = '0' then
						read_points_cnt					<= '1';
						if (video_buf_rd_addr = NUM_OF_PIXELS_PER_CHANNEL*4-1) then
							video_buf_rd_addr				<= (others => '0');
						else
							video_buf_rd_addr				<= video_buf_rd_addr + 1;
						end if;
							
						linspace_p_start				<= DataToRead;
						linear_interpolation_state		<= delay_state;	
						linear_interpolation_next_state	<= read_points_from_video_buf;				
					elsif read_points_cnt = '1' then
						if (dec_row_pixels_cnt = IMAGE_COLS/4-1) then		
							read_points_cnt					<= '0';
							linspace_p_stop					<= linspace_p_start;
							linspace_din_valid				<= '1';
							dec_row_pixels_cnt				<= (others => '0');
							linear_interpolation_state		<= wait_for_linspace_valid;	
							linear_interpolation_next_state	<= fill_row;	
						else			
							read_points_cnt					<= '0';
							linspace_p_stop					<= DataToRead;
							linspace_din_valid				<= '1';
							dec_row_pixels_cnt				<= dec_row_pixels_cnt + 1;
							linear_interpolation_state		<= wait_for_linspace_valid;	
							linear_interpolation_next_state	<= fill_row;		
						end if;
					end if;
				
				when wait_for_linspace_valid =>
					if (linspace_points_valid = '1') then		
						if (linear_interpolation_next_state = fill_row) then
							restored_points(0)					<= linspace_p_start;
							restored_points(1 to 3)				<= linspace_points;
							restored_points(4)					<= linspace_p_stop;
							video_buf_full_din					<= linspace_p_start;
							video_buf_full_we					<= '1';
							fill_pix_cnt						<= std_logic_vector(to_unsigned(1, 10));
							linear_interpolation_state			<= linear_interpolation_next_state;
						elsif (linear_interpolation_next_state = fill_col) then
							restored_points(0)					<= linspace_p_start;
							restored_points(1 to 3)				<= linspace_points;
							restored_points(4)					<= linspace_p_stop;
							video_buf_full_din					<= linspace_points(0);
							video_buf_full_we					<= '1';
							fill_pix_cnt						<= std_logic_vector(to_unsigned(1, 10));
							linear_interpolation_state			<= linear_interpolation_next_state;
						end if;
					else			
						linspace_din_valid					<= '0';	
					end if;
						
				when fill_row =>
					if (video_buf_full_addra(1 downto 0) = DECIMATION_FACTOR-1) then		
						fill_pix_cnt							<= (others => '0');
						video_buf_full_we						<= '0';
						video_buf_full_din						<= restored_points(to_integer(unsigned(fill_pix_cnt)));
						if (full_row_pixels_cnt = IMAGE_COLS-1) then		
							video_buf_full_addra				<= video_buf_full_addra + IMAGE_COLS*3 + 1;
							full_row_pixels_cnt					<= (others => '0');
							if (rd_rows_cnt = IMAGE_ROWS/4-1) then		
								rd_rows_cnt						<= (others => '0');
								video_buf_full_addra			<= (others => '0');
								linear_interpolation_next_state	<= read_points_from_video_buf_full;
								linear_interpolation_state		<= delay_state;							-- one clk delay for video_buf_full_douta to be ready
							else			
								rd_rows_cnt						<= rd_rows_cnt + 1;
								linear_interpolation_state		<= read_points_from_video_buf;
							end if;
						else			
							full_row_pixels_cnt					<= full_row_pixels_cnt + 1;
							video_buf_full_addra				<= video_buf_full_addra + 1;	
							linear_interpolation_state			<= read_points_from_video_buf;
						end if;
						
						
					else			
						fill_pix_cnt							<= fill_pix_cnt + 1;
						full_row_pixels_cnt						<= full_row_pixels_cnt + 1;
						video_buf_full_addra					<= video_buf_full_addra + 1;
						video_buf_full_we						<= '1';
						video_buf_full_din						<= restored_points(to_integer(unsigned(fill_pix_cnt)));
					end if;		

				when read_points_from_video_buf_full =>
					if (rd_rows_cnt = IMAGE_ROWS/4-1) then
						video_buf_full_addra					<= video_buf_full_addra + IMAGE_COLS;	
						video_buf_full_keep_addr				<= video_buf_full_addra;	
						-- linspace_p_start						<= video_buf_full_douta;	
						-- linspace_p_stop							<= video_buf_full_douta;
						-- linspace_din_valid						<= '1';
						restored_points							<= (others => video_buf_full_douta);
						video_buf_full_we						<= '1';
						linear_interpolation_next_state			<= fill_col;
						linear_interpolation_state				<= fill_col;	
					else
						if read_points_cnt = '0' then
							read_points_cnt						<= '1';
							video_buf_full_addra				<= video_buf_full_addra + IMAGE_COLS*4;	
							video_buf_full_keep_addr			<= video_buf_full_addra;	
							linspace_p_start					<= video_buf_full_douta;	
							delay								<= std_logic_vector(to_unsigned(3, delay'length));
							linear_interpolation_next_state		<= read_points_from_video_buf_full;
							linear_interpolation_state			<= delay_state;	
						elsif read_points_cnt = '1' then
							read_points_cnt						<= '0';
							video_buf_full_addra				<= video_buf_full_addra + IMAGE_COLS*4;		
							linspace_p_stop						<= video_buf_full_douta;
							linspace_din_valid					<= '1';
							video_buf_full_addra				<= video_buf_full_keep_addr + IMAGE_COLS;	
							linear_interpolation_state			<= wait_for_linspace_valid;	
							linear_interpolation_next_state		<= fill_col;
						end if;
					end if;

				when fill_col =>
					if (fill_pix_cnt = DECIMATION_FACTOR-1) then		
						fill_pix_cnt							<= (others => '0');
						video_buf_full_we						<= '0';
						video_buf_full_din						<= restored_points(to_integer(unsigned(fill_pix_cnt)));
						if (full_row_pixels_cnt = IMAGE_COLS-1) then		
							full_row_pixels_cnt					<= (others => '0');
							if (rd_rows_cnt = IMAGE_ROWS/4-1) then		
								rd_rows_cnt						<= (others => '0');
								video_buf_full_addra			<= (others => '0');
								linear_interpolation_state		<= idle;							-- one clk delay for video_buf_full_douta to be ready
							else			
								rd_rows_cnt						<= rd_rows_cnt + 1;
								video_buf_full_addra			<= video_buf_full_addra + 1;
								linear_interpolation_next_state	<= read_points_from_video_buf_full;
								linear_interpolation_state		<= delay_state;
							end if;
						else			
							full_row_pixels_cnt					<= full_row_pixels_cnt + 1;
							video_buf_full_addra				<= video_buf_full_keep_addr + 1;	
							linear_interpolation_next_state		<= read_points_from_video_buf_full;
							linear_interpolation_state			<= delay_state;
						end if;
					else			
						fill_pix_cnt							<= fill_pix_cnt + 1;
						-- full_row_pixels_cnt						<= full_row_pixels_cnt + 1;
						video_buf_full_addra					<= video_buf_full_addra + IMAGE_COLS;
						video_buf_full_we						<= '1';
						video_buf_full_din						<= restored_points(to_integer(unsigned(fill_pix_cnt)));
					end if;		

				when delay_state =>
					if delay_cnt = delay-1 then
						delay_cnt								<= (others => '0');
						linear_interpolation_state				<= linear_interpolation_next_state;
					else
						delay_cnt								<= delay_cnt + 1;
					end if;
				
			end case ;
		end if;
	end if;
end process;

linspace_i : linspace
	port map 
	( 
		clk						=> W_CLK,
		reset					=> W_RESET,
		p_start					=> linspace_p_start,
		p_stop					=> linspace_p_stop,
		data_valid				=> linspace_din_valid,
		upsamp_factor			=> upsamp_factor,
		restored_points			=> linspace_points,
		restored_points_valid	=> linspace_points_valid 
	);

video_buf_full_i : video_buf_full
	PORT MAP (
	clka 	=> W_CLK,
	wea(0) 	=> video_buf_full_we,
	addra 	=> video_buf_full_addra,
	dina 	=> video_buf_full_din,
	douta 	=> video_buf_full_douta,
	clkb 	=> R_CLK,
	web(0) 	=> '0',
	dinb 	=> (video_buf_full_din'range  => '0'),
	addrb 	=> video_buf_full_addrb,
	doutb 	=> video_buf_full_doutb
	);

-- v_prob_0 : vio_0 PORT MAP 
-- (
-- 	clk => W_CLK,
-- 	probe_out0 => upsamp_factor
-- );

v_prob_1 : vio_1 PORT MAP 
(
	clk => W_CLK,
	probe_out0(0) => start_interpolation_vio
);

v_prob_2 : vio_1 PORT MAP 
(
	clk => W_CLK,
	probe_out0(0) => ram_init_vio
);

process(W_CLK, W_RESET) begin
	if rising_edge(W_CLK) then
		if W_RESET = '1' then
			start_interpolation_vio_s	<= '0';
		else
			start_interpolation_vio_s	<= start_interpolation_vio;
		end if;
	end if;
end process;

start_interpolation_vio_rise		<= start_interpolation_vio and not(start_interpolation_vio_s);

end Behavioral;
