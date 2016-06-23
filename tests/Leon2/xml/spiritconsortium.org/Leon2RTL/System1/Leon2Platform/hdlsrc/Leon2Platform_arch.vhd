
-- ****************************************************************************
-- ** Description: Leon2Platform_arch.vhd
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
use work.leon2Ahbbus22_component.all;
library leon2ahbram_lib;
use work.leon2Ahbram_component.all;
use work.apbSubSystem_component.all;
library cgu_lib;
use work.cgu_component.all;
library leon2dma_lib;
use work.leon2Dma_component.all;
library processor_lib;
use work.processor_component.all;
library rgu_lib;
use work.rgu_component.all;
architecture structure of Leon2Platform is

-- synopsys translate_off
  for all: leon2Ahbbus22
    use entity leon2ahbbus_lib.leon2Ahbbus22;

  for all: leon2Ahbram
    use entity leon2ahbram_lib.leon2Ahbram;

  for all: apbSubSystem
    use entity work.apbSubSystem;

  for all: cgu
    use entity cgu_lib.cgu;

  for all: leon2Dma
    use entity leon2dma_lib.leon2Dma;

  for all: processor
    use entity processor_lib.processor;

  for all: rgu
    use entity rgu_lib.rgu;
-- synopsys translate_on

   signal uahbbus_haddr_slv0                   : std_logic_vector(31 downto 0);
   signal uahbbus_haddr_slv1                   : std_logic_vector(31 downto 0);
   signal uahbbus_hburst_slv0                  : std_logic_vector(2 downto 0);
   signal uahbbus_hburst_slv1                  : std_logic_vector(2 downto 0);
   signal uahbbus_hgrant_mst0                  : std_logic;
   signal uahbbus_hgrant_mst1                  : std_logic;
   signal uahbbus_hprot_slv0                   : std_logic_vector(3 downto 0);
   signal uahbbus_hprot_slv1                   : std_logic_vector(3 downto 0);
   signal uahbbus_hrdata_mst0                  : std_logic_vector(31 downto 0);
   signal uahbbus_hrdata_mst1                  : std_logic_vector(31 downto 0);
   signal uahbbus_hready_mst0                  : std_logic;
   signal uahbbus_hmastlock_slv0               : std_logic;
   signal uahbbus_hready_mst1                  : std_logic;
   signal uahbbus_hreadyin_slv0                : std_logic;
   signal uahbbus_hreadyin_slv1                : std_logic;
   signal uahbbus_hresp_mst0                   : std_logic_vector(1 downto 0);
   signal uahbbus_hresp_mst1                   : std_logic_vector(1 downto 0);
   signal uahbbus_hsel_slv0                    : std_logic;
   signal uahbbus_hsel_slv1                    : std_logic;
   signal uahbbus_hsize_slv0                   : std_logic_vector(2 downto 0);
   signal uahbbus_hsize_slv1                   : std_logic_vector(2 downto 0);
   signal uahbbus_htrans_slv0                  : std_logic_vector(1 downto 0);
   signal uahbbus_htrans_slv1                  : std_logic_vector(1 downto 0);
   signal uahbbus_hwdata_slv0                  : std_logic_vector(31 downto 0);
   signal uahbbus_hwdata_slv1                  : std_logic_vector(31 downto 0);
   signal uahbbus_hwrite_slv0                  : std_logic;
   signal uahbbus_hwrite_slv1                  : std_logic;
   signal uahbram_hrdata_s                     : std_logic_vector(31 downto 0);
   signal uahbram_hreadyo_s                    : std_logic;
   signal uahbram_hresp_s                      : std_logic_vector(1 downto 0);
   signal uahbram_hsplit_s                     : std_logic_vector(15 downto 0);
   signal uapbSubSystem_Interrupt_IRL          : std_logic_vector(3 downto 0);
   signal uapbSubSystem_ex_ambaAHB_hrdata      : std_logic_vector(31 downto 0);
   signal uapbSubSystem_ex_ambaAHB_hready_resp : std_logic;
   signal uapbSubSystem_ex_ambaAHB_hresp       : std_logic_vector(1 downto 0);
   signal uapbSubSystem_i_apbbus_slv4_paddr    : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv4_penable  : std_logic;
   signal uapbSubSystem_i_apbbus_slv4_psel     : std_logic;
   signal uapbSubSystem_i_apbbus_slv4_pwdata   : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv4_pwrite   : std_logic;
   signal uapbSubSystem_i_apbbus_slv5_paddr    : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv5_penable  : std_logic;
   signal uapbSubSystem_i_apbbus_slv5_psel     : std_logic;
   signal uapbSubSystem_i_apbbus_slv5_pwdata   : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv5_pwrite   : std_logic;
   signal uapbSubSystem_i_apbbus_slv6_paddr    : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv6_penable  : std_logic;
   signal uapbSubSystem_i_apbbus_slv6_psel     : std_logic;
   signal uapbSubSystem_i_apbbus_slv6_pwdata   : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv6_pwrite   : std_logic;
   signal uapbSubSystem_i_apbbus_slv7_paddr    : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv7_penable  : std_logic;
   signal uapbSubSystem_i_apbbus_slv7_psel     : std_logic;
   signal uapbSubSystem_i_apbbus_slv7_pwdata   : std_logic_vector(31 downto 0);
   signal uapbSubSystem_i_apbbus_slv7_pwrite   : std_logic;
   signal ucgu_clkout                          : std_logic_vector(7 downto 0);
   signal ucgu_prdata                          : std_logic_vector(31 downto 0);
   signal udma_haddr                           : std_logic_vector(31 downto 0);
   signal udma_hburst                          : std_logic_vector(2 downto 0);
   signal udma_hbusreq                         : std_logic;
   signal udma_hlock                           : std_logic;
   signal udma_hprot                           : std_logic_vector(3 downto 0);
   signal udma_hsize                           : std_logic_vector(2 downto 0);
   signal udma_htrans                          : std_logic_vector(1 downto 0);
   signal udma_hwdata                          : std_logic_vector(31 downto 0);
   signal udma_hwrite                          : std_logic;
   signal udma_prdata                          : std_logic_vector(31 downto 0);
   signal uproc_haddr                          : std_logic_vector(31 downto 0);
   signal uproc_hburst                         : std_logic_vector(2 downto 0);
   signal uproc_hbusreq                        : std_logic;
   signal uproc_hprot                          : std_logic_vector(3 downto 0);
   signal uproc_hsize                          : std_logic_vector(2 downto 0);
   signal uproc_htrans                         : std_logic_vector(1 downto 0);
   signal uproc_hwdata                         : std_logic_vector(31 downto 0);
   signal uproc_hwrite                         : std_logic;
   signal uproc_intack                         : std_logic;
   signal uproc_irqvec                         : std_logic_vector(3 downto 0);
   signal uproc_prdata                         : std_logic_vector(31 downto 0);
   signal urgu_prdata                          : std_logic_vector(31 downto 0);
   signal urgu_rstout_an                       : std_logic_vector(7 downto 0);
   signal logic_zero                           : std_logic_vector(15 downto 0);
