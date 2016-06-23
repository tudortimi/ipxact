
-- ****************************************************************************
-- ** Description: Leon2Platform_pack.vhd
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
package ahb2ahb_component is
   component ahb2ahb
      port (hclk      : in    std_logic;
            hresetn   : in    std_logic;
            hgrant_m  : in    std_logic;
            hready_m  : in    std_logic;
            hresp_m   : in    std_logic_vector(1 downto 0);
            hrdata_m  : in    std_logic_vector(31 downto 0);
            hbusreq_m : out   std_logic;
            htrans_m  : out   std_logic_vector(1 downto 0);
            haddr_m   : out   std_logic_vector(31 downto 0);
            hwrite_m  : out   std_logic;
            hsize_m   : out   std_logic_vector(2 downto 0);
            hburst_m  : out   std_logic_vector(2 downto 0);
            hprot_m   : out   std_logic_vector(3 downto 0);
            hwdata_m  : out   std_logic_vector(31 downto 0);
            hsel_s    : in    std_logic;
            haddr_s   : in    std_logic_vector(31 downto 0);
            hwrite_s  : in    std_logic;
            htrans_s  : in    std_logic_vector(1 downto 0);
            hsize_s   : in    std_logic_vector(2 downto 0);
            hburst_s  : in    std_logic_vector(2 downto 0);
            hwdata_s  : in    std_logic_vector(31 downto 0);
            hprot_s   : in    std_logic_vector(3 downto 0);
            hreadyi_s : in    std_logic;
            hreadyo_s : out   std_logic;
            hresp_s   : out   std_logic_vector(1 downto 0);
            hrdata_s  : out   std_logic_vector(31 downto 0));
   end component;
end ahb2ahb_component;

library ieee;
use ieee.std_logic_1164.all;
package leon2Ahbbus33_component is
   component leon2Ahbbus33
      generic (start_addr_slv0 : integer := 12288;
               range_slv0      : integer := 131072;
               split_slv0      : boolean := FALSE;
               mst_access_slv0 : integer := 7;
               start_addr_slv1 : integer := 0;
               range_slv1      : integer := 1048576;
               split_slv1      : boolean := FALSE;
               mst_access_slv1 : integer := 7;
               start_addr_slv2 : integer := 32768;
               range_slv2      : integer := 1073741824;
               split_slv2      : boolean := FALSE;
               mst_access_slv2 : integer := 7;
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
            hbusreq_mst2   : in    std_logic;
            hlock_mst2     : in    std_logic;
            htrans_mst2    : in    std_logic_vector(1 downto 0);
            haddr_mst2     : in    std_logic_vector(31 downto 0);
            hwrite_mst2    : in    std_logic;
            hsize_mst2     : in    std_logic_vector(2 downto 0);
            hburst_mst2    : in    std_logic_vector(2 downto 0);
            hprot_mst2     : in    std_logic_vector(3 downto 0);
            hwdata_mst2    : in    std_logic_vector(31 downto 0);
            hgrant_mst2    : out   std_logic;
            hready_mst2    : out   std_logic;
            hresp_mst2     : out   std_logic_vector(1 downto 0);
            hrdata_mst2    : out   std_logic_vector(31 downto 0);
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
            hsplit_slv2    : in    std_logic_vector(15 downto 0));
   end component;
