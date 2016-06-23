/*******************************************************************************
 *                    SPIRIT 1.4 OSCI-TLM-PV to APB example
 *------------------------------------------------------------------------------
 * Simple Leon2 TLM PV to APB converter
 *------------------------------------------------------------------------------
 * Revision:    1.0
 * Authors:     SWG
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
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
 * http://www.spiritconsortium.org/about/contact_us/
 * 
 * This file may be copied, and distributed, with or without
 * modifications; but this notice must be included on any copy.
 *---------------------------------------------------------------------------*/

#ifndef _PV2APB_H_
#define _PV2APB_H_

#include <systemc.h>
#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "user_types.h"

class pv2apb : 
  public sc_module,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public:
  SC_HAS_PROCESS(pv2apb);

  sc_in<sc_logic>     pclk;
  sc_in<sc_logic>     presetn;
  sc_out<sc_logic>    psel;
  sc_out<sc_logic>    penable;
  sc_out<sc_logic>    pwrite;
  sc_out<sc_lv<12> >  paddr;
  sc_out<sc_lv<32> >  pwdata;
  sc_in<sc_lv<32> >   prdata;

  
  pv2apb( sc_module_name module_name );
  ~pv2apb();

  pv_target_port<ADDRESS_TYPE,DATA_TYPE>    tlmpv_slave_port;

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
  void reset();
}; 

#endif
