
-- ****************************************************************************
-- ** Description: apbSubSystem_pack.vhd
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
package leon2Apbbus8_component is
   component leon2Apbbus8
      generic (start_addr_slv0 : integer := 0;
               range_slv0      : integer := 4096;
               start_addr_slv1 : integer := 4096;
               range_slv1      : integer := 4096;
               start_addr_slv2 : integer := 8192;
               range_slv2      : integer := 4096;
               start_addr_slv3 : integer := 12288;
               range_slv3      : integer := 4096;
               start_addr_slv4 : integer := 16384;
               range_slv4      : integer := 4096;
               start_addr_slv5 : integer := 20480;
               range_slv5      : integer := 4096;
               start_addr_slv6 : integer := 24576;
               range_slv6      : integer := 4096;
               start_addr_slv7 : integer := 28672;
               range_slv7      : integer := 4096;
               number_ports    : integer := 8);
      port (psel_mst     : in    std_logic;
            penable_mst  : in    std_logic;
            paddr_mst    : in    std_logic_vector(31 downto 0);
            pwrite_mst   : in    std_logic;
            pwdata_mst   : in    std_logic_vector(31 downto 0);
            prdata_mst   : out   std_logic_vector(31 downto 0);
            psel_slv0    : out   std_logic;
            penable_slv0 : out   std_logic;
            paddr_slv0   : out   std_logic_vector(31 downto 0);
            pwrite_slv0  : out   std_logic;
            pwdata_slv0  : out   std_logic_vector(31 downto 0);
            prdata_slv0  : in    std_logic_vector(31 downto 0);
            psel_slv1    : out   std_logic;
            penable_slv1 : out   std_logic;
            paddr_slv1   : out   std_logic_vector(31 downto 0);
            pwrite_slv1  : out   std_logic;
            pwdata_slv1  : out   std_logic_vector(31 downto 0);
            prdata_slv1  : in    std_logic_vector(31 downto 0);
            psel_slv2    : out   std_logic;
            penable_slv2 : out   std_logic;
            paddr_slv2   : out   std_logic_vector(31 downto 0);
            pwrite_slv2  : out   std_logic;
            pwdata_slv2  : out   std_logic_vector(31 downto 0);
            prdata_slv2  : in    std_logic_vector(31 downto 0);
            psel_slv3    : out   std_logic;
            penable_slv3 : out   std_logic;
            paddr_slv3   : out   std_logic_vector(31 downto 0);
            pwrite_slv3  : out   std_logic;
            pwdata_slv3  : out   std_logic_vector(31 downto 0);
            prdata_slv3  : in    std_logic_vector(31 downto 0);
            psel_slv4    : out   std_logic;
            penable_slv4 : out   std_logic;
            paddr_slv4   : out   std_logic_vector(31 downto 0);
            pwrite_slv4  : out   std_logic;
            pwdata_slv4  : out   std_logic_vector(31 downto 0);
            prdata_slv4  : in    std_logic_vector(31 downto 0);
            psel_slv5    : out   std_logic;
            penable_slv5 : out   std_logic;
            paddr_slv5   : out   std_logic_vector(31 downto 0);
            pwrite_slv5  : out   std_logic;
            pwdata_slv5  : out   std_logic_vector(31 downto 0);
            prdata_slv5  : in    std_logic_vector(31 downto 0);
            psel_slv6    : out   std_logic;
            penable_slv6 : out   std_logic;
            paddr_slv6   : out   std_logic_vector(31 downto 0);
            pwrite_slv6  : out   std_logic;
            pwdata_slv6  : out   std_logic_vector(31 downto 0);
            prdata_slv6  : in    std_logic_vector(31 downto 0);
            psel_slv7    : out   std_logic;
            penable_slv7 : out   std_logic;
            paddr_slv7   : out   std_logic_vector(31 downto 0);
            pwrite_slv7  : out   std_logic;
            pwdata_slv7  : out   std_logic_vector(31 downto 0);
            prdata_slv7  : in    std_logic_vector(31 downto 0));
   end component;
end leon2Apbbus8_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Apbmst_component is
   component leon2Apbmst
      port (clk       : in    std_logic;
            rst       : in    std_logic;
            hsize     : in    std_logic_vector(2 downto 0);
            haddr     : in    std_logic_vector(31 downto 0);
            htrans    : in    std_logic_vector(1 downto 0);
            hwrite    : in    std_logic;
            hwdata    : in    std_logic_vector(31 downto 0);
            hreadyin  : in    std_logic;
            hsel      : in    std_logic;
            hrdata    : out   std_logic_vector(31 downto 0);
            hreadyout : out   std_logic;
            hresp     : out   std_logic_vector(1 downto 0);
            hprot     : in    std_logic_vector(3 downto 0);
            hburst    : in    std_logic_vector(2 downto 0);
            prdata    : in    std_logic_vector(31 downto 0);
            pwdata    : out   std_logic_vector(31 downto 0);
            penable   : out   std_logic;
            paddr     : out   std_logic_vector(31 downto 0);
            pwrite    : out   std_logic;
            psel      : out   std_logic);
   end component;
end leon2Apbmst_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Irqctrl_component is
   component leon2Irqctrl
      port (clk     : in    std_logic;
            rst     : in    std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(31 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            irq     : in    std_logic_vector(14 downto 0);
            intack  : in    std_logic;
            irlin   : in    std_logic_vector(3 downto 0);
            irlout  : out   std_logic_vector(3 downto 0));
   end component;
end leon2Irqctrl_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Timers_component is
   component leon2Timers
      generic (TPRESC : integer := 22);
      port (clk        : in    std_logic;
            rst        : in    std_logic;
            psel       : in    std_logic;
            penable    : in    std_logic;
            paddr      : in    std_logic_vector(31 downto 0);
            pwrite     : in    std_logic;
            pwdata     : in    std_logic_vector(31 downto 0);
            prdata     : out   std_logic_vector(31 downto 0);
            irq0       : out   std_logic;
            irq1       : out   std_logic;
            tick       : out   std_logic;
            wdog       : out   std_logic;
            dsuact     : in    std_logic;
            ntrace     : in    std_logic;
            freezetime : in    std_logic;
            lresp      : in    std_logic;
            dresp      : in    std_logic;
            dsuen      : in    std_logic;
            dsubre     : in    std_logic);
   end component;
end leon2Timers_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Uart_component is
   component leon2Uart
      generic (EXTBAUD : boolean := FALSE);
      port (clk     : in    std_logic;
            rst     : in    std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(31 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            irq     : out   std_logic;
            scaler  : in    std_logic_vector(7 downto 0);
            rxd     : in    std_logic;
            rxen    : out   std_logic;
            txd     : out   std_logic;
            txen    : out   std_logic;
            flow    : out   std_logic;
            rtsn    : out   std_logic;
            ctsn    : in    std_logic);
   end component;
end leon2Uart_component;

library ieee;
use ieee.std_logic_1164.all;
package uartcrosser_component is
   component uartcrosser
      generic (ScalerValue : std_logic_vector := x"01");
      port (rxd0   : out   std_logic;
            txd0   : in    std_logic;
            ctsn0  : out   std_logic;
            rtsn0  : in    std_logic;
            rxen0  : in    std_logic;
            rxd1   : out   std_logic;
            txd1   : in    std_logic;
            ctsn1  : out   std_logic;
            rtsn1  : in    std_logic;
            rxen1  : in    std_logic;
            scaler : out   std_logic_vector(7 downto 0));
   end component;
end uartcrosser_component;

