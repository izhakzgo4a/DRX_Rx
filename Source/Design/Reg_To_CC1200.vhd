----------------------------------------------------------------------------------
-- Company: Go4A Ltd
-- Engineer: Alex Vinitsky
-- 
-- Create Date: 06/24/2022 01:27:32 PM
-- Design Name: Reg_To_CC1200
-- Module Name: Reg_To_CC1200 - Behavioral
-- Project Name: Reg_To_CC1200
-- Target Devices: Reg_To_CC1200
-- Tool Versions: 2020.1
--
-- Description: 
-- This Module performs as an Interface to CC1200.
-- The Module Gets an Input Data on ZQ_REG_IN. The input Data is 24 bit.
-- The Module works with the Input CLK = 100MHz. Fixed.
-- The CC1200_CLK is 10MHz. Fixed.
-- The interface is SPI with 4 different Transaction Modes.
-- Each Transaction Mode is Encoded in the input Data on B21 to B16 bits : 
--                                                                       B21-B16 = "0x30 - 0x3D" - Command Strobe Access - Mode "00"
--                                                                       B21-B16 = "0x00 - 0x2E" - Single Register Low Register Space Read/Write - Mode "01"
--                                                                       B21-B16 = "0x2F" - Single Register High Register Space Read/Write - Mode "10"
--                                                                       B21-B16 = "0x3F" - Standard FIFO Access - Mode "11"    
--
-- ZQ_REG_IN (23:0) can get different value combination according to the Transaction Mode:        
--                                                         
-- Command Strobe Access "00" : 8 bit Transaction Mode. In this mode the Module sends a dedicated Command to CC1200. The Command is encrypted into the bits B21-B16.
--                              Bit B22 MUST be "0". Bit B23 is N.A. The Status byte is returned on the CC1200_MISO when a Command Strobe is sent on the CC1200_MOSI.
--
-- Single Register Low Register Space Read/Write "01" : 16 bit Transaction Mode. In this mode the Module Writes/Read 1 Register to/from CC1200 in low Registers Space - "0x00 - 0x2E".
--                                                       B23 - Read/Write bit. "0" - Write,  "1" - Read
--                                                       B22 - Burst bit - MUST be "0" as this is SINGLE access.
--                                                       B21-B16 - Register Address in LOW register Space - 0x00 - 0x2E.
--                                                       B15-B8 - Data byte in Write Case, N.A in Read Case.
--                                                       The Status byte is returned on the CC1200_MISO both when an Address or Data is sent on the CC1200_MOSI.
--
-- Single Register High Register Space Read/Write - Mode "10" : 24 bit Transaction Mode. In this mode the Module Writes/Read 1 Register to/from CC1200 in High Registers Space - "0x2F00 - 0x2FFF".
--                                                              B23 - Read/Write bit. "0" - Write,  "1" - Read
--                                                              B22 - Burst bit - MUST be "0" as this is SINGLE access.
--                                                              B21-B16 = "0x2F" - Single Register High Register Space Read/Write - Mode "10"
--                                                              B15-B8 - Extended Register Address - 0x00 - 0xFF.
--                                                              B7-B0 - Data byte in Write Case, N.A in Read Case. 
--                                                              The Status byte is returned on the CC1200_MISO both when a command "0x2F" is sent via B21-B16 bits or when Data is sent on the CC1200_MOSI.
--                                                              When the extended address is sent on the CC1200_MOSI, CC1200_MISO will return all zeros.
--
-- Standard FIFO Access - Mode "11" : 8 bit Header + N Data bytes Transaction Mode. In This Mode the Module Sends the special Header Byte to C1200 activating the Standard FIFO Mode.
--                                    B23-B16 - Header Byte Bits.
--                                    B23 - Read/Write bit. "0" - Write,  "1" - Read
--                                    B22 - Burst bit - MUST be "1" as this is BURST access.
--                                    B21-B16 = "0x3F" - Standard FIFO Access - Mode "11".
--                                    B15 and go on until CS goes High - are Data Bytes for FIFO.
--
-- The Input ZQ_REG_CS activates all 4 Transaction Modes. ZQ_REG_CS must be 1 CLK cycle at least. It can be any higher length.
-- The Transaction Reactivation is possible when the CC1200_READY goes HIGH only. This statment is valid for all the modes exept FIFO mode.
-- In the FIFO mode only the full reactivation is possible after the the CC1200_READY goes HIGH. But each Data Byte is transmitted untill PACKET_LENGTH_IN_BYTES - 1.
--
-- This Module latches the Input Register REG_IN_s when :
--                                                      All Modes exept FIFO Mode - "00", "01", "10" -  ZQ_REG_CS goes HIGH -> CC1200_CS goes LOW -> TranzactionAllowed goes HIGH. 
--                                                      FIFO Mode - "11" - ZQ_REG_CS goes HIGH -> CC1200_CS goes LOW -> TranzactionAllowed goes HIGH and BldCntr = "0" when the Header Byte is sent.   
--                                                                         Each time when BldCntr = "0" for the following Data bytes.     
-- This Module will output the incommoing Data from the CC1200 on the REG_OUT in the followin cases : 
--                                                                                                  Status Byte : When in Mode "00" - Status Byte is written into REG_OUT(23:16) bits.
--                                                                                                                When in Mode "01" - Status Byte is written into REG_OUT(23:16) and REG_OUT(15:8) bits in Write Register mode.
--                                                                                                                                    Data Byte is written into REG_OUT(15:8) bits in Resd mode.
--                                                                                                                When in Mode "10" - Status Byte is written into REG_OUT(23:16) and REG_OUT(7:0) bits in Write Register mode.  
--                                                                                                                                    "00" is written into REG_OUT(15:8) bits in both Write/Read modes.
--                                                                                                                                    Data Byte is written into REG_OUT(15:8) bits in Resd mode.
--                                                                                                                When in Mode "11" - Data Byte is written into REG_OUT(23:16) bits in Resd mode each time the FIFO returns the Data byte.    
--            
-- The CC1200_READY output signal goes LOW each time any Tranasaction Mode strats. CC1200_READY goes HIGH each time any Tranasaction Mode is Finished.
-- Any External Module that wants to comunicate with this module MUST wait untill CC1200_READY goes HIGH.       
--
-- DATA_IN_OUT_SELECT - This an Output signal Itnended to Control the External Asyncronouse DATA MUX. Both the ZQ_REG_IN and REG_OUT ports should be connected to the MUX.
-- DATA_IN_OUT_SELECT = "0"  - The Data is comming from ZQ on ZQ_REG_IN port and goes to ZQ via REG_OUT port. Usefull in all register transaction modes. 
-- DATA_IN_OUT_SELECT = "1"  - The Data is comming from the External Module/RAM on ZQ_REG_IN port in Write Mode and goes to the External Module/RAM in Read Mode via REG_OUT port. Usefull in FIFO Mode.
--
-- GET_DATA_FROM_RAM - This is an Output 1 CLK duration signal that Indicates the External Module when to prepare the Data on the ZQ_REG_IN port via the External Data Mux. Usefull in FIFO Write Mode.
--
-- DATA_FROM_FIFO_READY - This is an Output 1 CLK duration signal that Indicates the External Module when the Data is Ready from the CC1200 FIFO. The Data is Outputs on the REG_OUT port via the External Data Mux.  Usefull in FIFO Read Mode.
--
-- PACKET_LENGTH_IN_BYTES - Represents the number of Bytes in 1 packet that CC1200 will send/receive. Minimum 1, Maximum 128.                                                                             
-- Revision:
-- Revision 0.01 - File Created
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

