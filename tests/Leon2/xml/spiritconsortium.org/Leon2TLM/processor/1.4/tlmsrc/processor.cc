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
 * Simple TLM processor
 * Note:  this is a dummy implementation of a Leon2 processor. 
 * One should read this model as a simple testbench generator.
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "processor.h"
#include <string>
#include <map>
#include <vector>
#include <sstream>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
processor::processor( sc_module_name module_name , char* tb_file_name) :
  sc_module( module_name ), 
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port("apb_slave_port"),
  ahb_master_port ("ahb_master_port"),
  irl_port ("irl_port"),
  irqvec_port ("irq_port"),
  intack_port ("ack_port"),
  clk ("clk"),
  rst_an ("rst_an"),
  cmdIndex_(0),
  enableInterrupt_(true)
{
  apb_slave_port( *this );
  init_local_memory();
  SC_THREAD( ahbMaster );
  sensitive << clk;
  SC_METHOD( restart );
  sensitive << rst_an;
  SC_METHOD( catch_it );
  dont_initialize();
  sensitive << irl_port;
  read_testbench_file(tb_file_name);
  cout << "-----------------------------" << endl;
  cout << "Elaborating" << endl;
  cout << "-----------------------------" << endl;
  intack_port.initialize(0);
  irqvec_port.initialize(0x0);
}

processor::~processor() {
  cout << "-----------------------------" << endl;
  cout << "Simulation done" << endl;
  cout << "-----------------------------" << endl;
}

void processor::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

// the big statemachine (simplified compared to RTL)
void processor::ahbMaster() {
  tlm::tlm_status status;
  tb_cmd_t trans;
  int mask;
  DATA_TYPE localData;
  DATA_TYPE data;

  while (true) {
//  while (cmdIndex_ < numTbCmds_) {
    while (rst_an.read() == false) {
      wait();
    }

    while (cmdIndex_ == numTbCmds_)
      wait();

    if (cmdIndex_ == 0 ) {
      cout << "-----------------------------" << endl;
      cout << "Ready to start the simulation" << endl;
      cout << "-----------------------------" << endl;
    }
    
    // get next command
    trans = tbData_[cmdIndex_];
    cmdIndex_++;
    // generate transactions based on command 
    switch (trans.cmd) {
    case IDLE: 
      for (int j=0; j<trans.idle and rst_an.read(); j++) {
	wait();
	while (clk.read() != SC_LOGIC_1)
	  wait();
      }
      cout << "[" << name()  << "]: stayed       IDLE   for : " 
	   << std::dec << trans.idle  << " clock cycles" 
	   << "\tAt time " << sc_time_stamp() << endl;
      break;
    case READ:
      if ((trans.addr >= PROC_LOCALMEMORY_BASE_ADDR) &&
	  (trans.addr < (PROC_LOCALMEMORY_BASE_ADDR + PROC_LOCALMEMORY_SIZE))) { 
	// internal read
	localData = local_memory[trans.addr-PROC_LOCALMEMORY_BASE_ADDR]; // & trans.mask;
	// display vaue read
	cout << "[" << name()  << "]: local memory READ  data : " 
	     << std::showbase << std::hex << localData 
	     << " from address \t" << std::showbase << std::hex << trans.addr
	     << "\tAt time " << sc_time_stamp() << endl;
	// check vs expected vaue
	if (trans.data!=localData) {
	  cout << "WARNING: expected data value " << std::showbase << std::hex << trans.data  << endl;
	}
      } else {
	status = ahb_master_port.read(trans.addr, data);
	if (status.is_ok()) {
	  // display value read
	  cout << "[" << name()  << "]: external     READ  data : " 
	       << std::showbase << std::hex << data
	       << " from address \t" << std::showbase << std::hex << trans.addr 
	       << "\tAt time " << sc_time_stamp() << endl;
	  // check vs expected vaue
	  if ((trans.data & trans.mask) != (data & trans.mask)) {
	    cout << "WARNING: expected data value " << std::showbase << std::hex << trans.data << endl;
	  }
	} 
	else {
	  cout << "[" << name()  << "]: external     READ returned ERROR expected data : " 
	       << std::showbase << std::hex << trans.data
	       << " from address \t" << std::showbase << std::hex << trans.addr 
	       << "\tAt time " << sc_time_stamp() << endl;
	}
      }
      break;
    case WRITE:
      if ((trans.addr >= PROC_LOCALMEMORY_BASE_ADDR) &&
	  (trans.addr < (PROC_LOCALMEMORY_BASE_ADDR + PROC_LOCALMEMORY_SIZE))) { 
	// internal write
	local_memory[trans.addr-PROC_LOCALMEMORY_BASE_ADDR] = trans.data;
	// display value written
	cout << "[" << name()  << "]: local memory WRITE data : " 
	     << std::showbase << std::hex << trans.data 
	     << " at address \t" << std::showbase << std::hex << trans.addr 
	     << "\tAt time " << sc_time_stamp() << endl;
      } else {
	// external write
	status = ahb_master_port.write(trans.addr, trans.data);
	if (status.is_ok()) {
	  // display value written
	  cout << "[" << name()  << "]: external     WRITE data : " 
	       << std::showbase << std::hex << trans.data 
	       << " to address \t" << std::showbase << std::hex << trans.addr
	       << "\tAt time " << sc_time_stamp() << endl;
	} 
	else {
	  cout << "[" << name()  << "]: external     WRITE returned ERROR expected data : " 
	       << std::showbase << std::hex << trans.data
	       << " to address \t" << std::showbase << std::hex << trans.addr 
	       << "\tAt time " << sc_time_stamp() << endl;
	}

      }
      break;
    case END: 
	  cout << "[" << name()  << "]: Table Finished " 
	       << "\tAt time " << sc_time_stamp() << endl;
      break;
    default:
      cout << "[" << name() << "]: WARNING Skiping Unknown command" << endl;
      break;
    }
    wait(); // next edge
    while (clk.read() != SC_LOGIC_1) // wait if not rising
      wait();
  }
}

