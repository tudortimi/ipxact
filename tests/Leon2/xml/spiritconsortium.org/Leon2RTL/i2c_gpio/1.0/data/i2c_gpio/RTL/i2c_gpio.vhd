--
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

library ieee;
use ieee.std_logic_1164.all;

entity i2c_gpio is
        generic (
                gpibits: integer := 4;
                gpobits: integer := 4
        );

        port (
                sda: inout std_logic;
                scl: inout std_logic;
                address: in std_logic_vector(9 downto 0);
                gpi: in std_logic_vector((gpibits - 1) downto 0);
                gpo: out std_logic_vector((gpobits - 1) downto 0)
        );
end i2c_gpio;

architecture verilog of i2c_gpio is
        attribute foreign of verilog:architecture is "VERILOG(event) i2c_gpio_lib.i2c_gpio:module";
begin
end;

