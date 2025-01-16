--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
--Date        : Mon Dec 23 17:05:08 2024
--Host        : DESKTOP-I7N05T3 running 64-bit major release  (build 9200)
--Command     : generate_target DRX_Rx_bd_wrapper.bd
--Design      : DRX_Rx_bd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity DRX_Rx_bd_wrapper is
  port (
    CC1200_CLK_0 : out STD_LOGIC;
    CC1200_CLK_1 : out STD_LOGIC;
    CC1200_CLK_2 : out STD_LOGIC;
    CC1200_CLK_3 : out STD_LOGIC;
    CC1200_CS_0 : out STD_LOGIC;
    CC1200_CS_1 : out STD_LOGIC;
    CC1200_CS_2 : out STD_LOGIC;
    CC1200_CS_3 : out STD_LOGIC;
    CC1200_GPIO_0_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_MISO_0 : in STD_LOGIC;
    CC1200_MISO_1 : in STD_LOGIC;
    CC1200_MISO_2 : in STD_LOGIC;
    CC1200_MISO_3 : in STD_LOGIC;
    CC1200_MOSI_0 : out STD_LOGIC;
    CC1200_MOSI_1 : out STD_LOGIC;
    CC1200_MOSI_2 : out STD_LOGIC;
    CC1200_MOSI_3 : out STD_LOGIC;
    CC1200_RST_0 : out STD_LOGIC;
    CC1200_RST_1 : out STD_LOGIC;
    CC1200_RST_2 : out STD_LOGIC;
    CC1200_RST_3 : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    LED_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    TMDS_Clk_n : out STD_LOGIC;
    TMDS_Clk_p : out STD_LOGIC;
    TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
end DRX_Rx_bd_wrapper;

architecture STRUCTURE of DRX_Rx_bd_wrapper is
  component DRX_Rx_bd is
  port (
    TMDS_Clk_p : out STD_LOGIC;
    TMDS_Data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TMDS_Clk_n : out STD_LOGIC;
    TMDS_Data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    CC1200_GPIO_0_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_0_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_2_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_GPIO_3_3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    LED_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    LED_3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    CC1200_RST_0 : out STD_LOGIC;
    CC1200_CS_0 : out STD_LOGIC;
    CC1200_CLK_0 : out STD_LOGIC;
    CC1200_MOSI_0 : out STD_LOGIC;
    CC1200_RST_1 : out STD_LOGIC;
    CC1200_CS_1 : out STD_LOGIC;
    CC1200_CLK_1 : out STD_LOGIC;
    CC1200_MOSI_1 : out STD_LOGIC;
    CC1200_RST_2 : out STD_LOGIC;
    CC1200_CS_2 : out STD_LOGIC;
    CC1200_CLK_2 : out STD_LOGIC;
    CC1200_MOSI_2 : out STD_LOGIC;
    CC1200_RST_3 : out STD_LOGIC;
    CC1200_CS_3 : out STD_LOGIC;
    CC1200_CLK_3 : out STD_LOGIC;
    CC1200_MOSI_3 : out STD_LOGIC;
    CC1200_MISO_0 : in STD_LOGIC;
    CC1200_MISO_1 : in STD_LOGIC;
    CC1200_MISO_2 : in STD_LOGIC;
    CC1200_MISO_3 : in STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC
  );
  end component DRX_Rx_bd;
begin
DRX_Rx_bd_i: component DRX_Rx_bd
     port map (
      CC1200_CLK_0 => CC1200_CLK_0,
      CC1200_CLK_1 => CC1200_CLK_1,
      CC1200_CLK_2 => CC1200_CLK_2,
      CC1200_CLK_3 => CC1200_CLK_3,
      CC1200_CS_0 => CC1200_CS_0,
      CC1200_CS_1 => CC1200_CS_1,
      CC1200_CS_2 => CC1200_CS_2,
      CC1200_CS_3 => CC1200_CS_3,
      CC1200_GPIO_0_0(0) => CC1200_GPIO_0_0(0),
      CC1200_GPIO_0_1(0) => CC1200_GPIO_0_1(0),
      CC1200_GPIO_0_2(0) => CC1200_GPIO_0_2(0),
      CC1200_GPIO_0_3(0) => CC1200_GPIO_0_3(0),
      CC1200_GPIO_2_0(0) => CC1200_GPIO_2_0(0),
      CC1200_GPIO_2_1(0) => CC1200_GPIO_2_1(0),
      CC1200_GPIO_2_2(0) => CC1200_GPIO_2_2(0),
      CC1200_GPIO_2_3(0) => CC1200_GPIO_2_3(0),
      CC1200_GPIO_3_0(0) => CC1200_GPIO_3_0(0),
      CC1200_GPIO_3_1(0) => CC1200_GPIO_3_1(0),
      CC1200_GPIO_3_2(0) => CC1200_GPIO_3_2(0),
      CC1200_GPIO_3_3(0) => CC1200_GPIO_3_3(0),
      CC1200_MISO_0 => CC1200_MISO_0,
      CC1200_MISO_1 => CC1200_MISO_1,
      CC1200_MISO_2 => CC1200_MISO_2,
      CC1200_MISO_3 => CC1200_MISO_3,
      CC1200_MOSI_0 => CC1200_MOSI_0,
      CC1200_MOSI_1 => CC1200_MOSI_1,
      CC1200_MOSI_2 => CC1200_MOSI_2,
      CC1200_MOSI_3 => CC1200_MOSI_3,
      CC1200_RST_0 => CC1200_RST_0,
      CC1200_RST_1 => CC1200_RST_1,
      CC1200_RST_2 => CC1200_RST_2,
      CC1200_RST_3 => CC1200_RST_3,
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      LED_0(0) => LED_0(0),
      LED_1(0) => LED_1(0),
      LED_2(0) => LED_2(0),
      LED_3(0) => LED_3(0),
      TMDS_Clk_n => TMDS_Clk_n,
      TMDS_Clk_p => TMDS_Clk_p,
      TMDS_Data_n(2 downto 0) => TMDS_Data_n(2 downto 0),
      TMDS_Data_p(2 downto 0) => TMDS_Data_p(2 downto 0)
    );
end STRUCTURE;
