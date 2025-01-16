----------------------------------------------------------------------------------
-- Company: GO4A
-- Engineer: Itzhak
-- 
-- Create Date: 26-05-2024 17:09
-- Design Name: 
-- Module Name: cc1200_intf
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
use IEEE.math_real.all;
use work.drx_package.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--use work.example_package.all;

entity cc1200_intf is
Port 
(
	CLK						: in std_logic;
	RESET					: in std_logic;
	-- ZQ Signals
	ZQ_REG_CS				: in std_logic;
	ZQ_REG_IN				: in std_logic_vector(23 downto 0);
	-- Mux/Ram Signals
	GET_DATA_FROM_RAM		: out std_logic;
	RAM_DATA_IN				: in std_logic_vector(23 downto 0);
	ram_data_in_valid		: in std_logic;
	packet_start			: out std_logic;
	data_out				: out std_logic_vector(7 downto 0); 
	data_out_valid			: out std_logic;
	-- CC1200 Signals
	CC1200_CS				: out std_logic;
	CC1200_CLK				: out std_logic;
	CC1200_MOSI				: out std_logic;
	CC1200_MISO				: in std_logic;
	CC1200_GPIO_0			: in std_logic;
	REG_OUT					: out std_logic_vector(23 downto 0);          
	CC1200_READY			: out std_logic
);
end cc1200_intf;

architecture Behavioral of cc1200_intf is

----------- Components -----------

----------------------------------

------------ Signals -------------
constant CC1200_CLK_RATIO : integer := 10;

signal cc1200_clk_out 		: std_logic;
signal cc1200_cs_out 		: std_logic;
signal cc1200_mosi_out 		: std_logic;
signal cc1200_clk_en 		: std_logic;
signal cc1200_clk_out_s		: std_logic;
signal cc1200_clk_out_s1	: std_logic;
signal cc1200_clk_fall		: std_logic;
signal cc1200_clk_rise		: std_logic;
signal cc1200_clk_cnt		: std_logic_vector(integer(ceil(log2(real(CC1200_CLK_RATIO))))-1 downto 0);
signal cc1200_din			: std_logic_vector(23 downto 0);
signal cc1200_dout			: std_logic_vector(7 downto 0);
signal cc1200_wr_bits		: std_logic_vector(4 downto 0);
signal cc1200_wr_rd 		: std_logic;

signal spi_cnt				: std_logic_vector(4 downto 0);
signal spi_clk_cnt			: std_logic_vector(9 downto 0);
signal delay_cnt			: std_logic_vector(4 downto 0);
signal pkt_bytes_cnt		: std_logic_vector(7 downto 0);
signal total_bytes_cnt		: std_logic_vector(15 downto 0);
signal spi_access 			: spi_access_type;

signal zq_reg_cs_s 			: std_logic;
signal zq_reg_cs_rise		: std_logic;

signal CC1200_GPIO_0_s1		: std_logic;
signal CC1200_GPIO_0_s2		: std_logic;

type cc1200_state_type is
(
	idle,							-- 0
	cs_delay_start,					-- 1
	spi_write,						-- 2
	spi_read,						-- 3
	std_fifo_access,				-- 4
	wait_for_cc1200_packet_end,		-- 5
	wait_for_cc1200_packet_start,	-- 6
	cs_delay_end					-- 7
);
signal cc1200_state : cc1200_state_type;
----------------------------------

