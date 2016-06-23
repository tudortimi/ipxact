----------------------------------------------------------------------------
-- 
-- Revision:    $Revision: 1506 $
-- Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- 
-- Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
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
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ArmAPB2SpiritAPB is
  port (
    -- Mirrored Slave Side
    pselMS    : in  Std_ULogic;
    penableMS : in  Std_ULogic;
    paddrMS   : in  Std_Logic_Vector(31 downto 0);
    pwriteMS  : in  Std_ULogic;
    pwdataMS  : in  Std_Logic_Vector(31 downto 0);
    prdataMS  : out Std_Logic_Vector(31 downto 0);
    -- Slave Side
    pselS    : out  Std_ULogic;
    penableS : out  Std_ULogic;
    paddrS   : out  Std_Logic_Vector(31 downto 0);
    pwriteS  : out  Std_ULogic;
    pwdataS  : out  Std_Logic_Vector(31 downto 0);
    prdataS  : in Std_Logic_Vector(31 downto 0));
end ArmAPB2SpiritAPB;

architecture struct of ArmAPB2SpiritAPB is

begin

	pselS <= pselMS;
	penableS <= penableMS;
	paddrS <= paddrMS;
	pwriteS <= pwriteMS;
	pwdataS <= pwdataMS;
	prdataMS <= prdataS;	
	
end struct;
