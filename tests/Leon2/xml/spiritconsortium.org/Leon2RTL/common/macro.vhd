-- ****************************************************************************
-- ** Leon 2 code
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
-- Derived from European Space Agency (ESA) code as described below
----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------
-- Entity: 	macro
-- File:	macro.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	some common macro functions
------------------------------------------------------------------------------
-- Version control:
-- 29-11-1997:	First implemetation
-- 26-09-1999:	Release 1.0
------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.config.all;
use work.iface.all;

package macro is

constant zero32 : std_Logic_vector(31 downto 0) := (others => '0');

function decode(v : std_logic_vector) return std_logic_vector;
function genmux(s,v : std_logic_vector) return std_logic;
function xorv(d : std_logic_vector) return std_logic;
function orv(d : std_logic_vector) return std_logic;


end;

package body macro is

-- generic decoder

function decode(v : std_logic_vector) return std_logic_vector is
variable res : std_logic_vector((2**v'length)-1 downto 0); --'
variable i : natural;
begin
  res := (others => '0');
-- pragma translate_off
  i := 0;
  if not is_x(v) then
-- pragma translate_on
    i := conv_integer(unsigned(v));
    res(i) := '1';
-- pragma translate_off
  else
    res := (others => 'X');
  end if;
-- pragma translate_on
  return(res);
end;

-- generic multiplexer

function genmux(s,v : std_logic_vector) return std_logic is
variable res : std_logic_vector(v'length-1 downto 0); --'
variable i : integer;
begin
  res := v;
-- pragma translate_off
  i := 0;
  if not is_x(s) then
-- pragma translate_on
    i := conv_integer(unsigned(s));
-- pragma translate_off
  else
    res := (others => 'X');
  end if;
-- pragma translate_on
  return(res(i));
end;

-- vector XOR

function xorv(d : std_logic_vector) return std_logic is
variable tmp : std_logic;
begin
  tmp := '0';
  for i in d'range loop tmp := tmp xor d(i); end loop; --'
  return(tmp);
end;

-- vector OR

function orv(d : std_logic_vector) return std_logic is
variable tmp : std_logic;
begin
  tmp := '0';
  for i in d'range loop tmp := tmp or d(i); end loop; --'
  return(tmp);
end;



end;


