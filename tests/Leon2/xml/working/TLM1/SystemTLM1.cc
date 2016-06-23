/*******************************************************************************
 *                      SPIRIT 1.4 OSCI-TLM-PV example
 *------------------------------------------------------------------------------
 * Simple Leon2 TLM Design main
 *------------------------------------------------------------------------------
 * Revision: 1.4
 * Authors:  Jean-Michel Fernandez
 * 
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
 * 
 * This work forms part of a deliverable of The SPIRIT Consortium.
 * 
 * Use of these materials are governed by the legal terms and conditions
 * outlined in the disclaimer available from www.spiritconsortium.org.
 * 
 * This source file is provided on an AS IS basis.  The SPIRIT
 * Consortium disclaims any warranty express or implied including
 * any warranty of merchantability and fitness for use for a
 * particular purpose.
 * 
 * The user of the source file shall indemnify and hold The SPIRIT
 * Consortium and its members harmless from any damages or liability.
 * Users are requested to provide feedback to The SPIRIT Consortium
 * using either mailto:feedback@lists.spiritconsortium.org or the forms at 
 * http://www.spiritconsortium.org/about/contact_us/
 * 
 * This file may be copied, and distributed, with or without
 * modifications; but this notice must be included on any copy.
 *******************************************************************************/

#include "Leon2Platform.h"
#include "bool2sclv.h"

int sc_main( int argc , char **argv ) {
  sc_clock rst("rst", 10000, SC_US, 0.999, 10, SC_NS, true);
  sc_signal<sc_logic> rstsclv;

  Leon2Platform top("top_TLM");
  bool2sclv conv1("conv1");

  conv1.inbool(rst);
  conv1.outsclv(rstsclv);
  top.rstin_an(rstsclv);

  sc_start( 1 , SC_MS );
  return 0;
}
