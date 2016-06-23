-- ****************************************************************************
-- ** Description: leon2AhbLiteram.vhd
-- ** Author:      The SPIRIT Consortium
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.amba.all;
use work.iface.all;

library leon2ahbram_lib;

entity leon2AhbLiteram is
    generic ( abits : integer := 10);
    port (
        rst         : in  std_logic;
        clk         : in  std_logic;
        hsel_s      : in  std_ulogic;                         -- slave select
        haddr_s     : in  std_logic_vector(31 downto 0);      -- address bus (byte)
        hwrite_s    : in  std_ulogic;                         -- read/write
        htrans_s    : in  std_logic_vector(1 downto 0);       -- transfer type
        hsize_s     : in  std_logic_vector(2 downto 0);       -- transfer size
        hburst_s    : in  std_logic_vector(2 downto 0);       -- burst type
        hwdata_s    : in  std_logic_vector(31 downto 0);      -- write data bus
        hprot_s     : in  std_logic_vector(3 downto 0);       -- protection control
        hmastlock_s : in  std_ulogic;                         -- master lock
        hreadyi_s   : in  std_ulogic;                         -- transfer done
        hreadyo_s   : out std_ulogic;                         -- transfer done
        hresp_s     : out std_logic;                          -- response type
        hrdata_s    : out std_logic_vector(31 downto 0)       -- read data bus
    );
end; 

architecture struct of leon2AhbLiteram is

    component ahbram
        generic ( abits : integer);
        port (
            rst    : in  std_logic;
            clk    : in  clk_type;
            ahbsi  : in  ahb_slv_in_type;
            ahbso  : out ahb_slv_out_type
        );
    end component;
 
-- synopsys translate_off
  for all: ahbram
    use entity leon2ahbram_lib.ahbram(rtl);
-- synopsys translate_on

begin
    u1 : ahbram
         generic map ( abits => abits)
            port map ( 
                rst             => rst,
                clk             => clk,
                ahbsi.hsel      => hsel_s, 
                ahbsi.haddr     => haddr_s, 
                ahbsi.hwrite    => hwrite_s, 
                ahbsi.htrans    => htrans_s, 
                ahbsi.hsize     => hsize_s, 
                ahbsi.hburst    => hburst_s, 
                ahbsi.hwdata    => hwdata_s, 
                ahbsi.hprot     => hprot_s, 
                ahbsi.hready    => hreadyi_s,
                ahbso.hready    => hreadyo_s,
                ahbso.hresp(0)  => hresp_s,
                ahbso.hresp(1)  => open,
                ahbso.hrdata    => hrdata_s,
		ahbso.hsplit    => open
                );
end struct; 
