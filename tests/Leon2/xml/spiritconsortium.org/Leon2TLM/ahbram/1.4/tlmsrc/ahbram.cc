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
 * Simple Leon2 TLM AHBram memory
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "ahbram.h"


/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
ahbram::ahbram( sc_module_name module_name , unsigned long addrsize ) :
  sc_module( module_name ),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  ahb_slave_port("ahb_slave_port"),
  memory(0x1<<addrsize)
{
  memorySize = 0x1<<addrsize; // actual number of locations 
  ahb_slave_port( *this );
  init_memory(0x1<<addrsize);
}

ahbram::~ahbram() {
}

void ahbram::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

tlm::tlm_status ahbram::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			       const unsigned int byte_enable,
			       const tlm::tlm_mode mode,
			       const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < MEM_BASE_ADDR) || (addr >= MEM_BASE_ADDR+memorySize)) {
    cout << "ERROR\t" << name() << " : trying to write out of bounds at address " << memorySize <<  endl;
    status.set_error();
    return status;
  }
  memory[addr] = data;
  status.set_ok();
  return status;
}

tlm::tlm_status ahbram::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < MEM_BASE_ADDR) || (addr >= MEM_BASE_ADDR+memorySize)) {
    cout << "ERROR\t" << name() << " : trying to read out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  data = memory[addr];
  status.set_ok();
  return status;
}

void ahbram::init_memory(unsigned long s) 
{
  for (unsigned long i=0; i < s; i++) memory[i]=1;
}

