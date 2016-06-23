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

library IEEE;
use IEEE.std_logic_1164.all;

use work.target.all;
use work.config.all;
use work.amba.all;
use work.iface.all;

library leon2ahbbus_lib;

entity leon2Ahbbus12 is
  generic (
      start_addr_slv0 : integer := 0;           -- upper 16 bits of address
      restart_addr_slv0 : integer := 0;           -- upper 16 bits of address
      range_slv0      : integer := 0;           -- range in bytes
      split_slv0      : boolean := false;
      start_addr_slv1 : integer := 0;
      restart_addr_slv1 : integer := 0;
      range_slv1      : integer := 0;
      split_slv1      : boolean := false
  );

  port (
    rst            : in  std_logic;
    clk            : in  clk_type;
    remap          : in  std_logic;
    -- msti[0]
    hgrant_mst0    : out  Std_ULogic;                    -- bus grant
    hready_mst0    : out  Std_ULogic;                    -- transfer done
    hresp_mst0     : out  Std_Logic_Vector(1  downto 0); -- response type
    hrdata_mst0    : out  Std_Logic_Vector(31 downto 0); -- read data bus

    -- msto[0]
    hbusreq_mst0   : in   Std_ULogic;                    -- bus request
    hlock_mst0     : in   Std_ULogic;                    -- lock request
    htrans_mst0    : in   Std_Logic_Vector(1  downto 0); -- transfer type 
    haddr_mst0     : in   Std_Logic_Vector(31 downto 0); -- address bus (byte)
    hwrite_mst0    : in   Std_ULogic;                    -- read/write
    hsize_mst0     : in   Std_Logic_Vector(2  downto 0); -- transfer size
    hburst_mst0    : in   Std_Logic_Vector(2  downto 0); -- burst type
    hprot_mst0     : in   Std_Logic_Vector(3  downto 0); -- protection control
    hwdata_mst0    : in   Std_Logic_Vector(31 downto 0); -- write data bus

    -- slvi[0]
    hsel_slv0      : out   Std_ULogic;                         -- slave select
    haddr_slv0     : out   Std_Logic_Vector(31 downto 0);      -- address bus (byte)
    hwrite_slv0    : out   Std_ULogic;                         -- read/write
    htrans_slv0    : out   Std_Logic_Vector(1  downto 0);      -- transfer type
    hsize_slv0     : out   Std_Logic_Vector(2  downto 0);      -- transfer size
    hburst_slv0    : out   Std_Logic_Vector(2  downto 0);      -- burst type
    hwdata_slv0    : out   Std_Logic_Vector(31 downto 0);      -- write data bus
    hprot_slv0     : out   Std_Logic_Vector(3  downto 0);      -- protection control
    hreadyin_slv0  : out   Std_ULogic;                         -- transfer done
    hmaster_slv0   : out   Std_Logic_Vector(3  downto 0);      -- current master
    hmastlock_slv0 : out   Std_ULogic;                         -- locked access

    -- slvi[1]
    hsel_slv1      : out   Std_ULogic;                         -- slave select
    haddr_slv1     : out   Std_Logic_Vector(31 downto 0);      -- address bus (byte)
    hwrite_slv1    : out   Std_ULogic;                         -- read/write
    htrans_slv1    : out   Std_Logic_Vector(1  downto 0);      -- transfer type
    hsize_slv1     : out   Std_Logic_Vector(2  downto 0);      -- transfer size
    hburst_slv1    : out   Std_Logic_Vector(2  downto 0);      -- burst type
    hwdata_slv1    : out   Std_Logic_Vector(31 downto 0);      -- write data bus
    hprot_slv1     : out   Std_Logic_Vector(3  downto 0);      -- protection control
    hreadyin_slv1  : out   Std_ULogic;                         -- transfer done
    hmaster_slv1   : out   Std_Logic_Vector(3  downto 0);      -- current master
    hmastlock_slv1 : out   Std_ULogic;                         -- locked access

    -- slvo[0]
    hreadyout_slv0 : in    Std_ULogic;                         -- transfer done
    hresp_slv0     : in    Std_Logic_Vector(1  downto 0);      -- response type
    hrdata_slv0    : in    Std_Logic_Vector(31 downto 0);      -- read data bus
    hsplit_slv0    : in    Std_Logic_Vector(15 downto 0);      -- split completion

    -- slvo[1]
    hreadyout_slv1 : in    Std_ULogic;                         -- transfer done
    hresp_slv1     : in    Std_Logic_Vector(1  downto 0);      -- response type
    hrdata_slv1    : in    Std_Logic_Vector(31 downto 0);      -- read data bus
    hsplit_slv1    : in    Std_Logic_Vector(15 downto 0)      -- split completion
  );
