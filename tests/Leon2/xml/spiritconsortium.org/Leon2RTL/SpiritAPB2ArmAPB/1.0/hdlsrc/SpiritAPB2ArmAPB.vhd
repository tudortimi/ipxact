----------------------------------------------------------------------------
-- Copyright (c) 2007 SPIRIT.  All rights reserved.
-- www.spiritconsortium.com
--
-- THIS WORK FORMS PART OF A SPIRIT CONSORTIUM SPECIFICATION.  
-- THIS WORK CONTAINS TRADE SECRETS AND PROPRIETARY INFORMATION 
-- WHICH IS THE EXCLUSIVE PROPERTY OF INDIVIDUAL MEMBERS OF THE 
-- SPIRIT CONSORTIUM. USE OF THESE MATERIALS ARE GOVERNED BY 
-- THE LEGAL TERMS AND CONDITIONS OUTLINED IN THE THE SPIRIT 
-- SPECIFICATION DISCLAIMER AVAILABLE FROM
-- www.spiritconsortium.org
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SpiritAPB2ArmAPB is
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
end SpiritAPB2ArmAPB;

architecture struct of SpiritAPB2ArmAPB is

begin
	pselS <= pselMS;
	penableS <= penableMS;
	paddrS <= paddrMS;
	pwriteS <= pwriteMS;
	pwdataS <= pwdataMS;
	prdataMS <= prdataS;	
	
end struct;