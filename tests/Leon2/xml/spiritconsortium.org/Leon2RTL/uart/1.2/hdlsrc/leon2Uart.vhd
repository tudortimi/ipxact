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

use work.amba.all;
use work.iface.all;

library leon2uart_lib;

entity leon2Uart is
  generic (
         EXTBAUD  : boolean
      );
  port (
    rst    : in  std_logic;
    clk    : in  clk_type;
    --apbi   : in  apb_slv_in_type;
    psel    : in  Std_ULogic;                         -- slave select
    penable : in  Std_ULogic;                         -- strobe
    paddr   : in  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite  : in  Std_ULogic;                         -- write
    pwdata  : in  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo   : out apb_slv_out_type;
    prdata  : out Std_Logic_Vector(31 downto 0); -- read data bus
    -- uarti  : in  uart_in_type;
    rxd     : in std_logic;
    ctsn    : in std_logic;
    scaler  : in std_logic_vector(7 downto 0);
    -- uarto  : out uart_out_type
    rxen    : out std_logic;
    txen    : out std_logic;
    flow    : out std_logic;
    irq     : out std_logic;
    rtsn    : out std_logic;
    txd     : out std_logic  );
end leon2Uart; 

architecture struct of leon2Uart is

   component uart
     generic (
         EXTBAUD  : boolean
      );
     port (
       rst    : in  std_logic;
       clk    : in  clk_type;
       apbi   : in  apb_slv_in_type;
       apbo   : out apb_slv_out_type;
       uarti  : in  uart_in_type;
       uarto  : out uart_out_type
     );
    end component;
  
-- synopsys translate_off
  for all: uart
    use entity leon2uart_lib.uart(rtl);
-- synopsys translate_on

  begin

    u1 : uart

       generic map (
                     EXTBAUD => EXTBAUD)
       port map ( rst => rst,
                  clk => clk,
                  apbi.psel => psel,
                  apbi.penable => penable,
                  apbi.paddr => paddr,
                  apbi.pwrite => pwrite,
                  apbi.pwdata => pwdata,

                  apbo.prdata => prdata,

                  uarti.rxd    => rxd,
                  uarti.ctsn   => ctsn,
                  uarti.scaler => scaler,

                  uarto.rxen => rxen,
                  uarto.txen => txen,
                  uarto.flow => flow,
                  uarto.irq  => irq,
                  uarto.rtsn => rtsn,
                  uarto.txd  => txd );
  end struct;
