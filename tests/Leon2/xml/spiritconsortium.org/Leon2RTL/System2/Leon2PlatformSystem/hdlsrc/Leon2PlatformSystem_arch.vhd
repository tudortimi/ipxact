
-- ****************************************************************************
-- ** Description: Leon2PlatformSystem_arch.vhd
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
use work.Leon2Platform_component.all;
library dac_lib;
use work.dac_component.all;
library i2c_channel_lib;
use work.i2c_channel_1m_2s_component.all;
library i2c_gpio_lib;
use work.i2c_gpio_component.all;
library i2c_memory_lib;
use work.i2c_memory_component.all;
architecture structure of Leon2PlatformSystem is

-- synopsys translate_off
  for all: Leon2Platform
    use entity work.Leon2Platform;

  for all: dac
    use entity dac_lib.dac;

  for all: i2c_gpio
    use entity i2c_gpio_lib.i2c_gpio;
-- synopsys translate_on

   signal dac_clk            : std_logic;
   signal i_Leon2Platform_i2c_SCL            : std_logic;
   signal i_Leon2Platform_i2c_SDA            : std_logic;
   signal i_Leon2Platform_mp3Decode_dac_data : std_logic_vector(23 downto 0);
   signal i_i2c_channel_1m_2s_scl_s1         : std_logic;
   signal i_i2c_channel_1m_2s_scl_s2         : std_logic;
   signal i_i2c_channel_1m_2s_sda_s1         : std_logic;
   signal i_i2c_channel_1m_2s_sda_s2         : std_logic;
begin

   i_Leon2Platform : Leon2Platform
   port map(i2c_SCL            => i_Leon2Platform_i2c_SCL,
            i2c_SDA            => i_Leon2Platform_i2c_SDA,
            clkin              => clkin,
            rstin_an           => rstin_an,
            SimDone            => SimDone,
            dac_clk            => dac_clk,
            mp3Decode_dac_data => i_Leon2Platform_mp3Decode_dac_data);

   i_dac : dac
   generic map(WIDTH => 24)
   port map(data => i_Leon2Platform_mp3Decode_dac_data,
            clk  => dac_clk);

   i_i2c_channel_1m_2s : i2c_channel_1m_2s
   port map(scl_m1 => i_Leon2Platform_i2c_SCL,
            sda_m1 => i_Leon2Platform_i2c_SDA,
            scl_s1 => i_i2c_channel_1m_2s_scl_s1,
            sda_s1 => i_i2c_channel_1m_2s_sda_s1,
            scl_s2 => i_i2c_channel_1m_2s_scl_s2,
            sda_s2 => i_i2c_channel_1m_2s_sda_s2);

   i_i2c_gpio : i2c_gpio
   generic map(gpibits => 4,
               gpobits => 4)
   port map(scl     => i_i2c_channel_1m_2s_scl_s1,
            sda     => i_i2c_channel_1m_2s_sda_s1,
            address => i2c_gpio_address,
            gpi     => gpi,
            gpo     => gpo);

   i_i2c_memory : i2c_memory
   generic map(MEM_DEPTH     => 4096,
               ADDRESS_BYTES => 2)
   port map(scl     => i_i2c_channel_1m_2s_scl_s2,
            sda     => i_i2c_channel_1m_2s_sda_s2,
            address => i2c_memory_address);



end structure;
