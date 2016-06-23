----------------------------------------------------------------------------
-- 
-- Revision:    $Revision: 1506 $
-- Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- 
-- Copyright (c) 2004, 2008, 2009 The SPIRIT Consortium.
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
-- Entity: 	ahbstat
-- File:	ahbstat.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	AHB status register. Latches the address and bus
--		parameters when an error is signalled on the AHB bus.
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.iface.all;
use work.amba.all;

entity ahbstat is
  port (
    rst    : in  std_logic;
    clk    : in  clk_type;
    ahbmi  : in  ahb_mst_in_type;
    ahbsi  : in  ahb_slv_in_type;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    ahbsto : out ahbstat_out_type

  );
end; 

architecture rtl of ahbstat is

type memstattype is record
  hsize            : std_logic_vector(2 downto 0);
  hmaster          : std_logic_vector(3 downto 0);
  address          : std_logic_vector(31 downto 0);  -- failed address
  read             : std_logic;
  newerr           : std_logic;
  ahberr           : std_logic;
  hresp 	   : std_logic_vector(1 downto 0);
end record;

signal r, rin : memstattype;


begin


  ctrl : process(rst, ahbmi, ahbsi, apbi, r)

  variable v : memstattype;
  variable regsd : std_logic_vector(31 downto 0);   -- data from registers


  begin

    v := r; 
    regsd := (others => '0');

    case apbi.paddr(2 downto 2) is
    when "1" => regsd := r.address;
    when "0" => 
	  regsd := "00000000000000000000000" &  r.newerr & r.read & 
	    	   r.hmaster & r.hsize  ;

    when others => regsd := (others => '-');
    end case;

    apbo.prdata <= regsd;

    if (apbi.psel and apbi.penable and apbi.pwrite) = '1' then
      case apbi.paddr(2 downto 2) is
      when "1" => v.address := apbi.pwdata;
      when "0" => 

	v.newerr  := apbi.pwdata(8);
	v.read    := apbi.pwdata(7);
	v.hmaster := apbi.pwdata(6 downto 3);
	v.hsize   := apbi.pwdata(2 downto 0);
      when others => null;
      end case;

    end if;

    v.hresp := ahbmi.hresp;

    if (ahbsi.hready = '1') then

      if (r.newerr = '0') then 
	if (r.hresp = HRESP_ERROR) then v.newerr := '1';
	else
      	  v.hmaster := ahbsi.hmaster; v.address := ahbsi.haddr; 
      	  v.read := not ahbsi.hwrite; v.hsize := ahbsi.hsize;
	end if;
      end if;
      v.hresp := HRESP_OKAY;
    end if;

    if rst = '0' then
      v.newerr := '0'; 
      v.read := '0'; 
      v.hmaster := "0000"; 
      v.hsize := "000"; 
      v.address := "00000000000000000000000000000000"; 
      v.hresp := HRESP_OKAY;
    end if;

    v.ahberr := v.newerr and not r.newerr;

    rin <= v;
    ahbsto.ahberr <= r.ahberr;

  end process;


  memstatregs : process(clk)
  begin if rising_edge(clk) then r <= rin; end if; end process;



end;


