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
-- Entity:      ahbbus
-- File:        ahbbus.vhd
-- Author:      Jiri Gaisler - Gaisler Research
-- Description: AMBA AHB arbiter and decoder
------------------------------------------------------------------------------ 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;



entity ahbbus is
  generic (
    start_addr_slv0 : integer := 0;       -- upper 16 bits of address
    restart_addr_slv0 : integer := 0;     -- upper 16 bits of address when 'remap' is high
    range_slv0      : integer := 0;       -- range in bytes
    split_slv0      : boolean := false;   -- enable split
    mst_access_slv0 : integer := 16#FFFF#; -- bit mask for master access to this slave
    start_addr_slv1 : integer := 0;
    restart_addr_slv1 : integer := 0;
    range_slv1      : integer := 0;
    split_slv1      : boolean := false;
    mst_access_slv1 : integer := 16#FFFF#;
    start_addr_slv2 : integer := 0;
    restart_addr_slv2 : integer := 0;
    range_slv2      : integer := 0;
    split_slv2      : boolean := false;
    mst_access_slv2 : integer := 16#FFFF#;
    start_addr_slv3 : integer := 0;
    restart_addr_slv3 : integer := 0;
    range_slv3      : integer := 0;
    split_slv3      : boolean := false;
    mst_access_slv3 : integer := 16#FFFF#;
    start_addr_slv4 : integer := 0;
    restart_addr_slv4 : integer := 0;
    range_slv4      : integer := 0;
    split_slv4      : boolean := false;
    mst_access_slv4 : integer := 16#FFFF#;
    start_addr_slv5 : integer := 0;
    restart_addr_slv5 : integer := 0;
    range_slv5      : integer := 0;
    split_slv5      : boolean := false;
    mst_access_slv5 : integer := 16#FFFF#;
    start_addr_slv6 : integer := 0;
    restart_addr_slv6 : integer := 0;
    range_slv6      : integer := 0;
    split_slv6      : boolean := false;
    mst_access_slv6 : integer := 16#FFFF#;
    defmast         : integer := 1; 		-- default master
    slaves          : integer := 2;		-- number of slaves
    masters         : integer := 2		-- number of masters
  );
  port (
    rst     : in  std_logic;
    clk     : in  clk_type;
    remap   : in  std_logic;
    msti    : out ahb_mst_in_vector(0 to masters-1);
    msto    : in  ahb_mst_out_vector(0 to masters-1);
    slvi    : out ahb_slv_in_vector(0 to slaves-1);
    slvo    : in  ahb_slv_out_vector(0 to slaves-1)
  );
end;

architecture rtl of ahbbus is

constant AHB_SLVTABLE_LOCAL: ahb_slave_config_vector(0 to AHB_SLV_MAX-1) := (
  (start_addr_slv0, range_slv0, 0, split_slv0, mst_access_slv0),
  (start_addr_slv1, range_slv1, 1, split_slv1, mst_access_slv1),
  (start_addr_slv2, range_slv2, 2, split_slv2, mst_access_slv2),
  (start_addr_slv3, range_slv3, 3, split_slv3, mst_access_slv3),
  (start_addr_slv4, range_slv4, 4, split_slv4, mst_access_slv4),
  (start_addr_slv5, range_slv5, 5, split_slv5, mst_access_slv5),
  (start_addr_slv6, range_slv6, 6, split_slv6, mst_access_slv6),
  others => ahb_slave_config_void);

constant REMAP_AHB_SLVTABLE_LOCAL: ahb_slave_config_vector(0 to AHB_SLV_MAX-1) := (
  (restart_addr_slv0, range_slv0, 0, split_slv0, mst_access_slv0),
  (restart_addr_slv1, range_slv1, 1, split_slv1, mst_access_slv1),
  (restart_addr_slv2, range_slv2, 2, split_slv2, mst_access_slv2),
  (restart_addr_slv3, range_slv3, 3, split_slv3, mst_access_slv3),
  (restart_addr_slv4, range_slv4, 4, split_slv4, mst_access_slv4),
  (restart_addr_slv5, range_slv5, 5, split_slv5, mst_access_slv5),
  (restart_addr_slv6, range_slv6, 6, split_slv6, mst_access_slv6),
  others => ahb_slave_config_void);

constant MIMAX : integer := log2x(masters) - 1;
constant SIMAX : integer := log2(slaves+1) - 1;
type reg_type is record
  hmaster   : std_logic_vector(MIMAX downto 0);
  hmasterd  : std_logic_vector(MIMAX downto 0);
  hslave    : std_logic_vector(SIMAX downto 0);
  hready    : std_logic;	-- needed for two-cycle error response
  hlock     : std_logic;
  hmasterlock : std_logic;
  htrans  : std_logic_vector(1 downto 0);    -- transfer type 
