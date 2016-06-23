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

use work.iface.all;
use work.amba.all;

library leon2apbmst_lib;

entity leon2Apbmst2 is
  generic (
    start_addr_mst0 : integer := 0;       -- upper bits of address (apbAddrMax to apbAddrMin)
    range_mst0      : integer := 0;       -- range in bytes
    start_addr_mst1 : integer := 0;
    range_mst1      : integer := 0;
    apbAddrMax      : integer := 31; 		-- upper address bit used for address range compares
    apbAddrMin      : integer := 13;		-- lower address bit used for address range compares
    masterPorts     : integer := 2		-- number of master ports
  );

  port (
    rst     : in  std_logic;
    clk     : in  std_logic;
    --ahbi    : in  ahb_slv_in_type;
     hsel     : in  Std_ULogic;                         -- slave select
     haddr    : in Std_Logic_Vector(HAMAX-1 downto 0); -- address bus (byte)
     hwrite   : in Std_ULogic;                         -- read/write
     htrans   : in Std_Logic_Vector(1       downto 0); -- transfer type
     hsize    : in Std_Logic_Vector(2       downto 0); -- transfer size
     hburst   : in Std_Logic_Vector(2       downto 0); -- burst type
     hwdata   : in Std_Logic_Vector(31 downto 0); -- write data bus
     hprot    : in Std_Logic_Vector(3       downto 0); -- protection control
     hreadyin : in Std_ULogic;                         -- transfer done
    -- ahbo    : out ahb_slv_out_type;
     hreadyout: out Std_ULogic;                         -- transfer done
     hresp    : out Std_Logic_Vector(1       downto 0); -- response type
     hrdata   : out Std_Logic_Vector(31 downto 0); -- read data bus

    -- apbi0    : out apb_slv_in_vector;
    psel0      : out  Std_ULogic;                         -- slave select
    penable0   : out  Std_ULogic;                         -- strobe
    paddr0     : out  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite0    : out  Std_ULogic;                         -- write
    pwdata0    : out  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo0    : in  apb_slv_out_vector;
    prdata0    : in  Std_Logic_Vector(31 downto 0); -- read data bus

    -- apbi1    : out apb_slv_in_vector;
    psel1      : out  Std_ULogic;                         -- slave select
    penable1   : out  Std_ULogic;                         -- strobe
    paddr1     : out  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite1    : out  Std_ULogic;                         -- write
    pwdata1    : out  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo1    : in  apb_slv_out_vector;
    prdata1    : in  Std_Logic_Vector(31 downto 0) -- read data bus
  );
end leon2Apbmst2;

architecture struct of leon2Apbmst2 is

   component apbmst2
      generic (
	start_addr_mst0 : integer := 0;       -- upper bits of address (apbAddrMax to apbAddrMin)
	range_mst0      : integer := 0;       -- range in bytes
	start_addr_mst1 : integer := 0;
	range_mst1      : integer := 0;
	apbAddrMax      : integer := 31; 		-- upper address bit used for address range compares
	apbAddrMin      : integer := 13;		-- lower address bit used for address range compares
	masterPorts     : integer := 2		-- number of master ports
      );

     port (
       rst     : in  std_logic;
       clk     : in  clk_type;
       ahbi    : in  ahb_slv_in_type;
       ahbo    : out ahb_slv_out_type;
       apbi    : out apb_slv_in_vector (0 to masterPorts-1);
       apbo    : in  apb_slv_out_vector (0 to masterPorts-1)
     );
   end component;
   
-- synopsys translate_off
  for all: apbmst2
    use entity leon2apbmst_lib.apbmst2(rtl);
-- synopsys translate_on

   signal null_hsplit : std_logic_vector (15 downto 0);
   signal pulldown  : std_logic_vector (3 downto 0) := "0000";
 
   begin

      u1 : apbmst2
          generic map ( start_addr_mst0 => start_addr_mst0,
	                range_mst0 => range_mst0,
			start_addr_mst1 => start_addr_mst1,
			range_mst1 => range_mst1,
			apbAddrMax => apbAddrMax,
			apbAddrMin => apbAddrMin,
			masterPorts => masterPorts)

          port map ( rst => rst,
                     clk => clk,

                     ahbi.hsel => hsel,
                     ahbi.haddr => haddr,
                     ahbi.hwrite => hwrite,
                     ahbi.htrans => htrans,
                     ahbi.hsize => hsize,
                     ahbi.hburst => hburst,
                     ahbi.hwdata => hwdata,
                     ahbi.hprot => hprot,
                     ahbi.hready => hreadyin,
                     ahbi.hmaster => pulldown,
                     ahbi.hmastlock => pulldown(0),

                     ahbo.hready =>  hreadyout,
                     ahbo.hresp  =>  hresp,
                     ahbo.hrdata =>  hrdata,
                     ahbo.hsplit =>  null_hsplit,

                     apbi(0).psel => psel0,
                     apbi(0).penable => penable0,
                     apbi(0).paddr => paddr0,
                     apbi(0).pwrite => pwrite0,
                     apbi(0).pwdata => pwdata0,


                     apbi(1).psel => psel1,
                     apbi(1).penable => penable1,
                     apbi(1).paddr => paddr1,
                     apbi(1).pwrite => pwrite1,
                     apbi(1).pwdata => pwdata1,

                     apbo(0).prdata => prdata0,
                     apbo(1).prdata => prdata1
          );
   end struct;