entity Reg_To_CC1200 is
   --  Generic (PACKET_LENGTH_IN_BYTES : INTEGER range 1 to 128 := 120); 
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           -- ZQ Signals
           ZQ_REG_CS : in STD_LOGIC;
           ZQ_REG_IN : in STD_LOGIC_VECTOR (23 downto 0);
           -- Mux/Ram Signals
           DATA_IN_OUT_SELECT : out STD_LOGIC;             -- '0' - Data From/To ZQ  '1' - Data From/To RAM
           GET_DATA_FROM_RAM : out STD_LOGIC;
           DATA_FROM_FIFO_READY : out STD_LOGIC;
           -- CC1200 Signals
           CC1200_CS : out STD_LOGIC;
           CC1200_CLK : out STD_LOGIC;
           CC1200_MOSI : out STD_LOGIC;
           CC1200_MISO : in STD_LOGIC;
           REG_OUT : out STD_LOGIC_VECTOR (23 downto 0);          
           CC1200_READY : out STD_LOGIC;

           PACKET_LENGTH_IN_BYTES : in STD_LOGIC_VECTOR (7 downto 0)
         );
end Reg_To_CC1200;

architecture Behavioral of Reg_To_CC1200 is

-- Activation/Deactivation Signals
signal SPI_CS_s : STD_LOGIC;