end record;

-- Number of upper AHB bits to decode
constant AHB_ADDR_DECODE_BITS : integer := 16;

type nmstarr is array ( 1 to 5) of integer range 0 to masters-1;
type nvalarr is array ( 1 to 5) of boolean;

signal r, rin : reg_type;
signal rsplit, rsplitin : std_logic_vector(masters-1 downto 0);

begin

  comb : process(rst, msto, slvo, r, rsplit, remap)
  variable rv : reg_type;
  variable rhmaster, rhmasterd : integer range 0 to masters -1;
  variable rhslave : integer range 0 to slaves;
  variable nhmaster, hmaster : integer range 0 to masters -1;
  variable haddr   : std_logic_vector(31 downto 0);   -- address bus
  variable hrdata  : std_logic_vector(31 downto 0);   -- read data bus
  variable htrans  : std_logic_vector(1 downto 0);    -- transfer type 
  variable hresp   : std_logic_vector(1 downto 0);    -- respons type 
  variable hwrite  : std_logic;  		     -- read/write
  variable hsize   : std_logic_vector(2 downto 0);    -- transfer size
  variable hprot   : std_logic_vector(3 downto 0);    -- protection info
  variable hburst  : std_logic_vector(2 downto 0);    -- burst type
  variable hwdata  : std_logic_vector(31 downto 0);   -- write data
  variable hgrant  : std_logic_vector(0 to masters-1);   -- bus grant
  variable hsel    : std_logic_vector(0 to slaves);   -- slave select
  variable hready  : std_logic;  		     -- ready
  variable hmastlock  : std_logic;  		
  variable nslave : natural range 0 to slaves;
  variable ahbaddr : std_logic_vector(AHB_ADDR_DECODE_BITS-1 downto 0);
  variable vsplit  : std_logic_vector(masters-1 downto 0);
  variable nmst    : nmstarr;
  variable nvalid  : nvalarr;
  variable htmp    : std_logic_vector(3 downto 0); 
  variable table_address  : std_logic_vector(31 downto 0);   -- used for compare of addresses
  variable mst_slv_access : std_logic_vector(15 downto 0);   -- used for master to slave access checks
  begin

    rv := r; rv.hready := '0';

    -- bus multiplexers

-- pragma translate_off
    if not is_x(r.hmaster) then
-- pragma translate_on
      rhmaster  := conv_integer(unsigned(r.hmaster));
-- pragma translate_off
    end if;
    if not is_x(r.hmasterd) then
-- pragma translate_on
      rhmasterd := conv_integer(unsigned(r.hmasterd));
-- pragma translate_off
    end if;
    if not is_x(r.hslave) then
-- pragma translate_on
      rhslave   := conv_integer(unsigned(r.hslave));
-- pragma translate_off
    end if;
-- pragma translate_on
    haddr     := msto(rhmaster).haddr;
    htrans    := msto(rhmaster).htrans;
    hwrite    := msto(rhmaster).hwrite;
    hsize     := msto(rhmaster).hsize;
    hprot     := msto(rhmaster).hprot;
    hburst    := msto(rhmaster).hburst;
    hmastlock := msto(rhmaster).hlock;
    hwdata    := msto(rhmasterd).hwdata;
    if rhslave /= slaves then
      hready := slvo(rhslave).hready;
      hrdata := slvo(rhslave).hrdata;
      hresp  := slvo(rhslave).hresp ;
    else
      -- default slave
      hrdata := (others => '-');
      if (r.htrans = HTRANS_IDLE) or (r.htrans = HTRANS_BUSY) then
        hresp := HRESP_OKAY; hready := '1';
      else
	-- return two-cycle error in case of unimplemented slave access
        hresp := HRESP_ERROR; hready := r.hready; rv.hready := not r.hready;
      end if;
    end if;


