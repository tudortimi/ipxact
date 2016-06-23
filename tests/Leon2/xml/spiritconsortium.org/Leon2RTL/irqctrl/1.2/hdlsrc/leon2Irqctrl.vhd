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
use ieee.std_logic_misc.all;

use work.amba.all;
use work.iface.all;

library leon2irqctrl_lib;

entity leon2Irqctrl is
  port (
      clk : in std_logic;
      rst : in std_logic; 
      psel : in std_logic;
      penable : in std_logic;
      pwrite : in std_logic;
      pwdata : in std_logic_vector (31 downto 0);
      prdata : out std_logic_vector (31 downto 0);
      paddr  : in std_logic_vector (31 downto 0);
      irq    : in std_logic_vector (14 downto 0);
      irlin  : in std_logic_vector (3 downto 0);
      irlout : out std_logic_vector(3 downto 0);
      intack : in std_logic
  );

end; 

architecture struct of leon2Irqctrl is

   component irqctrl_rdack
      port (
        rst    : in  std_logic;
        clk    : in  clk_type;
        apbi   : in  apb_slv_in_type;
        apbo   : out apb_slv_out_type;
        irqi   : in  irq_in_type;
        irqo   : out irq_out_type
      );
    end component; 

-- synopsys translate_off
  for all: irqctrl_rdack
    use entity leon2irqctrl_lib.irqctrl_rdack(rtl);
-- synopsys translate_on

  begin

     u1 : irqctrl_rdack
       port map ( rst => rst,
                  clk => clk,
                  apbi.psel => psel,
                  apbi.penable => penable,
                  apbi.paddr => paddr,
                  apbi.pwrite => pwrite,
                  apbi.pwdata => pwdata,

                  apbo.prdata => prdata,

                  irqi.irq => irq,
                  irqi.intack => intack,
                  irqi.irl => irlin,
  
                  irqo.irl => irlout);

 
  end struct; 


