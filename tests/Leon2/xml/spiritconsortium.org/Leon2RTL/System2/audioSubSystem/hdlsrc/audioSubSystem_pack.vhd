
-- ****************************************************************************
-- ** Description: audioSubSystem_pack.vhd
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
package leon2Ahbbus25_component is
   component leon2Ahbbus25
      generic (start_addr_slv0 : integer := 36864;
               range_slv0      : integer := 131072;
               split_slv0      : boolean := FALSE;
               mst_access_slv0 : integer := 3;
               start_addr_slv1 : integer := 32768;
               range_slv1      : integer := 1048576;
               split_slv1      : boolean := FALSE;
               mst_access_slv1 : integer := 3;
               start_addr_slv2 : integer := 45056;
               range_slv2      : integer := 1048576;
               split_slv2      : boolean := FALSE;
               mst_access_slv2 : integer := 3;
               start_addr_slv3 : integer := 40960;
               range_slv3      : integer := 4096;
               split_slv3      : boolean := FALSE;
               start_addr_slv4 : integer := 0;
               range_slv4      : integer := 134217728;
               split_slv4      : boolean := FALSE;
               mst_access_slv4 : integer := 3;
               defmast         : integer := 1);
      port (rst            : in    std_logic;
            clk            : in    std_logic;
            remap          : in    std_logic;
            hgrant_mst0    : out   std_logic;
            hready_mst0    : out   std_logic;
            hresp_mst0     : out   std_logic_vector(1 downto 0);
            hrdata_mst0    : out   std_logic_vector(31 downto 0);
            hgrant_mst1    : out   std_logic;
            hready_mst1    : out   std_logic;
            hresp_mst1     : out   std_logic_vector(1 downto 0);
            hrdata_mst1    : out   std_logic_vector(31 downto 0);
            hbusreq_mst0   : in    std_logic;
            hlock_mst0     : in    std_logic;
            htrans_mst0    : in    std_logic_vector(1 downto 0);
            haddr_mst0     : in    std_logic_vector(31 downto 0);
            hwrite_mst0    : in    std_logic;
            hsize_mst0     : in    std_logic_vector(2 downto 0);
            hburst_mst0    : in    std_logic_vector(2 downto 0);
            hprot_mst0     : in    std_logic_vector(3 downto 0);
            hwdata_mst0    : in    std_logic_vector(31 downto 0);
            hbusreq_mst1   : in    std_logic;
            hlock_mst1     : in    std_logic;
            htrans_mst1    : in    std_logic_vector(1 downto 0);
            haddr_mst1     : in    std_logic_vector(31 downto 0);
            hwrite_mst1    : in    std_logic;
            hsize_mst1     : in    std_logic_vector(2 downto 0);
            hburst_mst1    : in    std_logic_vector(2 downto 0);
            hprot_mst1     : in    std_logic_vector(3 downto 0);
            hwdata_mst1    : in    std_logic_vector(31 downto 0);
            hsel_slv0      : out   std_logic;
            haddr_slv0     : out   std_logic_vector(31 downto 0);
            hwrite_slv0    : out   std_logic;
            htrans_slv0    : out   std_logic_vector(1 downto 0);
            hsize_slv0     : out   std_logic_vector(2 downto 0);
            hburst_slv0    : out   std_logic_vector(2 downto 0);
            hwdata_slv0    : out   std_logic_vector(31 downto 0);
            hprot_slv0     : out   std_logic_vector(3 downto 0);
            hreadyin_slv0  : out   std_logic;
            hmaster_slv0   : out   std_logic_vector(3 downto 0);
            hmastlock_slv0 : out   std_logic;
            hreadyout_slv0 : in    std_logic;
            hresp_slv0     : in    std_logic_vector(1 downto 0);
            hrdata_slv0    : in    std_logic_vector(31 downto 0);
            hsplit_slv0    : in    std_logic_vector(15 downto 0);
            hsel_slv1      : out   std_logic;
            haddr_slv1     : out   std_logic_vector(31 downto 0);
            hwrite_slv1    : out   std_logic;
            htrans_slv1    : out   std_logic_vector(1 downto 0);
            hsize_slv1     : out   std_logic_vector(2 downto 0);
            hburst_slv1    : out   std_logic_vector(2 downto 0);
            hwdata_slv1    : out   std_logic_vector(31 downto 0);
            hprot_slv1     : out   std_logic_vector(3 downto 0);
            hreadyin_slv1  : out   std_logic;
            hmaster_slv1   : out   std_logic_vector(3 downto 0);
            hmastlock_slv1 : out   std_logic;
            hreadyout_slv1 : in    std_logic;
            hresp_slv1     : in    std_logic_vector(1 downto 0);
            hrdata_slv1    : in    std_logic_vector(31 downto 0);
            hsplit_slv1    : in    std_logic_vector(15 downto 0);
            hsel_slv2      : out   std_logic;
            haddr_slv2     : out   std_logic_vector(31 downto 0);
            hwrite_slv2    : out   std_logic;
            htrans_slv2    : out   std_logic_vector(1 downto 0);
            hsize_slv2     : out   std_logic_vector(2 downto 0);
            hburst_slv2    : out   std_logic_vector(2 downto 0);
            hwdata_slv2    : out   std_logic_vector(31 downto 0);
            hprot_slv2     : out   std_logic_vector(3 downto 0);
            hreadyin_slv2  : out   std_logic;
            hmaster_slv2   : out   std_logic_vector(3 downto 0);
            hmastlock_slv2 : out   std_logic;
            hreadyout_slv2 : in    std_logic;
            hresp_slv2     : in    std_logic_vector(1 downto 0);
            hrdata_slv2    : in    std_logic_vector(31 downto 0);
            hsplit_slv2    : in    std_logic_vector(15 downto 0);
            hsel_slv3      : out   std_logic;
            haddr_slv3     : out   std_logic_vector(31 downto 0);
            hwrite_slv3    : out   std_logic;
            htrans_slv3    : out   std_logic_vector(1 downto 0);
            hsize_slv3     : out   std_logic_vector(2 downto 0);
            hburst_slv3    : out   std_logic_vector(2 downto 0);
            hwdata_slv3    : out   std_logic_vector(31 downto 0);
            hprot_slv3     : out   std_logic_vector(3 downto 0);
            hreadyin_slv3  : out   std_logic;
            hmaster_slv3   : out   std_logic_vector(3 downto 0);
            hmastlock_slv3 : out   std_logic;
            hreadyout_slv3 : in    std_logic;
            hresp_slv3     : in    std_logic_vector(1 downto 0);
            hrdata_slv3    : in    std_logic_vector(31 downto 0);
            hsplit_slv3    : in    std_logic_vector(15 downto 0);
            hsel_slv4      : out   std_logic;
            haddr_slv4     : out   std_logic_vector(31 downto 0);
            hwrite_slv4    : out   std_logic;
            htrans_slv4    : out   std_logic_vector(1 downto 0);
            hsize_slv4     : out   std_logic_vector(2 downto 0);
            hburst_slv4    : out   std_logic_vector(2 downto 0);
            hwdata_slv4    : out   std_logic_vector(31 downto 0);
            hprot_slv4     : out   std_logic_vector(3 downto 0);
            hreadyin_slv4  : out   std_logic;
            hmaster_slv4   : out   std_logic_vector(3 downto 0);
            hmastlock_slv4 : out   std_logic;
            hreadyout_slv4 : in    std_logic;
            hresp_slv4     : in    std_logic_vector(1 downto 0);
            hrdata_slv4    : in    std_logic_vector(31 downto 0);
            hsplit_slv4    : in    std_logic_vector(15 downto 0));
   end component;
