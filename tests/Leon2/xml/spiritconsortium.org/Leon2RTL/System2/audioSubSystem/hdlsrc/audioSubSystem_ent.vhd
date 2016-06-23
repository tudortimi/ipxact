
-- ****************************************************************************
-- ** Description: audioSubSystem_ent.vhd
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
entity audioSubSystem is
      port (-- Ports for Interface MirroredMaster0
            MirroredMaster0_haddr     : in    std_logic_vector(31 downto 0);
            MirroredMaster0_hburst    : in    std_logic_vector(2 downto 0);
            MirroredMaster0_hbusreq   : in    std_logic;
            MirroredMaster0_hlock     : in    std_logic;
            MirroredMaster0_hprot     : in    std_logic_vector(3 downto 0);
            MirroredMaster0_hsize     : in    std_logic_vector(2 downto 0);
            MirroredMaster0_htrans    : in    std_logic_vector(1 downto 0);
            MirroredMaster0_hwdata    : in    std_logic_vector(31 downto 0);
            MirroredMaster0_hwrite    : in    std_logic;
            MirroredMaster0_hgrant    : out   std_logic;
            MirroredMaster0_hrdata    : out   std_logic_vector(31 downto 0);
            MirroredMaster0_hready    : out   std_logic;
            MirroredMaster0_hresp     : out   std_logic_vector(1 downto 0);
            -- Ports for Interface i_ahbbus_slv4
            i_ahbbus_slv4_hrdata      : in    std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hready_resp : in    std_logic;
            i_ahbbus_slv4_hresp       : in    std_logic_vector(1 downto 0);
            i_ahbbus_slv4_haddr       : out   std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hburst      : out   std_logic_vector(2 downto 0);
            i_ahbbus_slv4_hmastlock   : out   std_logic;
            i_ahbbus_slv4_hprot       : out   std_logic_vector(3 downto 0);
            i_ahbbus_slv4_hready      : out   std_logic;
            i_ahbbus_slv4_hsel        : out   std_logic;
            i_ahbbus_slv4_hsize       : out   std_logic_vector(2 downto 0);
            i_ahbbus_slv4_htrans      : out   std_logic_vector(1 downto 0);
            i_ahbbus_slv4_hwdata      : out   std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hwrite      : out   std_logic;
            i_ahbbus_slv4_hmaster     : out   std_logic_vector(3 downto 0);
            i_ahbbus_slv4_hsplit      : in    std_logic_vector(15 downto 0);
            -- Ports for Interface mp3_dma_Interrupt
            mp3_dma_Interrupt_IRQ     : out   std_logic;

            -- shared Ports
            clk                       : in    std_logic;
            rst_an                    : in    std_logic;
            -- Ports for Manually exported pins
            i_mp3Decode_mp3_clk       : in    std_logic;
            i_mp3Decode_mp3_rst_an    : in    std_logic;
            i_mp3Decode_dac_clk       : in    std_logic;
            i_mp3Decode_dac_data      : out   std_logic_vector(23 downto 0));
end audioSubSystem;