-- Tranzaction Anable Signals
signal TranzactionAllowed : STD_LOGIC;

-- Tranzaction Mode Signals
signal TranzactionMode : STD_LOGIC_VECTOR (1 downto 0); 
signal Write_Read_Slct : STD_LOGIC;

-- Build Couter Signals
signal Bld_Cntr : STD_LOGIC_VECTOR (8 downto 0);

-- Packet Bytes Counter Signals
signal Pckt_Bytes_Cntr : STD_LOGIC_VECTOR (7 downto 0);

-- SPI Clock Generator Signals
signal SpiClkEnb : STD_LOGIC_VECTOR (3 downto 0); 
signal SPI_CLK_s : STD_LOGIC;

-- SPI Process Signals
signal REG_IN_s : STD_LOGIC_VECTOR (23 downto 0);
signal REG_OUT_s : STD_LOGIC_VECTOR (23 downto 0);
signal DATA_IN_OUT_SELECT_s : STD_LOGIC;              -- '0' - Data From/To ZQ  '1' - Data From/To RAM
signal Reg_Lached : STD_LOGIC;
signal SPI_REG_SENT_s : STD_LOGIC;
signal CC1200_READY_s : STD_LOGIC; 

-- attribute MARK_DEBUG : string;
-- attribute MARK_DEBUG of Pckt_Bytes_Cntr: signal is "TRUE";
-- attribute MARK_DEBUG of ZQ_REG_IN: signal is "TRUE";

begin

CC1200_MOSI <= REG_IN_s(23);
CC1200_CLK <= SPI_CLK_s;
CC1200_CS <= SPI_CS_s; 
CC1200_READY <= CC1200_READY_s;
DATA_IN_OUT_SELECT <= DATA_IN_OUT_SELECT_s;

Reg_Select : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         SPI_CS_s <= '1';
      elsif (ZQ_REG_CS = '1' and SPI_REG_SENT_s = '0' and CC1200_READY_s = '1' and ZQ_REG_IN (22) = '0' and  ZQ_REG_IN (21 downto 16) < x"3E") or  -- Single Register Low Register Space Read/Write, Single Register High Register Space Read/Write, Command Strobe
            (ZQ_REG_CS = '1' and SPI_REG_SENT_s = '0' and CC1200_READY_s = '1' and ZQ_REG_IN (22) = '1' and  ZQ_REG_IN (21 downto 16) = x"3F") then -- Standard FIFO Read/Write in Burst Mode
            SPI_CS_s <= '0';
      elsif SPI_REG_SENT_s = '1' then
            SPI_CS_s <= '1';
      end if;
    end if;
end process;

Tranzaction_Enable : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         TranzactionAllowed <= '0';
      -- The MASTER must wait until CC120X0 MISO pin goes low before starting to transfer the header byte. 
      elsif SPI_CS_s = '0' and CC1200_MISO = '0' then
            TranzactionAllowed <= '1';
      elsif SPI_CS_s = '1' then
            TranzactionAllowed <= '0';
      end if;
    end if;
end process;

