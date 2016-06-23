/*****************************************************************************
  Description: pv_target_port.h
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


#ifndef _PV_TARGET_PORT_H_
#define _PV_TARGET_PORT_H_

/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include "systemc.h"
#include <string>

#include "tlm.h"
#include "pv_tlm_if.h"
#include "pv_target_port_base.h"

//----------------------------------------------------------------------------
template<typename ADDRESS,typename DATA>
class pv_target_port :
  public pv_target_port_base,
  public sc_export<tlm::tlm_transport_if<pv_request<ADDRESS,DATA>, pv_response<DATA> > >
{

public:
  typedef pv_request<ADDRESS,DATA> request_type;
  typedef pv_response<DATA> response_type;

  typedef tlm::tlm_transport_if<request_type,response_type> interface_type;
  typedef sc_export<interface_type> target_port_type;

  typedef pv_target_port_base target_port_base_type;
                                               
  //--------------
  // Constructor
  //--------------
  pv_target_port(const char * port_name) :
    target_port_type(port_name)
  {}
  
  void before_end_of_elaboration();
  void end_of_elaboration();

  void bind(target_port_type& target_port_);
  void bind(interface_type& interface) {
    target_port_type::bind(interface);
  }

  void operator() (interface_type& interface) {
    target_port_type::bind(interface);
  }

protected:
  bool is_already_bound(sc_interface * other_if);
};

template<typename ADDRESS,typename DATA>
bool
pv_target_port<ADDRESS, DATA>::is_already_bound(sc_interface * other_if) {
  if (dynamic_cast<sc_interface * >(this->get_interface()) == NULL) return(false);
  else {
    std::string if_name1,if_name2 ;
    sc_object * tmp = dynamic_cast<sc_object * >(other_if);
    if (tmp) if_name1 = tmp->name();
    else if_name1 = "unnamed interface (non sc_object)";
    tmp = dynamic_cast<sc_object * >(this->get_interface());
    if (tmp) if_name2 = tmp->name();
    else if_name2 = "unnamed interface (non sc_object)";

    std::string msg(sc_object::name());
    msg += (std::string)(": tlm_target_port warning, Can't bind to \"") + if_name1;
    msg += (std::string)("\" interface,the target port is already bound to this interface: \"");
    msg += if_name2 + (std::string)("\"\n");
    SC_REPORT_WARNING("binding warning",msg.c_str());

    return(true);
  }
}

template<typename ADDRESS,typename DATA>
void
pv_target_port<ADDRESS, DATA>::before_end_of_elaboration()
{
  // if this target port is not directly connected to the core interface
  if (get_target_port_list().size() > 1) {

    for(typename std::vector<target_port_base_type *>::iterator target_port = get_target_port_list().begin();
	target_port != get_target_port_list().end();
	target_port++) {		 	  
      set_tlm_export_id((*target_port)->get_tlm_export_id());	// Propagate the target port id
    }
  }
}

template<typename ADDRESS,typename DATA>
void
pv_target_port<ADDRESS, DATA>::end_of_elaboration() {

#ifdef TLM_PORT_DEBUG
  printf("DEBUG\t\t%s: Registered target port list :\n",sc_object::name());
  for(typename std::vector<target_port_base_type *>::iterator port = get_target_port_list().begin();
      port != get_target_port_list().end();
      port++) {
    printf("DEBUG\t\t%s: \t- %s\n",sc_object::name(),(static_cast<target_port_type * >(*port))->name());      
  }
  printf("DEBUG\t\t%s: -------------------------------------------------------\n",sc_object::name());
#endif
    
}

template<typename ADDRESS,typename DATA>
void
pv_target_port<ADDRESS, DATA>::bind(target_port_type& target_port_)
{
  // If the target port is still not bound
  if (!is_already_bound(target_port_.get_interface())) {
    // Copy the list of registered target ports to the current bound port (port propagation)
    for(typename std::vector<target_port_base_type *>::iterator target_port = target_port_.get_target_port_list().begin();
	target_port != target_port_.get_target_port_list().end();
	target_port++) {
      this->register_target_port(*target_port);
    }
      
    // Calls sc_export standard bind method
    sc_export<interface_type>::bind(target_port_);
  }
}
#endif /* _PV_TARGET_PORT_H_ */

