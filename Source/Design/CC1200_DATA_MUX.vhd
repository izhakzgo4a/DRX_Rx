----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/06/2022 04:45:40 PM
-- Design Name: 
-- Module Name: CC1200_DATA_MUX - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CC1200_DATA_MUX is
    Port ( DATA_IN_OUT_SELECT : in STD_LOGIC;
           -- Zynq Signals
           ZQ_DATA_IN : in STD_LOGIC_VECTOR (23 downto 0);
           MUX_TO_ZQ_DATA_OUT : out STD_LOGIC_VECTOR (23 downto 0);
           -- RAM Signals
           RAM_TO_MUX_DATA_IN : in STD_LOGIC_VECTOR (23 downto 0);
           MUX_TO_RAM_DATA_OUT : out STD_LOGIC_VECTOR (23 downto 0);
           -- CC1200 Signals
           CC1200_TO_MUX_DATA_IN : in STD_LOGIC_VECTOR (23 downto 0);
           MUX_TO_CC1200_DATA_OUT : out STD_LOGIC_VECTOR (23 downto 0));
end CC1200_DATA_MUX;

architecture Behavioral of CC1200_DATA_MUX is

begin

mux: process (DATA_IN_OUT_SELECT)
begin
    case DATA_IN_OUT_SELECT is
         -- Mux Switched to ZQ
         when '0' =>
               MUX_TO_CC1200_DATA_OUT <= ZQ_DATA_IN;
               MUX_TO_ZQ_DATA_OUT <= CC1200_TO_MUX_DATA_IN;
               MUX_TO_RAM_DATA_OUT <= (others => '0');
         -- Mux Switched to RAM
         when '1' =>
               MUX_TO_CC1200_DATA_OUT <= RAM_TO_MUX_DATA_IN;
               MUX_TO_RAM_DATA_OUT <= CC1200_TO_MUX_DATA_IN;
               MUX_TO_ZQ_DATA_OUT <= (others => '0');
         when others => 
               MUX_TO_CC1200_DATA_OUT <= RAM_TO_MUX_DATA_IN;
               MUX_TO_RAM_DATA_OUT <= CC1200_TO_MUX_DATA_IN;
               MUX_TO_ZQ_DATA_OUT <= (others => '0');
    end case;
end process;

end Behavioral;
