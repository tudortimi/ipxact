// 
// Revision:    $Revision: 1506 $
// Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
// 
// Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
// 
// This work forms part of a deliverable of The SPIRIT Consortium.
// 
// Use of these materials are governed by the legal terms and conditions
// outlined in the disclaimer available from www.spiritconsortium.org.
// 
// This source file is provided on an AS IS basis.  The SPIRIT
// Consortium disclaims any warranty express or implied including
// any warranty of merchantability and fitness for use for a
// particular purpose.
// 
// The user of the source file shall indemnify and hold The SPIRIT
// Consortium and its members harmless from any damages or liability.
// Users are requested to provide feedback to The SPIRIT Consortium
// using either mailto:feedback@lists.spiritconsortium.org or the forms at 
// http://www.spiritconsortium.org/about/contact_us/
// 
// This file may be copied, and distributed, with or without
// modifications; but this notice must be included on any copy.

 /*------------------------------------------------------------------------------
 * Simple Leon2 TLM AHB to APB bridge
 *------------------------------------------------------------------------------*/

#ifndef __APBMST_H__
#define __APBMST_H__

#include <systemc.h>
#include "pv_router.h"
#include "user_types.h"

typedef pv_router< ADDRESS_TYPE , DATA_TYPE > basic_router;


class apbmst : public basic_router
{
 public:
  apbmst (sc_module_name module_name, const char* mapFile)
    : basic_router (module_name, mapFile)
  {}
  void end_of_elaboration() {
    basic_router::end_of_elaboration();
    cout << name() << " constructed." << endl;
  }
};


#endif
