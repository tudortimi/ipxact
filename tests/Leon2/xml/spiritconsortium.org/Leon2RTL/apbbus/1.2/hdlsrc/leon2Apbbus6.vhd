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
use IEEE.std_logic_arith.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;

library leon2Apbbus_lib;

entity leon2Apbbus6 is

  generic (
    start_addr_slv0 : integer := 0;
    range_slv0 : integer := 0;
    start_addr_slv1 : integer := 0;
    range_slv1 : integer := 0;
    start_addr_slv2 : integer := 0;
    range_slv2 : integer := 0;
    start_addr_slv3 : integer := 0;
    range_slv3 : integer := 0;
    start_addr_slv4 : integer := 0;
    range_slv4 : integer := 0;
    start_addr_slv5 : integer := 0;
    range_slv5 : integer := 0;
    number_ports : integer := 6
    );

  port (
	 -- apbi_mst
	psel_mst : in Std_ULogic;                     -- slave select
	penable_mst : in Std_ULogic;                  -- strobe
	paddr_mst : in Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_mst : in Std_ULogic;                   -- write
        pwdata_mst : in Std_Logic_Vector(31 downto 0); -- write data bus
	-- apbo_mst
        prdata_mst : out Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbi_slv(0)
	psel_slv0 : out Std_ULogic;                     -- slave select
	penable_slv0 : out Std_ULogic;                  -- strobe
	paddr_slv0 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv0 : out Std_ULogic;                   -- write
        pwdata_slv0 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbi_slv(1)
	psel_slv1 : out Std_ULogic;                     -- slave select
	penable_slv1 : out Std_ULogic;                  -- strobe
	paddr_slv1 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv1 : out Std_ULogic;                   -- write
        pwdata_slv1 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbi_slv(2)
	psel_slv2 : out Std_ULogic;                     -- slave select
	penable_slv2 : out Std_ULogic;                  -- strobe
	paddr_slv2 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv2 : out Std_ULogic;                   -- write
        pwdata_slv2 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbi_slv(3)
	psel_slv3 : out Std_ULogic;                     -- slave select
	penable_slv3 : out Std_ULogic;                  -- strobe
	paddr_slv3 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv3 : out Std_ULogic;                   -- write
        pwdata_slv3 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbi_slv(4)
	psel_slv4 : out Std_ULogic;                     -- slave select
	penable_slv4 : out Std_ULogic;                  -- strobe
	paddr_slv4 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv4 : out Std_ULogic;                   -- write
        pwdata_slv4 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbi_slv(5)
	psel_slv5 : out Std_ULogic;                     -- slave select
	penable_slv5 : out Std_ULogic;                  -- strobe
	paddr_slv5 : out Std_Logic_Vector(31 downto 0); -- address bus (byte)
	pwrite_slv5 : out Std_ULogic;                   -- write
        pwdata_slv5 : out Std_Logic_Vector(31 downto 0); -- write data bus

	-- apbo_slv(0)
	prdata_slv0 : in Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbo_slv(1)
	prdata_slv1 : in Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbo_slv(2)
	prdata_slv2 : in Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbo_slv(3)
	prdata_slv3 : in Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbo_slv(4)
	prdata_slv4 : in Std_Logic_Vector(31 downto 0); -- read data bus

	-- apbo_slv(5)
	prdata_slv5 : in Std_Logic_Vector(31 downto 0) -- read data bus
	);
end;

