// 
// Revision:    $Revision: 1506 $
// Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
// 
// Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
// 
// This work forms part of a deliverable of The SPIRIT Consortium.
// 
// Use of these materials are governed by the legal terms and conditions
// outlined in the disclaimer available from www.spiritconsortium.org.
// 
// This source file is provided on an AS IS basis.  The SPIRIT
// Consortium disclaims any warranty express or implied including
// any warranty of merchantability and fitness for use for a
// particular purpose.
// 
// The user of the source file shall indemnify and hold The SPIRIT
// Consortium and its members harmless from any damages or liability.
// Users are requested to provide feedback to The SPIRIT Consortium
// using either mailto:feedback@lists.spiritconsortium.org or the forms at 
// http://www.spiritconsortium.org/about/contact_us/
// 
// This file may be copied, and distributed, with or without
// modifications; but this notice must be included on any copy.

#ifndef _IRQCTRL_H_
#define _IRQCTRL_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <systemc.h>

#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "user_types.h"

/*------------------------------------------------------------------------------
 * Define device parameters
 *----------------------------------------------------------------------------*/
#define IRQ_BASE_ADDR     0x0000 // in global systems, start at: 0x30000000
#define IRQ_SIZE          0x1000 // 4Kb

/*------------------------------------------------------------------------------
 * Define IRQ Registers
 * Note : here static, but could be read from external description
 *----------------------------------------------------------------------------*/
#define IRQ_MASK      0x0000
#define IRQ_PENDING   0x0004
#define IRQ_FORCE     0x0008
#define IRQ_CLEAR     0x000c
#define IRQ_READCLEARPENDING   0x0010

/*------------------------------------------------------------------------------
 * Define IRQ Register
 * Note : here static, but could be read from external description
 *----------------------------------------------------------------------------*/
#define IRQ_DISABLED      0
#define IRQ_ENABLED       1

/*------------------------------------------------------------------------------
 * leon2 irqctrl
 *----------------------------------------------------------------------------*/

class irqctrl :
  public sc_module ,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public:
  SC_HAS_PROCESS(irqctrl);
  irqctrl( sc_module_name module_name);
  ~irqctrl();

  pv_target_port<ADDRESS_TYPE,DATA_TYPE>    apb_slave_port;
  sc_in<int>		int0;
  sc_in<int>		int1;
  sc_in<int>		int2;
  sc_in<int>		int3;
  sc_in<int>		int4;
  sc_out<int>	  irlout;
  sc_in<int>	  irlin;
  sc_in<bool>		intack;

  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );

private:
  int irq_mask;
  int irq_level;
  int irq_pending;
  int irq_force;
  int irq_last;
  int irl;
  sc_event force_change;
  void init_register();
  void run();
  void run2();
  void ack();
  void end_of_elaboration();
};

#endif /* _IRQCTRL_H_ */
