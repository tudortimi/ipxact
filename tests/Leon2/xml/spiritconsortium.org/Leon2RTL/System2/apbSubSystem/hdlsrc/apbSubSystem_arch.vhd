-- ****************************************************************************
-- ** Description: apbSubSystem_arch.vhd
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
library leon2apbbus_lib;
use work.leon2Apbbus9_component.all;
library leon2apbmst_lib;
use work.leon2Apbmst_component.all;
library leon2irqctrl_lib;
use work.leon2Irqctrl_component.all;
library leon2timers_lib;
use work.leon2Timers_component.all;
library leon2uart_lib;
use work.leon2Uart_component.all;
library uartcrosser_lib;
use work.uartcrosser_component.all;
architecture structure of apbSubSystem is

-- synopsys translate_off
  for all: leon2Apbbus9
    use entity leon2apbbus_lib.leon2Apbbus9;

  for all: leon2Apbmst
    use entity leon2apbmst_lib.leon2Apbmst;

  for all: leon2Irqctrl
    use entity leon2irqctrl_lib.leon2Irqctrl;

  for all: leon2Timers
    use entity leon2timers_lib.leon2Timers;

  for all: leon2Uart
    use entity leon2uart_lib.leon2Uart;

  for all: uartcrosser
    use entity uartcrosser_lib.uartcrosser;
-- synopsys translate_on

   signal i_apbbus9_paddr_slv0   : std_logic_vector(31 downto 0);
   signal i_apbbus9_paddr_slv1   : std_logic_vector(31 downto 0);
   signal i_apbbus9_paddr_slv2   : std_logic_vector(31 downto 0);
   signal i_apbbus9_paddr_slv3   : std_logic_vector(31 downto 0);
   signal i_apbbus9_penable_slv0 : std_logic;
   signal i_apbbus9_penable_slv1 : std_logic;
   signal i_apbbus9_penable_slv2 : std_logic;
   signal i_apbbus9_penable_slv3 : std_logic;
   signal i_apbbus9_prdata_mst   : std_logic_vector(31 downto 0);
   signal i_apbbus9_psel_slv0    : std_logic;
   signal i_apbbus9_psel_slv1    : std_logic;
   signal i_apbbus9_psel_slv2    : std_logic;
   signal i_apbbus9_psel_slv3    : std_logic;
   signal i_apbbus9_pwdata_slv0  : std_logic_vector(31 downto 0);
   signal i_apbbus9_pwdata_slv1  : std_logic_vector(31 downto 0);
   signal i_apbbus9_pwdata_slv2  : std_logic_vector(31 downto 0);
   signal i_apbbus9_pwdata_slv3  : std_logic_vector(31 downto 0);
   signal i_apbbus9_pwrite_slv0  : std_logic;
   signal i_apbbus9_pwrite_slv1  : std_logic;
   signal i_apbbus9_pwrite_slv2  : std_logic;
   signal i_apbbus9_pwrite_slv3  : std_logic;
   signal i_apbmst_paddr         : std_logic_vector(31 downto 0);
   signal i_apbmst_penable       : std_logic;
   signal i_apbmst_psel          : std_logic;
   signal i_apbmst_pwdata        : std_logic_vector(31 downto 0);
   signal i_apbmst_pwrite        : std_logic;
   signal i_irqctrl_irq          : std_logic_vector(14 downto 0);
   signal i_irqctrl_prdata       : std_logic_vector(31 downto 0);
   signal i_timers_irq0          : std_logic;
   signal i_timers_irq1          : std_logic;
   signal i_timers_prdata        : std_logic_vector(31 downto 0);
   signal i_uart_1_irq           : std_logic;
   signal i_uart_1_prdata        : std_logic_vector(31 downto 0);
   signal i_uart_1_rtsn          : std_logic;
   signal i_uart_1_rxen          : std_logic;
   signal i_uart_1_txd           : std_logic;
   signal i_uart_irq             : std_logic;
   signal i_uart_prdata          : std_logic_vector(31 downto 0);
   signal i_uart_rtsn            : std_logic;
   signal i_uart_rxen            : std_logic;
   signal i_uart_txd             : std_logic;
   signal i_uartcrosser_ctsn0    : std_logic;
   signal i_uartcrosser_ctsn1    : std_logic;
   signal i_uartcrosser_rxd0     : std_logic;
   signal i_uartcrosser_rxd1     : std_logic;
   signal i_uartcrosser_scaler   : std_logic_vector(7 downto 0);
   signal logic_one              : std_logic;
   signal logic_zero             : std_logic_vector(14 downto 0);