-- Find next master:
--   * priority is fixed, highest index has highest priority
--   * splitted masters are not granted
--   * burst transfers cannot be interrupted
--   * low-priority masters will be granted if they drive SEQ or NONSEQ
--     on HTRANS, and high-priority masters only drive IDLE

    nvalid(1 to 4) := (others => false); nvalid(5) := true;
    nmst(1 to 4) := (others => 0); nmst(5) := defmast; nhmaster := rhmaster; 

    if (r.hmasterlock = '0') and (
       (msto(rhmaster).htrans = HTRANS_IDLE) or
       ( (msto(rhmaster).htrans = HTRANS_NONSEQ) and
         (msto(rhmaster).hburst = HBURST_SINGLE) ) ) then
      for i in 0 to (masters -1) loop
	if ((rsplit(i) = '0') or not AHB_SPLIT) then
          if (msto(i).hbusreq = '1') and (msto(i).htrans(1) = '1') then
	    nmst(2) := i; nvalid(2) := true;
	  end if;
          if (msto(i).hbusreq = '1') then
	    nmst(3) := i; nvalid(3) := true;
	  end if;
	  if not ((nmst(4) = defmast) and nvalid(4)) then 
	    nmst(4) := i; nvalid(4) := true; 
	  end if;
	end if;
      end loop;
      for i in 1 to 5 loop
        if nvalid(i) then nhmaster := nmst(i); exit; end if;
      end loop;
    end if;

    rv.hlock := msto(nhmaster).hlock;

    hgrant := (others => '0'); hgrant(nhmaster) := '1';

    -- select slave
    nslave := slaves;
--    for i in AHB_SLVTABLE_LOCAL'range loop	--'
    for i in 0 to slaves-1 loop	--'
      if (remap = '1') then
	table_address := conv_std_logic_vector(REMAP_AHB_SLVTABLE_LOCAL(i).startaddr,16) & "0000000000000000" ;
      else
	table_address := conv_std_logic_vector(AHB_SLVTABLE_LOCAL(i).startaddr,16) & "0000000000000000" ;
      end if;
      mst_slv_access := conv_std_logic_vector(AHB_SLVTABLE_LOCAL(i).mstaccess,16);
      if AHB_SLVTABLE_LOCAL(i).addrrange /= 0 and mst_slv_access(rhmaster) = '1' and
	 (unsigned(haddr) >= unsigned(table_address)) and
         (unsigned(haddr) < unsigned(table_address) + AHB_SLVTABLE_LOCAL(i).addrrange) 
      then nslave :=  AHB_SLVTABLE_LOCAL(i).index; end if;
    end loop;

    if htrans = HTRANS_IDLE then nslave := slaves; end if;

    hsel := (others => '0'); hsel(nslave) := '1'; 

    -- latch active master and slave
    if hready = '1' then 
      rv.hmaster := (conv_std_logic_vector(nhmaster, MIMAX + 1));
      rv.hmasterd := r.hmaster; 
      rv.hslave := (conv_std_logic_vector(nslave, SIMAX + 1));
      rv.htrans := htrans; 
      rv.hmasterlock := r.hlock;
    end if;

-- latch HLOCK

    -- split support
    
    vsplit := (others => '0');
    if AHB_SPLIT then
      vsplit := rsplit;
      if hresp = HRESP_SPLIT then vsplit(rhmasterd) := '1'; end if;
      for i in AHB_SLVTABLE_LOCAL'range loop --'
	if AHB_SLVTABLE_LOCAL(i).split then
	  vsplit := vsplit and not slvo(AHB_SLVTABLE_LOCAL(i).index).hsplit(masters-1 downto 0);
	end if;
      end loop;
    end if;

    -- reset operation
    if (rst = '0') then
      rv.hmaster := (others => '0'); rv.hmasterlock := '0'; 
      rv.hslave := std_logic_vector(conv_unsigned(slaves, SIMAX+1));
      hsel := (others => '0'); rv.htrans := HTRANS_IDLE;
      hready := '1'; vsplit := (others => '0');
    end if;
    
    -- drive master inputs
    for i in 0 to (masters -1) loop
      msti(i).hgrant  <= hgrant(i);
      msti(i).hready  <= hready;
      msti(i).hrdata  <= hrdata;
      msti(i).hresp   <= hresp;
    end loop;

    -- drive slave inputs
    for i in 0 to (slaves -1) loop
      slvi(i).haddr   <= haddr;
      slvi(i).htrans  <= htrans;
      slvi(i).hwrite  <= hwrite;
      slvi(i).hsize   <= hsize;
      slvi(i).hburst  <= hburst;
      slvi(i).hready  <= hready;
      slvi(i).hwdata  <= hwdata;
      slvi(i).hprot   <= hprot;
      slvi(i).hsel    <= hsel(i);
      htmp := "0000"; htmp(MIMAX downto 0) := r.hmaster;
      slvi(i).hmaster <= htmp;
      slvi(i).hmastlock <= r.hmasterlock;
    end loop;

    -- assign register inputs
    
    rin <= rv;
    rsplitin <= vsplit;

  end process;


  reg0 : process(clk)
  begin if rising_edge(clk) then r <= rin; end if; end process;

  splitreg : if AHB_SPLIT generate
    reg1 : process(clk)
    begin if rising_edge(clk) then rsplit <= rsplitin; end if; end process;
  end generate;


end;

