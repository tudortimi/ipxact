 /*------------------------------------------------------------------------------
 * Simple TLM DMA
 * 
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2006, 2007, 2008, 2009 The SPIRIT Consortium.
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
 *
 *------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "dma.h"


/*------------------------------------------------------------------------------
 * Constants							       
 *----------------------------------------------------------------------------*/
// Register relative addresses
const int dma::SRC_ADDR;
const int dma::DST_ADDR;
const int dma::LENGTH;
const int dma::CONTROL;

// Control register bit
const int dma::START;
const int dma::IRQ;

//----------------
// Constructor
//----------------
dma::dma(sc_module_name module_name,
	       tlm::tlm_endianness endian) :
  sc_module(module_name),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port("apb_slave_port"),
  ahb_master_port("ahb_master_port"),
  m_endian(endian),
  m_dma_src_addr(0),
  m_dma_dst_addr(0),
  m_dma_control(0) {

  apb_slave_port(*this);

  SC_METHOD(transfer);
  sensitive << m_start_transfer;
  dont_initialize();

  SC_METHOD(irq);
  sensitive << m_irq_to_change;
  dont_initialize();
  
  int_master_port.initialize(false);

  std::cout << name() << " module created - "<< ((m_endian == tlm::TLM_BIG_ENDIAN) ? "big": "little") << " endian\n";

}


//----------------------------------------
// pv_if virtual method implementation
//----------------------------------------

//------------------------------------------------------------------------------
// DMA read access 

tlm::tlm_status dma::read(const ADDRESS_TYPE &addr , DATA_TYPE &data,
			     const unsigned int byte_enable,
			     const tlm::tlm_mode mode,
			     const unsigned int export_id
			     ) {
  tlm::tlm_status status;
  
  switch (addr)
    {      
    case SRC_ADDR:       
      data = m_dma_src_addr; // Read dma source address register
    std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": read dma source address register, returns " << m_dma_src_addr << std::endl;
      break;
      
    case DST_ADDR: 
      data = m_dma_dst_addr; // Read dma destination address register
    std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": read dma destination address register, returns " << m_dma_dst_addr << std::endl;
      break;  
      
    case CONTROL: 
      data= m_dma_control;
      std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": read dma control register, returns " << (int)m_dma_control << std::endl;
      wait(SC_ZERO_TIME); // control register is a system synchronization point
      break;

    default:       
      std::cout << "ERROR\t" << name() << std::showbase << std::hex;
      std::cout << ": DMA has received a request with input address out of range: " << addr << std::endl;
      return(status);
    }
    
  status.set_ok();

  return(status);
}


//------------------------------------------------------------------------------
// Write access 
tlm::tlm_status dma::write(const ADDRESS_TYPE &addr , const DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id
			      ) {
  tlm::tlm_status status;

  switch (addr)
    {
    case SRC_ADDR: 
      m_dma_src_addr  = data; // Write dma source address register
      break;

    case DST_ADDR: 
      m_dma_dst_addr  = data; // Write dma destination address register
      break;

    case CONTROL: 
      {	
	if (data==0x1a08 ){
	  //&& (!( m_dma_control & START))) {
	  m_start_transfer.notify();
	  m_dma_control |= START; 
	}	
	if ((!(data & IRQ)) && (m_dma_control & IRQ)) {
	  m_dma_control &= ~IRQ;
	  m_irq_to_change.notify();
	}	
      }
      break;

    default: 
      std::cout << "ERROR\t[" << name() << "]:  received a request with input address out of range: "
		<< std::showbase << std::hex << addr << std::endl;
      return(status);
    }
  status.set_ok();
  return(status);
}


//------------------------------------------------------------------------------
// Transfer end IRQ signal management
void dma::irq() {
  if (m_dma_control & IRQ) {
    int_master_port.write(true);
    std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": rise transfer end IRQ \n";
  } else {
    int_master_port.write(false);  
    std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": clear transfer end IRQ \n";
  }
}


//------------------------------------------------------------------------------
// dma transfer management
void dma::transfer() {
  tlm::tlm_status status;
  //    if (m_dma_control & START) {
  std::cout << "DEBUG\t" << name() << std::showbase << std::hex << ": dma transfer started. Source address: "
	    << m_dma_src_addr << " - destination address: " << m_dma_dst_addr  << std::endl;
  
  // starts the memory transfer
  // copy data from memory start address (SRC_ADDR) to memory destination address (DST_ADDR)
  DATA_TYPE tmp;
  for(int i = 0;i<LENGTH;i++) {
    status = ahb_master_port.read(m_dma_src_addr + i,tmp);
    if (status.is_error()) 
      std::cout << "ERROR\t" << name() << ": read memory failure at " << (m_dma_src_addr +i) << std::endl;
    else {
      status = ahb_master_port.write(m_dma_dst_addr + i,tmp);
      if (status.is_error()) 
	std::cout << "ERROR\t" << name() << ": write memory failure at " << (m_dma_dst_addr +i) << std::endl;
    }
  }
      
  // Clear the START bit of the control register 
  m_dma_control &= ~START;
  
  // Interrupt generation
  if (!(m_dma_control&IRQ)) {
    m_dma_control |= IRQ;
    m_irq_to_change.notify();
  }
}





/* END of dma.cc */
