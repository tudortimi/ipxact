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
 * Simple TLM CGU
 * Clock diviser PV example. Produces a clock vector of 8 bits.
 * Each Clock output line has an 8 bit divide register.
 * If register[i]=0 => No divide (reset state)
 * If register[i]=1 => divide by 2 
 * If register[i]=2 => divide by 4 
 * If register[i]=3 => divide by 8 ...
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "cgu.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
cgu::cgu( sc_module_name module_name) :
  sc_module(module_name), 
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port ("apb_slave_port"),
  clkin("clkin")
{
  apb_slave_port( *this );
  SC_METHOD( gen_clocks );
  sensitive << clkin;
  init_registers();
  init_counters();
}

tlm::tlm_status cgu::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			    const unsigned int byte_enable,
			    const tlm::tlm_mode mode,
			    const unsigned int export_id )
{
  tlm::tlm_status status;
  if ((addr / 4) < NUMCLOCKS) {
    registers[addr/4] = data & 0xFF;
  }
  status.set_ok();
  return status;
}

tlm::tlm_status cgu::read ( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			    const unsigned int byte_enable,
			    const tlm::tlm_mode mode,
			    const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr/4) < NUMCLOCKS) { // read the registers
    data = registers[addr/4];
  } else if ( addr == 0xFFC) { // read the ID register
    data = 0xD00;
  } else {
    data = 0x0;
  }
  status.set_ok();
  return status;
}


void cgu::gen_clocks()
{
  for (int i=0; i<NUMCLOCKS; i++) {
    if (registers[i] == 0) {
      clkout[i].write(static_cast<sc_logic>(clkin.read()));
    }
    else {
      if (clkin.read()) {
	if (counters[i] == 0) {
		clkout[i].write(static_cast<sc_logic>(0));
  //	      cout << "clock[" << i << "]=0  " << sc_time_stamp() << endl;
	}
	else if (counters[i] == registers[i]) {
		clkout[i].write(static_cast<sc_logic>(1));
  //	      cout << "clock[" << i << "]=1  " << sc_time_stamp() << endl;
	}
	counters[i]++;
	if (counters[i] == 2*registers[i]) // counter actually counts to 2x the register value. 
	  counters[i] = 0;
      }
    }
  }
}

void cgu::init_registers()
{
 for (int i=0;i<NUMCLOCKS;i++) registers[i]=0;
}

void cgu::init_counters()
{
 for (int i=0;i<NUMCLOCKS;i++) counters[i]=0;
}