end;

architecture STRUCT of leon2Ahbbus12 is

 component ahbbus
    generic (
      start_addr_slv0 : integer := 0;       -- upper 16 bits of address
      restart_addr_slv0 : integer := 0;       -- upper 16 bits of address
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
      defmast         : integer := 0; 		-- default master
      slaves          : integer := 2;		-- number of slaves
      masters         : integer := 1		-- number of masters
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
  end component;

-- synopsys translate_off
  for all: ahbbus
    use entity leon2ahbbus_lib.ahbbus(rtl);
-- synopsys translate_on

begin

	u1: ahbbus
	    generic map (
    		start_addr_slv0 => start_addr_slv0,
    		restart_addr_slv0 => restart_addr_slv0,
    		range_slv0      => range_slv0,
    		split_slv0      => split_slv0,
    		start_addr_slv1 => start_addr_slv1,
    		restart_addr_slv1 => restart_addr_slv1,
    		range_slv1      => range_slv1,
    		split_slv1      => split_slv1,
    		defmast	        => 0,
		masters         => 1	
	    )
	    port map (
		rst            => rst,
		clk            => clk,
		remap          => remap,

		msti(0).hgrant => hgrant_mst0,
		msti(0).hready => hready_mst0,
		msti(0).hresp  => hresp_mst0,
		msti(0).hrdata => hrdata_mst0,

		msto(0).hbusreq => hbusreq_mst0,
		msto(0).hlock  => hlock_mst0,
		msto(0).htrans => htrans_mst0,
		msto(0).haddr  => haddr_mst0,
		msto(0).hwrite => hwrite_mst0,
		msto(0).hsize  => hsize_mst0,
		msto(0).hburst => hburst_mst0,
		msto(0).hprot  => hprot_mst0,
		msto(0).hwdata => hwdata_mst0,

		slvi(0).hsel   => hsel_slv0,
		slvi(0).haddr  => haddr_slv0,
		slvi(0).hwrite => hwrite_slv0,
		slvi(0).htrans => htrans_slv0,
		slvi(0).hsize  => hsize_slv0,
		slvi(0).hburst => hburst_slv0,
		slvi(0).hwdata => hwdata_slv0,
		slvi(0).hprot  => hprot_slv0,
		slvi(0).hready => hreadyin_slv0,
		slvi(0).hmaster => hmaster_slv0,
		slvi(0).hmastlock => hmastlock_slv0,	

		slvi(1).hsel   => hsel_slv1,
		slvi(1).haddr  => haddr_slv1,
		slvi(1).hwrite => hwrite_slv1,
		slvi(1).htrans => htrans_slv1,
		slvi(1).hsize  => hsize_slv1,
		slvi(1).hburst => hburst_slv1,
		slvi(1).hwdata => hwdata_slv1,
		slvi(1).hprot  => hprot_slv1,
		slvi(1).hready => hreadyin_slv1,
		slvi(1).hmaster => hmaster_slv1,
		slvi(1).hmastlock => hmastlock_slv1,

		slvo(0).hready => hreadyout_slv0,
		slvo(0).hresp  => hresp_slv0,
		slvo(0).hrdata => hrdata_slv0,
		slvo(0).hsplit => hsplit_slv0,	

		slvo(1).hready => hreadyout_slv1,
		slvo(1).hresp  => hresp_slv1,
		slvo(1).hrdata => hrdata_slv1,
		slvo(1).hsplit => hsplit_slv1	
		);
end;

