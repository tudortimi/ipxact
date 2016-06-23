//
//Revision:    $Revision: 1506 $
//Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
//
//Copyright (c) 2008, 2009 The SPIRIT Consortium.
//
//This work forms part of a deliverable of The SPIRIT Consortium.
//
//Use of these materials are governed by the legal terms and conditions
//outlined in the disclaimer available from www.spiritconsortium.org.
//
//This source file is provided on an AS IS basis.  The SPIRIT
//Consortium disclaims any warranty express or implied including
//any warranty of merchantability and fitness for use for a
//particular purpose.
//
//The user of the source file shall indemnify and hold The SPIRIT
//Consortium and its members harmless from any damages or liability.
//Users are requested to provide feedback to The SPIRIT Consortium
//using either mailto:feedback@lists.spiritconsortium.org or the forms at 
//http://www.spiritconsortium.org/about/contact_us/
//
//This file may be copied, and distributed, with or without
//modifications; but this notice must be included on any copy.

#include "pv2tac.h"
#include "tac_if.h"
#include "tac_protocol.h"

pv2tac::pv2tac( sc_module_name module_name ) :
  sc_module( module_name ),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  tlmpv_slave_port("tlmpv_slave_port"),
  tac_master_port("tac_master_port")
{
  tlmpv_slave_port( *this );
}

void pv2tac::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

pv2tac::~pv2tac()
{
}

tlm::tlm_status pv2tac::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				const unsigned int byte_enable,
				const tlm::tlm_mode mode,
				const unsigned int export_id)
{
  tlm::tlm_status status;
  prt_tlm_tac::tac_error_reason error_reason;
  
  prt_tlm_tac::tac_request<tlm_uint32_t, tlm_uint32_t> req;
  prt_tlm_tac::tac_response<tlm_uint32_t> resp;
  
  tlm_uint32_t tdata = data;

  req.set_access(prt_tlm_tac::WRITE);
  req.set_access_mode(prt_tlm_tac::DEFAULT);
  req.set_address(addr);
  req.set_data_ptr(&tdata); // Correctness depends on DATA_TYPE
  req.set_number(1);
  req.set_byte_enable(prt_tlm_tac::NO_BE);
  req.set_block_byte_enable_period(0);
  req.set_error_reason(error_reason);
  req.set_port_id(0);
  
  tac_master_port.do_transport(req, resp);
 
  if (resp.get_status().is_ok()) {
    status.set_ok();
  } else {
    status.set_error();
  }
  return status;
}

tlm::tlm_status pv2tac::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  tlm::tlm_status status;
  prt_tlm_tac::tac_error_reason error_reason;

  prt_tlm_tac::tac_request<tlm_uint32_t, tlm_uint32_t> req;
  prt_tlm_tac::tac_response<tlm_uint32_t> resp;

  tlm_uint32_t tdata;
  
  req.set_access(prt_tlm_tac::READ);
  req.set_access_mode(prt_tlm_tac::DEFAULT);
  req.set_address(addr);
  req.set_data_ptr(&tdata); // Correctness depends on DATA_TYPE
  req.set_number(1);
  req.set_byte_enable(byte_enable);
  req.set_block_byte_enable_period(0);
  req.set_error_reason(error_reason);
  req.set_port_id(0);
  
  tac_master_port.do_transport(req, resp);
  
  data = tdata;


  if (resp.get_status().is_ok()) {
    status.set_ok();
  } else {
    status.set_error();
  }
  return status; 
}