end leon2Ahbbus25_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Ahbram_component is
   component leon2Ahbram
      generic (abits : integer := 10);
      port (clk       : in    std_logic;
            rst       : in    std_logic;
            hsel_s    : in    std_logic;
            haddr_s   : in    std_logic_vector(31 downto 0);
            hwrite_s  : in    std_logic;
            htrans_s  : in    std_logic_vector(1 downto 0);
            hsize_s   : in    std_logic_vector(2 downto 0);
            hburst_s  : in    std_logic_vector(2 downto 0);
            hwdata_s  : in    std_logic_vector(31 downto 0);
            hprot_s   : in    std_logic_vector(3 downto 0);
            hreadyi_s : in    std_logic;
            hmaster_s : in    std_logic_vector(3 downto 0);
            hmastlock_s : in    std_logic;
            hreadyo_s : out   std_logic;
            hresp_s   : out   std_logic_vector(1 downto 0);
            hrdata_s  : out   std_logic_vector(31 downto 0);
            hsplit_s  : out   std_logic_vector(15 downto 0));
   end component;
end leon2Ahbram_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Ahbrom_component is
   component leon2Ahbrom
      generic (abits : integer := 10);
      port (clk         : in    std_logic;
            rst         : in    std_logic;
            hsel_s      : in    std_logic;
            haddr_s     : in    std_logic_vector(31 downto 0);
            hwrite_s    : in    std_logic;
            htrans_s    : in    std_logic_vector(1 downto 0);
            hsize_s     : in    std_logic_vector(2 downto 0);
            hburst_s    : in    std_logic_vector(2 downto 0);
            hwdata_s    : in    std_logic_vector(31 downto 0);
            hprot_s     : in    std_logic_vector(3 downto 0);
            hreadyi_s   : in    std_logic;
            hmaster_s   : in    std_logic_vector(3 downto 0);
            hmastlock_s : in    std_logic;
            hreadyo_s   : out   std_logic;
            hresp_s     : out   std_logic_vector(1 downto 0);
            hrdata_s    : out   std_logic_vector(31 downto 0);
            hsplit_s    : out   std_logic_vector(15 downto 0));
   end component;
