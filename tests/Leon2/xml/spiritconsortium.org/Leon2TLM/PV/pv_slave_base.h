/*****************************************************************************
  Description: pv_slave_base.h
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


#ifndef _PV_SLAVE_BASE_H_
#define _PV_SLAVE_BASE_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <string>

#include "tlm.h"

#include "pv_tlm_if.h"
#include "pv_target_port.h"


//----------------------------------------------------------------------------
template<typename ADDRESS,typename DATA>
class pv_slave_base :
  public virtual tlm::tlm_transport_if<pv_request<ADDRESS,DATA>,pv_response<DATA> >,
  public virtual pv_tlm_if<ADDRESS,DATA> {

  typedef pv_request<ADDRESS,DATA> request_type;
  typedef pv_response<DATA> response_type;

  typedef tlm::tlm_transport_if<request_type,response_type> interface_type;

  typedef pv_target_port<ADDRESS,DATA> target_port_type;

public:

  //---------------
  // Constructor 
  //---------------
  pv_slave_base(const char * module_name);

  //-------------------------------------------------
  // tlm_transport_if methods implementation   
  //-------------------------------------------------
  virtual response_type transport(const request_type& request);


  //--------------------------------------------------------
  // Abstract class pv_tlm_if methods default implementation
  //--------------------------------------------------------

  virtual tlm::tlm_status read(const ADDRESS& address,
			       DATA& data,
			       const unsigned int byte_enable = tlm::NO_BE,
			       const tlm::tlm_mode mode = tlm::REGULAR,
			       const unsigned int export_id = 0);
    
  virtual tlm::tlm_status write(const ADDRESS& address,
				const DATA& data,
				const unsigned int byte_enable = tlm::NO_BE,
				const tlm::tlm_mode mode = tlm::REGULAR,
				const unsigned int export_id = 0);  
    
protected:
    
  /// Slave name (used for debug and error messages: pv_slave_base is not a sc_object )
  std::string m_slave_name;

};


// Class implementation
#include "./pv_slave_base.tpp"



#endif /* _PV_SLAVE_BASE_H_ */