Tranzaction_Mode : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         TranzactionMode <= "00"; -- Command Strobe Access 
         Write_Read_Slct <= '0';  -- '0' Write   '1' Read
      elsif SPI_CS_s = '0' and CC1200_READY_s = '1' then
            -- Command Strobe Access 
            if ZQ_REG_IN (22) = '0' and ZQ_REG_IN (21 downto 16) > x"2F" and  ZQ_REG_IN (21 downto 16) < x"3E" then
               TranzactionMode <= "00";  -- 8 bit mode
            -- Single Register Low Register Space Read/Write
            elsif ZQ_REG_IN (22) = '0' and ZQ_REG_IN (21 downto 16) < x"2F" then
                  TranzactionMode <= "01";  -- 16 bit mode
            -- Single Register High Register Space Read/Write   
            elsif ZQ_REG_IN (22) = '0' and ZQ_REG_IN (21 downto 16) = x"2F" then  
                  TranzactionMode <= "10";  -- 24 bit mode  
            -- Standard FIFO Read/Write in Burst Mode
            elsif ZQ_REG_IN (22) = '1' and ZQ_REG_IN (21 downto 16) = x"3F" then  
                TranzactionMode <= "11"; -- 8 bit mode to Send FIFO Address to CC1200
                -- Write Data to FIFO
                if ZQ_REG_IN (23) = '0' then
                   Write_Read_Slct <= '0';
                -- Read Data from FIFO
                else
                   Write_Read_Slct <= '1';
                end if;
            end if;
      end if;
    end if;
end process;

Bld_Count : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         Bld_Cntr <= (others => '0');
      -- All Tranzaction Modes exept Standard FIFO Read/Write in Burst Mode
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode /= "11" then
            Bld_Cntr <= Bld_Cntr + 1;
      -- Standard FIFO Read/Write in Burst Mode
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode = "11" then
            if Bld_Cntr < 79 then 
               Bld_Cntr <= Bld_Cntr + 1;
            elsif Bld_Cntr = 79 then  
                  Bld_Cntr <= (others => '0');
            end if;
      elsif SPI_CS_s = '1' then
            -- Time from CSn has been pulled high until it can be pulled low again MUST be > 50ns
            if TranzactionMode = "00" then   -- 8 bit
               if Bld_Cntr = 105 then 
                  Bld_Cntr <= (others => '0');
               elsif Bld_Cntr > 0 then
                     Bld_Cntr <= Bld_Cntr + 1;
               end if;
            elsif TranzactionMode = "01" then   -- 16 bit
                  if Bld_Cntr = 185 then 
                     Bld_Cntr <= (others => '0');
                  elsif Bld_Cntr > 0 then
                        Bld_Cntr <= Bld_Cntr + 1;
                  end if;
            elsif TranzactionMode = "10" then   -- 24 bit
                  if Bld_Cntr = 265 then 
                     Bld_Cntr <= (others => '0');
                  elsif Bld_Cntr > 0 then
                        Bld_Cntr <= Bld_Cntr + 1;
                  end if;
            elsif TranzactionMode = "11" then   -- Standard FIFO Read/Write in Burst Mode
                  if Bld_Cntr = 27 then 
                     Bld_Cntr <= (others => '0');
                  elsif Bld_Cntr > 0 then
                        Bld_Cntr <= Bld_Cntr + 1;
                  end if;
            end if;
      end if;
    end if;
end process;

Packet_Bytes_Counter : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         Pckt_Bytes_Cntr <= (others => '1');
      elsif DATA_IN_OUT_SELECT_s = '1' and Bld_Cntr = 0 and Reg_Lached = '0' and  SPI_CS_s = '0' then
            Pckt_Bytes_Cntr <= Pckt_Bytes_Cntr + 1;
      elsif SPI_CS_s = '1' then
            Pckt_Bytes_Cntr <= (others => '1');
      end if;
    end if;
end process;

