
-- ****************************************************************************
-- ** Description: i2cSubSystem_pack.vhd
-- ** Author:      The SPIRIT Consortium
-- ** Revision:    $Revision: 1506 $
-- ** Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- **
-- ** Copyright (c) 2009 The SPIRIT Consortium.
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
package i2c_component is
   component i2c
      port (pclk    : in    std_logic;
            presetn : in    std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(11 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            sclIn   : in    std_logic;
            sclOut  : out   std_logic;
            sdaIn   : in    std_logic;
            sdaOut  : out   std_logic;
            ip_clk  : in    std_logic;
            rst_an  : in    std_logic;
            intr    : out   std_logic);
   end component;
end i2c_component;

library ieee;
use ieee.std_logic_1164.all;
package i2c_io_component is
   component i2c_io
      port (scl     : inout std_logic;
            sda     : inout std_logic;
            scl_in  : out   std_logic;
            scl_out : in    std_logic;
            scl_oen : in    std_logic;
            sda_in  : out   std_logic;
            sda_out : in    std_logic;
            sda_oen : in    std_logic);
   end component;
end i2c_io_component;

