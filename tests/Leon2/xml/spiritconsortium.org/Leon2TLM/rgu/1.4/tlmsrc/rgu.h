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
 * Reset delay generator PV example. Produces a reset vector of 8 bits.
 * Each reset output line has a 8 bits delay register.
 * reset(0) = read only delay at address 0x0
 * reset(1) = read only delay at address 0x4
 * reset(2) = read only delay at address 0x8
 * reset(3) = read only delay at address 0xC
 * reset(4) = read only delay at address 0x10
 * reset(5) = read only delay at address 0x14
 * reset(6) = read only delay at address 0x18
 * reset(7) = read only delay at address 0x1C
 * The delay value (stored in the above reset registers) is the number 
 * of clocks from when the reset input is deasserted  till the 
 * reset output is deasserted. i.e.
 * 0 = No Delay 
 * 1 = Delay by 1 clock
 * 2 = Delay by 2 clocks
 * 3 = Delay by 3 clocks ...
 * The 8 other registers are used as non volatile storage inside the RGU
 * memory[0] = read/write register at address 0x20
 * memory[1] = read/write register at address 0x24
 * memory[2] = read/write register at address 0x28
 * ...
 * memory[7] = read/write register at address 0x3C
 * 4K byte addressSpace.
 *------------------------------------------------------------------------------*/

#ifndef _RGU_H_
#define _RGU_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <systemc.h>

#include "user_types.h"
#include "pv_target_port.h"
#include "pv_slave_base.h"

#define NUMRESETS 8
#define NUMEEPROM 8
#define DELAYDEPTH 8

/*------------------------------------------------------------------------------
 * RGU 
 *----------------------------------------------------------------------------*/
class rgu :
   public sc_module,
   public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
 public:
  rgu( sc_module_name module_name);
  SC_HAS_PROCESS( rgu );
  
  pv_target_port<ADDRESS_TYPE , DATA_TYPE> apb_slave_port;
  sc_in<sc_logic> rstin_an;
  sc_out<bool>    rstout_an[NUMRESETS];
  sc_in<sc_logic>     ipclk;
  
  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );

 private:
  sc_pvector<int> registers;
  sc_pvector<int> counter;
  sc_pvector<int> memory;
  void init_registers();
  void init_memory();
  void gen_resets();
};
 

#endif  /* _RGU_H_ */
