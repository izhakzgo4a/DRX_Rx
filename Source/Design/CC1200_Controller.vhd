----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2022 01:10:17 PM
-- Design Name: 
-- Module Name: CC1200_Controller - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CC1200_Controller is
    -- Generic (PACKET_LENGTH_IN_BYTES : INTEGER range 1 to 128 := 120);
    Port 
    (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
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
end CC1200_Controller;

architecture Behavioral of CC1200_Controller is

COMPONENT cc1200_intf is
    Port 
	( 	CLK : in std_logic;
		RESET : in std_logic;
		-- ZQ Signals
		ZQ_REG_CS				: in std_logic;
		ZQ_REG_IN				: in std_logic_vector(23 downto 0);
		-- Ram Signals
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
end COMPONENT;


COMPONENT vio_0 is
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

begin

CC1200_RST          <= ZQ_CC1200_RST;


CC1200 : cc1200_intf PORT MAP 
(
	CLK						=> CLK,
	RESET					=> RESET,
	-- ZQ Signals
	ZQ_REG_CS				=> ZQ_REG_CS,
	ZQ_REG_IN				=> ZQ_REG_IN,
	-- Ram Signals
	GET_DATA_FROM_RAM		=> GET_DATA_FROM_RAM,
	RAM_DATA_IN				=> RAM_DATA_IN,
	ram_data_in_valid		=> ram_data_in_valid,
	packet_start			=> open,
	data_out				=> cc1200_data_out,
	data_out_valid			=> cc1200_data_out_valid,
	-- CC1200 Signals
	CC1200_CS				=> CC1200_CS,
	CC1200_CLK				=> CC1200_CLK,
	CC1200_MOSI				=> CC1200_MOSI,
	CC1200_MISO				=> CC1200_MISO,
	CC1200_GPIO_0			=> '0',
	REG_OUT					=> REG_OUT,
	CC1200_READY			=> CC1200_READY
);

end Behavioral;
