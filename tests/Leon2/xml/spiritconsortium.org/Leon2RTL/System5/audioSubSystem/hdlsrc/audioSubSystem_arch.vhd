
-- ****************************************************************************
-- ** Description: audioSubSystem_arch.vhd
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
library leon2ahbbus_lib;
use work.leon2Ahbbus25_component.all;
library leon2ahbram_lib;
use work.leon2AhbLiteram_component.all;
library leon2ahbrom_lib;
use work.leon2Ahbrom_component.all;
library leon2apbbus_lib;
use work.leon2Apbbus2_component.all;
library leon2apbmst_lib;
use work.leon2Apbmst_component.all;
library leon2dma_lib;
use work.leon2Dma_component.all;
library mp3decode_lib;
use work.mp3Decode_component.all;
use mp3decode_lib.types.dac_word_type;
library leon2Ahbstat_lib;
use work.leon2Ahbstat_component.all;
architecture structure of audioSubSystem is

-- synopsys translate_off
  for all: leon2Ahbbus25
    use entity leon2ahbbus_lib.leon2Ahbbus25;

  for all: leon2AhbLiteram
    use entity leon2ahbram_lib.leon2AhbLiteram;

  for all: leon2Ahbrom
    use entity leon2ahbrom_lib.leon2Ahbrom;

  for all: leon2Apbbus2
    use entity leon2apbbus_lib.leon2Apbbus2;

  for all: leon2Apbmst
    use entity leon2apbmst_lib.leon2Apbmst;

  for all: leon2Dma
    use entity leon2dma_lib.leon2Dma;

  for all: mp3Decode
    use entity mp3decode_lib.mp3Decode;

  for all: leon2Ahbstat
    use entity leon2Ahbstat_lib.leon2Ahbstat;