attribute MARK_DEBUG : string;
attribute MARK_DEBUG of CC1200_READY : signal is "TRUE"; 
attribute MARK_DEBUG of CC1200_MISO : signal is "TRUE"; 
attribute MARK_DEBUG of CC1200_MOSI  : signal is "TRUE"; 
attribute MARK_DEBUG of CC1200_CLK : signal is "TRUE"; 
attribute MARK_DEBUG of CC1200_CS : signal is "TRUE"; 
attribute MARK_DEBUG of GET_DATA_FROM_RAM : signal is "TRUE"; 
attribute MARK_DEBUG of ZQ_REG_IN : signal is "TRUE"; 
attribute MARK_DEBUG of ZQ_REG_CS : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_state : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_wr_bits : signal is "TRUE"; 
attribute MARK_DEBUG of spi_access : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_din : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_dout : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_clk_en : signal is "TRUE"; 
attribute MARK_DEBUG of spi_cnt : signal is "TRUE"; 
attribute MARK_DEBUG of CC1200_GPIO_0 : signal is "TRUE"; 
attribute MARK_DEBUG of REG_OUT : signal is "TRUE"; 
attribute MARK_DEBUG of pkt_bytes_cnt : signal is "TRUE"; 
attribute MARK_DEBUG of total_bytes_cnt : signal is "TRUE"; 
attribute MARK_DEBUG of cc1200_clk_rise : signal is "TRUE"; 
attribute MARK_DEBUG of spi_clk_cnt : signal is "TRUE"; 
attribute MARK_DEBUG of data_out : signal is "TRUE"; 
attribute MARK_DEBUG of data_out_valid : signal is "TRUE"; 

begin

CC1200_CLK		<= cc1200_clk_out_s;
CC1200_CS		<= cc1200_cs_out;
CC1200_MOSI		<= cc1200_mosi_out;

cc1200_clk_fall	<= not(cc1200_clk_out_s) and cc1200_clk_out_s1;
cc1200_clk_rise	<= cc1200_clk_out_s and not(cc1200_clk_out_s1);

process(clk, reset) begin
	if rising_edge(clk) then
		if reset = '1' then
			zq_reg_cs_s			<= '0';
			CC1200_GPIO_0_s1	<= '0';
			CC1200_GPIO_0_s2	<= '0';
		else
			zq_reg_cs_s			<= ZQ_REG_CS;
			CC1200_GPIO_0_s1	<= CC1200_GPIO_0;
			CC1200_GPIO_0_s2	<= CC1200_GPIO_0_s1;
		end if;
	end if;
end process;

process(clk, reset) begin
	if rising_edge(clk) then
		if reset = '1' then
			spi_clk_cnt		<= (others => '0');
		else
			if (cc1200_cs_out = '0') then		
				if (cc1200_clk_rise = '1') then
					spi_clk_cnt			<= spi_clk_cnt + 1;
				end if;
			else			
				spi_clk_cnt				<= (others => '0');
			end if;
		end if;
	end if;
end process;

zq_reg_cs_rise		<= ZQ_REG_CS and not(zq_reg_cs_s); 

process(CLK, RESET) begin
	if rising_edge(CLK) then
		if RESET = '1' then
			cc1200_clk_out					<= '0';
			cc1200_clk_out_s				<= '0';
			cc1200_clk_out_s1				<= '0';
			cc1200_clk_cnt					<= (others => '0');
		else
			cc1200_clk_out_s				<= cc1200_clk_out;
			cc1200_clk_out_s1				<= cc1200_clk_out_s;
			if (cc1200_clk_en = '1') then		
				if (cc1200_clk_cnt = 0) then
					cc1200_clk_out			<= not(cc1200_clk_out);
					cc1200_clk_cnt			<= cc1200_clk_cnt + 1;
				elsif (cc1200_clk_cnt = CC1200_CLK_RATIO/2 - 1) then		
					cc1200_clk_cnt			<= (others => '0');
				else			
					cc1200_clk_cnt			<= cc1200_clk_cnt + 1;	
				end if;
			else			
				cc1200_clk_out				<= '0';	
				cc1200_clk_cnt				<= (others => '0');
			end if;
		end if;
	end if;
end process;

