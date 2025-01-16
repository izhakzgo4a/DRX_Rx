----------------------------------------------------------------------------------
-- Company: GO4A
-- Engineer: Itzhak
-- 
-- Create Date: 08-04-2024 08:09
-- Design Name: 
-- Module Name: linspace
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
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.drx_package.all;

entity linspace is
Generic 
(
	D_WIDTH  		: INTEGER range 4 to 10 := 4;
	NUM_OF_SAMP		: INTEGER := 3
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
end linspace;

architecture Behavioral of linspace is

----------- Components -----------

----------------------------------

------------ Signals -------------
constant VALID_DELAY : integer := 3;

signal valid_sr		: std_logic_vector(VALID_DELAY-1 downto 0);

type padded_pixels_array is array (integer range <>) of std_logic_vector((D_WIDTH+1)*3-1 downto 0);
signal temp_points	: padded_pixels_array(0 to NUM_OF_SAMP-1);

----------------------------------

begin

-- p_start_pad		<= '0' & p_start;
-- p_stop_pad		<= '0' & p_stop;

linspace_gen: for i in 0 to 2 generate
	process(clk, reset) begin
		if rising_edge(clk) then
			if reset = '1' then
				temp_points(1)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= (others => '0');
				temp_points(0)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= (others => '0');
				temp_points(2)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= (others => '0');
			else
				temp_points(1)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= ('0' & p_start(D_WIDTH*(i+1)-1 downto D_WIDTH*i)) + ('0' & p_stop(D_WIDTH*(i+1)-1 downto D_WIDTH*i));
				temp_points(0)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= ('0' & temp_points(1)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i+1)) + ('0' & p_start(D_WIDTH*(i+1)-1 downto D_WIDTH*i));
				temp_points(2)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i)		<= ('0' & temp_points(1)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i+1)) + ('0' & p_stop(D_WIDTH*(i+1)-1 downto D_WIDTH*i));
			end if;
		end if;
	end process;

	restored_points(0)(D_WIDTH*(i+1)-1 downto D_WIDTH*i)		<= temp_points(0)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i+1) when upsamp_factor = 4 else (others => '0');
	restored_points(1)(D_WIDTH*(i+1)-1 downto D_WIDTH*i)		<= temp_points(1)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i+1) when upsamp_factor /= 0 else (others => '0');
	restored_points(2)(D_WIDTH*(i+1)-1 downto D_WIDTH*i)		<= temp_points(2)((D_WIDTH+1)*(i+1)-1 downto (D_WIDTH+1)*i+1) when upsamp_factor = 4 else (others => '0');
	
end generate linspace_gen;

process(clk, reset) begin
	if rising_edge(clk) then
		if reset = '1' then
			valid_sr		<= (others => '0');		
		else
			valid_sr		<= valid_sr(valid_sr'high-1 downto 0) & data_valid;
		end if;
	end if;
end process;

restored_points_valid		<= valid_sr(valid_sr'high);

end Behavioral;