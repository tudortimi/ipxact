/*
  Description: apbSubSystem.h
  Author:      The SPIRIT Consortium
  Revision:    $Revision: 1506 $
  Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $

  Copyright (c) 2009 The SPIRIT Consortium.

  This work forms part of a deliverable of The SPIRIT Consortium.

  Use of these materials are governed by the legal terms and conditions
  outlined in the disclaimer available from www.spiritconsortium.org.

  This source file is provided on an AS IS basis.  The SPIRIT
  Consortium disclaims any warranty express or implied including
  any warranty of merchantability and fitness for use for a
  particular purpose.

  The user of the source file shall indemnify and hold The SPIRIT
  Consortium and its members harmless from any damages or liability.
  Users are requested to provide feedback to The SPIRIT Consortium
  using either mailto:feedback@lists.spiritconsortium.org or the forms at
  http://www.spiritconsortium.org/about/contact_us/

  This file may be copied, and distributed, with or without
  modifications; this notice must be included on any copy.
 */
#include <systemc.h>
#include  "apbbus.h" 
#include  "apbmst.h" 
#include  "irqctrl.h" 
#include  "timers.h" 
#include  "uart.h" 
#include  "serial_device.h" 
#include  "Leon2_uart.h" 
#include  "scmladaptor.h" 
#include  "pv2tac.h" 


class apbSubSystem : public sc_module
{
 
public:

  apbSubSystem(sc_module_name name);
  ~apbSubSystem(){}
  

  

  
pv_target_port <ADDRESS_TYPE, DATA_TYPE>  ahb_slave_port; 
sc_out <int> irl_master_port; 
sc_in <int> irq_slave_port; 
sc_in <bool> ack_slave_port; 
sc_in <int> int4_slave_port; 
pv_initiator_port <ADDRESS_TYPE, DATA_TYPE>  apb4_mslave_port; 
pv_initiator_port <ADDRESS_TYPE, DATA_TYPE>  apb5_mslave_port; 
pv_initiator_port <ADDRESS_TYPE, DATA_TYPE>  apb6_mslave_port; 
pv_initiator_port <ADDRESS_TYPE, DATA_TYPE>  apb7_mslave_port; 
sc_in <sc_logic> clk_timers; 
sc_in <bool> reset_port; 


private:

apbbus i_apb; 
apbmst i_hp2; 
irqctrl i_irq; 
timers i_tim; 
uart i_uart_scml; 
SerialDevice i_sdev; 
Leon2::uart i_uart_tac; 
scmlAdaptor i_adp; 
pv2tac i_pv2tac; 


sc_signal < int > defaultid4490226_int1;
sc_signal < int > defaultid4490243_int2;
sc_signal < int > defaultid4490260_int0;
sc_signal < int > stub_i_irq_int3;

};