Spi_Clk_Gen : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         SpiClkEnb <= (others => '0');
         SPI_CLK_s <= '0';
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' then
            -- Build SPI CLK
            if SpiClkEnb = 4 then 
               SpiClkEnb <= SpiClkEnb + 1;
               if TranzactionMode = "00" then   -- 8 bit
                  if Bld_Cntr > 83 then         -- 99 - 16
                     SPI_CLK_s <= '0';
                  else
                     SPI_CLK_s <= not SPI_CLK_s;
                  end if;
               elsif TranzactionMode = "01" then   -- 16 bit 
                     if Bld_Cntr > 163 then        -- 179 - 16
                        SPI_CLK_s <= '0';
                     else
                        SPI_CLK_s <= not SPI_CLK_s;
                     end if;
               elsif TranzactionMode = "10" then   -- 24 bit 
                     if Bld_Cntr > 243 then        -- 259 - 16
                        SPI_CLK_s <= '0';
                     else
                        SPI_CLK_s <= not SPI_CLK_s;
                     end if;
               elsif TranzactionMode = "11" then
                     if Pckt_Bytes_Cntr = PACKET_LENGTH_IN_BYTES and Bld_Cntr > 3 then   
                        SPI_CLK_s <= '0';
                     else
                        SPI_CLK_s <= not SPI_CLK_s;
                     end if;
               end if;
            elsif SpiClkEnb = 9 then
                  SpiClkEnb <= (others => '0');
                  if TranzactionMode = "00" then   -- 8 bit
                     if Bld_Cntr > 83 then         -- 99 - 16
                        SPI_CLK_s <= '0';
                     else
                        SPI_CLK_s <= not SPI_CLK_s;
                     end if;
                  elsif TranzactionMode = "01" then   -- 16 bit 
                        if Bld_Cntr > 163 then         -- 179 - 16
                           SPI_CLK_s <= '0';
                        else
                           SPI_CLK_s <= not SPI_CLK_s;
                        end if;
                  elsif TranzactionMode = "10" then   -- 24 bit 
                        if Bld_Cntr > 243 then         -- 259 - 16
                           SPI_CLK_s <= '0';
                        else
                           SPI_CLK_s <= not SPI_CLK_s;
                        end if;
                  elsif TranzactionMode = "11" then
                        if Pckt_Bytes_Cntr = PACKET_LENGTH_IN_BYTES and Bld_Cntr > 3 then   
                           SPI_CLK_s <= '0';
                        else
                           SPI_CLK_s <= not SPI_CLK_s;
                        end if;
                  end if; 
            else
               SpiClkEnb <= SpiClkEnb + 1;
            end if;
      elsif SPI_CS_s = '1' then
            SpiClkEnb <= (others => '0');
      end if;
    end if;
end process;

Spi : process (CLK)
begin
    if rising_edge (CLK) then
      if RESET = '1' then
         REG_IN_s <= (others => '0');
         GET_DATA_FROM_RAM <= '0';
         REG_OUT_s <= (others => '0');
         REG_OUT <= (others => '0');
         DATA_FROM_FIFO_READY <= '0';
         Reg_Lached <= '0';
         SPI_REG_SENT_s <= '0';
         CC1200_READY_s <= '1';   
         DATA_IN_OUT_SELECT_s <= '0';  -- '0' - Data From/To ZQ  '1' - Data From/To RAM
