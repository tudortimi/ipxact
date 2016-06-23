-- ****************************************************************************
-- ** Description: mp3DecodeCrcPkg.vhd
-- ** Author:      The SPIRIT Consortium
-- ** 
-- ** Revision:    $Revision: 1506 $
-- ** Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- ** 
-- ** Copyright (c) 2008, 2009 The SPIRIT Consortium.
-- ** 
-- ** This work forms part of a deliverable of The SPIRIT Consortium.
-- ** 
-- ** Use of these materials are governed by the legal terms and conditions
-- ** outlined in the disclaimer available from www.spiritconsortium.org.
-- ** 
-- ** This source file is provided on an AS IS basis.  The SPIRIT
-- ** Consortium disclaims any warranty express or implied including
-- ** any warranty of merchantability and fitness for use for a
-- ** particular purpose.
-- ** 
-- ** The user of the source file shall indemnify and hold The SPIRIT
-- ** Consortium and its members harmless from any damages or liability.
-- ** Users are requested to provide feedback to The SPIRIT Consortium
-- ** using either mailto:feedback@lists.spiritconsortium.org or the forms at 
-- ** http://www.spiritconsortium.org/about/contact_us/
-- ** 
-- ** This file may be copied, and distributed, with or without
-- ** modifications; this notice must be included on any copy.
-- ****************************************************************************
--  Derived from Easics NV. as described below
-----------------------------------------------------------------------
-- File:  PCK_CRC24_D1.vhd                              
-- Date:  Thu Nov  1 21:34:54 2007                                                      
--                                                                     
-- Copyright (C) 1999-2003 Easics NV.                 
-- This source file may be used and distributed without restriction    
-- provided that this copyright statement is not removed from the file 
-- and that any derivative work contains the original copyright notice
-- and the associated disclaimer.
--
-- THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--
-- Purpose: VHDL package containing a synthesizable CRC function
--   * polynomial: (0 5 12 16 24)
--   * data width: 1
--                                                                     
-- Info: tools@easics.be
--       http://www.easics.com                                  
-----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

package mp3DecodeCrcPkg is

  -- polynomial: (0 5 12 16 24)
  -- data width: 1
  function nextCRC24_D1
    ( Data:  std_logic;
      CRC:   std_logic_vector(23 downto 0) )
    return std_logic_vector;

end mp3DecodeCrcPkg;

library IEEE;
use IEEE.std_logic_1164.all;

package body mp3DecodeCrcPkg is

  -- polynomial: (0 5 12 16 24)
  -- data width: 1
  function nextCRC24_D1 
    ( Data:  std_logic;
      CRC:   std_logic_vector(23 downto 0) )
    return std_logic_vector is

    variable D: std_logic_vector(0 downto 0);
    variable C: std_logic_vector(23 downto 0);
    variable NewCRC: std_logic_vector(23 downto 0);

  begin

    D(0) := Data;
    C := CRC;

    NewCRC(0) := D(0) xor C(23);
    NewCRC(1) := C(0);
    NewCRC(2) := C(1);
    NewCRC(3) := C(2);
    NewCRC(4) := C(3);
    NewCRC(5) := D(0) xor C(4) xor C(23);
    NewCRC(6) := C(5);
    NewCRC(7) := C(6);
    NewCRC(8) := C(7);
    NewCRC(9) := C(8);
    NewCRC(10) := C(9);
    NewCRC(11) := C(10);
    NewCRC(12) := D(0) xor C(11) xor C(23);
    NewCRC(13) := C(12);
    NewCRC(14) := C(13);
    NewCRC(15) := C(14);
    NewCRC(16) := D(0) xor C(15) xor C(23);
    NewCRC(17) := C(16);
    NewCRC(18) := C(17);
    NewCRC(19) := C(18);
    NewCRC(20) := C(19);
    NewCRC(21) := C(20);
    NewCRC(22) := C(21);
    NewCRC(23) := C(22);

    return NewCRC;

  end nextCRC24_D1;

end mp3DecodeCrcPkg;

