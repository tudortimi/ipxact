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
 * Simple APB wire abstraction systemC memory
 * 4K byte addressSpace.  address FC = ID = 0xD08
 *------------------------------------------------------------------------------*/

#ifndef _APBRAM_H_
#define _APBRAM_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "systemc.h"

#define MEMORYDEPTH 1023
#define MEMORYDEPTHLV "001111111110"

/*------------------------------------------------------------------------------
 * APBRAM 
 *----------------------------------------------------------------------------*/
class apbram :
   public sc_module
{
 public:
  apbram( sc_module_name module_name);
  ~apbram();
  SC_HAS_PROCESS( apbram );
  
  sc_in<sc_logic>     pclk;
  sc_in<sc_logic>     presetn;
  sc_in<sc_logic>     psel;
  sc_in<sc_logic>     penable;
  sc_in<sc_logic>     pwrite;
  sc_in<sc_lv<12> >    paddr;
  sc_in<sc_lv<32> >    pwdata;
  sc_out<sc_lv<32> >   prdata;
  
 private:
  sc_pvector<sc_lv<32> > memory;
  void end_of_elaboration();
  void memory_process();
};
 

#endif  /* _APBRAM_H_ */
