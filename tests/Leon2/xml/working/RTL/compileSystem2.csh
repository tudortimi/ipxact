#!/bin/csh -f

if ($1 == "") then
  echo "  usage: $0 <simulator name>"
  exit 1
endif

if ($1 == "ncsim") then
  set COMPILESCRIPT = "nccompile.csh"
else
  echo "Unknown simulator: $1"
  exit 1
endif

#location of where the IP is located
set IP_LOCATION="../../spiritconsortium.org"

$COMPILESCRIPT verilog  i2c_memory_lib \
$IP_LOCATION/Leon2RTL/i2c_memory/1.0/data/i2c_memory/RTL/i2c_memory.v


$COMPILESCRIPT verilog  i2c_gpio_lib \
$IP_LOCATION/Leon2RTL/i2c_gpio/1.0/data/i2c_gpio/RTL/i2c_gpio.v 

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
$IP_LOCATION/Leon2RTL/apbbus/1.2/hdlsrc/leon2Apbbus1.vhd \
$IP_LOCATION/Leon2RTL/apbbus/1.2/hdlsrc/leon2Apbbus9.vhd 

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
$IP_LOCATION/Leon2RTL/ahbbus/1.2/hdlsrc/leon2Ahbbus25.vhd\
$IP_LOCATION/Leon2RTL/ahbbus/1.2/hdlsrc/leon2Ahbbus33.vhd

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

$COMPILESCRIPT vhdl  leon2ahbrom_lib \
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
$IP_LOCATION/Leon2RTL/ahbrom/1.2/hdlsrc/ahbrom.vhd  \
$IP_LOCATION/Leon2RTL/ahbrom/1.2/hdlsrc/leon2Ahbrom.vhd  \

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

$COMPILESCRIPT vhdl  ahb2ahb_lib \
$IP_LOCATION/Leon2RTL/ahb2ahb/1.2/hdlsrc/ahb2ahb.vhd

$COMPILESCRIPT vhdl  uartcrosser_lib \
$IP_LOCATION/Leon2RTL/uartcrosser/1.2/hdlsrc/uartcrosser.vhd

$COMPILESCRIPT verilog  i2c_lib \
-incdir $IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_apb_read_mux.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_apb_write_decode.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_clkcnt.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_clkdiv.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_control.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_intr.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_master.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_risefall.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_rx.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_rxfifo.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_shift.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_status.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_transitions.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_tx.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c_txfifo.v \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c.v

$COMPILESCRIPT vhdl  i2c_lib \
$IP_LOCATION/Leon2RTL/i2c/1.0/data/i2c/RTL/i2c.vhd

$COMPILESCRIPT verilog  i2c_io_lib \
$IP_LOCATION/Leon2RTL/i2c_io/1.0/data/i2c_io/RTL/i2c_io.v 

$COMPILESCRIPT vhdl  i2c_io_lib \
$IP_LOCATION/Leon2RTL/i2c_io/1.0/data/i2c_io/RTL/i2c_io.vhd

$COMPILESCRIPT verilog  i2c_memory_lib \
$IP_LOCATION/Leon2RTL/i2c_memory/1.0/data/i2c_memory/RTL/i2c_memory.v 

$COMPILESCRIPT vhdl  i2c_memory_lib \
$IP_LOCATION/Leon2RTL/i2c_memory/1.0/data/i2c_memory/RTL/i2c_memory.vhd

$COMPILESCRIPT verilog  i2c_gpio_lib \
$IP_LOCATION/Leon2RTL/i2c_gpio/1.0/data/i2c_gpio/RTL/i2c_gpio.v 

$COMPILESCRIPT vhdl  i2c_gpio_lib \
$IP_LOCATION/Leon2RTL/i2c_gpio/1.0/data/i2c_gpio/RTL/i2c_gpio.vhd

$COMPILESCRIPT verilog  i2c_channel_lib \
$IP_LOCATION/Leon2RTL/i2c_channel/1.0/data/i2c_channel_1m_2s/RTL/i2c_channel_1m_2s.v 

$COMPILESCRIPT vhdl  i2c_channel_lib \
$IP_LOCATION/Leon2RTL/i2c_channel/1.0/data/i2c_channel_1m_2s/RTL/i2c_channel_1m_2s.vhd 

$COMPILESCRIPT vhdl  dac_lib \
$IP_LOCATION/Leon2RTL/dac/1.2/hdlsrc/dac.vhd 

$COMPILESCRIPT vhdl  mp3decode_lib \
$IP_LOCATION/Leon2RTL/i2c_io/1.0/data/i2c_io/RTL/i2c_io.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeFifoGrayPkg.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeCrcPkg.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeFifoPkg.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeAhbSlavePkg.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeFifoGray.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeFifo.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3DecodeAhbSlave.vhd \
$IP_LOCATION/Leon2RTL/mp3Decode/1.2/hdlsrc/mp3Decode.vhd \

$COMPILESCRIPT vhdl  work \
$IP_LOCATION/Leon2RTL/System2/audioSubSystem/hdlsrc/audioSubSystem_pack.vhd  \
$IP_LOCATION/Leon2RTL/System2/apbSubSystem/hdlsrc/apbSubSystem_pack.vhd  \
$IP_LOCATION/Leon2RTL/System2/i2cSubSystem/hdlsrc/i2cSubSystem_pack.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2Platform/hdlsrc/Leon2Platform_pack.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2PlatformSystem/hdlsrc/Leon2PlatformSystem_pack.vhd  \
$IP_LOCATION/Leon2RTL/System2/audioSubSystem/hdlsrc/audioSubSystem_ent.vhd  \
$IP_LOCATION/Leon2RTL/System2/apbSubSystem/hdlsrc/apbSubSystem_ent.vhd  \
$IP_LOCATION/Leon2RTL/System2/i2cSubSystem/hdlsrc/i2cSubSystem_ent.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2Platform/hdlsrc/Leon2Platform_ent.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2PlatformSystem/hdlsrc/Leon2PlatformSystem_ent.vhd  \
$IP_LOCATION/Leon2RTL/System2/audioSubSystem/hdlsrc/audioSubSystem_arch.vhd  \
$IP_LOCATION/Leon2RTL/System2/apbSubSystem/hdlsrc/apbSubSystem_arch.vhd  \
$IP_LOCATION/Leon2RTL/System2/i2cSubSystem/hdlsrc/i2cSubSystem_arch.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2Platform/hdlsrc/Leon2Platform_arch.vhd  \
$IP_LOCATION/Leon2RTL/System2/Leon2PlatformSystem/hdlsrc/Leon2PlatformSystem_arch.vhd  \
System2_tb.vhd

