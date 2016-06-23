/*
  Description: apbSubSystem.cc
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
#include "apbSubSystem.h"

apbSubSystem:: apbSubSystem(sc_module_name name) :
sc_module(name),
i_apb("i_apb" ,"leon2ApbBus.map"), 
i_hp2("i_hp2" ,"leon2ApbMst.map"), 
i_irq("i_irq"), 
i_tim("i_tim"), 
i_uart_scml("i_uart_scml"), 
i_sdev("i_sdev"), 
i_uart_tac("i_uart_tac" ,true ,0 ,TLM_BIG_ENDIAN), 
i_adp("i_adp"), 
i_pv2tac("i_pv2tac"), 
ahb_slave_port ("ahb_slave_port"), 
irl_master_port ("irl_master_port"), 
irq_slave_port ("irq_slave_port"), 
ack_slave_port ("ack_slave_port"), 
int4_slave_port ("int4_slave_port"), 
apb4_mslave_port ("apb4_mslave_port"), 
apb5_mslave_port ("apb5_mslave_port"), 
apb6_mslave_port ("apb6_mslave_port"), 
apb7_mslave_port ("apb7_mslave_port"), 
clk_timers ("clk_timers"), 
reset_port ("reset_port")
{
i_hp2.initiator_port(i_apb.target_port);
i_apb.initiator_port(i_irq.apb_slave_port);
i_apb.initiator_port(i_tim.apb_slave_port);
i_adp.scml_master_port(i_uart_scml.pPVTargetPort);
i_apb.initiator_port(i_adp.apb_slave_port);
i_pv2tac.tac_master_port(i_uart_tac.ambaAPB);
i_apb.initiator_port(i_pv2tac.tlmpv_slave_port);
i_uart_scml.pSerialOut(i_sdev.pSerialIn);
i_sdev.pSerialOut(i_uart_scml.pSerialIn);


i_irq.int1(defaultid4490226_int1);
i_tim.int0(defaultid4490226_int1);
i_irq.int2(defaultid4490243_int2);
i_tim.int1(defaultid4490243_int2);
i_irq.int0(defaultid4490260_int0);
i_uart_scml.pInterrupt(defaultid4490260_int0);
ahb_slave_port(i_hp2.target_port);
i_irq.irlout(irl_master_port);
i_irq.irlin(irq_slave_port);
i_irq.intack(ack_slave_port);
i_irq.int4(int4_slave_port);
i_apb.initiator_port(apb4_mslave_port);
i_apb.initiator_port(apb5_mslave_port);
i_apb.initiator_port(apb6_mslave_port);
i_apb.initiator_port(apb7_mslave_port);
i_tim.clk(clk_timers);
i_uart_scml.pReset(reset_port);
i_irq.int3(stub_i_irq_int3); 

}