-- synopsys translate_on

   signal i_ahbbus25_haddr_slv0     : std_logic_vector(31 downto 0);
   signal i_ahbbus25_haddr_slv1     : std_logic_vector(31 downto 0);
   signal i_ahbbus25_haddr_slv2     : std_logic_vector(31 downto 0);
   signal i_ahbbus25_haddr_slv3     : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hburst_slv0    : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hburst_slv1    : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hburst_slv2    : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hburst_slv3    : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hgrant_mst1    : std_logic;
   signal i_ahbbus25_hmaster_slv1   : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hmaster_slv2   : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hmastlock_slv1 : std_logic;
   signal i_ahbbus25_hmastlock_slv2 : std_logic;
   signal i_ahbbus25_hprot_slv0     : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hprot_slv1     : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hprot_slv2     : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hprot_slv3     : std_logic_vector(3 downto 0);
   signal i_ahbbus25_hrdata_mst1    : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hready_mst1    : std_logic;
   signal i_ahbbus25_hreadyin_slv0  : std_logic;
   signal i_ahbbus25_hreadyin_slv1  : std_logic;
   signal i_ahbbus25_hreadyin_slv2  : std_logic;
   signal i_ahbbus25_hreadyin_slv3  : std_logic;
   signal i_ahbbus25_hresp_mst1     : std_logic_vector(1 downto 0);
   signal i_ahbbus25_hsel_slv0      : std_logic;
   signal i_ahbbus25_hsel_slv1      : std_logic;
   signal i_ahbbus25_hsel_slv2      : std_logic;
   signal i_ahbbus25_hsel_slv3      : std_logic;
   signal i_ahbbus25_hsize_slv0     : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hsize_slv1     : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hsize_slv2     : std_logic_vector(2 downto 0);
   signal i_ahbbus25_hsize_slv3     : std_logic_vector(2 downto 0);
   signal i_ahbbus25_htrans_slv0    : std_logic_vector(1 downto 0);
   signal i_ahbbus25_htrans_slv1    : std_logic_vector(1 downto 0);
   signal i_ahbbus25_htrans_slv2    : std_logic_vector(1 downto 0);
   signal i_ahbbus25_htrans_slv3    : std_logic_vector(1 downto 0);
   signal i_ahbbus25_hwdata_slv0    : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hwdata_slv1    : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hwdata_slv2    : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hwdata_slv3    : std_logic_vector(31 downto 0);
   signal i_ahbbus25_hwrite_slv0    : std_logic;
   signal i_ahbbus25_hwrite_slv1    : std_logic;
   signal i_ahbbus25_hwrite_slv2    : std_logic;
   signal i_ahbbus25_hwrite_slv3    : std_logic;
   signal i_ahbram_hrdata_s         : std_logic_vector(31 downto 0);
   signal i_ahbram_hreadyo_s        : std_logic;
   signal i_ahbram_hresp_s          : std_logic_vector(1 downto 0);
   signal i_ahbram_hsplit_s         : std_logic_vector(15 downto 0);
   signal i_ahbrom_hrdata_s         : std_logic_vector(31 downto 0);
   signal i_ahbrom_hreadyo_s        : std_logic;
   signal i_ahbrom_hresp_s          : std_logic_vector(1 downto 0);
   signal i_ahbrom_hsplit_s         : std_logic_vector(15 downto 0);
   signal i_apbbus1_paddr_slv0      : std_logic_vector(31 downto 0);
   signal i_apbbus1_penable_slv0    : std_logic;
   signal i_apbbus1_prdata_mst      : std_logic_vector(31 downto 0);
   signal i_apbbus1_psel_slv0       : std_logic;
   signal i_apbbus1_pwdata_slv0     : std_logic_vector(31 downto 0);
   signal i_apbbus1_pwrite_slv0     : std_logic;
   signal i_apbbus1_paddr_slv1      : std_logic_vector(31 downto 0);
   signal i_apbbus1_penable_slv1    : std_logic;
   signal i_apbbus1_psel_slv1       : std_logic;
   signal i_apbbus1_pwdata_slv1     : std_logic_vector(31 downto 0);
   signal i_apbbus1_pwrite_slv1     : std_logic;
   signal i_apbmst_hrdata           : std_logic_vector(31 downto 0);
   signal i_apbmst_hreadyout        : std_logic;
   signal i_apbmst_hresp            : std_logic_vector(1 downto 0);
   signal i_apbmst_paddr            : std_logic_vector(31 downto 0);
   signal i_apbmst_penable          : std_logic;
   signal i_apbmst_psel             : std_logic;
   signal i_apbmst_pwdata           : std_logic_vector(31 downto 0);
   signal i_apbmst_pwrite           : std_logic;
   signal i_dma_haddr               : std_logic_vector(31 downto 0);
   signal i_dma_hburst              : std_logic_vector(2 downto 0);
   signal i_dma_hbusreq             : std_logic;
   signal i_dma_hlock               : std_logic;
   signal i_dma_hprot               : std_logic_vector(3 downto 0);
   signal i_dma_hsize               : std_logic_vector(2 downto 0);
   signal i_dma_htrans              : std_logic_vector(1 downto 0);
   signal i_dma_hwdata              : std_logic_vector(31 downto 0);
   signal i_dma_hwrite              : std_logic;
   signal i_dma_prdata              : std_logic_vector(31 downto 0);
   signal i_mon_prdata              : std_logic_vector(31 downto 0);
   signal i_mp3Decode_hrdata        : std_ulogic_vector(31 downto 0);
   signal i_mp3Decode_hreadyo       : std_logic;
   signal i_mp3Decode_hresp         : std_ulogic_vector(1 downto 0);
   signal logic_zero                : std_logic_vector(15 downto 0);
