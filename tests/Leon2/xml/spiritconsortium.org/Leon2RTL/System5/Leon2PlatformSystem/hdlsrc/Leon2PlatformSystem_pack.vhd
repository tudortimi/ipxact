-- ****************************************************************************
-- ** Description: Leon2PlatformSystem_pack.vhd
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
library ieee;
use ieee.std_logic_1164.all;
library mp3decode_lib;
use mp3decode_lib.types.dac_word_type;
package Leon2Platform_component is
   component Leon2Platform
      port (i2c_SCL            : inout std_logic;
            i2c_SDA            : inout std_logic;
            clkin              : in    std_logic;
            rstin_an           : in    std_logic;
            SimDone            : out   std_logic;
            dac_clk            : out   std_logic;
            mp3Decode_dac_data : out   dac_word_type);
   end component;
end Leon2Platform_component;

library ieee;
use ieee.std_logic_1164.all;
library mp3decode_lib;
use mp3decode_lib.types.dac_word_type;
package dac_component is
   component dac
      generic (WIDTH : integer := 24);
      port (data : in    dac_word_type;
            clk  : in    std_logic);
   end component;
end dac_component;

library ieee;
use ieee.std_logic_1164.all;
package i2c_channel_1m_2s_component is
   component i2c_channel_1m_2s
      port (scl_m1 : inout std_logic;
            sda_m1 : inout std_logic;
            scl_s1 : inout std_logic;
            sda_s1 : inout std_logic;
            scl_s2 : inout std_logic;
            sda_s2 : inout std_logic);
   end component;
end i2c_channel_1m_2s_component;

library ieee;
use ieee.std_logic_1164.all;
package i2c_gpio_component is
   component i2c_gpio
      generic (gpibits : integer := 4;
               gpobits : integer := 4);
      port (scl     : inout std_logic;
            sda     : inout std_logic;
            address : in    std_logic_vector(9 downto 0);
            gpi     : in    std_logic_vector(gpibits-1 downto 0);
            gpo     : out   std_logic_vector(gpobits-1 downto 0));
   end component;
end i2c_gpio_component;

library ieee;
use ieee.std_logic_1164.all;
package i2c_memory_component is
   component i2c_memory
      generic (MEM_DEPTH     : integer := 4096;
               ADDRESS_BYTES : integer := 2);
      port (scl     : inout std_logic;
            sda     : inout std_logic;
            address : in    std_logic_vector(9 downto 0));
   end component;
end i2c_memory_component;

