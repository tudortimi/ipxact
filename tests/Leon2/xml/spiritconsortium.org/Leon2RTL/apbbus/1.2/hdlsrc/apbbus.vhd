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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;

entity apbbus is
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
end;

architecture rtl of apbbus is

    constant APB_TABLE_LOCAL : apb_slave_config_vector(0 to APB_SLV_MAX-1) := (
	(start_addr_slv0, range_slv0, 0),
	(start_addr_slv1, range_slv1, 1),
	(start_addr_slv2, range_slv2, 2),
	(start_addr_slv3, range_slv3, 3),
	(start_addr_slv4, range_slv4, 4),
	(start_addr_slv5, range_slv5, 5),
	(start_addr_slv6, range_slv6, 6),
	(start_addr_slv7, range_slv7, 7),
	(start_addr_slv8, range_slv8, 8),
	(start_addr_slv9, range_slv9, 9),
	(start_addr_slv10, range_slv10, 10),
	(start_addr_slv11, range_slv11, 11),
	(start_addr_slv12, range_slv12, 12),
	(start_addr_slv13, range_slv13, 13),
	(start_addr_slv14, range_slv14, 14),
	(start_addr_slv15, range_slv15, 15),
        others => apb_slave_config_void);
    
   begin
    -- apbo_mst.prdata <= (others => '-');
    
    comb: process (apbo_slv, apbi_mst)
      
    begin  
    	for i in 0 to number_ports-1 loop
      		if  APB_TABLE_LOCAL(i).addrrange > 0 and
	 	(conv_integer(unsigned(apbi_mst.paddr(APB_SLV_ADDR_BITS-1 downto 0))) >= (APB_TABLE_LOCAL(i).startaddr)) and
         	(conv_integer(unsigned(apbi_mst.paddr(APB_SLV_ADDR_BITS-1 downto 0))) <= (APB_TABLE_LOCAL(i).startaddr+APB_TABLE_LOCAL(i).addrrange-1)) 
      		then 
			apbo_mst.prdata <= apbo_slv(APB_TABLE_LOCAL(i).index).prdata; 
			apbi_slv(APB_TABLE_LOCAL(i).index).psel <= apbi_mst.psel;
     		else
        		apbi_slv(APB_TABLE_LOCAL(i).index).psel <= '0';
      		end if;
      		apbi_slv(APB_TABLE_LOCAL(i).index).penable <= apbi_mst.penable;
      		apbi_slv(APB_TABLE_LOCAL(i).index).paddr <= apbi_mst.paddr;
      		apbi_slv(APB_TABLE_LOCAL(i).index).pwrite <= apbi_mst.pwrite;
      		apbi_slv(APB_TABLE_LOCAL(i).index).pwdata <= apbi_mst.pwdata;
    	end loop;
   end process;
end;
