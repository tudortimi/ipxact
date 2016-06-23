/* -*- C++ -*- */
/*****************************************************************************
  Description: pv_router.tpp
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
#include "pv_router.h"



//--------------
// Constructors
//--------------
template<typename ADDRESS,typename DATA>
pv_router<ADDRESS,DATA>::pv_router(sc_module_name module_name,
				   const char * map_filename
				   ) :
  sc_module(module_name),
  initiator_port("initiator_port"), 
  target_port("target_port")
{
  if (map_filename) m_map_filename = map_filename;
  else m_map_filename = (std::string)(name()) + ".map";

  target_port(*this);
  
  std::cout << name() << " module created\n";

}


//-------------
// Destructor
//-------------
template<typename ADDRESS,typename DATA>
pv_router<ADDRESS,DATA>::~pv_router() {
  for(typename std::vector<address_map_type *>::iterator map = m_address_map_list.begin();
      map != m_address_map_list.end();
      map ++) {
    if ((*map)) delete (*map);
  }
}

//-------------------------------------------------  
// sc_module method override
//-------------------------------------------------  

// Called by elaboration_done 
template<typename ADDRESS,typename DATA>
void pv_router<ADDRESS,DATA>::end_of_elaboration() {
  if (load_mapfile(m_map_filename.c_str()))
    std::cout << name() << ": End of Elaboration: "<<  initiator_port.get_target_port_list().size() << " target(s) connected\n";
  else sc_stop();
}


//-------------------------------------------------  
// tlm_transport_if method implementation   
//-------------------------------------------------  
      
// Transfer of transaction
template<typename ADDRESS,typename DATA>
pv_response<DATA>
pv_router<ADDRESS,DATA>::transport(const request_type& request) {

  response_type response;
  request_type router_request(request);  // Copy from input request 

  ADDRESS addr = request.get_address();

  // Search address map and modify the address
  address_map_type * map = decode(addr);

  if (map) {

    // Request modification: modified address and port ID added
    router_request.set_address(addr);

    // Send initiator request to the target
    initiator_port.do_transport(router_request,response,(*map).get_target_port_rank());    
  }
  else  {
    response.get_status().set_error();
    response.get_status().set_no_response();
    std::cout << "ERROR\t" << name() << std::showbase << std::hex
	      << ": No target at this address: " << request.get_address() << std::endl;
  }
  return(response);
}

/*
// Transfer of transaction
template<typename ADDRESS,typename DATA>
void
pv_router<ADDRESS,DATA>::transport(const request_type& request,response_type& response) {

  request_type router_request(request);  // Copy from input request 

  ADDRESS addr = request.get_address();

  // Search address map and modify the address
  address_map_type * map = decode(addr);

  if (map) {

    // Request modification: modified address and port ID added
    router_request.set_address(addr);

    // Send initiator request to the target
    initiator_port.do_transport(router_request,response,(*map).get_target_port_rank());    	
  }
  else  {    
    response.get_status().set_error();
    response.get_status().set_no_response();
    std::cout << "ERROR\t" << name() << std::showbase << std::hex
	      << ": No target at this address: " << request.get_address();
  }
}
*/


