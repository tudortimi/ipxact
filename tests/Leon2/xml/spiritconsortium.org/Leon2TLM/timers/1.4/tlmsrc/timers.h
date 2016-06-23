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


#ifndef _TIMERS_H_
#define _TIMERS_H_

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
#define TIMER_BASE_ADDR     0x0000 // in global systems, start at: 0x30001000
#define TIMER_SIZE          0x1000 // 4Kb

/*------------------------------------------------------------------------------
 * Define Timer Registers
 * Note : here static, but could be read from external description
 *----------------------------------------------------------------------------*/

#define TIMER_REGISTER_SIZE     0x4 // in bytes
#define TIMER0_COUNTER          TIMER_BASE_ADDR
#define TIMER0_RELOAD           TIMER_BASE_ADDR + 1*TIMER_REGISTER_SIZE
#define TIMER0_CONTROL          TIMER_BASE_ADDR + 2*TIMER_REGISTER_SIZE
#define WATCHDOG_COUNTER        TIMER_BASE_ADDR + 3*TIMER_REGISTER_SIZE
#define TIMER1_COUNTER          TIMER_BASE_ADDR + 4*TIMER_REGISTER_SIZE
#define TIMER1_RELOAD           TIMER_BASE_ADDR + 5*TIMER_REGISTER_SIZE
#define TIMER1_CONTROL          TIMER_BASE_ADDR + 6*TIMER_REGISTER_SIZE
#define PRESCALER_COUNTER       TIMER_BASE_ADDR + 7*TIMER_REGISTER_SIZE
#define PRESCALER_RELOAD_VALUE  TIMER_BASE_ADDR + 8*TIMER_REGISTER_SIZE

#define TIMER_ENABLE        1
#define TIMER_LOAD          2
#define TIMER_CTRL          4
#define TIMER_DISABLED      0
#define TIMER_ENABLED       1
/*------------------------------------------------------------------------------
 * leon2 timers
 *----------------------------------------------------------------------------*/

class timers :
  public sc_module ,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public:
  SC_HAS_PROCESS(timers);
  timers( sc_module_name module_name );
  ~timers();

  pv_target_port<ADDRESS_TYPE,DATA_TYPE>    apb_slave_port;
  sc_out<int>		int0;
  sc_out<int>		int1;
  sc_in<sc_logic>	clk;

  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );

private:
  sc_pvector<DATA_TYPE> registers;
  int prescaler;
  void init_registers();
  void count();
  void end_of_elaboration();
};

#endif /* _TIMERS_H_ */