begin

   uahbbus : leon2Ahbbus22
   generic map(start_addr_slv0 => 0,
               restart_addr_slv0 => 0,
               range_slv0      => 1048576,
               split_slv0      => FALSE,
               mst_access_slv0 => 3,
               start_addr_slv1 => 12288,
               restart_addr_slv1 => 12288,
               range_slv1      => 36864,
               split_slv1      => FALSE,
               mst_access_slv1 => 3,
               defmast         => 1)
   port map(rst            => urgu_rstout_an(0),
            clk            => ucgu_clkout(0),
            remap          => logic_zero(0),
            hgrant_mst0    => uahbbus_hgrant_mst0,
            hready_mst0    => uahbbus_hready_mst0,
            hresp_mst0     => uahbbus_hresp_mst0,
            hrdata_mst0    => uahbbus_hrdata_mst0,
            hgrant_mst1    => uahbbus_hgrant_mst1,
            hready_mst1    => uahbbus_hready_mst1,
            hresp_mst1     => uahbbus_hresp_mst1,
            hrdata_mst1    => uahbbus_hrdata_mst1,
            hbusreq_mst0   => uproc_hbusreq,
            hlock_mst0     => logic_zero(0),
            htrans_mst0    => uproc_htrans,
            haddr_mst0     => uproc_haddr,
            hwrite_mst0    => uproc_hwrite,
            hsize_mst0     => uproc_hsize,
            hburst_mst0    => uproc_hburst,
            hprot_mst0     => uproc_hprot,
            hwdata_mst0    => uproc_hwdata,
            hbusreq_mst1   => udma_hbusreq,
            hlock_mst1     => udma_hlock,
            htrans_mst1    => udma_htrans,
            haddr_mst1     => udma_haddr,
            hwrite_mst1    => udma_hwrite,
            hsize_mst1     => udma_hsize,
            hburst_mst1    => udma_hburst,
            hprot_mst1     => udma_hprot,
            hwdata_mst1    => udma_hwdata,
            hsel_slv0      => uahbbus_hsel_slv0,
            haddr_slv0     => uahbbus_haddr_slv0,
            hwrite_slv0    => uahbbus_hwrite_slv0,
            htrans_slv0    => uahbbus_htrans_slv0,
            hsize_slv0     => uahbbus_hsize_slv0,
            hburst_slv0    => uahbbus_hburst_slv0,
            hwdata_slv0    => uahbbus_hwdata_slv0,
            hprot_slv0     => uahbbus_hprot_slv0,
            hreadyin_slv0  => uahbbus_hreadyin_slv0,
            hmaster_slv0   => open,
            hmastlock_slv0 => uahbbus_hmastlock_slv0,
            hsel_slv1      => uahbbus_hsel_slv1,
            haddr_slv1     => uahbbus_haddr_slv1,
            hwrite_slv1    => uahbbus_hwrite_slv1,
            htrans_slv1    => uahbbus_htrans_slv1,
            hsize_slv1     => uahbbus_hsize_slv1,
            hburst_slv1    => uahbbus_hburst_slv1,
            hwdata_slv1    => uahbbus_hwdata_slv1,
            hprot_slv1     => uahbbus_hprot_slv1,
            hreadyin_slv1  => uahbbus_hreadyin_slv1,
            hmaster_slv1   => open,
            hmastlock_slv1 => open,
            hreadyout_slv0 => uahbram_hreadyo_s,
            hresp_slv0     => uahbram_hresp_s,
            hrdata_slv0    => uahbram_hrdata_s,
            hsplit_slv0    => uahbram_hsplit_s,
            hreadyout_slv1 => uapbSubSystem_ex_ambaAHB_hready_resp,
            hresp_slv1     => uapbSubSystem_ex_ambaAHB_hresp,
            hrdata_slv1    => uapbSubSystem_ex_ambaAHB_hrdata,
            hsplit_slv1    => logic_zero(15 downto 0));

   uahbram : leon2Ahbram
   generic map(abits => 20)
   port map(clk       => ucgu_clkout(0),
            rst       => urgu_rstout_an(0),
            hsel_s    => uahbbus_hsel_slv0,
            haddr_s   => uahbbus_haddr_slv0,
            hwrite_s  => uahbbus_hwrite_slv0,
            htrans_s  => uahbbus_htrans_slv0,
            hsize_s   => uahbbus_hsize_slv0,
            hburst_s  => uahbbus_hburst_slv0,
            hwdata_s  => uahbbus_hwdata_slv0,
            hprot_s   => uahbbus_hprot_slv0,
            hreadyi_s => uahbbus_hreadyin_slv0,
            hmastlock_s => uahbbus_hmastlock_slv0,
            hmaster_s => logic_zero(3 downto 0),
            hreadyo_s => uahbram_hreadyo_s,
            hresp_s   => uahbram_hresp_s,
            hrdata_s  => uahbram_hrdata_s,
            hsplit_s  => uahbram_hsplit_s);

   uapbSubSystem : apbSubSystem
   port map(clk            => ucgu_clkout(0),
            rst_an       => urgu_rstout_an(0),
            ex_ambaAHB_haddr       => uahbbus_haddr_slv1,
            ex_ambaAHB_hburst      => uahbbus_hburst_slv1,
            ex_ambaAHB_hprot       => uahbbus_hprot_slv1,
            ex_ambaAHB_hrdata      => uapbSubSystem_ex_ambaAHB_hrdata,
            ex_ambaAHB_hready      => uahbbus_hreadyin_slv1,
            ex_ambaAHB_hready_resp => uapbSubSystem_ex_ambaAHB_hready_resp,
            ex_ambaAHB_hresp       => uapbSubSystem_ex_ambaAHB_hresp,
            ex_ambaAHB_hsel        => uahbbus_hsel_slv1,
            ex_ambaAHB_hsize       => uahbbus_hsize_slv1,
            ex_ambaAHB_htrans      => uahbbus_htrans_slv1,
            ex_ambaAHB_hwdata      => uahbbus_hwdata_slv1,
            ex_ambaAHB_hwrite      => uahbbus_hwrite_slv1,
            i_apbbus_slv4_paddr    => uapbSubSystem_i_apbbus_slv4_paddr,
            i_apbbus_slv4_penable  => uapbSubSystem_i_apbbus_slv4_penable,
            i_apbbus_slv4_prdata   => ucgu_prdata,
            i_apbbus_slv4_psel     => uapbSubSystem_i_apbbus_slv4_psel,
            i_apbbus_slv4_pwdata   => uapbSubSystem_i_apbbus_slv4_pwdata,
            i_apbbus_slv4_pwrite   => uapbSubSystem_i_apbbus_slv4_pwrite,
            i_apbbus_slv5_paddr    => uapbSubSystem_i_apbbus_slv5_paddr,
            i_apbbus_slv5_penable  => uapbSubSystem_i_apbbus_slv5_penable,
            i_apbbus_slv5_prdata   => urgu_prdata,
            i_apbbus_slv5_psel     => uapbSubSystem_i_apbbus_slv5_psel,
            i_apbbus_slv5_pwdata   => uapbSubSystem_i_apbbus_slv5_pwdata,
            i_apbbus_slv5_pwrite   => uapbSubSystem_i_apbbus_slv5_pwrite,
            i_apbbus_slv6_paddr    => uapbSubSystem_i_apbbus_slv6_paddr,
            i_apbbus_slv6_penable  => uapbSubSystem_i_apbbus_slv6_penable,
            i_apbbus_slv6_prdata   => uproc_prdata,
            i_apbbus_slv6_psel     => uapbSubSystem_i_apbbus_slv6_psel,
            i_apbbus_slv6_pwdata   => uapbSubSystem_i_apbbus_slv6_pwdata,
            i_apbbus_slv6_pwrite   => uapbSubSystem_i_apbbus_slv6_pwrite,
            i_apbbus_slv7_paddr    => uapbSubSystem_i_apbbus_slv7_paddr,
            i_apbbus_slv7_penable  => uapbSubSystem_i_apbbus_slv7_penable,
            i_apbbus_slv7_prdata   => udma_prdata,
            i_apbbus_slv7_psel     => uapbSubSystem_i_apbbus_slv7_psel,
            i_apbbus_slv7_pwdata   => uapbSubSystem_i_apbbus_slv7_pwdata,
            i_apbbus_slv7_pwrite   => uapbSubSystem_i_apbbus_slv7_pwrite,
            Interrupt_INTack       => uproc_intack,
            Interrupt_IRL          => uapbSubSystem_Interrupt_IRL,
            Interrupt_IRQVEC       => uproc_irqvec);

   ucgu : cgu
   port map(pclk    => ucgu_clkout(0),
            presetn => urgu_rstout_an(0),
            psel    => uapbSubSystem_i_apbbus_slv4_psel,
            penable => uapbSubSystem_i_apbbus_slv4_penable,
            paddr   => uapbSubSystem_i_apbbus_slv4_paddr(11 downto 0),
            pwrite  => uapbSubSystem_i_apbbus_slv4_pwrite,
            pwdata  => uapbSubSystem_i_apbbus_slv4_pwdata,
            prdata  => ucgu_prdata,
            clkin   => clkin,
            clkout  => ucgu_clkout);

   udma : leon2Dma
   port map(clk     => ucgu_clkout(0),
            rst     => urgu_rstout_an(0),
            hready  => uahbbus_hready_mst1,
            hrdata  => uahbbus_hrdata_mst1,
            hresp   => uahbbus_hresp_mst1,
            hgrant  => uahbbus_hgrant_mst1,
            haddr   => udma_haddr,
            htrans  => udma_htrans,
            hwrite  => udma_hwrite,
            hsize   => udma_hsize,
            hburst  => udma_hburst,
            hprot   => udma_hprot,
            hwdata  => udma_hwdata,
            hbusreq => udma_hbusreq,
            hlock   => udma_hlock,
            psel    => uapbSubSystem_i_apbbus_slv7_psel,
            penable => uapbSubSystem_i_apbbus_slv7_penable,
            paddr   => uapbSubSystem_i_apbbus_slv7_paddr,
            pwrite  => uapbSubSystem_i_apbbus_slv7_pwrite,
            pwdata  => uapbSubSystem_i_apbbus_slv7_pwdata,
            prdata  => udma_prdata,
            dirq    => open);

   uproc : processor
   generic map(local_memory_start_addr => 16#1000#,
               local_memory_addr_bits  => 12)
   port map(rst_an  => urgu_rstout_an(1),
            clk     => ucgu_clkout(2),
            clkn    => logic_zero(0),
            pclk    => ucgu_clkout(0),
            presetn => urgu_rstout_an(0),
            psel    => uapbSubSystem_i_apbbus_slv6_psel,
            penable => uapbSubSystem_i_apbbus_slv6_penable,
            paddr   => uapbSubSystem_i_apbbus_slv6_paddr(11 downto 0),
            pwrite  => uapbSubSystem_i_apbbus_slv6_pwrite,
            pwdata  => uapbSubSystem_i_apbbus_slv6_pwdata,
            prdata  => uproc_prdata,
            hclk    => ucgu_clkout(0),
            hresetn => urgu_rstout_an(0),
            hgrant  => uahbbus_hgrant_mst0,
            hready  => uahbbus_hready_mst0,
            hresp   => uahbbus_hresp_mst0,
            hrdata  => uahbbus_hrdata_mst0,
            hbusreq => uproc_hbusreq,
            htrans  => uproc_htrans,
            haddr   => uproc_haddr,
            hwrite  => uproc_hwrite,
            hsize   => uproc_hsize,
            hburst  => uproc_hburst,
            hprot   => uproc_hprot,
            hwdata  => uproc_hwdata,
            irl     => uapbSubSystem_Interrupt_IRL,
            intack  => uproc_intack,
            irqvec  => uproc_irqvec,
            tck     => logic_zero(0),
            ntrst   => logic_zero(0),
            tms     => logic_zero(0),
            tdi     => logic_zero(0),
            tdo     => open,
            SimDone => SimDone);

   urgu : rgu
   port map(pclk      => ucgu_clkout(0),
            presetn   => urgu_rstout_an(0),
            psel      => uapbSubSystem_i_apbbus_slv5_psel,
            penable   => uapbSubSystem_i_apbbus_slv5_penable,
            paddr     => uapbSubSystem_i_apbbus_slv5_paddr(11 downto 0),
            pwrite    => uapbSubSystem_i_apbbus_slv5_pwrite,
            pwdata    => uapbSubSystem_i_apbbus_slv5_pwdata,
            prdata    => urgu_prdata,
            ipclk     => clkin,
            rstin_an  => rstin_an,
            rstout_an => urgu_rstout_an);


   logic_zero                           <= ( others => '0');
   -- Note: uapbSubSystem_i_apbbus_slv4_paddr(31 downto 12) is open
   -- Note: uapbSubSystem_i_apbbus_slv5_paddr(31 downto 12) is open
   -- Note: uapbSubSystem_i_apbbus_slv6_paddr(31 downto 12) is open
   -- Note: ucgu_clkout(7 downto 3) is open
   -- Note: ucgu_clkout(1) is open
   -- Note: urgu_rstout_an(2) is open
   -- Note: urgu_rstout_an(7 downto 3) is open

end structure;
