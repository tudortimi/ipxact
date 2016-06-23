/* -*- C++ -*- */
/*****************************************************************************
  Description: pv_slave_base.tpp
  Author:      The SPIRIT Consortium
  Revision:    $Revision: 1506 $
  Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $

  Copyright (c) 2008, 2009 The SPIRIT Consortium.

  This work forms part of a deliverable of The SPIRIT Consortium.

  Use of these materials are governed by the legal terms and conditions
  outlined in the disclaimer available from www.spiritconsortium.org.

  This source file is provided on an AS IS basis.  The SPIRIT
  Consortium disclaims any warranty express or implied including
  any warranty of merchantability and fitness for use for a
  particular purpose.

  The user of the source file shall indemnify and hold The SPIRIT
  Consortium and its members harmless from any damages or liability.
  Users are requested to provide feedback to The SPIRIT Consortium
  using either mailto:feedback@lists.spiritconsortium.org or the forms at
  http://www.spiritconsortium.org/about/contact_us/

  This file may be copied, and distributed, with or without
  modifications; but this notice must be included on any copy.

  The following code is derived, directly or indirectly, from the SystemC
  source code Copyright (c) 1996-2004 by all Contributors.
  All Rights reserved.

  The contents of this file are subject to the restrictions and limitations
  set forth in the SystemC Open Source License Version 2.4 (the "License");
  You may not use this file except in compliance with such restrictions and
  limitations. You may obtain instructions on how to receive a copy of the
  License at http://www.systemc.org/. Software distributed by Contributors
  under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied. See the License for the specific
  language governing rights and limitations under the License.

*****************************************************************************/

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "pv_slave_base.h"

//---------------
// Constructor 
//---------------
template<typename ADDRESS,typename DATA>
pv_slave_base<ADDRESS,DATA>::pv_slave_base(const char * module_name) :
  m_slave_name(module_name) {
}
  



//-------------------------------------------------
// tlm_transport_if methods implementation   
//-------------------------------------------------
template<typename ADDRESS,typename DATA>
pv_response<DATA> 
pv_slave_base<ADDRESS,DATA>::transport(const request_type& request) {

  response_type response;

  switch(request.get_command()) {
      
  case PV_READ:
	
    response.set_data(request.get_data());
      
    response.set_status(this->read(request.get_address(), response.get_data()));    
    break;
    
  case PV_WRITE:	
    response.set_status(this->write(request.get_address(), request.get_data()));
    break;

  default:
    std::cout << "ERROR\t" << m_slave_name << ": Unknown command \n";
    break;
  }
    
  return response;
}

//---------------------
// Read access 
template<typename ADDRESS,typename DATA> 
tlm::tlm_status
pv_slave_base<ADDRESS,DATA>::read(const ADDRESS& address,
				  DATA& data,
				  const unsigned int byte_enable,
				  const tlm::tlm_mode mode,
				  const unsigned int export_id
				  ) {
  tlm::tlm_status status;
  
  std::cout << "ERROR\t" << m_slave_name << ": Read is not implemented\n";
  
  return(status);
}

//----------------------  
// Write access
template<typename ADDRESS,typename DATA> 
tlm::tlm_status
pv_slave_base<ADDRESS,DATA>::write(const ADDRESS& address,
				   const DATA& data,
				   const unsigned int byte_enable,
				   const tlm::tlm_mode mode,
				   const unsigned int export_id
				   ) {
  tlm::tlm_status status;
  
  std::cout << "ERROR\t" << m_slave_name << ": Write is not implemented\n";

  return(status);

}
  
/* END of pv_slave_base.tpp */
  
