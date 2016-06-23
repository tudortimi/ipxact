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

#ifndef _AHBRAM_H_
#define _AHBRAM_H_

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
#define MEM_BASE_ADDR     0x0

/*------------------------------------------------------------------------------
 * leon2 ahbram
 *----------------------------------------------------------------------------*/

class ahbram :
  public sc_module ,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public:
  SC_HAS_PROCESS(ahbram);
  ahbram( sc_module_name module_name , unsigned long addrsize = 18);
  ~ahbram();

  pv_target_port<ADDRESS_TYPE , DATA_TYPE> ahb_slave_port;

  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );
  
private:
  void end_of_elaboration();
  sc_pvector<DATA_TYPE> memory;
  int memorySize;
  void init_memory(unsigned long s);
};


#endif /* _AHBRAM_H_ */
