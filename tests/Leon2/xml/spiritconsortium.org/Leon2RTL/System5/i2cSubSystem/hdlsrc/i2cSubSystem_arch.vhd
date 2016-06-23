
-- ****************************************************************************
-- ** Description: i2cSubSystem_arch.vhd
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
library work;
library i2c_lib;
use work.i2c_component.all;
use work.i2c_io_component.all;
architecture structure of i2cSubSystem is
   signal i_i2c_io_scl_in : std_logic;
   signal i_i2c_io_sda_in : std_logic;
   signal i_i2c_sclOut    : std_logic;
   signal i_i2c_sdaOut    : std_logic;
   signal logic_zero      : std_logic;
begin

   i_i2c : i2c
   port map(pclk    => i_i2c_pclk,
            presetn => i_i2c_presetn,
            psel    => i2c_ambaAPB_psel,
            penable => i2c_ambaAPB_penable,
            paddr   => i2c_ambaAPB_paddr,
            pwrite  => i2c_ambaAPB_pwrite,
            pwdata  => i2c_ambaAPB_pwdata,
            prdata  => i2c_ambaAPB_prdata,
            sclIn   => i_i2c_io_scl_in,
            sclOut  => i_i2c_sclOut,
            sdaIn   => i_i2c_io_sda_in,
            sdaOut  => i_i2c_sdaOut,
            ip_clk  => i_i2c_ip_clk,
            rst_an  => i_i2c_rst_an,
            intr    => i2c_interrupt_IRQ);

   i_i2c_io : i2c_io
   port map(scl     => i2c_SCL,
            sda     => i2c_SDA,
            scl_in  => i_i2c_io_scl_in,
            scl_out => logic_zero,
            scl_oen => i_i2c_sclOut,
            sda_in  => i_i2c_io_sda_in,
            sda_out => logic_zero,
            sda_oen => i_i2c_sdaOut);


   logic_zero      <= '0';

end structure;
