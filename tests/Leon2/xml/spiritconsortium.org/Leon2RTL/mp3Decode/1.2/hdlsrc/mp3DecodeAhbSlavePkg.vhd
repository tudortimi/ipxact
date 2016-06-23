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



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mp3DecodeAhbSlavePkg is

    component mp3DecodeAhbSlave
        generic ( abits : integer := 12);
        port (
	    hresetn     : in  std_logic;
	    hclk        : in  std_logic;
	    hsel        : in  std_logic;                          -- slave select
	    haddr       : in  std_logic_vector(abits-1 downto 0);  -- address bus (byte)
	    hwrite      : in  std_logic;                          -- read/write
	    htrans      : in  std_logic_vector(1 downto 0);       -- transfer type
	    hsize       : in  std_logic_vector(2 downto 0);       -- transfer size
	    hburst      : in  std_logic_vector(2 downto 0);       -- burst type
	    hwdata      : in  std_logic_vector(31 downto 0);      -- write data bus
	    hprot       : in  std_logic_vector(3 downto 0);       -- protection control
	    hreadyi     : in  std_logic;                          -- transfer done on any slave
	    hreadyo     : out std_logic;                          -- transfer done in this slave
	    hresp       : out std_logic_vector(1 downto 0);       -- response type
	    hrdata      : out std_logic_vector(31 downto 0);      -- read data bus
	    reg1        : out std_logic_vector(31 downto 0);      -- registered data out
	    fifofull    : in  std_logic;                          -- FIFO full signal
	    fifowrite   : out std_logic;                          -- write to FIFO
	    fifodata    : out std_logic_vector(31 downto 0)       -- data to FIFO
        );
    end component;


end mp3DecodeAhbSlavePkg;


