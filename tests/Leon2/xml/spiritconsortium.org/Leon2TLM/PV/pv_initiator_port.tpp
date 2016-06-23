/* -*- C++ -*- */
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
#include "pv_initiator_port.h"
#include <string>



//--------------
// Constructor
//--------------
template<typename ADDRESS,typename DATA,int N>
pv_initiator_port<ADDRESS,DATA,N>::pv_initiator_port(const char * port_name) :
  sc_initiator_port_type(port_name)
{}

//---------------------------------------
//  Execute the transaction transfer
//---------------------------------------
template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::do_transport(request_type& request,
						response_type& response,
						unsigned int target_port_rank)
{
  // Send initiator request to the target, functionnal call method using  -> operator of sc_port
  // response = (*this)[target_port_rank]->transport(request);

	pv_target_port<ADDRESS,DATA>& target_port = *(static_cast<pv_target_port<ADDRESS,DATA>* >(this->get_target_port_list()[target_port_rank]));
  response = target_port->transport(request);
}

//-------------------------------
// pv_tlm_if methods implementation
//-------------------------------

//----------------------------
// Read access 
template<typename ADDRESS,typename DATA,int N>
tlm::tlm_status
pv_initiator_port<ADDRESS,DATA,N>::read(const ADDRESS& address,
					DATA& data,
					const unsigned int byte_enable,
					const tlm::tlm_mode mode,
					const unsigned int export_id
					)
{
  response_type response;
  request_type request;
  request.set_command(PV_READ);
  request.set_address(address);

  do_transport(request,response);

  data = response.get_data();

  return response.get_status();
}

//----------------------------
// Write access
template<typename ADDRESS,typename DATA,int N>
tlm::tlm_status 
pv_initiator_port<ADDRESS,DATA,N>::write(const ADDRESS& address,
					 const DATA& data,
					 const unsigned int byte_enable,
					 const tlm::tlm_mode mode,
					 const unsigned int export_id
					 )
{
  response_type response;
  request_type request;
  request.set_command(PV_WRITE);
  request.set_address(address);
  request.set_data(data);

  do_transport(request,response);

  return(response.get_status());
}


template<typename ADDRESS,typename DATA,int N>
bool
pv_initiator_port<ADDRESS,DATA,N>::is_interface_bound_twice(sc_export_base& target_port_)
{
  for(int i=0;i<this->size();i++) {
    if ((*this)[i] == target_port_.get_interface()) {
      sc_object * tmp = dynamic_cast<sc_object * >(target_port_.get_interface());
      std::string if_name;
      if (tmp) if_name = tmp->name();
      else if_name = "unnamed interface/non sc_object";

      std::string msg(sc_object::name());
      msg += (std::string)(": tlm_initiator_port warning, while binding the interface \"");
      msg += if_name + (std::string)("\" exported by target port ");
      msg += (std::string)(target_port_.name()) + (std::string)(": the initiator port is already bound to this interface\n");
      SC_REPORT_WARNING("binding warning",msg.c_str());
	
      return(true);
    }
  }
  return(false);
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::before_end_of_elaboration()
{

  // Registered target port list propagation (complete sharing of target_port_list between all initiator ports)
  // If current port's target port list exist, share the list with all other port of the chain using the 
  // reversed initiator port list.
  if (m_target_port_list.size()) {
    for(typename std::vector<initiator_port_base_type *>::iterator port = get_reversed_initiator_port_list().begin();
	port != get_reversed_initiator_port_list().end();
	port++) {		 

      // Copy the target port(s) to the target port list of the registered initiator (port info. propagation)
      if ((*port) != this) {
	for(typename std::vector<target_port_base_type *>::iterator target_port = m_target_port_list.begin();
	    target_port != m_target_port_list.end();
	    target_port++) {
	  (*port)->register_target_port((*target_port));
	}
      }
    }
  }

  // Recreate the complete list of registered initiator_port, from deeper port to higher port (hierarchically speaking)
  // Objective: deeper port is able to "see" all others but intermediate port cannot "see" deeper ports.
  std::vector<initiator_port_base_type *> tmp_initiator_port_list; 
  tmp_initiator_port_list.push_back(this);
  this->create_port_list(tmp_initiator_port_list);
  // replace the regular initiator port list: this list is now complete
  this->set_initiator_port_list(tmp_initiator_port_list);
}


template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::end_of_elaboration()
{
  // Checks the target port list
  if ((!get_target_port_list().size()) && this->size()) {
    std::string msg(sc_object::name());
    msg += (std::string)(": tlm_initiator_port error, target port list is empty. Initiator port should be bound at least to one target port\n");
    SC_REPORT_ERROR("port end of elaboration",msg.c_str());
  }
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::bind(pv_target_port_type& target_port_) {
  if (!is_interface_bound_twice(target_port_))
    // Registers the target port
    register_target_port(&target_port_);
    
  // Calls sc_port standard bind() method 
  sc_port_b<interface_type>::bind(target_port_);
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::operator() (pv_target_port_type& target_port_) {
  bind(target_port_);
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::bind(sc_port_b<interface_type>& port_) {
  // Register the bound port in the regular list
  this->register_initiator_port(static_cast<pv_initiator_port_type *>(&port_));

  // Bound port registers the current port. Used to share the target port list between all port before the end of elaboration
  for(typename std::vector<initiator_port_base_type *>::iterator initiator_port = get_reversed_initiator_port_list().begin();
      initiator_port != get_reversed_initiator_port_list().end();
      initiator_port++) {
    static_cast<pv_initiator_port_type *>(&port_)->reversed_register_initiator_port(*initiator_port);
  }

  // Calls sc_port standard bind() method 
  sc_port_b<interface_type>::bind(port_);
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::operator() (sc_port_b<interface_type>& port_) {
  bind(port_);
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::bind(interface_type& interface_) {
  // Calls sc_port standard bind method
  sc_port_b<interface_type>::bind(interface_);    
}

template<typename ADDRESS,typename DATA,int N>
void
pv_initiator_port<ADDRESS,DATA,N>::operator() (interface_type& interface_) {
  sc_port_b<interface_type>::bind(interface_); 
}

/* END of pv_initiator_port.tpp */
