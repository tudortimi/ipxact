
-- ****************************************************************************
-- ** Description: Leon2Platform_ent.vhd
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
library mp3decode_lib;
use mp3decode_lib.types.dac_word_type;

entity Leon2Platform is
      port (-- Ports for Interface i2c
            i2c_SCL            : inout std_logic;
            i2c_SDA            : inout std_logic;
            -- Ports for Manually exported pins
            clkin              : in    std_logic;
            rstin_an           : in    std_logic;
            SimDone            : out   std_logic;
            dac_clk            : out   std_logic;
            mp3Decode_dac_data : out   dac_word_type);
end Leon2Platform;

