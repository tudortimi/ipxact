
-- ****************************************************************************
-- ** Description: i2cSubSystem_ent.vhd
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
entity i2cSubSystem is
      port (-- Ports for Interface i2c
            i2c_SCL             : inout std_logic;
            i2c_SDA             : inout std_logic;
            -- Ports for Interface i2c_ambaAPB
            i_i2c_pclk          : in    std_logic;
            i_i2c_presetn       : in    std_logic;
            i2c_ambaAPB_paddr   : in    std_logic_vector(11 downto 0);
            i2c_ambaAPB_penable : in    std_logic;
            i2c_ambaAPB_psel    : in    std_logic;
            i2c_ambaAPB_pwdata  : in    std_logic_vector(31 downto 0);
            i2c_ambaAPB_pwrite  : in    std_logic;
            i2c_ambaAPB_prdata  : out   std_logic_vector(31 downto 0);
            -- Ports for Interface i2c_interrupt
            i2c_interrupt_IRQ   : out   std_logic;
            -- Ports for Manually exported pins
            i_i2c_ip_clk        : in    std_logic;
            i_i2c_rst_an        : in    std_logic);
end i2cSubSystem;

