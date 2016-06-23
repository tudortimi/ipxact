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
 * Simple TLM RGU
 * Clock diviser PV example. Produces a clock vector of 8 bits.
 * Each Clock output line has a 8 bits devide register.
 * If register[i]=0 => No divide (reset state)
 * If register[i]=1 => divide by 2 
 * If register[i]=2 => divide by 4 
 * If register[i]=3 => divide by 8 ...
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "rgu.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
rgu::rgu( sc_module_name module_name) :
  sc_module( module_name ) , 
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port ("apb_slave_port"),
  ipclk ("ipclk"),
  rstin_an ("rstin_an")
{
  apb_slave_port( *this );
  SC_METHOD( gen_resets );
  sensitive << ipclk;
  init_registers();
  init_memory();
}

tlm::tlm_status rgu::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			    const unsigned int byte_enable,
			    const tlm::tlm_mode mode,
			    const unsigned int export_id )
{
  tlm::tlm_status status;
  if ((addr/4) < NUMRESETS + NUMEEPROM) {
    memory[addr/4] = data;
  }
  status.set_ok();
  return status;
}

tlm::tlm_status rgu::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			   const unsigned int byte_enable,
			   const tlm::tlm_mode mode,
			   const unsigned int export_id )
{
  tlm::tlm_status status;
  if ((addr/4) < NUMRESETS) { // read the registers
    data = registers[addr/4];
  } else if (addr < NUMRESETS + NUMEEPROM) { 
    data = memory[addr/4]; // read the memory registers
  } else if (addr == 0xFFC) { // read the ID register
    data = 0xD01;
  } else {
    data = 0x0;
  }
  status.set_ok();
  return status;
}

void rgu::gen_resets()
{
  if (rstin_an==0) {
    for (int i=0; i<NUMRESETS; i++) {
      if (rstout_an[i].read())
	rstout_an[i].write(0);
      counter[i] = registers[i];
    }
  } else {
    if (ipclk.read() == SC_LOGIC_1) {
      for (int i=0; i<NUMRESETS; i++) {
	if (counter[i] == 0) {
	  if (rstout_an[i].read() != 1) {
	    rstout_an[i].write(1);
	    cout << name() << ": Reset " << i << " deasserted at time " << sc_time_stamp() << endl;
	  }
	}
	else {
	  counter[i]--;
	}
      }
    }
  }
}

void rgu::init_registers()
{
 for (int i=0;i<NUMRESETS;i++) {
   registers[i]=0x01 << i+1;
   counter[i] = registers[i];
 }
}

void rgu::init_memory()
{
 for (int i=0;i<NUMEEPROM;i++) memory[i]=0;
}
