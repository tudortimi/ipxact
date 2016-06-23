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


#include "scmladaptor.h"

scmlAdaptor::scmlAdaptor( sc_module_name module_name ) :
  sc_module( module_name ),
  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  apb_slave_port("apb_slave_port"),
  scml_master_port("scml_master_port")
{
  apb_slave_port( *this );
}

void scmlAdaptor::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

scmlAdaptor::~scmlAdaptor()
{
}

tlm::tlm_status scmlAdaptor::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				const unsigned int byte_enable,
				const tlm::tlm_mode mode,
				const unsigned int export_id)
{
  tlm::tlm_status status;
  
  PVReq<DATA_TYPE, ADDRESS_TYPE> req;
  PVResp<DATA_TYPE> resp;
  
  DATA_TYPE tdata = data;

  req.setAddress(addr);
  req.setWriteDataSource(&tdata);
  req.setOffset(0);
  req.setBurstCount(1);
  req.setDataSize(8*sizeof(DATA_TYPE));
  req.setType(pvWrite);
  
  resp = scml_master_port.transport(req);
 
  if (resp.getResponse() == pvOk) {
    status.set_ok();
  } else {
    status.set_error();
  }
  return status;
}

tlm::tlm_status scmlAdaptor::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  tlm::tlm_status status;

  PVReq<DATA_TYPE, ADDRESS_TYPE> req;
  PVResp<DATA_TYPE> resp;
  
  req.setAddress(addr);
  req.setReadDataDestination(&data);
  req.setOffset(0);
  req.setBurstCount(1);
  req.setDataSize(8*sizeof(DATA_TYPE));
  req.setType(pvRead);
  
  resp = scml_master_port.transport(req);

  if (resp.getResponse() == pvOk) {
    status.set_ok();
  } else {
    status.set_error();
  }
  return status; 
}