end leon2Ahbrom_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Apbbus1_component is
   component leon2Apbbus1
      generic (start_addr_slv0 : integer := 0;
               range_slv0      : integer := 4096);
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
            prdata_slv0  : in    std_logic_vector(31 downto 0));
   end component;
end leon2Apbbus1_component;

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
package leon2Dma_component is
   component leon2Dma
      port (clk     : in    std_logic;
            rst     : in    std_logic;
            hready  : in    std_logic;
            hrdata  : in    std_logic_vector(31 downto 0);
            hresp   : in    std_logic_vector(1 downto 0);
            hgrant  : in    std_logic;
            haddr   : out   std_logic_vector(31 downto 0);
            htrans  : out   std_logic_vector(1 downto 0);
            hwrite  : out   std_logic;
            hsize   : out   std_logic_vector(2 downto 0);
            hburst  : out   std_logic_vector(2 downto 0);
            hprot   : out   std_logic_vector(3 downto 0);
            hwdata  : out   std_logic_vector(31 downto 0);
            hbusreq : out   std_logic;
            hlock   : out   std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(31 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            dirq    : out   std_logic);
   end component;
end leon2Dma_component;

library ieee;
use ieee.std_logic_1164.all;
package mp3Decode_component is
   component mp3Decode
      port (hclk       : in    std_logic;
            hresetn    : in    std_logic;
            hsel       : in    std_logic;
            haddr      : in    std_logic_vector(11 downto 0);
            hwrite     : in    std_logic;
            htrans     : in    std_logic_vector(1 downto 0);
            hsize      : in    std_logic_vector(2 downto 0);
            hburst     : in    std_logic_vector(2 downto 0);
            hwdata     : in    std_logic_vector(31 downto 0);
            hprot      : in    std_logic_vector(3 downto 0);
            hreadyi    : in    std_logic;
            hreadyo    : out   std_logic;
            hresp      : out   std_logic_vector(1 downto 0);
            hrdata     : out   std_logic_vector(31 downto 0);
            dac_data   : out   std_logic_vector(23 downto 0);
            dac_clk    : in    std_logic;
            mp3_clk    : in    std_logic;
            mp3_rst_an : in    std_logic);
   end component;
end mp3Decode_component;

