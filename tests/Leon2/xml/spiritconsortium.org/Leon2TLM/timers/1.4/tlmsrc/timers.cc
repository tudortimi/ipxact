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
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "timers.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
timers::timers( sc_module_name module_name ) :
  sc_module( module_name ),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port("apb_slave_port"),
  int0("int0"),
  int1("int1"),
  clk("clk")
{
  apb_slave_port( *this );
  int0.initialize(false);
  int1.initialize(false);
  init_registers();
  SC_METHOD(count); // timer process
  dont_initialize();
  sensitive << clk;
}

timers::~timers() {
}

void timers::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

tlm::tlm_status timers::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			       const unsigned int byte_enable,
			       const tlm::tlm_mode mode,
			       const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < TIMER_BASE_ADDR) || (addr >= TIMER_BASE_ADDR+TIMER_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to write out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  // Write the register with the correct mask.
  switch (addr) {
    case TIMER0_CONTROL:
      registers[addr] = data & 0x7;
      break;
    case TIMER1_CONTROL:
      registers[addr] = data & 0x7;
      break;
    case PRESCALER_COUNTER:
      registers[addr] = data & 0x3FF;
      break;
    case PRESCALER_RELOAD_VALUE:
      registers[addr] = data & 0x3FF;
      break;
    default :
      registers[addr] = data & 0xFFFFFF;
      break;
  }

  if (addr==TIMER0_CONTROL) {
    // reload timer
    if (data & TIMER_CTRL) {
      cout << name() << " Timer0 forced reload" << endl;
      registers[TIMER0_COUNTER] = registers[TIMER0_RELOAD];
      registers[TIMER0_CONTROL] = data & 0x3; // reset reload bit
    }
    if ((data & TIMER_ENABLE) == TIMER_DISABLED) {
      cout << name() << " Timer0 disabled (clear control register0)" << endl;
    }
  }

  if (addr==TIMER1_CONTROL) {
    // reload timer
    if (data & TIMER_CTRL) {
      cout << name() << " Timer1 forced reload" << endl;
      registers[TIMER1_COUNTER] = registers[TIMER1_RELOAD];
      registers[TIMER1_CONTROL] = data & 0x3; // reset reload bit
    }
    if ((data & TIMER_ENABLE) == TIMER_DISABLED) {
      cout << name() << " Timer1 disabled (clear control register1)" << endl;
    }
  }

  status.set_ok();
  return status;
}

tlm::tlm_status timers::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < TIMER_BASE_ADDR) || (addr >= TIMER_BASE_ADDR+TIMER_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to read out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  data = registers[addr];
  status.set_ok();
  return status;
}

void timers::init_registers() 
{
  for (int i=0; i < 9; i++) registers[i]=0;
}

void timers::count() 
{
  
  if (clk.posedge()) {

  // Prescaler
  if ((registers[PRESCALER_COUNTER] > 0)) { 
    registers[PRESCALER_COUNTER]--;
  }
  else {
    registers[PRESCALER_COUNTER] = registers[PRESCALER_RELOAD_VALUE];
  }
 
  // Update the timer only if the prescaler value is 0
  if ((registers[PRESCALER_COUNTER] == 0)) { 
    // Timer 0
    if ((registers[TIMER0_CONTROL] & TIMER_ENABLE) == TIMER_ENABLED) {
      if ((registers[TIMER0_COUNTER] > 0)) { 
	cout << "... T0=" << registers[TIMER0_COUNTER] << " At Time " << sc_time_stamp() << endl;
	registers[TIMER0_COUNTER]--;
      }
      if (registers[TIMER0_COUNTER] == 0) {
 	int0.write(1);
	if ((registers[TIMER0_CONTROL] & TIMER_LOAD)) {
	  registers[TIMER0_COUNTER] = registers[TIMER0_RELOAD];
	}
      }
      else {
	if (int0.read() == 1) 
  	  int0.write(0);
      }
    }

    // Timer 1
    if ((registers[TIMER1_CONTROL] & TIMER_ENABLE) == TIMER_ENABLED) {
      if ((registers[TIMER1_COUNTER] > 0)) { 
	cout << "... T1=" << registers[TIMER1_COUNTER] << " At Time " << sc_time_stamp() << endl;
	registers[TIMER1_COUNTER]--;
      }
      if (registers[TIMER1_COUNTER] == 0) {
	int1.write(1);
	if ((registers[TIMER1_CONTROL] & TIMER_LOAD)) {
	  registers[TIMER1_COUNTER] = registers[TIMER1_RELOAD];
	}
      }
      else {
	if (int1.read() == 1) 
	  int1.write(0);
      }
    }
  }

  if ((registers[TIMER0_CONTROL] & TIMER_ENABLE) == TIMER_DISABLED && int0.read() == 1) {
    int0.write(0);
  }

  if ((registers[TIMER1_CONTROL] & TIMER_ENABLE) == TIMER_DISABLED && int1.read() == 1) {
    int1.write(0);
  }

  // Timer count rate ( SC kernel recall this method when simulation time
  // reaches now + 10 ns
  //next_trigger(10,SC_NS);
  }
}
