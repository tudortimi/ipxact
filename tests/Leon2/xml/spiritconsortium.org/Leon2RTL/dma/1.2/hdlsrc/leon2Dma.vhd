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

library leon2dma_lib;


entity leon2Dma is
   port (
      rst       : in   std_logic;
      clk       : in   std_logic;
      dirq      : out  std_logic;
      -- apbi   : in   apb_slv_in_type;
      psel      : in   Std_Logic;                     -- slave select
      penable   : in   Std_Logic;                     -- strobe
      paddr     : in   Std_Logic_Vector(31 downto 0); -- address bus (byte)
      pwrite    : in   Std_Logic;                     -- write
      pwdata    : in   Std_Logic_Vector(31 downto 0); -- write data bus
      -- apbo   : out apb_slv_out_type;
      prdata    : out  std_logic_vector(31 downto 0);
      -- ahbi   : in  ahb_mst_in_type;
      hgrant    : in  Std_ULogic;                    -- bus grant
      hready    : in  Std_ULogic;                    -- transfer done
      hresp     : in  Std_Logic_Vector(1  downto 0); -- response type
      hrdata    : in  Std_Logic_Vector(31 downto 0); -- read data bus
      --ahbo : out ahb_mst_out_type 
      hbusreq   : out   Std_ULogic;                    -- bus request
      hlock     : out   Std_ULogic;                    -- lock request
      htrans    : out   Std_Logic_Vector(1  downto 0); -- transfer type 
      haddr     : out   Std_Logic_Vector(31 downto 0); -- address bus (byte)
      hwrite    : out   Std_ULogic;                    -- read/write
      hsize     : out   Std_Logic_Vector(2  downto 0); -- transfer size
      hburst    : out   Std_Logic_Vector(2  downto 0); -- burst type
      hprot     : out   Std_Logic_Vector(3  downto 0); -- protection control
      hwdata    : out   Std_Logic_Vector(31 downto 0) -- write data bus
    );
end leon2Dma;      

architecture struct of leon2Dma is

-- synopsys translate_off
   for all: dma
       use entity leon2dma_lib.dma(struct);
-- synopsys translate_on
--

   component dma
      port (
        rst  : in  std_logic;
        clk  : in  clk_type;
        dirq : out std_logic;
        apbi : in  apb_slv_in_type;
        apbo : out apb_slv_out_type;
        ahbi : in  ahb_mst_in_type;
        ahbo : out ahb_mst_out_type );
   end component;  

  begin

          u1 : dma 
              port map (
                  rst => rst,
                  clk => clk,

                  dirq => dirq,

                  ahbo.hbusreq => hbusreq,
                  ahbo.hlock => hlock,
                  ahbo.haddr => haddr,
                  ahbo.hwrite => hwrite,
                  ahbo.htrans => htrans,
                  ahbo.hsize => hsize,
                  ahbo.hburst => hburst,
                  ahbo.hwdata => hwdata,
                  ahbo.hprot => hprot,

                  ahbi.hresp  =>  hresp,
                  ahbi.hrdata =>  hrdata,
                  ahbi.hgrant =>  hgrant,
                  ahbi.hready =>  hready,

                  apbi.psel => psel,
                  apbi.penable => penable,
                  apbi.paddr => paddr,
                  apbi.pwrite => pwrite,
                  apbi.pwdata => pwdata,

                  apbo.prdata => prdata );

  end struct;
