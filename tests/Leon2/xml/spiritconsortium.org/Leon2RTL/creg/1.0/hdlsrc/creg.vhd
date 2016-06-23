-- 
-- Revision:    $Revision: 1506 $
-- Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- 
-- Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
-- 
-- This work forms part of a deliverable of The SPIRIT Consortium.
-- 
-- Use of these materials are governed by the legal terms and conditions
-- outlined in the disclaimer available from www.spiritconsortium.org.
-- 
-- This source file is provided on an AS IS basis.  The SPIRIT
-- Consortium disclaims any warranty express or implied including
-- any warranty of merchantability and fitness for use for a
-- particular purpose.
-- 
-- The user of the source file shall indemnify and hold The SPIRIT
-- Consortium and its members harmless from any damages or liability.
-- Users are requested to provide feedback to The SPIRIT Consortium
-- using either mailto:feedback@lists.spiritconsortium.org or the forms at 
-- http://www.spiritconsortium.org/about/contact_us/
-- 
-- This file may be copied, and distributed, with or without
-- modifications; this notice must be included on any copy.


-- SIMPLE GPIO EXAMPLE. PRODUCES UP TO 32 INPUT AND OUTPUTS
-- 4K byte addressSpace
--
-- gpi = read only input regsiter at address 0x0
-- gpo = read/write output register at address 0x4
--
-- read only ID register at 0xFFC = 0x00000D03


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_Logic_TEXTIO.all;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity creg is

port (
      rst_an:     in     std_logic;  -- reset for the creg

      pclk:       in     std_logic;
      paddr:      in     std_logic_vector(11 downto 0);
      pwrite:     in     std_logic;
      penable:    in     std_logic;
      psel:       in     std_logic;
      pwdata:     in     std_logic_vector(31 downto 0);
      prdata:     out    std_logic_vector(31 downto 0)
      );
end creg;

-- -----------------------------------------------------------------------------
architecture rtl of creg is
-- -----------------------------------------------------------------------------


   signal Reg1 : std_logic_vector (31 downto 0);
   signal Reg2 : std_logic_vector (31 downto 0);
   signal Reg3 : std_logic_vector (31 downto 0);
   signal Reg4 : std_logic_vector (31 downto 0);
   signal Reg5 : std_logic_vector (31 downto 0);
   signal Reg6 : std_logic_vector (31 downto 0);
   signal Reg7 : std_logic_vector (31 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

  ReadMem: process(paddr, psel, pwrite, penable)
  begin
    if (pwrite = '0' and psel = '1' and penable = '1') then
      if paddr(11 downto 2) = "0000000000" then 
	prdata <= Reg1;                               -- read the Reg1 register
      elsif paddr(11 downto 2) = "0000000001" then 
	prdata <= Reg1;                               -- read the Reg1 register
      elsif paddr(11 downto 2) = "0000000010" then 
	prdata <= Reg2;                               -- read the Reg2 register
      elsif paddr(11 downto 2) = "0000000011" then 
	prdata <= Reg3;                               -- read the Reg3 register
      elsif paddr(11 downto 2) = "0000000100" then 
	prdata <= Reg4;                               -- read the Reg4 register
      elsif paddr(11 downto 2) = "0000000101" then 
	prdata <= Reg5;                               -- read the Reg5 register and clear
      elsif paddr(11 downto 2) = "0000000110" then 
	prdata <= Reg5;                               -- read the Reg5 register and set
      elsif paddr(11 downto 2) = "0000000111" then 
	prdata <= Reg6;                               -- read the Reg6 register
      elsif paddr(11 downto 2) = "0000001000" then 
	prdata <= Reg7;                               -- read the Reg7 register
      elsif paddr = "111111111100" then
	prdata <= "00000000000000000000110100000111";   -- read the ID register = 0x00000D07
      else
	prdata <= "00000000000000000000000000000000";   -- else read 0
      end if;
    end if;
  end process;


  WriteMem: process(pclk, rst_an)
  variable addr: natural;
  begin
    
  if rst_an = '0' then
    Reg1 <= "00000000000000000000000000000000";
    Reg2 <= "00000000000000000000000000000000";
    Reg3 <= "11111111111111111111111111111111";
    Reg4 <= "00000000000000000000000000000000";
    Reg5 <= "00000000000000000000000000000000";
    Reg6 <= "00000000000000000000000000000000";
    Reg7 <= "00000000000000000000000000000000";
  elsif rising_edge(pclk) then
    if (pwrite = '1' and psel = '1' and penable = '1') then
      if paddr(11 downto 2) = "0000000000" then 
        Reg1 <= pwdata;
      elsif paddr(11 downto 2) = "0000000001" then  -- alias Reg1 at 0x0 with Reg1 at 0x4
        Reg1 <= pwdata;
      elsif paddr(11 downto 2) = "0000000010" then  -- Reg2 at 0x8 bitwise oneToSet
        Reg2 <= Reg2 or pwdata ;                   
      elsif paddr(11 downto 2) = "0000000011" then  -- Reg3 at 0xc bitwise oneToClear
        Reg3 <= Reg3 and not pwdata ;                   
      elsif paddr(11 downto 2) = "0000000100" then  -- Reg4 at 0x10 bitwise oneToToggle
        Reg4 <= Reg4 xor pwdata ;                   
      elsif paddr(11 downto 2) = "0000000101" then  -- Reg5 at 0x14 write set
        Reg5 <= "11111111111111111111111111111111";
      elsif paddr(11 downto 2) = "0000000110" then  -- Reg5 at 0x18 write clear
        Reg5 <= "00000000000000000000000000000000";
      elsif paddr(11 downto 2) = "0000000111" then  -- Reg6 at 0x1c write data is less than 16
	if (pwdata < "00000000000000000000000000010000") then
	  Reg6 <= pwdata;
	end if;
      elsif paddr(11 downto 2) = "0000001000" and Reg7(31) = '0' then  -- Reg7 at 0x20 only allows one write.
        Reg7 <= '1' & pwdata(30 downto 0);
      end if;
    end if;
    if (pwrite = '0' and psel = '1' and penable = '1') then
      if paddr(11 downto 2) = "0000000101" then  -- Reg5 at 0x14 read clear 
        Reg5 <= "00000000000000000000000000000000";
      elsif paddr(11 downto 2) = "0000000110" then  -- Reg5 at 0x18 read set
        Reg5 <= "11111111111111111111111111111111";
      end if;
    end if;

  end if;
  end process;

end rtl;

