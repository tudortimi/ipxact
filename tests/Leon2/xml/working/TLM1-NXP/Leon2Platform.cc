/*
  Description: Leon2Platform.cc
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
#include "Leon2Platform.h"

Leon2Platform:: Leon2Platform(sc_module_name name) :
sc_module(name),
i_ahb("i_ahb" ,"leon2AhbBus.map"), 
i_mem("i_mem" ,16), 
i_sub("i_sub"), 
i_cgu("i_cgu"), 
i_dma("i_dma"), 
i_proc("i_proc" ,"master.tbl"), 
i_rgu("i_rgu"), 
rstin_an ("rstin_an")
{
i_proc.ahb_master_port(i_ahb.target_port);
i_dma.ahb_master_port(i_ahb.target_port);
i_ahb.initiator_port(i_mem.ahb_slave_port);
i_ahb.initiator_port(i_sub.ahb_slave_port);
i_sub.apb4_mslave_port(i_cgu.apb_slave_port);
i_sub.apb5_mslave_port(i_rgu.apb_slave_port);
i_sub.apb6_mslave_port(i_proc.apb_slave_port);
i_sub.apb7_mslave_port(i_dma.apb_slave_port);


i_dma.int_master_port(defaultid4489949_int_master_port);
i_sub.int4_slave_port(defaultid4489949_int_master_port);
i_proc.irl_port(defaultid4489998_irl_port);
i_sub.irl_master_port(defaultid4489998_irl_port);
i_proc.irqvec_port(defaultid4489998_irqvec_port);
i_sub.irq_slave_port(defaultid4489998_irqvec_port);
i_proc.intack_port(defaultid4489998_intack_port);
i_sub.ack_slave_port(defaultid4489998_intack_port);
i_rgu.rstin_an(rstin_an);
i_proc.clk(clkdiv0);
i_rgu.ipclk(clkdiv0);
i_sub.clk_timers(clkdiv0);
i_cgu.clkout[0](clkdiv0);
i_cgu.clkout[1](clkdiv1); 
i_cgu.clkout[2](clkdiv2); 
i_cgu.clkout[3](clkdiv3); 
i_cgu.clkout[4](clkdiv4); 
i_cgu.clkout[5](clkdiv5); 
i_cgu.clkout[6](clkdiv6); 
i_cgu.clkout[7](clkdiv7); 
i_proc.rst_an(rstdiv0);
i_rgu.rstout_an[0](rstdiv0);
i_rgu.rstout_an[1](rstdiv1); 
i_rgu.rstout_an[2](rstdiv2); 
i_rgu.rstout_an[3](rstdiv3); 
i_rgu.rstout_an[4](rstdiv4); 
i_rgu.rstout_an[5](rstdiv5); 
i_rgu.rstout_an[6](rstdiv6); 
i_rgu.rstout_an[7](rstdiv7); 

}
