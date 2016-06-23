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
 * Simple TLM Design netlist
 *------------------------------------------------------------------------------
 * Revision: 1.4
 * Authors:  Jean-Michel Fernandez
 * Copyright The SPIRIT Consortium 2006
 *******************************************************************************/

#ifndef _LEON2PLATFORM_H_
#define _LEON2PLATFORM_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <systemc.h>

#include "processor.h"
#include "ahbram.h"
#include "ahbbus.h"
#include "apbSubSystem.h"
#include "dma.h"
#include "cgu.h"
#include "rgu.h"

/*------------------------------------------------------------------------------
 *  top netlist
 *----------------------------------------------------------------------------*/
class Leon2Platform : public sc_module
{

 public:
  sc_in<sc_logic>    rstin_an;

 private:
  // component instances
  processor*     i_proc; 
  ahbram*        i_mem;
  ahbbus*        i_ahb;
  apbSubSystem*  i_sub;
  dma*           i_dma;
  cgu*           i_cgu;
  rgu*           i_rgu;
  // interrupt signals
  sc_buffer<int>        interrupt_proc_irl;
  sc_buffer<int>        interrupt_proc_irq;
  sc_buffer<bool>       interrupt_proc_ack;
  sc_buffer<int>        interrupt_dma;
  // clock and reset signals
  sc_buffer<bool>     rstdiv[8];
  sc_buffer<sc_logic> clkdiv[8];


 public:
  // Note: the timers and memory size and base addresses 
  //       (start addr, end addr) are defined in in each 
  //       component external map files.
  Leon2Platform(sc_module_name module_name) : sc_module(module_name)
  {
      // instances
      i_proc = new processor("uproc","master.tbl");
      i_mem = new ahbram("uahbram", 16);
      i_ahb = new ahbbus("uahbbus","leon2AhbBus.map");
      i_sub = new apbSubSystem("uapbSubSystem");
      i_dma = new dma("udma");
      i_cgu = new cgu("ucgu");
      i_rgu = new rgu("urgu");
      // interconnections (transactional port binding)
      i_proc->ahb_master_port ( i_ahb->target_port );
      i_dma->ahb_master_port ( i_ahb->target_port );
      i_ahb->initiator_port ( i_mem->ahb_slave_port );
      i_ahb->initiator_port ( i_sub->ahb_slave_port );
      i_sub->apb4_mslave_port ( i_cgu->apb_slave_port );
      i_sub->apb5_mslave_port ( i_rgu->apb_slave_port );
      i_sub->apb6_mslave_port ( i_proc->apb_slave_port );
      i_sub->apb7_mslave_port ( i_dma->apb_slave_port );
      // adhoc connections (wire port binding)
      i_proc->irl_port (interrupt_proc_irl);
      i_proc->irqvec_port (interrupt_proc_irq);
      i_proc->intack_port (interrupt_proc_ack);
      i_dma->int_master_port (interrupt_dma);
      i_sub->int4_slave_port (interrupt_dma);
      i_sub->irl_master_port (interrupt_proc_irl);
      i_sub->irq_slave_port (interrupt_proc_irq);
      i_sub->ack_slave_port (interrupt_proc_ack);
      i_sub->clk_timers (clkdiv[0]);
      i_proc->clk (clkdiv[0]);
      i_cgu->clkout[0](clkdiv[0]);
      i_cgu->clkout[1](clkdiv[1]);
      i_cgu->clkout[2](clkdiv[2]);
      i_cgu->clkout[3](clkdiv[3]);
      i_cgu->clkout[4](clkdiv[4]);
      i_cgu->clkout[5](clkdiv[5]);
      i_cgu->clkout[6](clkdiv[6]);
      i_cgu->clkout[7](clkdiv[7]);
      i_rgu->ipclk(clkdiv[0]);
      i_rgu->rstin_an(rstin_an);
      i_proc->rst_an (rstdiv[0]);
      i_rgu->rstout_an[0](rstdiv[0]);
      i_rgu->rstout_an[1](rstdiv[1]);
      i_rgu->rstout_an[2](rstdiv[2]);
      i_rgu->rstout_an[3](rstdiv[3]);
      i_rgu->rstout_an[4](rstdiv[4]);
      i_rgu->rstout_an[5](rstdiv[5]);
      i_rgu->rstout_an[6](rstdiv[6]);
      i_rgu->rstout_an[7](rstdiv[7]);
    }
  ~Leon2Platform() {
    delete i_proc;
    delete i_mem;
    delete i_ahb;
    delete i_dma;
    delete i_sub;
    delete i_cgu;
    delete i_rgu;
  }
};

#endif /* _LEON2PLATFORM_H_ */


