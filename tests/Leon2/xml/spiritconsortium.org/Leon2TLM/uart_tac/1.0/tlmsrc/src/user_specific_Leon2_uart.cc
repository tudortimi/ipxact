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
// modifications; this notice must be included on any copy.

/* -----------------------------------------------------------------------
 * Includes
 * ----------------------------------------------------------------------- */

#include "systemc.h"                              /* SystemC include file */
#include "Leon2_uart.h"

#include "def_Leon2_uart.h"

namespace Leon2 {

  /* -----------------------------------------------------------------------
   * define the method and thread sensitivity and the end of the constructor
   * ----------------------------------------------------------------------- */

  void uart::method_and_thread_sensitivity()
  {
  }


  /***************************************************************************
   * \brief   Slave read_block Interface
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::read_block(const tlm_uint32_t & address_tlmske,
                                                 tlm_uint32_t * block_data_tlmske,
                                                 const unsigned int number,
                                                 prt_tlm_tac::tac_error_reason& error_reason,
                                                 unsigned int * block_byte_enable,
                                                 const unsigned int block_byte_enable_period,
                                                 const prt_tlm_tac::tac_mode mode,
                                                 const unsigned int target_port_id
                                                 ) {
    prt_tlm_tac::tac_status status_tlmske;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        DEBUG_REPORT(3,"\ttarget_port_id = Leon2_uart_ambaAPB_ID\n");
        break;

      default:
        status_tlmske.set_error();
        error_reason.set_reason("Error,  no businterface at that ID ");
        string msg_tlmske = "Error, can not write at address ";
        ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n",
                     name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
        break;
    }
  }

  /***************************************************************************
   * \brief   Slave write_block Interface
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::write_block(const tlm_uint32_t& address_tlmske,
                                                  const tlm_uint32_t * block_data_tlmske,
                                                  const unsigned int number,
                                                  prt_tlm_tac::tac_error_reason& error_reason,
                                                  unsigned int * block_byte_enable,
                                                  const unsigned int block_byte_enable_period,
                                                  const prt_tlm_tac::tac_mode mode,
                                                  const unsigned int target_port_id
                                                  ) {
    prt_tlm_tac::tac_status status_tlmske;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        DEBUG_REPORT(3,"\ttarget_port_id = Leon2_uart_ambaAPB_ID\n");
        break;

      default:
        status_tlmske.set_error();
        error_reason.set_reason("Error, no businterface at that ID ");
        string msg_tlmske = "Error, can not write at address ";
        ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n",
                     name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
        break;
    }
  };

  /***************************************************************************
   * \brief   Slave set_target_info Interface
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::set_target_info(const tlm_uint32_t& address_tlmske,
                                                      const prt_tlm_tac::tac_metadata& metadata,
                                                      prt_tlm_tac::tac_error_reason& error_reason,
                                                      const unsigned int target_port_id
                                                      ) {
    prt_tlm_tac::tac_status status_tlmske;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        error_reason.set_reason("set info for port ID : Leon2_uart_ambaAPB_ID using metadata not supported");
        ERROR_REPORT(2,"\t%s: %s T:%9.9f\n",
                     name(),error_reason.get_reason().c_str(),
                     (float)(sc_time_stamp().to_seconds()));
        status_tlmske.set_error();
        break;

      default:
        status_tlmske.set_error();
        break;
    }

    DEBUG_REPORT(3,"\t%s: set_target_info at 0x%X T:%9.9f\n", 
                 name(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));

    return(status_tlmske);
  }

}                                                 // end namespace Leon2
