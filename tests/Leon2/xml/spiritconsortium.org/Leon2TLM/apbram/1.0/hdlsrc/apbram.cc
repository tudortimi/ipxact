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
 * Simple APB wire abstraction memory
 *------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "apbram.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
apbram::apbram( sc_module_name module_name) :
  sc_module( module_name ) , 
  pclk ("pclk"),
  presetn ("presetn"),
  psel ("psel"),
  penable ("penable"),
  pwrite ("pwrite"),
  paddr ("paddr"),
  pwdata ("pwdata"),
  prdata ("prdata")
{
  SC_METHOD( memory_process );
  sensitive << pclk;
  sensitive << presetn;
  prdata.initialize(0xdeadbeef);
}

void apbram::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

apbram::~apbram()
{
}

void apbram::memory_process()
{
  if (presetn.read() == '0') {
//    cout << name() << " reset" << endl;
    for (int i=0; i<MEMORYDEPTH; i++) {
      memory[i] = "00000000000000000000000000000000";
    }
    memory[MEMORYDEPTH] = "00000000000000000000110100001000";
  } else {
    if (pclk.posedge()) {

      sc_uint<12> addruint = paddr.read();
      int addr = addruint >> 2;
      if (pwrite.read() == '1' && psel.read() == '1' && penable.read() == '1' && addr < MEMORYDEPTH) {
//	cout << name() << " write addr=" << addr << endl;
	memory[addr] = pwdata.read();
      }
      if (pwrite.read() == '0' && psel.read() == '1' && penable.read() == '1' && addr <= MEMORYDEPTH) {
	sc_uint<32> datauint = memory[addr];
	int data = datauint;
	prdata.write(memory[addr]);
//	cout << name() << " read addr=" << addr << " data=" << data << endl;
      }
    }
  }
}