process(CLK, RESET) begin
	if RESET = '1' then
		cc1200_clk_en		<= '0';
		cc1200_cs_out		<= '1';
		cc1200_mosi_out		<= '0';
		cc1200_din			<= (others => '0');
		cc1200_dout			<= (others => '0');
		data_out			<= (others => '0');
		data_out_valid		<= '0';
		cc1200_wr_bits		<= (others => '0');
		cc1200_wr_rd		<= '0';
		spi_cnt				<= (others => '0');
		spi_access			<= COMMAND_STROBE;
		delay_cnt			<= (others => '0');
		REG_OUT				<= (others => '0');
		CC1200_READY		<= '1';
		packet_start		<= '0';
		pkt_bytes_cnt		<= (others => '0');	
		total_bytes_cnt		<= (others => '0');	
		get_data_from_ram	<= '0';
		cc1200_state		<= idle;
	elsif rising_edge(CLK) then
		case cc1200_state is
			when idle =>
				if (zq_reg_cs_rise = '1') then
					if (ZQ_REG_IN(22 downto 20) <= 2) then		
						if (ZQ_REG_IN(22 downto 16) /= x"2F") then	
							if (ZQ_REG_IN(23) = '0') then												-- write
								cc1200_wr_bits			<= std_logic_vector(to_unsigned(16, cc1200_wr_bits'length));
							else																		-- read
								cc1200_wr_bits			<= std_logic_vector(to_unsigned(8, cc1200_wr_bits'length));	
							end if;	
							spi_access					<= REGISTER_SPACE;
						else			
							if (ZQ_REG_IN(23) = '0') then												-- write
								cc1200_wr_bits			<= std_logic_vector(to_unsigned(24, cc1200_wr_bits'length));
							else																		-- read
								cc1200_wr_bits			<= std_logic_vector(to_unsigned(16, cc1200_wr_bits'length));	
							end if;	
							spi_access					<= EXTENDED_ADDRESS;
						end if;
					elsif (ZQ_REG_IN(21 downto 20) = x"3" and ZQ_REG_IN(19 downto 16) /= x"E") then											-- command strobe / standard fifo accsess
						if (ZQ_REG_IN(19 downto 16) /= x"F") then			-- command strobe
							cc1200_wr_bits				<= std_logic_vector(to_unsigned(8, cc1200_wr_bits'length));
							spi_access					<= COMMAND_STROBE;
						else
							cc1200_wr_bits				<= std_logic_vector(to_unsigned(8, cc1200_wr_bits'length));
							spi_access					<= STANDARD_FIFO_ACCESS;
						end if;
					end if;
					cc1200_wr_rd						<= ZQ_REG_IN(23);
					cc1200_cs_out						<= '0';
					cc1200_mosi_out						<= ZQ_REG_IN(ZQ_REG_IN'high);	
					cc1200_din							<= ZQ_REG_IN(ZQ_REG_IN'high-1 downto 0) & '0';
					CC1200_READY						<= '0';
					cc1200_state						<= cs_delay_start;
				else			
					cc1200_cs_out						<= '1';	
					cc1200_clk_en						<= '0';
					CC1200_READY						<= '1';
				end if;
		
			when cs_delay_start =>
				if (delay_cnt = 4 ) then			-- wait 5 clk cycles (10ns) = 50ns (Tsp)		
					if (CC1200_MISO = '0') then
						delay_cnt						<= (others => '0');
						cc1200_clk_en					<= '1';
						cc1200_state					<= spi_write;
						if (spi_access = STANDARD_FIFO_ACCESS) then
							packet_start				<= '1';
						end if;
					end if;
				else			
					delay_cnt							<= delay_cnt + 1;	
				end if;
			
			when spi_write =>
				packet_start							<= '0';	
				if (cc1200_clk_rise = '1') then		
					cc1200_dout							<= cc1200_dout(cc1200_dout'high-1 downto 0) & CC1200_MISO;
				elsif (cc1200_clk_fall = '1') then		
					cc1200_mosi_out						<= cc1200_din(cc1200_din'high);
					cc1200_din							<= cc1200_din(cc1200_din'high-1 downto 0) & '0';
					if (spi_cnt = cc1200_wr_bits - 1) then		
						spi_cnt							<= (others => '0');
						if (cc1200_wr_rd = '1') then							-- read reg
							cc1200_state				<= spi_read;
						else					
							if (spi_access = COMMAND_STROBE) then			-- command strobe
								REG_OUT					<= cc1200_dout & x"0000";
								CC1200_READY			<= '1';
								cc1200_clk_en			<= '0';
								cc1200_state			<= cs_delay_end;
							elsif (spi_access = STANDARD_FIFO_ACCESS) then												-- standard fifo accsess
								if (pkt_bytes_cnt = TOTAL_PACKET_LEN) then	
									pkt_bytes_cnt		<= (others => '0');	
									cc1200_clk_en		<= '0';
									cc1200_state		<= cs_delay_end;
								else	
									pkt_bytes_cnt		<= pkt_bytes_cnt + 1;
									get_data_from_ram	<= '1';
									cc1200_state		<= std_fifo_access;		
								end if;	
							else
								cc1200_clk_en			<= '0';
								cc1200_state			<= cs_delay_end;
							end if;
						end if;
					else			
						spi_cnt							<= spi_cnt + 1;	
					end if;
				end if;
			
			when spi_read =>
				if (cc1200_clk_rise = '1') then		
					cc1200_dout							<= cc1200_dout(cc1200_dout'high-1 downto 0) & CC1200_MISO;
				elsif (cc1200_clk_fall = '1') then
					if (spi_cnt = 7) then
						if (spi_access = REGISTER_SPACE or spi_access = EXTENDED_ADDRESS) then		
							spi_cnt						<= (others => '0');
							REG_OUT						<= x"0000" & cc1200_dout;
							cc1200_clk_en				<= '0';
							cc1200_state				<= cs_delay_end;
						elsif (spi_access = STANDARD_FIFO_ACCESS) then	
							spi_cnt						<= (others => '0');
							data_out					<= cc1200_dout;
							data_out_valid				<= '1';
							if (pkt_bytes_cnt = CC1200_FIFO_TH - 1) then		
								pkt_bytes_cnt			<= (others => '0');
								total_bytes_cnt			<= total_bytes_cnt + 1;
								cc1200_clk_en			<= '0';
								cc1200_state			<= cs_delay_end;
							else			
								pkt_bytes_cnt			<= pkt_bytes_cnt + 1;
								total_bytes_cnt			<= total_bytes_cnt + 1;
							end if;								
						end if;	
					else			
						data_out_valid					<= '0';
						spi_cnt							<= spi_cnt + 1;	
					end if;
				else			
					data_out_valid						<= '0';
				end if;
					
			when std_fifo_access =>
				get_data_from_ram						<= '0';
				if (ram_data_in_valid = '1') then		
					cc1200_din							<= RAM_DATA_IN;
					cc1200_state						<= spi_write;
				end if;
				

			when wait_for_cc1200_packet_start => 
				packet_start							<= '1';		
				if (CC1200_GPIO_0_s2 = '1') then
					cc1200_state       					<= wait_for_cc1200_packet_end;
				end if;
				
			when wait_for_cc1200_packet_end =>
				if (CC1200_GPIO_0_s2 = '0') then		
					packet_start						<= '1';						-- indicates video_buf module
					cc1200_cs_out						<= '0';
					cc1200_mosi_out						<= '0';
					cc1200_din							<= x"fe0000";					-- x"7f" << 1
					CC1200_READY						<= '0';
					spi_access							<= STANDARD_FIFO_ACCESS;
					cc1200_state						<= cs_delay_start;
				end if;
				

			when cs_delay_end =>
				data_out_valid						<= '0';
				if (delay_cnt = 20) then											-- wait 5 clk cycles (10ns) = 50ns (Tns)		
					delay_cnt							<= (others => '0');
					cc1200_cs_out						<= '1';
					cc1200_state						<= idle;
				else			
					delay_cnt							<= delay_cnt + 1;	
				end if;
		end case;
	end if;
end process;

end Behavioral;