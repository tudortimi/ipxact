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

use work.amba.all;
use work.iface.all;

library leon2ahbstat_lib;

entity leon2Ahbstat is
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;

    --ahbmi  : in  ahb_mst_in_type;
    hresp     : in  Std_Logic_Vector(1 downto 0); -- response type
    --ahbsi  : in  ahb_slv_in_type;

    hwrite    : in  Std_ULogic;                         -- read/write
    hsize     : in  Std_Logic_Vector(2 downto 0); -- transfer size
    haddr     : in  Std_Logic_Vector(31 downto 0); -- write data bus
    hready    : in  Std_ULogic;                         -- transfer done
    hmaster   : in  Std_Logic_Vector(3 downto 0); -- current master

    --apbi   : in  apb_slv_in_type;
    psel      : in  Std_ULogic;                         -- slave select
    penable   : in  Std_ULogic;                         -- strobe
    paddr     : in  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite    : in  Std_ULogic;                         -- write
    pwdata    : in  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo   : out apb_slv_out_type;

    prdata    : out Std_Logic_Vector(31 downto 0); -- read data bus
    --ahbsto : out ahbstat_out_type

    ahberr    : out std_logic -- output flag for an error

  );
end leon2Ahbstat; 

architecture struct of leon2Ahbstat is

    component ahbstat 
      port (
        rst    : in  std_logic;
        clk    : in  std_logic;
        ahbmi  : in  ahb_mst_in_type;
        ahbsi  : in  ahb_slv_in_type;
        apbi   : in  apb_slv_in_type;
        apbo   : out apb_slv_out_type;
        ahbsto : out ahbstat_out_type
      );
    end component;

-- synopsys translate_off
  for all: ahbstat
    use entity leon2ahbstat_lib.ahbstat(rtl);
-- synopsys translate_on

   signal logic_zero  : std_logic_vector(31 downto 0);

begin
  
   logic_zero <= ( others => '0');


    u1 : ahbstat
      port map ( rst => rst,
                 clk => clk,

                 -- Any ports tied to 0 are not used in the monitor

                 ahbmi.hgrant => logic_zero(0),
                 ahbmi.hready => logic_zero(0),
                 ahbmi.hresp  => hresp,
                 ahbmi.hrdata => logic_zero,

                 ahbsi.hsel => logic_zero(0),
                 ahbsi.haddr => haddr,
                 ahbsi.hwrite => hwrite,
                 ahbsi.htrans => logic_zero(1 downto 0),
                 ahbsi.hsize  => hsize,
            
                 ahbsi.hburst  => logic_zero(2 downto 0),
                 ahbsi.hwdata  => logic_zero,
                 ahbsi.hprot   => logic_zero(3 downto 0),
                 ahbsi.hready => hready,
                 ahbsi.hmaster => hmaster,
                 ahbsi.hmastlock => logic_zero(0),

                 apbi.psel => psel,
                 apbi.penable => penable,
                 apbi.paddr => paddr,
                 apbi.pwrite => pwrite,
                 apbi.pwdata => pwdata,

                 apbo.prdata => prdata,

                 ahbsto.ahberr => ahberr
     );

  end struct;