end leon2Ahbbus33_component;

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
package apbSubSystem_component is
   component apbSubSystem
      port (clk                    : in    std_logic;
            rst_an                 : in    std_logic;
            ex_ambaAHB_haddr       : in    std_logic_vector(31 downto 0);
            ex_ambaAHB_hburst      : in    std_logic_vector(2 downto 0);
            ex_ambaAHB_hprot       : in    std_logic_vector(3 downto 0);
            ex_ambaAHB_hrdata      : out   std_logic_vector(31 downto 0);
            ex_ambaAHB_hready      : in    std_logic;
            ex_ambaAHB_hready_resp : out   std_logic;
            ex_ambaAHB_hresp       : out   std_logic_vector(1 downto 0);
            ex_ambaAHB_hsel        : in    std_logic;
            ex_ambaAHB_hsize       : in    std_logic_vector(2 downto 0);
            ex_ambaAHB_htrans      : in    std_logic_vector(1 downto 0);
            ex_ambaAHB_hwdata      : in    std_logic_vector(31 downto 0);
            ex_ambaAHB_hwrite      : in    std_logic;
            i_apbbus_slv4_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv4_penable  : out   std_logic;
            i_apbbus_slv4_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv4_psel     : out   std_logic;
            i_apbbus_slv4_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv4_pwrite   : out   std_logic;
            i_apbbus_slv5_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv5_penable  : out   std_logic;
            i_apbbus_slv5_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv5_psel     : out   std_logic;
            i_apbbus_slv5_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv5_pwrite   : out   std_logic;
            i_apbbus_slv6_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv6_penable  : out   std_logic;
            i_apbbus_slv6_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv6_psel     : out   std_logic;
            i_apbbus_slv6_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv6_pwrite   : out   std_logic;
            i_apbbus_slv7_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv7_penable  : out   std_logic;
            i_apbbus_slv7_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv7_psel     : out   std_logic;
            i_apbbus_slv7_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv7_pwrite   : out   std_logic;
            i_apbbus_slv8_paddr    : out   std_logic_vector(31 downto 0);
            i_apbbus_slv8_penable  : out   std_logic;
            i_apbbus_slv8_prdata   : in    std_logic_vector(31 downto 0);
            i_apbbus_slv8_psel     : out   std_logic;
            i_apbbus_slv8_pwdata   : out   std_logic_vector(31 downto 0);
            i_apbbus_slv8_pwrite   : out   std_logic;
            Int4_IRQ               : in    std_logic;
            Int5_IRQ               : in    std_logic;
            Int6_IRQ               : in    std_logic;
            Interrupt_INTack       : in    std_logic;
            Interrupt_IRL          : out   std_logic_vector(3 downto 0);
            Interrupt_IRQVEC       : in    std_logic_vector(3 downto 0));
   end component;
end apbSubSystem_component;

library ieee;
use ieee.std_logic_1164.all;
library mp3decode_lib;
use mp3decode_lib.types.dac_word_type;
package audioSubSystem_component is
   component audioSubSystem
      port (i_ahbbus_slv4_haddr       : out   std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hburst      : out   std_logic_vector(2 downto 0);
            i_ahbbus_slv4_hmastlock   : out   std_logic;
            i_ahbbus_slv4_hprot       : out   std_logic_vector(3 downto 0);
            i_ahbbus_slv4_hrdata      : in    std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hready      : out   std_logic;
            i_ahbbus_slv4_hready_resp : in    std_logic;
            i_ahbbus_slv4_hresp       : in    std_logic_vector(1 downto 0);
            i_ahbbus_slv4_hsel        : out   std_logic;
            i_ahbbus_slv4_hsize       : out   std_logic_vector(2 downto 0);
            i_ahbbus_slv4_htrans      : out   std_logic_vector(1 downto 0);
            i_ahbbus_slv4_hwdata      : out   std_logic_vector(31 downto 0);
            i_ahbbus_slv4_hwrite      : out   std_logic;
            i_ahbbus_slv4_hmaster     : out   std_logic_vector(3 downto 0);
            i_ahbbus_slv4_hsplit      : in    std_logic_vector(15 downto 0);
            MirroredMaster0_haddr     : in    std_logic_vector(31 downto 0);
            MirroredMaster0_hburst    : in    std_logic_vector(2 downto 0);
            MirroredMaster0_hbusreq   : in    std_logic;
            MirroredMaster0_hgrant    : out   std_logic;
            MirroredMaster0_hlock     : in    std_logic;
            MirroredMaster0_hprot     : in    std_logic_vector(3 downto 0);
            MirroredMaster0_hrdata    : out   std_logic_vector(31 downto 0);
            MirroredMaster0_hready    : out   std_logic;
            MirroredMaster0_hresp     : out   std_logic_vector(1 downto 0);
            MirroredMaster0_hsize     : in    std_logic_vector(2 downto 0);
            MirroredMaster0_htrans    : in    std_logic_vector(1 downto 0);
            MirroredMaster0_hwdata    : in    std_logic_vector(31 downto 0);
            MirroredMaster0_hwrite    : in    std_logic;
            mp3_dma_Interrupt_IRQ     : out   std_logic;
            clk                       : in    std_logic;
            rst_an                    : in    std_logic;
            i_mp3Decode_dac_clk       : in    std_logic;
            i_mp3Decode_mp3_clk       : in    std_logic;
            i_mp3Decode_mp3_rst_an    : in    std_logic;
            i_mp3Decode_dac_data      : out   dac_word_type);
   end component;
