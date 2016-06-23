//copyright (c) The SPIRIT Consortium.  All rights reserved.
//www.spiritconsortium.org
// 
//THIS WORK FORMS PART OF A SPIRIT CONSORTIUM SPECIFICATION.
//USE OF THESE MATERIALS ARE GOVERNED BY
//THE LEGAL TERMS AND CONDITIONS OUTLINED IN THE SPIRIT
//SPECIFICATION DISCLAIMER AVAILABLE FROM
//www.spiritconsortium.org
// 
//This source file is provided on an AS IS basis. The SPIRIT Consortium disclaims 
//ANY WARRANTY EXPRESS OR IMPLIED INCLUDING ANY WARRANTY OF
//MERCHANTABILITY AND FITNESS FOR USE FOR A PARTICULAR PURPOSE. 
//The user of the source file shall indemnify and hold The SPIRIT Consortium harmless
//from any damages or liability arising out of the use thereof or the performance or
//implementation or partial implementation of the schema.


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

tlm::tlm_status scmlAdaptor::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				const unsigned int byte_enable,
				const tlm::tlm_mode mode,
				const unsigned int export_id)
{
  tlm::tlm_status status;
  
  PVReq<DATA_TYPE, ADDRESS_TYPE> req;
  PVResp<DATA_TYPE> resp;

  req.setAddress(addr);
  req.setWriteDataSource(&data);
  req.setOffset(0);
  req.setBurstCount(1);
  req.setDataSize(sizeof(DATA_TYPE));
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
  req.setDataSize(sizeof(DATA_TYPE));
  req.setType(pvRead);
  
  resp = scml_master_port.transport(req);

  if (resp.getResponse() == pvOk) {
    status.set_ok();
  } else {
    status.set_error();
  }
  return status; 
}