begin

   i_ahbbus25 : leon2Ahbbus25
   generic map(start_addr_slv0 => 36864,
               range_slv0      => 131072,
               split_slv0      => FALSE,
               mst_access_slv0 => 3,
               start_addr_slv1 => 32768,
               range_slv1      => 1048576,
               split_slv1      => FALSE,
               mst_access_slv1 => 3,
               start_addr_slv2 => 45056,
               range_slv2      => 1048576,
               split_slv2      => FALSE,
               mst_access_slv2 => 3,
               start_addr_slv3 => 40960,
               range_slv3      => 4096,
               split_slv3      => FALSE,
               start_addr_slv4 => 0,
               range_slv4      => 2147483648,
               split_slv4      => FALSE,
               mst_access_slv4 => 3,
               defmast         => 1)
   port map(rst            => rst_an,
            clk            => clk,
	    remap	   => logic_zero(0),
            hgrant_mst0    => MirroredMaster0_hgrant,
            hready_mst0    => MirroredMaster0_hready,
            hresp_mst0     => MirroredMaster0_hresp,
            hrdata_mst0    => MirroredMaster0_hrdata,
            hgrant_mst1    => i_ahbbus25_hgrant_mst1,
            hready_mst1    => i_ahbbus25_hready_mst1,
            hresp_mst1     => i_ahbbus25_hresp_mst1,
            hrdata_mst1    => i_ahbbus25_hrdata_mst1,
            hbusreq_mst0   => MirroredMaster0_hbusreq,
            hlock_mst0     => MirroredMaster0_hlock,
            htrans_mst0    => MirroredMaster0_htrans,
            haddr_mst0     => MirroredMaster0_haddr,
            hwrite_mst0    => MirroredMaster0_hwrite,
            hsize_mst0     => MirroredMaster0_hsize,
            hburst_mst0    => MirroredMaster0_hburst,
            hprot_mst0     => MirroredMaster0_hprot,
            hwdata_mst0    => MirroredMaster0_hwdata,
            hbusreq_mst1   => i_dma_hbusreq,
            hlock_mst1     => i_dma_hlock,
            htrans_mst1    => i_dma_htrans,
            haddr_mst1     => i_dma_haddr,
            hwrite_mst1    => i_dma_hwrite,
            hsize_mst1     => i_dma_hsize,
            hburst_mst1    => i_dma_hburst,
            hprot_mst1     => i_dma_hprot,
            hwdata_mst1    => i_dma_hwdata,
            hsel_slv0      => i_ahbbus25_hsel_slv0,
            haddr_slv0     => i_ahbbus25_haddr_slv0,
            hwrite_slv0    => i_ahbbus25_hwrite_slv0,
            htrans_slv0    => i_ahbbus25_htrans_slv0,
            hsize_slv0     => i_ahbbus25_hsize_slv0,
            hburst_slv0    => i_ahbbus25_hburst_slv0,
            hwdata_slv0    => i_ahbbus25_hwdata_slv0,
            hprot_slv0     => i_ahbbus25_hprot_slv0,
            hreadyin_slv0  => i_ahbbus25_hreadyin_slv0,
            hmaster_slv0   => open,
            hmastlock_slv0 => open,
            hreadyout_slv0 => i_apbmst_hreadyout,
            hresp_slv0     => i_apbmst_hresp,
            hrdata_slv0    => i_apbmst_hrdata,
            hsplit_slv0    => logic_zero(15 downto 0),
            hsel_slv1      => i_ahbbus25_hsel_slv1,
            haddr_slv1     => i_ahbbus25_haddr_slv1,
            hwrite_slv1    => i_ahbbus25_hwrite_slv1,
            htrans_slv1    => i_ahbbus25_htrans_slv1,
            hsize_slv1     => i_ahbbus25_hsize_slv1,
            hburst_slv1    => i_ahbbus25_hburst_slv1,
            hwdata_slv1    => i_ahbbus25_hwdata_slv1,
            hprot_slv1     => i_ahbbus25_hprot_slv1,
            hreadyin_slv1  => i_ahbbus25_hreadyin_slv1,
            hmaster_slv1   => i_ahbbus25_hmaster_slv1,
            hmastlock_slv1 => i_ahbbus25_hmastlock_slv1,
            hreadyout_slv1 => i_ahbrom_hreadyo_s,
            hresp_slv1     => i_ahbrom_hresp_s,
            hrdata_slv1    => i_ahbrom_hrdata_s,
            hsplit_slv1    => i_ahbrom_hsplit_s,
            hsel_slv2      => i_ahbbus25_hsel_slv2,
            haddr_slv2     => i_ahbbus25_haddr_slv2,
            hwrite_slv2    => i_ahbbus25_hwrite_slv2,
            htrans_slv2    => i_ahbbus25_htrans_slv2,
            hsize_slv2     => i_ahbbus25_hsize_slv2,
            hburst_slv2    => i_ahbbus25_hburst_slv2,
            hwdata_slv2    => i_ahbbus25_hwdata_slv2,
            hprot_slv2     => i_ahbbus25_hprot_slv2,
            hreadyin_slv2  => i_ahbbus25_hreadyin_slv2,
            hmaster_slv2   => i_ahbbus25_hmaster_slv2,
            hmastlock_slv2 => i_ahbbus25_hmastlock_slv2,
            hreadyout_slv2 => i_ahbram_hreadyo_s,
            hresp_slv2     => i_ahbram_hresp_s,
            hrdata_slv2    => i_ahbram_hrdata_s,
            hsplit_slv2    => logic_zero(15 downto 0),
            hsel_slv3      => i_ahbbus25_hsel_slv3,
            haddr_slv3     => i_ahbbus25_haddr_slv3,
            hwrite_slv3    => i_ahbbus25_hwrite_slv3,
            htrans_slv3    => i_ahbbus25_htrans_slv3,
            hsize_slv3     => i_ahbbus25_hsize_slv3,
            hburst_slv3    => i_ahbbus25_hburst_slv3,
            hwdata_slv3    => i_ahbbus25_hwdata_slv3,
            hprot_slv3     => i_ahbbus25_hprot_slv3,
            hreadyin_slv3  => i_ahbbus25_hreadyin_slv3,
            hmaster_slv3   => open,
            hmastlock_slv3 => open,
            hreadyout_slv3 => i_mp3Decode_hreadyo,
            hresp_slv3     => std_logic_vector(i_mp3Decode_hresp),
            hrdata_slv3    => std_logic_vector(i_mp3Decode_hrdata),
            hsplit_slv3    => logic_zero(15 downto 0),
            hsel_slv4      => i_ahbbus_slv4_hsel,
            haddr_slv4     => i_ahbbus_slv4_haddr,
            hwrite_slv4    => i_ahbbus_slv4_hwrite,
            htrans_slv4    => i_ahbbus_slv4_htrans,
            hsize_slv4     => i_ahbbus_slv4_hsize,
            hburst_slv4    => i_ahbbus_slv4_hburst,
            hwdata_slv4    => i_ahbbus_slv4_hwdata,
            hprot_slv4     => i_ahbbus_slv4_hprot,
            hreadyin_slv4  => i_ahbbus_slv4_hready,
            hmaster_slv4   => i_ahbbus_slv4_hmaster,
            hmastlock_slv4 => i_ahbbus_slv4_hmastlock,
            hreadyout_slv4 => i_ahbbus_slv4_hready_resp,
            hresp_slv4     => i_ahbbus_slv4_hresp,
            hrdata_slv4    => i_ahbbus_slv4_hrdata,
            hsplit_slv4    => i_ahbbus_slv4_hsplit);

   i_ahbram_hresp_s(1) <= '0';

   i_ahbram : leon2AhbLiteram
   generic map(abits => 10)
   port map(clk       => clk,
            rst       => rst_an,
            hsel_s    => i_ahbbus25_hsel_slv2,
            haddr_s   => i_ahbbus25_haddr_slv2,
            hwrite_s  => i_ahbbus25_hwrite_slv2,
            htrans_s  => i_ahbbus25_htrans_slv2,
            hsize_s   => i_ahbbus25_hsize_slv2,
            hburst_s  => i_ahbbus25_hburst_slv2,
            hwdata_s  => i_ahbbus25_hwdata_slv2,
            hprot_s   => i_ahbbus25_hprot_slv2,
            hreadyi_s => i_ahbbus25_hreadyin_slv2,
            hmastlock_s => i_ahbbus25_hmastlock_slv2,
            hreadyo_s => i_ahbram_hreadyo_s,
            hresp_s   => i_ahbram_hresp_s(0),
            hrdata_s  => i_ahbram_hrdata_s);

   i_ahbrom : leon2Ahbrom
   generic map(abits => 10)
   port map(clk         => clk,
            rst         => rst_an,
            hsel_s      => i_ahbbus25_hsel_slv1,
            haddr_s     => i_ahbbus25_haddr_slv1,
            hwrite_s    => i_ahbbus25_hwrite_slv1,
            htrans_s    => i_ahbbus25_htrans_slv1,
            hsize_s     => i_ahbbus25_hsize_slv1,
            hburst_s    => i_ahbbus25_hburst_slv1,
            hwdata_s    => i_ahbbus25_hwdata_slv1,
            hprot_s     => i_ahbbus25_hprot_slv1,
            hreadyi_s   => i_ahbbus25_hreadyin_slv1,
            hmaster_s   => i_ahbbus25_hmaster_slv1,
            hmastlock_s => i_ahbbus25_hmastlock_slv1,
            hreadyo_s   => i_ahbrom_hreadyo_s,
            hresp_s     => i_ahbrom_hresp_s,
            hrdata_s    => i_ahbrom_hrdata_s,
            hsplit_s    => i_ahbrom_hsplit_s);

   i_apbbus2 : leon2Apbbus2
   generic map(start_addr_slv0 => 0,
               range_slv0      => 4096,
	       start_addr_slv1 => 4096,
	       range_slv1      => 4096)
   port map(psel_mst     => i_apbmst_psel,
            penable_mst  => i_apbmst_penable,
            paddr_mst    => i_apbmst_paddr,
            pwrite_mst   => i_apbmst_pwrite,
            pwdata_mst   => i_apbmst_pwdata,
            prdata_mst   => i_apbbus1_prdata_mst,
            psel_slv0    => i_apbbus1_psel_slv0,
            penable_slv0 => i_apbbus1_penable_slv0,
            paddr_slv0   => i_apbbus1_paddr_slv0,
            pwrite_slv0  => i_apbbus1_pwrite_slv0,
            pwdata_slv0  => i_apbbus1_pwdata_slv0,
            prdata_slv0  => i_dma_prdata,
            psel_slv1    => i_apbbus1_psel_slv1,
            penable_slv1 => i_apbbus1_penable_slv1,
            paddr_slv1   => i_apbbus1_paddr_slv1,
            pwrite_slv1  => i_apbbus1_pwrite_slv1,
            pwdata_slv1  => i_apbbus1_pwdata_slv1,
            prdata_slv1  => i_mon_prdata);

   i_apbmst : leon2Apbmst
   port map(clk       => clk,
            rst       => rst_an,
            hsize     => i_ahbbus25_hsize_slv0,
            haddr     => i_ahbbus25_haddr_slv0,
            htrans    => i_ahbbus25_htrans_slv0,
            hwrite    => i_ahbbus25_hwrite_slv0,
            hwdata    => i_ahbbus25_hwdata_slv0,
            hreadyin  => i_ahbbus25_hreadyin_slv0,
            hsel      => i_ahbbus25_hsel_slv0,
            hrdata    => i_apbmst_hrdata,
            hreadyout => i_apbmst_hreadyout,
            hresp     => i_apbmst_hresp,
            hprot     => i_ahbbus25_hprot_slv0,
            hburst    => i_ahbbus25_hburst_slv0,
            prdata    => i_apbbus1_prdata_mst,
            pwdata    => i_apbmst_pwdata,
            penable   => i_apbmst_penable,
            paddr     => i_apbmst_paddr,
            pwrite    => i_apbmst_pwrite,
            psel      => i_apbmst_psel);

   i_dma : leon2Dma
   port map(clk     => clk,
            rst     => rst_an,
            hready  => i_ahbbus25_hready_mst1,
            hrdata  => i_ahbbus25_hrdata_mst1,
            hresp   => i_ahbbus25_hresp_mst1,
            hgrant  => i_ahbbus25_hgrant_mst1,
            haddr   => i_dma_haddr,
            htrans  => i_dma_htrans,
            hwrite  => i_dma_hwrite,
            hsize   => i_dma_hsize,
            hburst  => i_dma_hburst,
            hprot   => i_dma_hprot,
            hwdata  => i_dma_hwdata,
            hbusreq => i_dma_hbusreq,
            hlock   => i_dma_hlock,
            psel    => i_apbbus1_psel_slv0,
            penable => i_apbbus1_penable_slv0,
            paddr   => i_apbbus1_paddr_slv0,
            pwrite  => i_apbbus1_pwrite_slv0,
            pwdata  => i_apbbus1_pwdata_slv0,
            prdata  => i_dma_prdata,
            dirq    => mp3_dma_Interrupt_IRQ);

   i_ahbmon : leon2Ahbstat
   port map(clk         => clk,
            rst         => rst_an,
            hresp       => i_ahbrom_hresp_s,
            hwrite      => i_ahbbus25_hwrite_slv1,
            hsize       => i_ahbbus25_hsize_slv1,
            haddr       => i_ahbbus25_haddr_slv1,
            hready      => i_ahbrom_hreadyo_s,
            hmaster     => i_ahbbus25_hmaster_slv1,
            psel    => i_apbbus1_psel_slv1,
            penable => i_apbbus1_penable_slv1,
            paddr   => i_apbbus1_paddr_slv1,
            pwrite  => i_apbbus1_pwrite_slv1,
            pwdata  => i_apbbus1_pwdata_slv1,
            prdata  => i_mon_prdata,
            ahberr    => open);

   i_mp3Decode : mp3Decode
   port map(hclk       => clk,
            hresetn    => rst_an,
            hsel       => i_ahbbus25_hsel_slv3,
            haddr      => std_ulogic_vector(i_ahbbus25_haddr_slv3(11 downto 0)),
            hwrite     => i_ahbbus25_hwrite_slv3,
            htrans     => std_ulogic_vector(i_ahbbus25_htrans_slv3),
            hsize      => std_ulogic_vector(i_ahbbus25_hsize_slv3),
            hburst     => std_ulogic_vector(i_ahbbus25_hburst_slv3),
            hwdata     => std_ulogic_vector(i_ahbbus25_hwdata_slv3),
            hprot      => std_ulogic_vector(i_ahbbus25_hprot_slv3),
            hreadyi    => i_ahbbus25_hreadyin_slv3,
            hreadyo    => i_mp3Decode_hreadyo,
            hresp      => i_mp3Decode_hresp,
            hrdata     => i_mp3Decode_hrdata,
            dac_data   => i_mp3Decode_dac_data,
            dac_clk    => i_mp3Decode_dac_clk,
            mp3_clk    => i_mp3Decode_mp3_clk,
            mp3_rst_an => i_mp3Decode_mp3_rst_an);


   logic_zero                <= ( others => '0');
   -- Note: i_ahbbus25_haddr_slv3(31 downto 12) is open

end structure;
