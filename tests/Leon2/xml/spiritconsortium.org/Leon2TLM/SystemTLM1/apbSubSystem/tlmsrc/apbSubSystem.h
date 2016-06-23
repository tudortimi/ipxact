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
#include "user_types.h"

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
  sc_out<int>        irl_master_port;
  sc_in<int>         irq_slave_port;
  sc_in<bool>        ack_slave_port;
  sc_in<sc_logic>    clk_timers;

  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb4_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb5_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb6_mslave_port;
  pv_initiator_port<ADDRESS_TYPE,DATA_TYPE> apb7_mslave_port;

 private:
  // component instances
  apbmst*  i_h2p;
  apbbus*  i_apb;
  irqctrl* i_irq;
  timers*  i_tim;
  // interrupt signals
  sc_buffer<int>  interrupt_tim0;
  sc_buffer<int>  interrupt_tim1;
  sc_buffer<int>  dangling;

 public:
  apbSubSystem(sc_module_name module_name) : sc_module(module_name),
    ahb_slave_port("ahb_slave_port"),
    apb4_mslave_port("apb4_mslave_port"),
    apb5_mslave_port("apb5_mslave_port"),
    apb6_mslave_port("apb6_mslave_port"),
    apb7_mslave_port("apb7_mslave_port")
    {
      // instances
      i_h2p = new apbmst("i_apbmst","leon2ApbMst.map");
      i_apb = new apbbus("i_apbbus","leon2ApbBus.map");
      i_irq = new irqctrl("i_irqctrl");
      i_tim = new timers("i_timers");
      // interconnections (transactional port binding)
      i_h2p->initiator_port ( i_apb->target_port );
      i_apb->initiator_port ( i_irq->apb_slave_port ); // binding of APB 0
      i_apb->initiator_port ( i_tim->apb_slave_port ); // binding of APB 1
      // adhoc connections (wire port binding)
      i_tim->int0 (interrupt_tim0);
      i_irq->int3 (interrupt_tim0);
      i_tim->int1 (interrupt_tim1);
      i_irq->int2 (interrupt_tim1);
      i_tim->clk (clk_timers);
      i_irq->int1 (dangling);
      i_irq->int0 (dangling);
      // external interconnections 
      ahb_slave_port (i_h2p->target_port );
      i_apb->initiator_port ( apb4_mslave_port ); // binding of APB 4
      i_apb->initiator_port ( apb5_mslave_port ); // binding of APB 5
      i_apb->initiator_port ( apb6_mslave_port ); // binding of APB 6
      i_apb->initiator_port ( apb7_mslave_port ); // binding of APB 7
      // external adhoc connections
      i_irq->int4 ( this->int4_slave_port );
      i_irq->irlout ( this->irl_master_port );
      i_irq->irlin  ( this->irq_slave_port );
      i_irq->intack ( this->ack_slave_port );
    }
  ~apbSubSystem() {
    delete i_h2p;
    delete i_apb;
    delete i_tim;
    delete i_irq;
  }
};

#endif /* _APB_SUBSYSTEM_H_ */