//-------------------------------------------------
// Load mapfile. Called at the end of elaboration
// Can be called again dirung the simulation -> remap
//-------------------------------------------------
template<typename ADDRESS,typename DATA>
bool
pv_router<ADDRESS,DATA>::load_mapfile(const char * filename) {

  // Temporary address map lists
  std::vector<address_map_type *> tmp_address_map_list;
  
  // Parse the map file to fill the temporary address_map list
  ifstream mapfile(filename);
  if( !mapfile.is_open() ) {
    std::cout << "ERROR\t" << name() << ": Opening mapfile \"" << m_map_filename << "\"\n";
    return(false);
    }
  else {
    std::cout << name() << ": mapfile \"" << m_map_filename << "\" loaded\n";
    
    // Reads the map stream and fills the address map list
    char line[1024];
    while (mapfile.good()) {
      memset(line,0,1024);
      mapfile.getline(line,1024);
      
      // If the current map line is not a comment, the parser retrieves 
      // the address map parameters and creates a new address map object
      if ((line[0]) && (line[0] != ';') && (line[0] != ' ') && (line[0] != '\n') && (line[0] != '\t')) {
	std::string port_name;
	ADDRESS addr,size = 0;	
	std::stringstream linestream(line);
	linestream >> hex >> port_name >> addr >> size; // Read addresses using HEX format

	if (size == 0) 	// Ignore map entry with null size
	  std::cout << "WARNING\t" << name() << ":Null entry size for \"" <<  port_name.c_str() << "\" entry while parsing map input. This entry will be ignored\n";
	else {
	  address_map_type * map = new address_map_type(port_name,addr,addr+(size-1));
	  tmp_address_map_list.push_back(map);
	}
      }
    }

    // For all the child objects of the module (search initiator ports)
    for (int i=0;i<(int)this->get_child_objects().size();i++) {
      initiator_port_type * port;
      if ((port = dynamic_cast<initiator_port_type *>(this->get_child_objects()[i])) != NULL) {
	for (unsigned int target_port_rank = 0;target_port_rank<port->get_target_port_list().size();target_port_rank++) {
	  target_port_type& target_port = *(static_cast<target_port_type * >(port->get_target_port_list()[target_port_rank]));
	  bool mapped = false;	  // Unmapped port detection flag	  
	  std::string port_name(target_port.name());  	  // Gets port name: target port in the list 	  	  

	  // Check the temporary address map object list to find a matching port map
	  for(typename std::vector<address_map_type *>::iterator map = tmp_address_map_list.begin();
	      map != tmp_address_map_list.end();
	      map ++) {
	    std::string entry_name((*map)->get_entry_port_name().c_str()); // Gets mapfile target port entry name	    
	    if (port_name == entry_name) {// port name and entry name matches 

	      // New address_map object initialized with mapfile entry
	      address_map_type * tmp_map = new address_map_type(*(*map));
	      // Add target_port rang information
	      tmp_map->set_target_port_rank(target_port_rank);
	      m_address_map_list.push_back(tmp_map);   // Register address_map object in temporary map list
	      mapped = true;
#ifdef PV_ROUTER_DEBUG
	      std::cout << std::showbase << std::hex << name() << ": port \"" << target_port.name() 
			<< "\" identified - " << "Address range: "
			<< (*map)->get_start_address() << " - " << (*map)->get_end_address() << std::endl;
#endif
	    }
	  }	  
	  // Error if a registered target port has no associated  mapping information
	  if (!mapped) std::cout << "ERROR\t" << name() << ": port \"" << port_name.c_str() 
				 << "\" has no mapping defined in \"" << filename << "\"\n";
	}
      }
    }
	
    // Address map overlap detection
    // For each registered address map object, the other address map objects are
    // checked to detect mapping overlap
    for(typename std::vector<address_map_type *>::iterator map = m_address_map_list.begin();
	map != m_address_map_list.end();
	map ++) {
      
      for(typename std::vector<address_map_type *>::iterator other_map = map+1;
	  other_map != m_address_map_list.end();
	  other_map ++) {
	
	if ( ( (*other_map)->decode((*map)->get_start_address() ) ) || 
	     ( (*other_map)->decode((*map)->get_end_address() ) )   ||
	     ( (*map)->decode((*other_map)->get_start_address() ) ) || 
	     ( (*map)->decode((*other_map)->get_end_address() ) )
	     ) {
	  // Print a Warning message if a map definition collision is detected	  
	  std::cout << "WARNING\t" << name() << ": "
		    << std::showbase << std::hex  << " \"" << (*other_map)->get_entry_port_name() << "\" map definition ("
		    << (*other_map)->get_start_address() << " - " << (*other_map)->get_end_address() << ")"<< std::endl 
		    << "\t\toverlaps map defined for \"" << (*map)->get_entry_port_name() << "\" ("
		    << (*map)->get_start_address() << " - " << (*map)->get_end_address() << ")" << std::endl;
	}
      }
    }
      
    // Cleanup temporary mapfile address map list
    for(typename std::vector<address_map_type *>::iterator map = tmp_address_map_list.begin();
	map != tmp_address_map_list.end();
	map ++) {
      if ((*map)) delete (*map);
    }
    return(true);
  }
}


/* END of pv_router.tpp */
