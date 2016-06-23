/*****************************************************************************
  Description: pv_target_port_base.h
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


#ifndef _PV_TARGET_PORT_BASE_H_
#define _PV_TARGET_PORT_BASE_H_

/*------------------------------------------------------------------------------
 * Includes
 *----------------------------------------------------------------------------*/
#include <vector>

#include "systemc.h"



//----------------------------------------------------------------------------
/// Class pv_target_port_base: This class is a base class for pv_target_port class.
/**
 *
 * \n It provides a container to store registered target ports as pointer list.
 * \n In addition, it provides a target port ID used by to identify the input export port.
 *    This ID is injected in the request structure by the initiator at run time.
 *
 * \n Accessors are provided for the port list and port ID.
 **/
//----------------------------------------------------------------------------
class pv_target_port_base {

  typedef pv_target_port_base this_type;

public:

  //--------------
  // Constructor
  //--------------
  pv_target_port_base():
    m_tlm_export_id(0) {
    m_target_port_list.push_back(this);
  }

  //------------------------------------------
  /// @name  Data members access methods
  //------------------------------------------
  /// @{

  /// Returns the port id
  inline int get_tlm_export_id() const {
    return(m_tlm_export_id);
  }

  /// Sets the port id
  void set_tlm_export_id(int tlm_export_id) {
    m_tlm_export_id = tlm_export_id;
  }


  //---------------------------------------------------------------------------

  /// Register the target port
  inline void register_target_port(this_type * target_port) {
    m_target_port_list.push_back(target_port);
  }

  /// Returns the vector of registered target port(s)
  inline std::vector<this_type *>& get_target_port_list() {
    return(m_target_port_list);
  }

  /// Sets the vector of registered target port(s) (port propagation)
  inline void set_target_port_list(std::vector<this_type*>& target_port_list) {
    m_target_port_list = target_port_list;
  }

  /// @}

protected:

  /// Port instance ID
  int m_tlm_export_id;

  /// target port objects registration
  /**
   * Direct registration of the target port(s) into current target port.
   * \n Used for transaction recording and target port id propagation in case of target port binding
   * through a module hierarchy
   **/
  std::vector<this_type *> m_target_port_list;

};

#endif /* _PV_TARGET_PORT_BASE_H_ */


