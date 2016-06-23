//
//Revision:    $Revision: 1506 $
//Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
//
//Copyright (c) 2008, 2009 The SPIRIT Consortium.
//
//This work forms part of a deliverable of The SPIRIT Consortium.
//
//Use of these materials are governed by the legal terms and conditions
//outlined in the disclaimer available from www.spiritconsortium.org.
//
//This source file is provided on an AS IS basis.  The SPIRIT
//Consortium disclaims any warranty express or implied including
//any warranty of merchantability and fitness for use for a
//particular purpose.
//
//The user of the source file shall indemnify and hold The SPIRIT
//Consortium and its members harmless from any damages or liability.
//Users are requested to provide feedback to The SPIRIT Consortium
//using either mailto:feedback@lists.spiritconsortium.org or the forms at 
//http://www.spiritconsortium.org/about/contact_us/
//
//This file may be copied, and distributed, with or without
//modifications; but this notice must be included on any copy.

#include "pv2apb.h"

pv2apb::pv2apb( sc_module_name module_name ) :
  sc_module( module_name ),

  pclk ("pclk"),
  presetn ("presetn"),
  psel ("psel"),
  penable ("penable"),
  pwrite ("pwrite"),
  paddr ("paddr"),
  pwdata ("pwdata"),
  prdata ("prdata"),

  pv_slave_base<ADDRESS_TYPE,DATA_TYPE>(name()),
  tlmpv_slave_port("tlmpv_slave_port")
{
  tlmpv_slave_port( *this );

  psel.initialize(static_cast<sc_logic>(0));
  penable.initialize(static_cast<sc_logic>(0));
  pwrite.initialize(static_cast<sc_logic>(0));
  paddr.initialize(0);
  pwdata.initialize(0);

//  SC_METHOD( reset );
//  sensitive << presetn;
}

void pv2apb::end_of_elaboration() {
  cout << name() << " constructed." << endl;
}

pv2apb::~pv2apb()
{
}

tlm::tlm_status pv2apb::write( const ADDRESS_TYPE &addr , const DATA_TYPE &data,
				const unsigned int byte_enable,
				const tlm::tlm_mode mode,
				const unsigned int export_id)
{

  // NEED CODE HERE TO SET APB SIGNALS
  //
  //

  psel.write(static_cast<sc_logic>(0));
  penable.write(static_cast<sc_logic>(0));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(0);
  pwdata.write(0);

//  wait(pclk.posedge_event());
  wait(500, SC_NS);

  psel.write(static_cast<sc_logic>(1));
  penable.write(static_cast<sc_logic>(1));
  pwrite.write(static_cast<sc_logic>(1));
  paddr.write(addr);
  pwdata.write(data);

//  wait(pclk.posedge_event());
  wait(500, SC_NS);

  psel.write(static_cast<sc_logic>(0));
  penable.write(static_cast<sc_logic>(0));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(0);
  pwdata.write(0);


  tlm::tlm_status status;
  status.set_ok();
  return status;
}

tlm::tlm_status pv2apb::read( const ADDRESS_TYPE &addr , DATA_TYPE &data,
			      const unsigned int byte_enable,
			      const tlm::tlm_mode mode,
			      const unsigned int export_id)
{
  // NEED CODE HERE TO SET APB SIGNALS
  //
  //
  sc_int<32> scdata;

  psel.write(static_cast<sc_logic>(0));
  penable.write(static_cast<sc_logic>(0));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(0);
  pwdata.write(0);

//  wait(pclk.posedge_event());
  wait(500, SC_NS);

  psel.write(static_cast<sc_logic>(1));
  penable.write(static_cast<sc_logic>(1));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(addr);

//  wait(pclk.posedge_event());
  wait(500, SC_NS);

  scdata = prdata.read();
  data = scdata;

  psel.write(static_cast<sc_logic>(0));
  penable.write(static_cast<sc_logic>(0));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(0);

//  cout << name() << " done. data=" << data << endl;

  tlm::tlm_status status;
  status.set_ok();
  return status;
}

void pv2apb::reset()
{
  psel.write(static_cast<sc_logic>(0));
  penable.write(static_cast<sc_logic>(0));
  pwrite.write(static_cast<sc_logic>(0));
  paddr.write(0);
  pwdata.write(0);
}

