/*

  Description: Leon2Platform.h
  Author:      The SPIRIT Consortium
  Revision:    $Revision: 1506 $
  Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $

  Copyright (c) 2009 The SPIRIT Consortium.

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
  modifications; this notice must be included on any copy.
 */
#include <systemc.h>
#include  "ahbbus.h" 
#include  "ahbram.h" 
#include  "apbSubSystem.h" 
#include  "cgu.h" 
#include  "dma.h" 
#include  "processor.h" 
#include  "rgu.h" 


class Leon2Platform : public sc_module
{
 
public:

  Leon2Platform(sc_module_name name);
  ~Leon2Platform(){}
  

  

  
sc_in < bool > clkin; 
sc_in < sc_logic > rstin_an; 


private:

ahbbus i_ahb; 
ahbram i_mem; 
apbSubSystem i_sub; 
cgu i_cgu; 
dma i_dma; 
processor i_proc; 
rgu i_rgu; 


sc_signal < int > defaultid4489949_int_master_port;
sc_signal < int > defaultid4489998_irl_port;
sc_signal < int > defaultid4489998_irqvec_port;
sc_signal < bool > defaultid4489998_intack_port;
sc_signal < sc_logic > clkdiv0;
sc_signal < sc_logic > clkdiv1;
sc_signal < sc_logic > clkdiv2;
sc_signal < sc_logic > clkdiv3;
sc_signal < sc_logic > clkdiv4;
sc_signal < sc_logic > clkdiv5;
sc_signal < sc_logic > clkdiv6;
sc_signal < sc_logic > clkdiv7;
sc_signal < bool > rstdiv0;
sc_signal < bool > rstdiv1;
sc_signal < bool > rstdiv2;
sc_signal < bool > rstdiv3;
sc_signal < bool > rstdiv4;
sc_signal < bool > rstdiv5;
sc_signal < bool > rstdiv6;
sc_signal < bool > rstdiv7;

};