// Watch for a reset
void processor::restart() {

  if (!rst_an.read()) {
    cout << name() << "   Reset" << "\tAt time " << sc_time_stamp() << endl;
    cmdIndex_ = 0;
  }
}


// Handle slave port write requests
tlm::tlm_status processor::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				  const unsigned int byte_enable,
				  const tlm::tlm_mode mode,
				  const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < PROC_BASE_ADDR) || (addr >= PROC_BASE_ADDR+PROC_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to write out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  // APB write. for now only effect is to reset the interrupt
  //enableInterrupt_ = !enableInterrupt_;
  //cout << name() << " : interrupts enable = " << enableInterrupt_ << endl;
  apb_memory[addr & PROC_SIZE] = data;

  status.set_ok();
  return status;
}

// Handle slave port read requests
tlm::tlm_status processor::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
				 const unsigned int byte_enable,
				 const tlm::tlm_mode mode,
				 const unsigned int export_id)
{
  tlm::tlm_status status;
  if ((addr < PROC_BASE_ADDR) || (addr >= PROC_BASE_ADDR+PROC_SIZE)) {
    cout << "ERROR\t" << name() << " : trying to read out of bounds at address " << addr << endl;
    status.set_error();
    return status;
  }
  data = apb_memory[addr & PROC_SIZE];

  status.set_ok();
  return status;
}

// Handle interrupt requests
void processor::catch_it() {
  // decode interrupt signal
  irqvec_port.write(irl_port.read());

  if (enableInterrupt_ && irl_port.read() != 0) {
    cout << name() << "   Got interrupt. Send ack and reset SubSystem Interrupt register" << endl;
    intack_port.write(1);
  }
  if (!enableInterrupt_ || irl_port.read() == 0) {
//    cout << name() << " intack low" << endl;
    intack_port.write(0);
  }
}

// Initialize local memory
void processor::init_local_memory() 
{
  for (unsigned long i=0; i < PROC_LOCALMEMORY_SIZE; i++) local_memory[i]=0;
  for (unsigned long i=0; i < PROC_SIZE; i++) apb_memory[i]=0;
}

// the file name should have the .tbl extension
// the file format is (
//   R Address Data <MASK>
//   W Address Data
//   I Clocks 
// Note: address and data values in HEX comments start with --
void processor::read_testbench_file( const char *file_name  ) {
  ifstream fd ( file_name );
  std::string line;
  std::string token, token2;
  if ( ! fd.is_open() ) {
    cout << "[" << name() << "]: ERROR Cannot open file " <<  file_name << endl;
    return;
  }
  int i=0;
  while( !fd.eof() ) {
      getline(fd ,line) ;
      std::istringstream iss(line);
      token = "";
      iss>>token;
      if (token=="" || (token[0]=='-' && token[1]=='-')) continue;
      switch (token[0]) {
      case 'R' :  
	tbData_[i].cmd = READ; 
	tbData_[i].cmdname = 'R'; 
	iss >> token2; tbData_[i].addr = std::strtol(token2.c_str(),0,16);
	iss >> token2; tbData_[i].data = std::strtol(token2.c_str(),0,16);
	iss >> token2;
	if (token2=="" || token2=="--" ) {
	  tbData_[i].mask = std::strtol("FFFFFFFF",0,16);
	} else {
	  tbData_[i].mask = std::strtol(token2.c_str(),0,16);
	}
	i++;
	break;
      case 'W' :  
	tbData_[i].cmd = WRITE; 
	tbData_[i].cmdname = 'W'; 
	iss >> token2; tbData_[i].addr = std::strtol(token2.c_str(),0,16);
	iss >> token2; tbData_[i].data = std::strtol(token2.c_str(),0,16);
	i++;
	break;
      case 'I' :  
	tbData_[i].cmd = IDLE; 
	tbData_[i].cmdname = 'I'; 
	iss >> token2; tbData_[i].idle = std::strtol(token2.c_str(),0,10);
	i++;
	break;
      case '-' :  
	tbData_[i].cmd = COMMENT; 
	tbData_[i].cmdname = 'C'; 
	i++;
	break;
      }
  }
  tbData_[i++].cmd = END; 
  numTbCmds_ = i;
}