----------------------------- 8 Bit FIFO Tranzaction Mode ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode = "11" then  
            CC1200_READY_s <= '0';
            -- Latch Input Register
            if Bld_Cntr = 0 and Reg_Lached = '0' then
               Reg_Lached <= '1';
               REG_IN_s <= ZQ_REG_IN;
            elsif Bld_Cntr = 79 and Reg_Lached = '1' then
                  Reg_Lached <= '0';
                  DATA_IN_OUT_SELECT_s <= '1';  -- '0' - Data From/To ZQ  '1' - Data From/To RAM
            end if;
            -- Get Data from RAM
            if Write_Read_Slct = '0' and Bld_Cntr = 77 and (Pckt_Bytes_Cntr < PACKET_LENGTH_IN_BYTES - 1 or Pckt_Bytes_Cntr = 255) then
               GET_DATA_FROM_RAM <= '1';
            elsif Write_Read_Slct = '0' and Bld_Cntr = 78 and (Pckt_Bytes_Cntr < PACKET_LENGTH_IN_BYTES - 1 or Pckt_Bytes_Cntr = 255) then
                  GET_DATA_FROM_RAM <= '0';
            end if;
            -- Out Register for Read is Ready
            if Bld_Cntr = 0 then      -- 99 - 19
               REG_OUT <= REG_OUT_s;
            end if;
            -- Data From FIFO is Ready
            if Write_Read_Slct = '1' and Pckt_Bytes_Cntr < PACKET_LENGTH_IN_BYTES and Bld_Cntr = 0 then
               DATA_FROM_FIFO_READY <= '1';
            elsif Write_Read_Slct = '1' and Pckt_Bytes_Cntr < PACKET_LENGTH_IN_BYTES + 1 and Bld_Cntr = 1 then
                  DATA_FROM_FIFO_READY <= '0';
            end if;
            -- SPI Register Sent/Received
            if Pckt_Bytes_Cntr = PACKET_LENGTH_IN_BYTES and Bld_Cntr = 20 then   
               SPI_REG_SENT_s <= '1';
            end if;
            -- Shift Data on Each Falling Edge of SPI CLK
            if SpiClkEnb = 9 and (Pckt_Bytes_Cntr < PACKET_LENGTH_IN_BYTES or Pckt_Bytes_Cntr = 255) then
               for i in 16 to 22 loop    -- 24 - 8
                   REG_IN_s(i+1) <=  REG_IN_s(i);
               end loop;
               REG_OUT_s(16) <= CC1200_MISO;   -- 24 - 8
               for i in 16 to 22 loop          -- 24 - 8
                   REG_OUT_s(i+1) <= REG_OUT_s(i);
               end loop;
            end if;
      elsif SPI_CS_s = '1' and TranzactionMode = "11" then
            REG_IN_s <= (others => '0');
            GET_DATA_FROM_RAM <= '0';
            REG_OUT_s <= (others => '0');
            DATA_IN_OUT_SELECT_s <= '0';  -- '0' - Data From/To ZQ  '1' - Data From/To RAM
            DATA_FROM_FIFO_READY <= '0';
            Reg_Lached <= '0'; 
            SPI_REG_SENT_s <= '0';
            -- Time from CSn has been pulled high until it can be pulled low again MUST be > 50ns
            if Bld_Cntr = 27 then     
               CC1200_READY_s <= '1';
            end if;                
----------------------------- 8 Bit Register Tranzaction Mode ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode = "00" then  
            CC1200_READY_s <= '0';
            -- Latch Input Register
            if Reg_Lached = '0' then
               Reg_Lached <= '1';
               REG_IN_s <= ZQ_REG_IN;
            end if;
            -- Out Register for Read is Ready
            if Bld_Cntr = 80 then      -- 99 - 19
               REG_OUT <= REG_OUT_s;
            end if;
            -- SPI Register Sent/Received
            if Bld_Cntr /= 0 and Bld_Cntr = 99 then    -- 99
               SPI_REG_SENT_s <= '1';
            end if;
            -- Shift Data on Each Falling Edge of SPI CLK
            if SpiClkEnb = 9 then
               -- Do NOT Shift Registers After Number Clocks Grater than 99 - 14
               if Bld_Cntr < 84 then      -- 99 - 15
                  for i in 16 to 22 loop    -- 24 - 8
                      REG_IN_s(i+1) <=  REG_IN_s(i);
                  end loop;
                  REG_OUT_s(16) <= CC1200_MISO;   -- 24 - 8
                  for i in 16 to 22 loop          -- 24 - 8
                      REG_OUT_s(i+1) <= REG_OUT_s(i);
                  end loop;
               end if;
            end if;
      elsif SPI_CS_s = '1' and TranzactionMode = "00" then
            REG_IN_s <= (others => '0');
            REG_OUT_s <= (others => '0');
            Reg_Lached <= '0'; 
            SPI_REG_SENT_s <= '0';
            -- Time from CSn has been pulled high until it can be pulled low again MUST be > 50ns
            if Bld_Cntr = 105 then      -- 99 + 6
               CC1200_READY_s <= '1';
            end if;
