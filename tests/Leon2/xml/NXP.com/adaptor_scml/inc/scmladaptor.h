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


#ifndef _SCMLADAPTOR_H_
#define _SCMLADAPTOR_H_

#include <systemc.h>
#include "scml.h"
#include "PV/PV.h"
#include "pv_slave_base.h"
#include "pv_target_port.h"
#include "user_types.h"

class scmlAdaptor : 
  public sc_module,
  public pv_slave_base< ADDRESS_TYPE , DATA_TYPE >
{
public:
  SC_HAS_PROCESS(scmlAdaptor);
  scmlAdaptor( sc_module_name module_name );
  ~scmlAdaptor();

  pv_target_port<ADDRESS_TYPE,DATA_TYPE>    apb_slave_port;
  PVInitiator_port<DATA_TYPE, ADDRESS_TYPE>   scml_master_port; 

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
} 

#endif
