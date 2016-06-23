/*****************************************************************************

  Description: pv_router.h
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

#ifndef _PV_ROUTER_H_
#define _PV_ROUTER_H_


/*------------------------------------------------------------------------------
 * Includes							       
 *----------------------------------------------------------------------------*/
#include <string>
#include <iostream>
#include <sstream>

#include "systemc.h"

#include "pv_initiator_port.h"
#include "pv_target_port.h"


//----------------------------------------------------------------------------
template<typename ADDRESS>
class address_map {
  
public:
  
  //----------------------
  // Constructors
  //----------------------
  address_map() : 
    m_target_port_rank(0),
    m_start_address(0),
    m_end_address(0)
  {}
  
  address_map(std::string& name,ADDRESS start,ADDRESS end) :
    m_target_port_rank(0),
    m_entry_port_name(name),
    m_start_address(start),
    m_end_address(end)
  {}
  
  //--------------------------------------------------
  // Accessors
  //--------------------------------------------------
  inline void set_target_port_rank(unsigned int target_port_rank) {m_target_port_rank = target_port_rank;}
  inline unsigned int get_target_port_rank() const {return(m_target_port_rank);}

  inline std::string& get_entry_port_name() {return(m_entry_port_name);}
  inline void set_entry_port_name(const char * name) {m_entry_port_name = name;}
  inline void set_entry_port_name(const std::string& name) {m_entry_port_name = name;}

  inline ADDRESS get_start_address() const {return(m_start_address);}
  inline void set_start_address(ADDRESS address) {m_start_address = address;}

  inline ADDRESS get_end_address() const {return(m_end_address);}
  inline void set_end_address(ADDRESS address) {m_end_address = address;}


  //--------------------------------------------------------------
  // Decode method used to check port address range
  //--------------------------------------------------------------
  /// Returns true if input address matches the port address range
  inline bool decode(const ADDRESS& address) const {
    return((address>=m_start_address)&&(address<=m_end_address));
  }
  
protected:
  
  unsigned int m_target_port_rank;        // Target port binding rank (initiator port<->target port binding order)
  std::string m_entry_port_name;          // Name of the mapfile port name entry corresponding to the address range
  ADDRESS m_start_address;                // Start address
  ADDRESS m_end_address;                  // End address
};

//----------------------------------------------------------------------------
template<typename ADDRESS,typename DATA>
class pv_router :
  public sc_module,
  public virtual tlm::tlm_transport_if<pv_request<ADDRESS,DATA>, pv_response<DATA> >
{
  typedef pv_request<ADDRESS,DATA> request_type;
  typedef pv_response<DATA> response_type;

  typedef tlm::tlm_transport_if<request_type,response_type> interface_type;

  typedef pv_initiator_port<ADDRESS,DATA,0> initiator_port_type; // 0 allows this port to be bound to several interfaces
  typedef pv_target_port<ADDRESS,DATA> target_port_type;

  typedef address_map<ADDRESS> address_map_type; 

public:

  //--------------
  // Module ports
  //--------------
  initiator_port_type initiator_port;   
  target_port_type target_port;
  
  
  //--------------
  // Constructors
  //--------------
  pv_router(sc_module_name module_name,
	    const char * map_filename = NULL
	    );
  
  //-------------
  // Destructor
  //-------------
  ~pv_router();



  //-------------------------------------------------  
  // sc_module method override
  //-------------------------------------------------  
  // Called by elaboration_done. Used here to load the mapfile when the SC binding is finished     
  void end_of_elaboration();

  //-------------------------------------------------  
  // tlm_transport_if method implementation   
  //-------------------------------------------------      
  virtual response_type transport(const request_type& request);
//  virtual void transport(const request_type& request,response_type& response );
  
  //-------------------------------------------------
  // Load mapfile. Called at the end of elaboration
  // Can be called again dirung the simulation -> remap
  //-------------------------------------------------
  bool load_mapfile(const char * filename);

protected :

  std::string m_map_filename;       // Name of the file containing the mapping informations
  std::stringstream m_map_stream;   // Stringsteam containing the mapping information
  std::vector<address_map_type *> m_address_map_list; // List of address_map objects

  //--------------------------------------------------------------
  /* If the given address matches one address map, returns a reference on 
     the address map. The address parameter is modified: remove address map start address 
  */
  inline address_map_type * decode(ADDRESS& address) {
    // For each registered & mapped target port
    for(typename std::vector<address_map_type *>::iterator map = m_address_map_list.begin();
	map != m_address_map_list.end();
	map ++) {
      if ((*map)->decode(address)) { 
	address = address - (*map)->get_start_address();
	return(*map);
      }
    }
    return(NULL);
  }

};


// Class implementation
#include "./pv_router.tpp"


#endif /* _PV_ROUTER_H_ */


