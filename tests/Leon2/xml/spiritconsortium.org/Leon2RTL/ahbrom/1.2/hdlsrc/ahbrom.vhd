-- Description : ahbrom.vhd
-- Author : SPIRIT Schema Working Group 
-- Version: 1.2
--
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
--  ahbram.vhd is a part of the LEON VHDL model
--  Copyright (C) 2003 Gaisler Research
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.

-----------------------------------------------------------------------------
-- Entity: 	ahbrom
-- File:	ahbrom.vhd
-- Description:	AHB rom. 0-waitstate read, 0/1-waitstate write. 
-- modified from ahbram.vhd from Leon2
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.conv_integer;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;
use work.tech_map.all;

entity ahbrom is
  generic ( abits : integer := 10);
  port (
    rst    : in  std_logic;
    clk    : in  clk_type;
    ahbsi  : in  ahb_slv_in_type;
    ahbso  : out ahb_slv_out_type
  );
end;

architecture rtl of ahbrom is
type reg_type is record
  hwrite : std_logic;
  hread  : std_logic;
  hready : std_logic;
  hsel   : std_logic;
  addr   : std_logic_vector(abits+1 downto 0);
  size   : std_logic_vector(1 downto 0);
  hresp  : std_logic_vector(1 downto 0);
end record;
signal r, c : reg_type;
signal romsel : std_logic;
signal write : std_logic_vector(3 downto 0);
signal romaddr  : std_logic_vector(abits-1 downto 0);
begin

  comb : process (ahbsi, r, rst)
  variable bs : std_logic_vector(3 downto 0);
  variable v : reg_type;
  variable haddr  : std_logic_vector(abits-1 downto 0);
  variable highaddr  : std_logic_vector(31 downto abits+2);
  begin
    v := r; 
    v.hready := '1'; 
    bs := (others => '0');
    highaddr := (others => '0');
    v.hresp := r.hresp;
    v.hwrite := r.hwrite; 
    v.hread := r.hread; 

    if (r.hwrite or not r.hready) = '1' then 
      haddr := r.addr(abits+1 downto 2);
    else
      haddr := ahbsi.haddr(abits+1 downto 2); 
      bs := (others => '0'); 
    end if;

    if ahbsi.hready = '1' then 
      v.hsel := ahbsi.hsel and ahbsi.htrans(1);
      v.hwrite := ahbsi.hwrite and v.hsel;
      v.hread := not(ahbsi.hwrite) and v.hsel;
      if v.hread = '1' then 
	v.hready := '1'; 
	v.hresp := "00";
      end if;
      if v.hwrite = '1' then 
	v.hready := '0'; 
	v.hresp := "01";
      end if;
      v.addr := ahbsi.haddr(abits+1 downto 0); 
      v.size := ahbsi.hsize(1 downto 0);
    end if;
    
    if r.hwrite = '1' then
      case r.size(1 downto 0) is
      when "00" => bs (conv_integer(r.addr(1 downto 0))) := '1';
      when "01" => bs := r.addr(1) & r.addr(1) & not (r.addr(1) & r.addr(1));
      when others => bs := (others => '1');
      end case;
	v.hready := '1';
      v.hwrite := v.hwrite and v.hready;
    end if;

    if r.hread = '1' then
      v.hready := '1';
      v.hread := '0';
      v.hresp := "00";
    end if;

    if rst = '0' then 
      v.hresp := "00"; 
      v.hwrite := '0'; 
      v.hread := '0'; 
    end if;

    write <= bs; 
    romsel <= v.hsel or r.hwrite; 
    ahbso.hready <= r.hready; 
    ahbso.hresp <= r.hresp;
    ahbso.hrdata <= highaddr & r.addr;  -- ROM data is simply the address.
    romaddr <= haddr; 
    c <= v;
  end process;

  ahbso.hsplit <= (others => '0');  -- No split support

  reg : process (clk)
  begin
    if rising_edge(clk ) then 
      r <= c; 
    end if;
  end process;
end;
