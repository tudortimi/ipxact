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

 /*------------------------------------------------------------------------------
 * Simple Leon2 TLM interrupt controller
 * Note: in this (dummy) implementation we only use a single register
 * to enable or disable the interrupts.
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "irqctrl.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
irqctrl::irqctrl( sc_module_name module_name) :
  sc_module( module_name ),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  irlout("irlout"),
  irlin("irlin"),
  intack("intack"),
  int0("int0"),
  int1("int1"),
  int2("int2"),
  int3("int3"),
  apb_slave_port("apb_slave_port")
{
  apb_slave_port( *this );
  init_register();
  SC_METHOD(run);
  dont_initialize();
  sensitive << int0;
  sensitive << int1;
  sensitive << int2;
  sensitive << int3;
  sensitive << int4;
  SC_METHOD(run2);
  dont_initialize();
  sensitive << force_change;
  SC_METHOD(ack);
  dont_initialize();
  sensitive << intack;
  irlout.initialize(0);
}

irqctrl::~irqctrl() {
}

tlm::tlm_status irqctrl::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				const unsigned int byte_enable,
				const tlm::tlm_mode mode,
				const unsigned int export_id)
{
  tlm::tlm_status status;

  if ((addr < IRQ_BASE_ADDR) || (addr >= IRQ_BASE_ADDR+IRQ_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to write out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  if (addr==IRQ_MASK) { 
    irq_mask = (data >> 1) & 0x7FFF;
    irq_level = (data >> 17) & 0x7FFF;
    if (irq_mask > 0) {
      int i;
      for (i=1;i<=15;i++) {
	if ((irq_mask >> i-1) & 0x01) {
	  cout << name() << "    Interrupt " << i << " enabled: " << endl; 
	}
      }
    }
    force_change.notify();
  }

  if (addr==IRQ_FORCE) {
    irq_force = (data >> 1) & 0x7FFF;
    force_change.notify();
  }

  // clear the pending bit
  if (addr==IRQ_CLEAR) irq_pending = irq_pending & ~(data >> 1) & 0x7FFF;

  status.set_ok();
  return status;
}

tlm::tlm_status irqctrl::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < IRQ_BASE_ADDR) || (addr >= IRQ_BASE_ADDR+IRQ_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to read out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  if (addr==IRQ_MASK) data = ((irq_mask << 1) & 0xFFFE) | ((irq_level << 17) & 0xFFFE0000);
  if (addr==IRQ_PENDING) data = ((irq_pending << 1) & 0xFFFE);
  if (addr==IRQ_FORCE) data = 0;
  if (addr==IRQ_CLEAR) data = 0;
  if (addr==IRQ_READCLEARPENDING) {
    data = irl;
    force_change.notify();
  }
  cout << name() << "    Read IRQ register value: " << data << endl; 
  status.set_ok();
  return status;
}

void irqctrl::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

void irqctrl::init_register()
{
  irq_mask=0;
  irq_level=0;
  irq_pending=0;
  irq_force=0;
  irl = 0;
  irq_last=0;
}

void irqctrl::run() 
{
  int pending;
  int last_pending = irq_pending;

  // just catch the rising edge of the interrupt
  pending = (~irq_last & ( int0.read()*1 + int1.read()*2 +int2.read()*4 +int3.read()*8 +int4.read()*16));
  irq_pending = irq_pending | pending;

  irq_last = ( int0.read()*1 + int1.read()*2 +int2.read()*4 +int3.read()*8 +int4.read()*16);

  // just call if things changed
  if (irq_pending != last_pending)
	  force_change.notify();
}

void irqctrl::run2() 
{
  int hilevel = (irq_force | irq_pending ) & irq_mask & irq_level;
  int lolevel = (irq_force | irq_pending ) & irq_mask & (~irq_level & 0x7FFF);

  // reset the force register after processing.
  irq_force = 0;

  if (hilevel > 0  && hilevel >= lolevel) {
    int i;
    for (i=15;i>=1;i--) {
      if (hilevel & (0x1 << i-1)) {
        irlout.write(i);	
	cout << name() << " interrupt set to level " << i << " At time " << sc_time_stamp() << endl;
	irl = i;
	break;
      }
    }
  }
  else {
    if (lolevel > 0  && lolevel > hilevel) {
      int i;
      for (i=15;i>=1;i--) {
	if (lolevel & (0x1 << i-1)) {
	  irlout.write(i);	
	  cout << name() << " interrupt set to level " << i <<" At time " <<  sc_time_stamp() << endl;
	  irl = i;
	  break;
	}
      }
    }
    else {
      irlout.write(0);	
      cout << name() << " interrupt set to level " << 0 << " At time " << sc_time_stamp() << endl;
      irl = 0;
    }
  }
}

void irqctrl::ack() 
{
  if (intack.read() == 1) {
    cout << name() << " got interrupt ack" << endl;
    irq_pending = irq_pending & (~(0x1 << (irlin-1)) & 0x7FFF);
    force_change.notify();
  }
}
