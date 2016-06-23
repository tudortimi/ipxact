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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.amba.all;
use work.iface.all;
use work.target.all;

library leon2timers_lib;

entity leon2Timers is
  generic (
         TPRESC  : integer
      );  
  port (
    rst    : in  std_logic;
    clk    : in  std_logic;
    --apbi   : in  apb_slv_in_type;
    psel    : in  Std_ULogic;                    -- slave select
    penable : in  Std_ULogic;                    -- strobe
    paddr   : in  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite  : in  Std_ULogic;                         -- write
    pwdata  : in  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo   : out apb_slv_out_type;
    prdata  : out Std_Logic_Vector(31 downto 0); -- read data bus
    --timo   : out timers_out_type;
    irq0     : out std_logic;
    irq1     : out std_logic;
    tick    : out std_logic;
    wdog    : out std_logic;
    --dsuo   : in  dsu_out_type
    dsuact     : in std_logic;
    ntrace     : in std_logic;
    freezetime : in std_logic;
    lresp      : in std_logic;
    dresp      : in std_logic;
    dsuen      : in std_logic;
    dsubre     : in std_logic
  );
end; 

architecture struct of leon2Timers is

    component timers
      generic (
         TPRESC  : std_logic_vector (15 downto 0)
      );
      port (
        rst    : in  std_logic;
        clk    : in  clk_type;
        apbi   : in  apb_slv_in_type;
        apbo   : out apb_slv_out_type;
        timo   : out timers_out_type;
        dsuo   : in  dsu_out_type
      );
    end component;
 
-- synopsys translate_off
   for all: timers
      use entity leon2timers_lib.timers(rtl);
-- synopsys translate_on

  signal irq : std_logic_vector(1 downto 0);

  begin

    irq0 <= irq(0);
    irq1 <= irq(1);

     u1 : timers

      generic map (
                  TPRESC =>  CONV_STD_LOGIC_VECTOR(TPRESC, 16))

       port map ( rst => rst,
                  clk => clk,
                  apbi.psel => psel,
                  apbi.penable => penable,
                  apbi.paddr => paddr,
                  apbi.pwrite => pwrite,
                  apbi.pwdata => pwdata,

                  apbo.prdata => prdata,

                  timo.irq => irq,
                  timo.tick => tick,
                  timo.wdog => wdog,

                  dsuo.dsuact    => dsuact,
                  dsuo.ntrace    => ntrace,
                  dsuo.freezetime => freezetime,
                  dsuo.lresp     => lresp,
                  dsuo.dresp     => dresp,
                  dsuo.dsuen     => dsuen,
                  dsuo.dsubre    => dsubre);
 
  end struct; 