----------------------------- 16 Bit Register Tranzaction Mode ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode = "01" then
            CC1200_READY_s <= '0';
            -- Latch Input Register
            if Reg_Lached = '0' then
               Reg_Lached <= '1';
               REG_IN_s <= ZQ_REG_IN;
            end if;
            -- Out Register for Read is Ready
            if Bld_Cntr = 160 then      -- 179 - 19
               REG_OUT <= REG_OUT_s;
            end if;
            -- SPI Register Sent/Received
            if Bld_Cntr /= 0 and Bld_Cntr = 179 then    -- 179
               SPI_REG_SENT_s <= '1';
            end if;
            -- Shift Data on Each Falling Edge of SPI CLK
            if SpiClkEnb = 9 then
               -- Do NOT Shift Registers After Number Clocks Grater than 99 - 14
               if Bld_Cntr < 164 then      -- 179 - 15
                  for i in 8 to 22 loop    -- 24 - 16
                      REG_IN_s(i+1) <=  REG_IN_s(i);
                  end loop;
                  REG_OUT_s(8) <= CC1200_MISO;   -- 24 - 16
                  for i in 8 to 22 loop          -- 24 - 16
                      REG_OUT_s(i+1) <= REG_OUT_s(i);
                  end loop;
               end if;
            end if;
      elsif SPI_CS_s = '1' and TranzactionMode = "01" then
            REG_IN_s <= (others => '0');
            REG_OUT_s <= (others => '0');
            Reg_Lached <= '0'; 
            SPI_REG_SENT_s <= '0';
            -- Time from CSn has been pulled high until it can be pulled low again MUST be > 50ns
            if Bld_Cntr = 185 then      -- 179 + 6
               CC1200_READY_s <= '1';
            end if;
----------------------------- 24 Bit Register Tranzaction Mode ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      elsif SPI_CS_s = '0' and TranzactionAllowed = '1' and TranzactionMode = "10" then
            CC1200_READY_s <= '0';
            -- Latch Input Register
            if Reg_Lached = '0' then
               Reg_Lached <= '1';
               REG_IN_s <= ZQ_REG_IN;
            end if;
            -- Out Register for Read is Ready
            if Bld_Cntr = 240 then      -- 259 - 19
               REG_OUT <= REG_OUT_s;
            end if;
            -- SPI Register Sent/Received
            if Bld_Cntr /= 0 and Bld_Cntr = 259 then    -- 259
               SPI_REG_SENT_s <= '1';
            end if;
            -- Shift Data on Each Falling Edge of SPI CLK
            if SpiClkEnb = 9 then
               -- Do NOT Shift Registers After Number Clocks Grater than 99 - 14
               if Bld_Cntr < 244 then      -- 259 - 15
                  for i in 0 to 22 loop    -- 24 - 24
                      REG_IN_s(i+1) <=  REG_IN_s(i);
                  end loop;
                  REG_OUT_s(0) <= CC1200_MISO;   -- 24 - 24
                  for i in 0 to 22 loop          -- 24 - 24
                      REG_OUT_s(i+1) <= REG_OUT_s(i);
                  end loop;
               end if;
            end if;
      elsif SPI_CS_s = '1' and TranzactionMode = "10" then
            REG_IN_s <= (others => '0');
            REG_OUT_s <= (others => '0');
            Reg_Lached <= '0'; 
            SPI_REG_SENT_s <= '0';
            -- Time from CSn has been pulled high until it can be pulled low again MUST be > 50ns
            if Bld_Cntr = 265 then      -- 259 + 6
               CC1200_READY_s <= '1';
            end if;
      end if;
    end if;
end process;

end Behavioral;
