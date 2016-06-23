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

entity gpio is

generic (
      GPI_BITS : integer := 8;
      GPO_RESET_VALUE : integer := 0;
      GPO_BITS : integer := 8
      );

port (
      gpi:        in     std_logic_vector(GPI_BITS-1 downto 0);
      gpo:        out    std_logic_vector(GPO_BITS-1 downto 0);
      rst_an:     in     std_logic;  -- reset for the gpo register

      pclk:       in     std_logic;
      paddr:      in     std_logic_vector(11 downto 0);
      pwrite:     in     std_logic;
      penable:    in     std_logic;
      psel:       in     std_logic;
      pwdata:     in     std_logic_vector(31 downto 0);
      prdata:     out    std_logic_vector(31 downto 0)
      );
end gpio;

-- -----------------------------------------------------------------------------
architecture rtl of gpio is
-- -----------------------------------------------------------------------------


   signal gpiReg : std_logic_vector (31 downto 0);
   signal gpoReg : std_logic_vector (31 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------
  gpo <= gpoReg(GPO_BITS-1 downto 0);
  gpiReg <= ext(gpi,32);
-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

  ReadMem: process(paddr, psel, pwrite, penable)
  begin
    if (pwrite = '0' and psel = '1' and penable = '1') then
      if paddr(11 downto 2) = "0000000000" then 
	prdata <= gpiReg;                               -- read the gpi register
      elsif paddr(11 downto 2) = "0000000001" then 
	prdata <= gpoReg;                               -- read the gpo register
      elsif paddr = "111111111100" then
	prdata <= "00000000000000000000110100000011";   -- read the ID register = 0x00000D03
      else
	prdata <= "00000000000000000000000000000000";   -- else read 0
      end if;
    end if;
  end process;


  WriteMem: process(pclk, rst_an)
  variable addr: natural;
  begin
    
  if rst_an = '0' then
    gpoReg <= conv_std_logic_vector(GPO_RESET_VALUE,32);
  elsif rising_edge(pclk) then
    if (pwrite = '1' and psel = '1' and penable = '1') then
      if paddr(11 downto 2) = "0000000001" then 
        gpoReg <= pwdata;
      end if;
    end if;

  end if;
  end process;

end rtl;

