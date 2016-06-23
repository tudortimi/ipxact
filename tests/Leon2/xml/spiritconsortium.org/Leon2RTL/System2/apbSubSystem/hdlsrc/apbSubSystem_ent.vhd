
-- ****************************************************************************
-- ** Description: apbSubSystem_ent.vhd
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
entity apbSubSystem is
      port (
            clk                    : in    std_logic;
            rst_an                 : in    std_logic;
            -- Ports for Interface Int4
            Int4_IRQ               : in    std_logic;
            -- Ports for Interface Int5
            Int5_IRQ               : in    std_logic;
            -- Ports for Interface Int6
            Int6_IRQ               : in    std_logic;
            -- Ports for Interface Interrupt
            Interrupt_INTack       : in    std_logic;
            Interrupt_IRQVEC       : in    std_logic_vector(3 downto 0);
            Interrupt_IRL          : out   std_logic_vector(3 downto 0);
            -- Ports for Interface ex_ambaAHB
            ex_ambaAHB_haddr       : in    std_logic_vector(31 downto 0);
            ex_ambaAHB_hburst      : in    std_logic_vector(2 downto 0);
            ex_ambaAHB_hprot       : in    std_logic_vector(3 downto 0);
            ex_ambaAHB_hready      : in    std_logic;
            ex_ambaAHB_hsel        : in    std_logic;
            ex_ambaAHB_hsize       : in    std_logic_vector(2 downto 0);
            ex_ambaAHB_htrans      : in    std_logic_vector(1 downto 0);
            ex_ambaAHB_hwdata      : in    std_logic_vector(31 downto 0);
            ex_ambaAHB_hwrite      : in    std_logic;
            ex_ambaAHB_hrdata      : out   std_logic_vector(31 downto 0);
            ex_ambaAHB_hready_resp : out   std_logic;
            ex_ambaAHB_hresp       : out   std_logic_vector(1 downto 0);
            -- Ports for Interface i_apbbus_slv4
            i_apbbus_slv4_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv4_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv4_penable  : out   std_logic;
            i_apbbus_slv4_psel     : out   std_logic;
            i_apbbus_slv4_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv4_pwrite   : out   std_logic;
            -- Ports for Interface i_apbbus_slv5
            i_apbbus_slv5_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv5_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv5_penable  : out   std_logic;
            i_apbbus_slv5_psel     : out   std_logic;
            i_apbbus_slv5_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv5_pwrite   : out   std_logic;
            -- Ports for Interface i_apbbus_slv6
            i_apbbus_slv6_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv6_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv6_penable  : out   std_logic;
            i_apbbus_slv6_psel     : out   std_logic;
            i_apbbus_slv6_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv6_pwrite   : out   std_logic;
            -- Ports for Interface i_apbbus_slv7
            i_apbbus_slv7_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv7_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv7_penable  : out   std_logic;
            i_apbbus_slv7_psel     : out   std_logic;
            i_apbbus_slv7_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv7_pwrite   : out   std_logic;
            -- Ports for Interface i_apbbus_slv8
            i_apbbus_slv8_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv8_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv8_penable  : out   std_logic;
            i_apbbus_slv8_psel     : out   std_logic;
            i_apbbus_slv8_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv8_pwrite   : out   std_logic);
end apbSubSystem;