end audioSubSystem_component;

library ieee;
use ieee.std_logic_1164.all;
package cgu_component is
   component cgu
      port (pclk    : in    std_logic;
            presetn : in    std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(11 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            clkin   : in    std_logic;
            clkout  : out   std_logic_vector(7 downto 0));
   end component;
end cgu_component;

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
package i2cSubSystem_component is
   component i2cSubSystem
      port (i2c_ambaAPB_paddr   : in    std_logic_vector(11 downto 0);
            i2c_ambaAPB_penable : in    std_logic;
            i2c_ambaAPB_prdata  : out   std_logic_vector(31 downto 0);
            i2c_ambaAPB_psel    : in    std_logic;
            i2c_ambaAPB_pwdata  : in    std_logic_vector(31 downto 0);
            i2c_ambaAPB_pwrite  : in    std_logic;
            i2c_interrupt_IRQ   : out   std_logic;
            i2c_SCL             : inout std_logic;
            i2c_SDA             : inout std_logic;
            i_i2c_ip_clk        : in    std_logic;
            i_i2c_pclk          : in    std_logic;
            i_i2c_presetn       : in    std_logic;
            i_i2c_rst_an        : in    std_logic);
   end component;
end i2cSubSystem_component;

library ieee;
use ieee.std_logic_1164.all;
package processor_component is
   component processor
      generic (local_memory_start_addr : integer := 16#1000#;
               local_memory_addr_bits  : integer := 12;
               code_file               : string := "master.tbl");
      port (rst_an  : in    std_logic;
            clk     : in    std_logic;
            clkn    : in    std_logic;
            pclk    : in    std_logic;
            presetn : in    std_logic;
            psel    : in    std_logic;
            penable : in    std_logic;
            paddr   : in    std_logic_vector(11 downto 0);
            pwrite  : in    std_logic;
            pwdata  : in    std_logic_vector(31 downto 0);
            prdata  : out   std_logic_vector(31 downto 0);
            hclk    : in    std_logic;
            hresetn : in    std_logic;
            hgrant  : in    std_logic;
            hready  : in    std_logic;
            hresp   : in    std_logic_vector(1 downto 0);
            hrdata  : in    std_logic_vector(31 downto 0);
            hbusreq : out   std_logic;
            htrans  : out   std_logic_vector(1 downto 0);
            haddr   : out   std_logic_vector(31 downto 0);
            hwrite  : out   std_logic;
            hsize   : out   std_logic_vector(2 downto 0);
            hburst  : out   std_logic_vector(2 downto 0);
            hprot   : out   std_logic_vector(3 downto 0);
            hwdata  : out   std_logic_vector(31 downto 0);
            irl     : in    std_logic_vector(3 downto 0);
            intack  : out   std_logic;
            irqvec  : out   std_logic_vector(3 downto 0);
            tck     : in    std_logic;
            ntrst   : in    std_logic;
            tms     : in    std_logic;
            tdi     : in    std_logic;
            tdo     : out   std_logic;
            SimDone : out   std_logic);
   end component;
end processor_component;

library ieee;
use ieee.std_logic_1164.all;
package rgu_component is
   component rgu
      port (pclk      : in    std_logic;
            presetn   : in    std_logic;
            psel      : in    std_logic;
            penable   : in    std_logic;
            paddr     : in    std_logic_vector(11 downto 0);
            pwrite    : in    std_logic;
            pwdata    : in    std_logic_vector(31 downto 0);
            prdata    : out   std_logic_vector(31 downto 0);
            ipclk     : in    std_logic;
            rstin_an  : in    std_logic;
            rstout_an : out   std_logic_vector(7 downto 0));
   end component;
end rgu_component;

