#!/bin/csh -f

if ($1 == "") then
  echo "  usage: $0 <simulator name>"
  exit 1
endif

if ($1 == "ncsim") then
  set COMPILESCRIPT="nccompile.csh"
else
  echo "Unknown simulator: $1"
  exit 1
endif

#location of where the IP is located
set IP_LOCATION="../../spiritconsortium.org"

$COMPILESCRIPT vhdl  leon2apbbus_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/apbbus/1.2/hdlsrc/apbbus.vhd \
$IP_LOCATION/Leon2RTL/apbbus/1.2/hdlsrc/leon2Apbbus8.vhd 

$COMPILESCRIPT vhdl  leon2timers_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/timers/1.2/hdlsrc/timers.vhd \
$IP_LOCATION/Leon2RTL/timers/1.2/hdlsrc/leon2Timers.vhd 

$COMPILESCRIPT vhdl  leon2uart_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/uart/1.2/hdlsrc/uart.vhd \
$IP_LOCATION/Leon2RTL/uart/1.2/hdlsrc/leon2Uart.vhd  

$COMPILESCRIPT vhdl  leon2apbmst_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/apbmst/1.2/hdlsrc/apbmst.vhd  \
$IP_LOCATION/Leon2RTL/apbmst/1.2/hdlsrc/leon2Apbmst.vhd

$COMPILESCRIPT vhdl  leon2irqctrl_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/irqctrl/1.2/hdlsrc/irqctrl_rdack.vhd  \
$IP_LOCATION/Leon2RTL/irqctrl/1.2/hdlsrc/leon2Irqctrl.vhd

$COMPILESCRIPT vhdl  leon2ahbbus_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/ahbbus/1.2/hdlsrc/ahbbus.vhd  \
$IP_LOCATION/Leon2RTL/ahbbus/1.2/hdlsrc/leon2Ahbbus22.vhd

$COMPILESCRIPT vhdl  leon2ahbram_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/ahbram/1.2/hdlsrc/ahbram.vhd  \
$IP_LOCATION/Leon2RTL/ahbram/1.2/hdlsrc/leon2Ahbram.vhd  \

$COMPILESCRIPT vhdl  leon2dma_lib \
$IP_LOCATION/Leon2RTL/common/target.vhd  \
$IP_LOCATION/Leon2RTL/common/device.vhd  \
$IP_LOCATION/Leon2RTL/common/config.vhd  \
$IP_LOCATION/Leon2RTL/common/sparcv8.vhd  \
$IP_LOCATION/Leon2RTL/common/iface.vhd  \
$IP_LOCATION/Leon2RTL/common/amba.vhd  \
$IP_LOCATION/Leon2RTL/common/ambacomp.vhd  \
$IP_LOCATION/Leon2RTL/common/macro.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_generic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_atc35.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_fs90.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_umc18.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_virtex.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_tsmc25.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_proasic.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_axcel.vhd  \
$IP_LOCATION/Leon2RTL/common/multlib.vhd  \
$IP_LOCATION/Leon2RTL/common/tech_map.vhd  \
$IP_LOCATION/Leon2RTL/dma/1.2/hdlsrc/ahbmst.vhd  \
$IP_LOCATION/Leon2RTL/dma/1.2/hdlsrc/dma.vhd  \
$IP_LOCATION/Leon2RTL/dma/1.2/hdlsrc/leon2Dma.vhd

$COMPILESCRIPT vhdl  processor_lib \
$IP_LOCATION/Leon2RTL/processor/1.2/hdlsrc/processorPackage.vhd \
$IP_LOCATION/Leon2RTL/processor/1.2/hdlsrc/processorApbSlave.vhd \
$IP_LOCATION/Leon2RTL/processor/1.2/hdlsrc/processorAhbMaster.vhd  \
$IP_LOCATION/Leon2RTL/processor/1.2/hdlsrc/processor.vhd

$COMPILESCRIPT vhdl  cgu_lib \
$IP_LOCATION/Leon2RTL/cgu/1.2/hdlsrc/cgu.vhd

$COMPILESCRIPT vhdl  rgu_lib \
$IP_LOCATION/Leon2RTL/rgu/1.2/hdlsrc/rgu.vhd

$COMPILESCRIPT vhdl  uartcrosser_lib \
$IP_LOCATION/Leon2RTL/uartcrosser/1.2/hdlsrc/uartcrosser.vhd

$COMPILESCRIPT vhdl  work \
$IP_LOCATION/Leon2RTL/System1/apbSubSystem/hdlsrc/apbSubSystem_pack.vhd  \
$IP_LOCATION/Leon2RTL/System1/apbSubSystem/hdlsrc/apbSubSystem_ent.vhd  \
$IP_LOCATION/Leon2RTL/System1/apbSubSystem/hdlsrc/apbSubSystem_arch.vhd  \
$IP_LOCATION/Leon2RTL/System1/Leon2Platform/hdlsrc/Leon2Platform_pack.vhd  \
$IP_LOCATION/Leon2RTL/System1/Leon2Platform/hdlsrc/Leon2Platform_ent.vhd  \
$IP_LOCATION/Leon2RTL/System1/Leon2Platform/hdlsrc/Leon2Platform_arch.vhd  \
System1_tb.vhd

