
-- ****************************************************************************
-- ** Description: System5_tb.vhd
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity System5_tb is
end System5_tb;

-- -----------------------------------------------------------------------------
architecture TESTBENCH of System5_tb is
-- -----------------------------------------------------------------------------
-- synopsys translate_off
   for all: Leon2PlatformSystem
      use entity work.Leon2PlatformSystem(structure);
-- synopsys translate_on

-- -----------------------------------------------------------------------------
component Leon2PlatformSystem 
port (
            clkin              : in    std_logic;
            gpi                : in    std_logic_vector(3 downto 0);
            i2c_gpio_address   : in    std_logic_vector(9 downto 0);
            i2c_memory_address : in    std_logic_vector(9 downto 0);
            rstin_an           : in    std_logic;
            SimDone            : out   std_logic;
            gpo                : out   std_logic_vector(3 downto 0)
      );
end component;

-- -----------------------------------------------------------------------------

  constant CYCLE:         time := 20 ns;         -- one cycle time
  constant CYCLE_Q:       time := CYCLE / 4;     -- quarter cycle time
  constant CYCLE_H:       time := CYCLE / 2;     -- half cycle time



  signal clkin: std_logic;
  signal rstin_an: std_logic;
  signal gpo: std_logic_vector (3 downto 0);
  signal SimDone : std_logic;

begin
  
-- ---------------------------------------------------------------------------
-- clock define
-- ---------------------------------------------------------------------------
   tb_clock: process
   begin
      if (SimDone = '1') then
        wait;
      end if;

      clkin <= '0'; 
      wait for CYCLE_H;
      clkin <= '1'; 
      wait for CYCLE_H;
   end process;


-- ---------------------------------------------------------------------------
-- reset define
-- ---------------------------------------------------------------------------
   tb_reset: process
   begin
      rstin_an <= '0'; 
      wait for CYCLE_H;
      wait for CYCLE;
      wait for CYCLE;
      wait for CYCLE;
      wait for CYCLE;
      rstin_an <= '1'; 
      wait;
   end process;

   u1: Leon2PlatformSystem
   port map (
      clkin      => clkin,
      rstin_an   => rstin_an,
      gpi        => gpo,
      gpo        => gpo,
      i2c_memory_address => "0000011111",
      i2c_gpio_address => "0000001111",
      SimDone    => SimDone
      );
 
end TESTBENCH;

