/*****************************************************************************
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
  modifications; but these notices must be included on any copy.

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


#ifndef _PV_INITIATOR_PORT_H_
#define _PV_INITIATOR_PORT_H_

/*------------------------------------------------------------------------------
 * Includes
 *----------------------------------------------------------------------------*/
#include <vector>

#include "systemc.h"

#include "tlm.h"

#include "pv_tlm_if.h"
#include "pv_initiator_port_base.h"
#include "pv_target_port.h"

//----------------------------------------------------------------------------
template<typename ADDRESS,typename DATA,int N = 1>
class pv_initiator_port :
  public sc_port<tlm::tlm_transport_if<pv_request<ADDRESS,DATA>,pv_response<DATA> >, N>,
  public pv_initiator_port_base,
  public virtual pv_tlm_if<ADDRESS,DATA> {
    
  typedef pv_request<ADDRESS,DATA> request_type;
  typedef pv_response<DATA> response_type;

  typedef tlm::tlm_transport_if<request_type,response_type> interface_type;

  typedef sc_export<interface_type> sc_target_port_type;
  typedef sc_port<interface_type,N> sc_initiator_port_type;

  typedef pv_target_port<ADDRESS,DATA> pv_target_port_type;
  typedef pv_initiator_port<ADDRESS,DATA,N> pv_initiator_port_type;

  typedef pv_target_port_base target_port_base_type;
  typedef pv_initiator_port_base initiator_port_base_type;
    
public:

  //--------------
  // Constructor
  //--------------
  pv_initiator_port(const char * port_name);

    
  //---------------------------------------
  // Execute the transaction transfer	
  void do_transport(request_type& request,
		    response_type& response,
		    unsigned int target_port_rank = 0);

  //-------------------------------------------------------------------
  //Abstract class pv_tlm_if methods implementation: used as convenience API

  virtual tlm::tlm_status read(const ADDRESS& address,
			       DATA& data,
			       const unsigned int byte_enable = tlm::NO_BE,
			       const tlm::tlm_mode mode = tlm::REGULAR,
			       const unsigned int export_id = 0
			       );
    
  virtual tlm::tlm_status write(const ADDRESS& address,
				const DATA& data,
				const unsigned int byte_enable = tlm::NO_BE,
				const tlm::tlm_mode mode = tlm::REGULAR,
				const unsigned int export_id = 0
				);  

  //------------------
  //Additional methods
  void before_end_of_elaboration();
  void end_of_elaboration();

  void bind(pv_target_port_type&);
  void operator() (pv_target_port_type&);

  void bind(sc_port_b<interface_type>&);
  void operator() (sc_port_b<interface_type>&);

  void bind(interface_type&);
  void operator() (interface_type&);

protected:
  bool is_interface_bound_twice(sc_export_base&);
};



// Class implementation
#include "./pv_initiator_port.tpp"

#endif /* _PV_INITIATOR_PORT_H_ */


