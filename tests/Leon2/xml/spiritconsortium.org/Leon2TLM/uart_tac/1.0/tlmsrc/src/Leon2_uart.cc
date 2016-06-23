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

#include "def_Leon2_uart.h"

#include "Leon2_uart.h"

/* -----------------------------------------------------------------------
 * Defines
 * ----------------------------------------------------------------------- */

using std::exception;

using namespace std;

using prt_tlm_tac::be_byte;

/* -----------------------------------------------------------------------
 * Global Variables
 * ----------------------------------------------------------------------- */

// sc_object kind string property

const char* const Leon2::uart::kind_string = "Leon2_uart";

/* -----------------------------------------------------------------------
 * Public functions
 * ----------------------------------------------------------------------- */

namespace Leon2 {

  /***************************************************************************
   * \brief   Reset
   **************************************************************************/

  
  void uart::reset()
  {
    DEBUG_REPORT(3,"\tLeon2::uart: Init registers\n");
    data.reset();
    status.reset();
    control.reset();
    scalarReload.reset();

  }

  /***************************************************************************
   * \brief   Constructor
   **************************************************************************/

  
  uart::uart(sc_module_name tlms_module_name,
                         bool resetOnInitialize,
                         unsigned int debugLevel,
                         tlm_endianness endianness) :
    sc_module(tlms_module_name),
    prt_tlm_tac::tac_slave_base<tlm_uint32_t,tlm_uint32_t>(name()),
    // tac ports
    ambaAPB("ambaAPB")
  {
    resetOnInitialize_c = resetOnInitialize;
    debugLevel_c = debugLevel;
    endianness_c = endianness;

    // Bind slave ports to the slave
    ambaAPB(*this);
    ambaAPB.set_port_id(Leon2_uart_ambaAPB_ID);


    /* -----------------------------------------------------------------------
     * Leon2_uart Internal SC_METHODS and SC_THREADS (sensitivity)
     * ----------------------------------------------------------------------- */

    method_and_thread_sensitivity();

    // Call the Reset to initialyze the registers
    reset();

  }

  /***************************************************************************
   * \brief   Destructor for Leon2_uart . Does nothing
   **************************************************************************/

  
  uart::~uart()
  {
    GENERAL_REPORT("\t%s: Destructor called \n",name());
  }

  /***************************************************************************
   * \brief   Slave Read Interface
   * \return  none
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::read(const tlm_uint32_t& address_tlmske,
                                           tlm_uint32_t& data_tlmske,
                                           prt_tlm_tac::tac_error_reason& error_reason,
                                           const unsigned int byte_enable,
                                           const prt_tlm_tac::tac_mode mode,
                                           const unsigned int target_port_id
                                           ) {
    prt_tlm_tac::tac_status status_tlmske;

    bool sd_enabled = 0;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        DEBUG_REPORT(3,"\ttarget_port_id = Leon2_uart_ambaAPB_ID\n");
        sd_enabled = 0;

        switch(address_tlmske)
        {
          case (data_offset):
            if (sd_enabled == 0) {
              data_tlmske = data.read();
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();

            break;

          case (status_offset):
            if (sd_enabled == 0) {
              data_tlmske = status.read();
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();

            break;

          case (control_offset):
            if (sd_enabled == 0) {
              data_tlmske = control.read();
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();

            break;

          case (scalarReload_offset):
            if (sd_enabled == 0) {
              data_tlmske = scalarReload.read();
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();

            break;

          default:
            status_tlmske.set_error();
            error_reason.set_reason("Error, can not read at address ");
            string msg_tlmske = "Error, can not read at address ";
            ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n", 
                         name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
            break;
        }
        break;

      default:
        status_tlmske.set_error();
        error_reason.set_reason("Error, bus ID unknown ");
        string msg_tlmske = "Error, bus ID unknown ";
        ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n", 
                     name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
        break;
    }

    DEBUG_REPORT(3,"\t%s: Read 0x%X at 0x%X T:%9.9f\n",
                 name(),(unsigned int)data_tlmske,(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));

    return(status_tlmske);
  }

  /***************************************************************************
   * \brief   Slave Write Interface
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::write(const tlm_uint32_t& address_tlmske,
                                            const tlm_uint32_t& data_tlmske,
                                            prt_tlm_tac::tac_error_reason& error_reason,
                                            const unsigned int byte_enable,
                                            const prt_tlm_tac::tac_mode mode,
                                            const unsigned int target_port_id
                                            ) {
    prt_tlm_tac::tac_status status_tlmske;
    bool sd_enabled = 0;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        DEBUG_REPORT(3,"\ttarget_port_id = Leon2_uart_ambaAPB_ID\n");
        sd_enabled = 0;

        switch(address_tlmske)
        {
          case (data_offset):
            if (sd_enabled == 0) {
              data.write(data_tlmske);
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();
            break;

          case (control_offset):
            if (sd_enabled == 0) {
              control.write(data_tlmske);
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();
            break;

          case (scalarReload_offset):
            if (sd_enabled == 0) {
              scalarReload.write(data_tlmske);
            }
            status_tlmske.set_ok(); 
            status_tlmske.set_synchro();
            break;

          default:
            status_tlmske.set_error();
            error_reason.set_reason("Error, can not write at address ");
            string msg_tlmske = "Error, can not write at address ";
            ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n", 
                         name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
            break;
        }
        break;
      default:
        status_tlmske.set_error();
        error_reason.set_reason("Error, bus ID unknown ");
        string msg_tlmske = "Error, bus ID unknown ";
        ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n", 
                     name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
        break;
    }

    DEBUG_REPORT(3,"\t%s: Write 0x%X at 0x%X T:%9.9f\n", 
                 name(),(unsigned int)data_tlmske,(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));

    return(status_tlmske);
  }

  /***************************************************************************
   * \brief   Slave get_target_info Interface
   **************************************************************************/

  
  prt_tlm_tac::tac_status uart::get_target_info(const tlm_uint32_t& address_tlmske,
                                                      prt_tlm_tac::tac_metadata& metadata,
                                                      prt_tlm_tac::tac_error_reason& error_reason,
                                                      const unsigned int target_port_id
                                                      ) {
    prt_tlm_tac::tac_status status_tlmske;

    stringstream info;

    switch(target_port_id)
    {

      case Leon2_uart_ambaAPB_ID:
        status_tlmske.set_ok();
        info << metadata.get_key_string(prt_tlm_tac::tac_metadata::NAME) << name();
        info << metadata.get_key_string(prt_tlm_tac::tac_metadata::SLAVE_BASE_PTR) << hex << showbase << (prt_tlm_tac::tac_slave_base<tlm_uint32_t,tlm_uint32_t> *)(this);
        info << metadata.get_key_string(prt_tlm_tac::tac_metadata::TARGET_PORT_ID) << dec << target_port_id;
        info << metadata.get_key_string(prt_tlm_tac::tac_metadata::ENDIANNESS) << ((endianness_c == TLM_BIG_ENDIAN) ? "big ": "little");
        metadata.set_metadata(info.str());
        break;
      default:
        status_tlmske.set_error();
        error_reason.set_reason("Error, bus ID unknown ");
        string msg_tlmske = "Error, bus ID unknown ";
        ERROR_REPORT(2,"\t%s: %s 0x%X T:%9.9f\n", 
                     name(),msg_tlmske.c_str(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));
        break;
    }

    DEBUG_REPORT(3,"\t%s: get_target_info at 0x%X T:%9.9f\n", 
                 name(),(unsigned int)address_tlmske,(float)(sc_time_stamp().to_seconds()));

    return(status_tlmske);
  }

}                                                 // end of namespace Leon2