begin

   i_apbbus9 : leon2Apbbus9
   generic map(start_addr_slv0 => 0,
               range_slv0      => 4096,
               start_addr_slv1 => 4096,
               range_slv1      => 4096,
               start_addr_slv2 => 8192,
               range_slv2      => 4096,
               start_addr_slv3 => 12288,
               range_slv3      => 4096,
               start_addr_slv4 => 16384,
               range_slv4      => 4096,
               start_addr_slv5 => 20480,
               range_slv5      => 4096,
               start_addr_slv6 => 24576,
               range_slv6      => 4096,
               start_addr_slv7 => 28672,
               range_slv7      => 4096,
               start_addr_slv8 => 32768,
               range_slv8      => 4096,
               number_ports    => 9)
   port map(psel_mst     => i_apbmst_psel,
            penable_mst  => i_apbmst_penable,
            paddr_mst    => i_apbmst_paddr,
            pwrite_mst   => i_apbmst_pwrite,
            pwdata_mst   => i_apbmst_pwdata,
            prdata_mst   => i_apbbus9_prdata_mst,
            psel_slv0    => i_apbbus9_psel_slv0,
            penable_slv0 => i_apbbus9_penable_slv0,
            paddr_slv0   => i_apbbus9_paddr_slv0,
            pwrite_slv0  => i_apbbus9_pwrite_slv0,
            pwdata_slv0  => i_apbbus9_pwdata_slv0,
            prdata_slv0  => i_irqctrl_prdata,
            psel_slv1    => i_apbbus9_psel_slv1,
            penable_slv1 => i_apbbus9_penable_slv1,
            paddr_slv1   => i_apbbus9_paddr_slv1,
            pwrite_slv1  => i_apbbus9_pwrite_slv1,
            pwdata_slv1  => i_apbbus9_pwdata_slv1,
            prdata_slv1  => i_timers_prdata,
            psel_slv2    => i_apbbus9_psel_slv2,
            penable_slv2 => i_apbbus9_penable_slv2,
            paddr_slv2   => i_apbbus9_paddr_slv2,
            pwrite_slv2  => i_apbbus9_pwrite_slv2,
            pwdata_slv2  => i_apbbus9_pwdata_slv2,
            prdata_slv2  => i_uart_prdata,
            psel_slv3    => i_apbbus9_psel_slv3,
            penable_slv3 => i_apbbus9_penable_slv3,
            paddr_slv3   => i_apbbus9_paddr_slv3,
            pwrite_slv3  => i_apbbus9_pwrite_slv3,
            pwdata_slv3  => i_apbbus9_pwdata_slv3,
            prdata_slv3  => i_uart_1_prdata,
            psel_slv4    => i_apbbus_slv4_psel,
            penable_slv4 => i_apbbus_slv4_penable,
            paddr_slv4   => i_apbbus_slv4_paddr,
            pwrite_slv4  => i_apbbus_slv4_pwrite,
            pwdata_slv4  => i_apbbus_slv4_pwdata,
            prdata_slv4  => i_apbbus_slv4_prdata,
            psel_slv5    => i_apbbus_slv5_psel,
            penable_slv5 => i_apbbus_slv5_penable,
            paddr_slv5   => i_apbbus_slv5_paddr,
            pwrite_slv5  => i_apbbus_slv5_pwrite,
            pwdata_slv5  => i_apbbus_slv5_pwdata,
            prdata_slv5  => i_apbbus_slv5_prdata,
            psel_slv6    => i_apbbus_slv6_psel,
            penable_slv6 => i_apbbus_slv6_penable,
            paddr_slv6   => i_apbbus_slv6_paddr,
            pwrite_slv6  => i_apbbus_slv6_pwrite,
            pwdata_slv6  => i_apbbus_slv6_pwdata,
            prdata_slv6  => i_apbbus_slv6_prdata,
            psel_slv7    => i_apbbus_slv7_psel,
            penable_slv7 => i_apbbus_slv7_penable,
            paddr_slv7   => i_apbbus_slv7_paddr,
            pwrite_slv7  => i_apbbus_slv7_pwrite,
            pwdata_slv7  => i_apbbus_slv7_pwdata,
            prdata_slv7  => i_apbbus_slv7_prdata,
            psel_slv8    => i_apbbus_slv8_psel,
            penable_slv8 => i_apbbus_slv8_penable,
            paddr_slv8   => i_apbbus_slv8_paddr,
            pwrite_slv8  => i_apbbus_slv8_pwrite,
            pwdata_slv8  => i_apbbus_slv8_pwdata,
            prdata_slv8  => i_apbbus_slv8_prdata);

   i_apbmst : leon2Apbmst
   port map(clk       => clk,
            rst       => rst_an,
            hsize     => ex_ambaAHB_hsize,
            haddr     => ex_ambaAHB_haddr,
            htrans    => ex_ambaAHB_htrans,
            hwrite    => ex_ambaAHB_hwrite,
            hwdata    => ex_ambaAHB_hwdata,
            hreadyin  => ex_ambaAHB_hready,
            hsel      => ex_ambaAHB_hsel,
            hrdata    => ex_ambaAHB_hrdata,
            hreadyout => ex_ambaAHB_hready_resp,
            hresp     => ex_ambaAHB_hresp,
            hprot     => ex_ambaAHB_hprot,
            hburst    => ex_ambaAHB_hburst,
            prdata    => i_apbbus9_prdata_mst,
            pwdata    => i_apbmst_pwdata,
            penable   => i_apbmst_penable,
            paddr     => i_apbmst_paddr,
            pwrite    => i_apbmst_pwrite,
            psel      => i_apbmst_psel);

   i_irqctrl : leon2Irqctrl
   port map(clk     => clk,
            rst     => rst_an,
            psel    => i_apbbus9_psel_slv0,
            penable => i_apbbus9_penable_slv0,
            paddr   => i_apbbus9_paddr_slv0,
            pwrite  => i_apbbus9_pwrite_slv0,
            pwdata  => i_apbbus9_pwdata_slv0,
            prdata  => i_irqctrl_prdata,
            irq     => i_irqctrl_irq,
            intack  => Interrupt_INTack,
            irlin   => Interrupt_IRQVEC,
            irlout  => Interrupt_IRL);

   i_timers : leon2Timers
   generic map(TPRESC => 22)
   port map(clk        => clk,
            rst        => rst_an,
            psel       => i_apbbus9_psel_slv1,
            penable    => i_apbbus9_penable_slv1,
            paddr      => i_apbbus9_paddr_slv1,
            pwrite     => i_apbbus9_pwrite_slv1,
            pwdata     => i_apbbus9_pwdata_slv1,
            prdata     => i_timers_prdata,
            irq0       => i_timers_irq0,
            irq1       => i_timers_irq1,
            tick       => open,
            wdog       => open,
            dsuact     => logic_zero(0),
            ntrace     => logic_zero(0),
            freezetime => logic_one,
            lresp      => logic_zero(0),
            dresp      => logic_zero(0),
            dsuen      => logic_zero(0),
            dsubre     => logic_zero(0));

   i_uart : leon2Uart
   generic map(EXTBAUD => FALSE)
   port map(clk     => clk,
            rst     => rst_an,
            psel    => i_apbbus9_psel_slv2,
            penable => i_apbbus9_penable_slv2,
            paddr   => i_apbbus9_paddr_slv2,
            pwrite  => i_apbbus9_pwrite_slv2,
            pwdata  => i_apbbus9_pwdata_slv2,
            prdata  => i_uart_prdata,
            irq     => i_uart_irq,
            scaler  => i_uartcrosser_scaler,
            rxd     => i_uartcrosser_rxd0,
            rxen    => i_uart_rxen,
            txd     => i_uart_txd,
            txen    => open,
            flow    => open,
            rtsn    => i_uart_rtsn,
            ctsn    => i_uartcrosser_ctsn0);

   i_uart_1 : leon2Uart
   generic map(EXTBAUD => FALSE)
   port map(clk     => clk,
            rst     => rst_an,
            psel    => i_apbbus9_psel_slv3,
            penable => i_apbbus9_penable_slv3,
            paddr   => i_apbbus9_paddr_slv3,
            pwrite  => i_apbbus9_pwrite_slv3,
            pwdata  => i_apbbus9_pwdata_slv3,
            prdata  => i_uart_1_prdata,
            irq     => i_uart_1_irq,
            scaler  => i_uartcrosser_scaler,
            rxd     => i_uartcrosser_rxd1,
            rxen    => i_uart_1_rxen,
            txd     => i_uart_1_txd,
            txen    => open,
            flow    => open,
            rtsn    => i_uart_1_rtsn,
            ctsn    => i_uartcrosser_ctsn1);

   i_uartcrosser : uartcrosser
   generic map(ScalerValue => x"01")
   port map(rxd0   => i_uartcrosser_rxd0,
            txd0   => i_uart_txd,
            ctsn0  => i_uartcrosser_ctsn0,
            rtsn0  => i_uart_rtsn,
            rxen0  => i_uart_rxen,
            rxd1   => i_uartcrosser_rxd1,
            txd1   => i_uart_1_txd,
            ctsn1  => i_uartcrosser_ctsn1,
            rtsn1  => i_uart_1_rtsn,
            rxen1  => i_uart_1_rxen,
            scaler => i_uartcrosser_scaler);


   logic_one              <= '1';
   logic_zero             <= ( others => '0');
   i_irqctrl_irq(14 downto 7) <= logic_zero(7 downto 0);
   i_irqctrl_irq(6)       <= Int6_IRQ;
   i_irqctrl_irq(5)       <= Int5_IRQ;
   i_irqctrl_irq(4)       <= Int4_IRQ;
   i_irqctrl_irq(3)       <= i_uart_1_irq;
   i_irqctrl_irq(2)       <= i_timers_irq1;
   i_irqctrl_irq(1)       <= i_timers_irq0;
   i_irqctrl_irq(0)       <= i_uart_irq;

end structure;