architecture STRUCT of leon2Apbbus6 is

  component apbbus  
  generic (
    start_addr_slv0 : integer := 0;
    range_slv0 : integer := 0;
    start_addr_slv1 : integer := 0;
    range_slv1 : integer := 0;
    start_addr_slv2 : integer := 0;
    range_slv2 : integer := 0;
    start_addr_slv3 : integer := 0;
    range_slv3 : integer := 0;
    start_addr_slv4 : integer := 0;
    range_slv4 : integer := 0;
    start_addr_slv5 : integer := 0;
    range_slv5 : integer := 0;
    start_addr_slv6 : integer := 0;
    range_slv6 : integer := 0;
    start_addr_slv7 : integer := 0;
    range_slv7 : integer := 0;
    start_addr_slv8 : integer := 0;
    range_slv8 : integer := 0;
    start_addr_slv9 : integer := 0;
    range_slv9 : integer := 0;
    start_addr_slv10 : integer := 0;
    range_slv10 : integer := 0;
    start_addr_slv11 : integer := 0;
    range_slv11 : integer := 0;
    start_addr_slv12 : integer := 0;
    range_slv12 : integer := 0;
    start_addr_slv13 : integer := 0;
    range_slv13 : integer := 0;
    start_addr_slv14 : integer := 0;
    range_slv14 : integer := 0;
    start_addr_slv15 : integer := 0;
    range_slv15 : integer := 0;
    number_ports : integer := 0
    );

  port (
	 apbi_mst    : in apb_slv_in_type;
    	 apbo_mst    : out  apb_slv_out_type;
	 apbi_slv   : out apb_slv_in_vector(0 to number_ports-1);
	 apbo_slv   : in apb_slv_out_vector(0 to number_ports-1)
	);
  end component;

-- synopsys translate_off
  for all: apbbus
    use entity leon2apbbus_lib.apbbus(rtl);
-- synopsys translate_on

begin

	u1: apbbus
		generic map(
    			start_addr_slv0 => start_addr_slv0,
    			range_slv0 => range_slv0,
    			start_addr_slv1 => start_addr_slv1,
    			range_slv1 => range_slv1,
    			start_addr_slv2 => start_addr_slv2,
    			range_slv2 => range_slv2,
    			start_addr_slv3 => start_addr_slv3,
    			range_slv3 => range_slv3,
    			start_addr_slv4 => start_addr_slv4,
    			range_slv4 => range_slv4,
    			start_addr_slv5 => start_addr_slv5,
    			range_slv5 => range_slv5,
    			number_ports => number_ports
		)
		port map (
			apbi_mst.psel       => psel_mst,
			apbi_mst.penable    => penable_mst,
			apbi_mst.paddr      => paddr_mst,
			apbi_mst.pwrite     => pwrite_mst,
			apbi_mst.pwdata     => pwdata_mst,
			apbo_mst.prdata     => prdata_mst,

			apbi_slv(0).psel    => psel_slv0,
			apbi_slv(0).penable => penable_slv0,
			apbi_slv(0).paddr   => paddr_slv0,
			apbi_slv(0).pwrite  => pwrite_slv0,
			apbi_slv(0).pwdata  => pwdata_slv0,

			apbi_slv(1).psel    => psel_slv1,
			apbi_slv(1).penable => penable_slv1,
			apbi_slv(1).paddr   => paddr_slv1,
			apbi_slv(1).pwrite  => pwrite_slv1,
			apbi_slv(1).pwdata  => pwdata_slv1,

			apbi_slv(2).psel    => psel_slv2,
			apbi_slv(2).penable => penable_slv2,
			apbi_slv(2).paddr   => paddr_slv2,
			apbi_slv(2).pwrite  => pwrite_slv2,
			apbi_slv(2).pwdata  => pwdata_slv2,

			apbi_slv(3).psel    => psel_slv3,
			apbi_slv(3).penable => penable_slv3,
			apbi_slv(3).paddr   => paddr_slv3,
			apbi_slv(3).pwrite  => pwrite_slv3,
			apbi_slv(3).pwdata  => pwdata_slv3,

			apbi_slv(4).psel    => psel_slv4,
			apbi_slv(4).penable => penable_slv4,
			apbi_slv(4).paddr   => paddr_slv4,
			apbi_slv(4).pwrite  => pwrite_slv4,
			apbi_slv(4).pwdata  => pwdata_slv4,

			apbi_slv(5).psel    => psel_slv5,
			apbi_slv(5).penable => penable_slv5,
			apbi_slv(5).paddr   => paddr_slv5,
			apbi_slv(5).pwrite  => pwrite_slv5,
			apbi_slv(5).pwdata  => pwdata_slv5,

			apbo_slv(0).prdata  => prdata_slv0,
			apbo_slv(1).prdata  => prdata_slv1,
			apbo_slv(2).prdata  => prdata_slv2,
			apbo_slv(3).prdata  => prdata_slv3,
			apbo_slv(4).prdata  => prdata_slv4,
			apbo_slv(5).prdata  => prdata_slv5
		);

end;
