/*------------------------------------------------------------------------------
 * Simple TLM DMA
 * 
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
 * 
 * This work forms part of a deliverable of The SPIRIT Consortium.
 * 
 * Use of these materials are governed by the legal terms and conditions
 * outlined in the disclaimer available from www.spiritconsortium.org.
 * 
 * This source file is provided on an AS IS basis.  The SPIRIT
 * Consortium disclaims any warranty express or implied including
 * any warranty of merchantability and fitness for use for a
 * particular purpose.
 * 
 * The user of the source file shall indemnify and hold The SPIRIT
 * Consortium and its members harmless from any damages or liability.
 * Users are requested to provide feedback to The SPIRIT Consortium
 * using either mailto:feedback@lists.spiritconsortium.org or the forms at 
 * http: *www.spiritconsortium.org/about/contact_us/
 * 
 * This file may be copied, and distributed, with or without
 * modifications; but this notice must be included on any copy.
 *
 * The following code is derived, directly or indirectly, from the SystemC
 * source code Copyright (c) 1996-2006 by all Contributors.
 * All Rights reserved.
 *
 * The contents of this file are subject to the restrictions and limitations
 * set forth in the SystemC Open Source License Version 2.4 (the "License");
 * You may not use this file except in compliance with such restrictions and
 * limitations. You may obtain instructions on how to receive a copy of the
 * License at http://www.systemc.org/. Software distributed by Contributors
 * under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
 * ANY KIND, either express or implied. See the License for the specific
 * language governing rights and limitations under the License.
 *------------------------------------------------------------------------------*/

#ifndef _DMA_H_
#define _DMA_H_

/*------------------------------------------------------------------------------
 * Includes
 *----------------------------------------------------------------------------*/ 
#include "systemc.h"
#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "pv_initiator_port.h"
#include "user_types.h"

//------------------------------------------------------------------------------
class dma : 
  public sc_module,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public :

  // Registers relative addresses
  static const int SRC_ADDR  = 0x0000;  
  static const int DST_ADDR  = 0x0004; 
  static const int CONTROL   = 0x0008; 
  // hardcoded lenght of the block transfer
  static const int LENGTH    = 0x001F; 
  
  // Control register bits
  static const int START = 0x1000;
  static const int IRQ   = 0x0010;


  //---------------
  // Module ports
  //---------------
  pv_target_port<ADDRESS_TYPE , DATA_TYPE> apb_slave_port;
  pv_initiator_port<ADDRESS_TYPE , DATA_TYPE> ahb_master_port;
  sc_out<int> int_master_port;

  //----------------
  // Constructor
  //----------------  
  SC_HAS_PROCESS(dma);
  dma(sc_module_name module_name,
	 tlm::tlm_endianness endian = PV_HOST_ENDIAN);

  //--------------------------------------------------------------------------------------------
  //Abstract class pv_if methods implementation (overides pv_slave_base default implementation)
  //--------------------------------------------------------------------------------------------
  
  tlm::tlm_status write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			 const unsigned int byte_enable = tlm::NO_BE,
			 const tlm::tlm_mode mode = tlm::REGULAR,
			 const unsigned int export_id = 0 );
  tlm::tlm_status read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			const unsigned int byte_enable = tlm::NO_BE,
			const tlm::tlm_mode mode = tlm::REGULAR,
			const unsigned int export_id = 0 );


protected:
  
  tlm::tlm_endianness m_endian;       // dma endianness    
  sc_event m_start_transfer;          // dma process related event (start)
  sc_event m_irq_to_change;           // rise/clear interrupt signal related event
  ADDRESS_TYPE m_dma_src_addr;       // Source address register
  ADDRESS_TYPE m_dma_dst_addr;       // Destination address register
  tlm::tlm_uint8_t m_dma_control;  // control register (8 bits register)    
  
  void transfer();                    // dma transfer management process 
  void irq();                         // dma transfer end IRQ signal management process
};

#endif /* _DMA_H_ */


