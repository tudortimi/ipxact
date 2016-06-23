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

entity i2c_memory is
        generic (
                \MEM_DEPTH\: integer := 4096;
                \ADDRESS_BYTES\: integer := 2
        );

        port (
                sda: inout std_logic;
                scl: in std_logic;
                address: in std_logic_vector(9 downto 0)
        );
end i2c_memory;

architecture verilog of i2c_memory is
        attribute foreign of verilog:architecture is "VERILOG(event) i2c_memory_lib.i2c_memory:module";
begin
end;

