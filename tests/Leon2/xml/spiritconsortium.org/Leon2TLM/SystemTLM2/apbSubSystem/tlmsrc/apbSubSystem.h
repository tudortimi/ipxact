/*---------------------------------------------------------------------------
 * 
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
 * 
 * This work forms part of a deliverable of The SPIRIT Consortium.
 * 
 * Use of these materials are governed by the legal terms and conditions
 * outlined in the disclaimer available from www.spiritconsortium.org.
 * 
 * This source file is provided on an AS IS basis.  The SPIRIT
 * Consortium disclaims any warranty express or implied including
 * any warranty of merchantability and fitness for use for a
 * particular purpose.
 * 
 * The user of the source file shall indemnify and hold The SPIRIT
 * Consortium and its members harmless from any damages or liability.
 * Users are requested to provide feedback to The SPIRIT Consortium
 * using either mailto:feedback@lists.spiritconsortium.org or the forms at 
 * http://www.spiritconsortium.org/about/contact_us/
 * 
 * This file may be copied, and distributed, with or without
 * modifications; but this notice must be included on any copy.
 *---------------------------------------------------------------------------*/

/*******************************************************************************
 *                      SPIRIT 1.4 OSCI-TLM-PV example
 *------------------------------------------------------------------------------
 * Simple TLM APB design
 *------------------------------------------------------------------------------
 * Revision: 1.4
 * Authors:  Jean-Michel Fernandez
 * Copyright The SPIRIT Consortium 2006
 *******************************************************************************/

#ifndef _APB_SUBSYSTEM_H_
#define _APB_SUBSYSTEM_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <systemc.h>

#include "apbbus.h"
#include "apbmst.h"
#include "timers.h"
#include "irqctrl.h"
#include "scmladaptor.h"
#include "uart.h"
#include "serial_device.h"
#include "user_types.h"
#include "pv2tac.h"
#include "Leon2_uart.h"

#include "pv_target_port.h"
#include "pv_initiator_port.h"

/*------------------------------------------------------------------------------
 *  top netlist
 *----------------------------------------------------------------------------*/
class apbSubSystem : public sc_module
{
 public:
  // slave ports
  sc_in<int>                             int4_slave_port;
  pv_target_port<ADDRESS_TYPE,DATA_TYPE> ahb_slave_port;
  // interrupt ports
  sc_out<int>     irl_master_port;
  sc_in<int>      irq_slave_port;
  sc_in<bool>     ack_slave_port;
  sc_in<sc_logic> clk_timers;
  sc_in<bool>     reset_port;

  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb4_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb5_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb6_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb7_mslave_port;

 private:
  // component instances
  apbmst*       i_h2p;
  apbbus*       i_apb;
  irqctrl*      i_irq;
  timers*       i_tim;
  scmlAdaptor*  i_adp;
  uart*         i_uart_scml;
  SerialDevice* i_sdev;
  pv2tac*       i_pv2tac;
  Leon2::uart*  i_uart_tac;
  // interrupt signals
  sc_buffer<int>       interrupt_tim0;
  sc_buffer<int>       interrupt_tim1;
  sc_buffer<int>       interrupt_uart_scml;
  sc_buffer<int>       dangling;

 public:
  apbSubSystem(sc_module_name module_name) : sc_module(module_name),
    ahb_slave_port("ahb_slave_port"),
    apb4_mslave_port("apb4_mslave_port"),
    apb5_mslave_port("apb5_mslave_port"),
    apb6_mslave_port("apb6_mslave_port"),
    apb7_mslave_port("apb7_mslave_port"),
    reset_port("reset_port")
    {
      // instances
      i_h2p = new apbmst("i_apbmst","leon2ApbMst.map");
      i_apb = new apbbus("i_apbbus","leon2ApbBus.map");
      i_irq = new irqctrl("i_irqctrl");
      i_tim = new timers("i_timers");
      i_adp = new scmlAdaptor("i_scmladp");
      i_uart_scml = new uart("i_uart_scml");
      i_sdev = new SerialDevice("i_sdev");
      i_pv2tac = new pv2tac("pv2tac");
      i_uart_tac = new Leon2::uart("uart_tac");
      // interconnections (transactional port binding)
      i_h2p->initiator_port ( i_apb->target_port );
      i_apb->initiator_port ( i_irq->apb_slave_port );      // binding of APB 0
      i_apb->initiator_port ( i_tim->apb_slave_port );      // binding of APB 1
      i_apb->initiator_port ( i_adp->apb_slave_port );      // binding of APB 2
      i_apb->initiator_port ( i_pv2tac->tlmpv_slave_port ); // binding of APB 3
      i_pv2tac->tac_master_port( i_uart_tac->ambaAPB );
      i_adp->scml_master_port( i_uart_scml->pPVTargetPort );
      i_uart_scml->pSerialOut( i_sdev->pSerialIn );
      i_sdev->pSerialOut( i_uart_scml->pSerialIn );
      // adhoc connections (wire port binding)
      i_tim->int0 (interrupt_tim0);
      i_irq->int3 (interrupt_tim0);
      i_tim->int1 (interrupt_tim1);
      i_irq->int2 (interrupt_tim1);
      i_tim->clk (clk_timers);
      i_irq->int1 (interrupt_uart_scml);
      i_uart_scml->pInterrupt (interrupt_uart_scml);
      i_irq->int0 (dangling);
      // external interconnections 
      ahb_slave_port (i_h2p->target_port );
      i_apb->initiator_port ( apb7_mslave_port ); // binding of APB 7
      i_apb->initiator_port ( apb6_mslave_port ); // binding of APB 6
      i_apb->initiator_port ( apb5_mslave_port ); // binding of APB 5
      i_apb->initiator_port ( apb4_mslave_port ); // binding of APB 4
      // external adhoc connections
      i_irq->int4 ( this->int4_slave_port );
      i_irq->irlout ( this->irl_master_port );
      i_irq->irlin  ( this->irq_slave_port );
      i_irq->intack ( this->ack_slave_port );
      i_uart_scml->pReset ( this->reset_port );
    }
  ~apbSubSystem() {
    delete i_h2p;
    delete i_apb;
    delete i_tim;
    delete i_irq;
    delete i_adp;
    delete i_uart_scml;
    delete i_sdev;
    delete i_pv2tac;
    delete i_uart_tac;
  }
};

#endif /* _APB_SUBSYSTEM_H_ */


