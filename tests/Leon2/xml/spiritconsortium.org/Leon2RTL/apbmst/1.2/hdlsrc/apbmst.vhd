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
-- Note: This file has been changed in order to use the APB busdef.
--       The decoder/multiplexor is moved out of the
--       bridge in order to use the one inside the busdef. The PSEL out
--       of the bridge just selects the decoder in the APB busdef.
--       Christophe Amerijckx

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
-- Entity:      apbmst
-- File:        apbmst.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: AMBA AHB/APB bridge
------------------------------------------------------------------------------ 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;


entity apbmst is
  port (
    rst     : in  std_logic;
    clk     : in  clk_type;
    ahbi    : in  ahb_slv_in_type;
    ahbo    : out ahb_slv_out_type;
    apbi    : out apb_slv_in_type;
    apbo    : in  apb_slv_out_type
  );
end;

architecture rtl of apbmst is

-- registers
type reg_type is record
  haddr   : std_logic_vector(31 downto 2);   -- address bus
  hsel    : std_logic;
  hwrite  : std_logic;  		     -- read/write
  hready  : std_logic;  		     -- ready
  hready2 : std_logic;  		     -- ready
  penable : std_logic;
end record;

signal r, rin : reg_type;

constant apbmax : integer := 31;
begin
  comb : process(ahbi, apbo, r, rst)
  variable v : reg_type;
  variable psel   : std_logic;
  variable prdata : std_logic_vector(31 downto 0);
  variable pwdata : std_logic_vector(31 downto 0);
  variable apbaddr : std_logic_vector(apbmax downto 2);
  variable apbaddr2 : std_logic_vector(31 downto 0);
  begin

    v := r; v.hready2 := '1';


    -- detect start of cycle
    if (ahbi.hready = '1') then
      if ((ahbi.htrans = HTRANS_NONSEQ) or (ahbi.htrans = HTRANS_SEQ)) and
	  (ahbi.hsel = '1')
      then
        v.hready := '0'; v.hwrite := ahbi.hwrite; v.hsel := '1';
	v.hwrite := ahbi.hwrite; v.hready2 := not ahbi.hwrite;
	v.haddr(apbmax downto 2)  := ahbi.haddr(apbmax downto 2); 
      else v.hsel := '0'; end if;
    end if;

    -- generate hready and penable
    if (r.hsel and r.hready2 and (not r.hready)) = '1' then 
      v.penable := '1'; v.hready := '1';
    else v.penable := '0'; end if;

    -- generate psel and select APB read data
    psel := '0'; prdata := (others => '-');
    apbaddr := r.haddr(apbaddr'range);
    prdata := apbo.prdata; 
    psel := '1';

    -- AHB respons
    ahbo.hresp  <= HRESP_OKAY;
    ahbo.hready <= r.hready;
    ahbo.hrdata <= prdata;
    ahbo.hsplit <= (others => '0');

    if rst = '0' then
      v.penable := '0'; v.hready := '1'; v.hsel := '0';
-- pragma translate_off
      v.haddr := (others => '0');
-- pragma translate_on

    end if;

    rin <= v;

    -- tie write data to zero if not used to save power (not testable)
    if r.hsel = '1' then pwdata := ahbi.hwdata; 
    else pwdata := (others => '0'); end if;

    -- drive APB bus
    apbaddr2 := (others => '0');
    apbaddr2(apbmax downto 2)    := r.haddr(apbmax downto 2);
    apbi.paddr   <= apbaddr2;
    apbi.pwdata  <= pwdata;
    apbi.pwrite  <= r.hwrite;
    apbi.penable <= r.penable;
    apbi.psel    <= psel and r.hsel and r.hready2;

  end process;


  reg : process(clk)
  begin if rising_edge(clk) then r <= rin; end if; end process;


end;

