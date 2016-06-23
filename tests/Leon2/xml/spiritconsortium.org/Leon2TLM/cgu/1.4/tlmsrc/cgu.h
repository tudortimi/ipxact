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
 * Each Clock output line has a 8 bits devide register.
 * If register[i]=0 => No divide (reset state)
 * If register[i]=1 => divide by 2 (reset state)
 * If register[i]=2 => divide by 4 
 * If register[i]=3 => divide by 8 ...
 *------------------------------------------------------------------------------*/

#ifndef _CGU_H_
#define _CGU_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "systemc.h"
#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "user_types.h"

/*------------------------------------------------------------------------------
 * CGU 
 *----------------------------------------------------------------------------*/
class cgu :
   public sc_module,
   public pv_slave_base < ADDRESS_TYPE , DATA_TYPE >
{
 public :
  cgu( sc_module_name module_name);
  SC_HAS_PROCESS( cgu );
  
  static const unsigned int NUMCLOCKS = 8;
  pv_target_port <ADDRESS_TYPE , DATA_TYPE> apb_slave_port;
  sc_out<sc_logic>  clkout[8];
  
  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );

 private:
  sc_clock        clk;
  sc_pvector<int> registers;
  sc_pvector<int> counters;
  void init_registers();
  void init_counters();
  void gen_clocks();
};
 

#endif  /* _CGU_H_ */
