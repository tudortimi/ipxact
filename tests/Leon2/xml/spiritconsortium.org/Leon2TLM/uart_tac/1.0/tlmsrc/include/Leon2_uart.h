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

#ifndef _LEON2_UART_H_
#define _LEON2_UART_H_

/* -----------------------------------------------------------------------
 * Includes
 * ----------------------------------------------------------------------- */

#include <vector>
#include <exception>
#include <iostream>
#include <iomanip>
#include <string>

#include "systemc.h"                              /* SystemC include file */
#include "tlmreg_Leon2_uart.h"              /* Register Class declaration */

#include "tlm_event.h"                            /* tlm randomize timing file */
#include "tlm_host_def.h"
                            /* tlm datatype and address typedef */

#include "tlm_module.h"
#include "tlm_transaction_counter.h"

#include "tac_slave_base.h"                       /* the tac files */

#include "tac_target_port.h"

/* -----------------------------------------------------------------------
 * Defines
 * ----------------------------------------------------------------------- */
using prt_tlm_tac::BYTE_LANE_0;
using prt_tlm_tac::BYTE_LANE_1;
using prt_tlm_tac::BYTE_LANE_2;
using prt_tlm_tac::BYTE_LANE_3;
using prt_tlm_tac::BYTE_LANE_4;
using prt_tlm_tac::BYTE_LANE_5;
using prt_tlm_tac::BYTE_LANE_6;
using prt_tlm_tac::BYTE_LANE_7;

using namespace std;


namespace Leon2 {

  class uart :
    public sc_module,
    // derivation of the protocol IF
    public prt_tlm_tac::tac_slave_base<tlm_uint32_t,tlm_uint32_t>
    {

      bool m_mau_byte;                          // memory minimum allocation unit mode (0 = word, 1 = byte)

      /* -----------------------------------------------------------------------
       * Internal variables private, public and internal events
       * ----------------------------------------------------------------------- */

    private:

      /* -----------------------------------------------------------------------
       * Register Map
       * ----------------------------------------------------------------------- */
      uart_data_tlm_register data;     // Data read/write register
      uart_status_tlm_register status;     // Status register
      uart_control_tlm_register control;     // Control register
      uart_scalarReload_tlm_register scalarReload;     // Scalar reload register

    public:

      /* -----------------------------------------------------------------------
       * BusInterFace/port Definitions
       * ----------------------------------------------------------------------- */

      // target Interface - Leon2_uart
      prt_tlm_tac::tac_target_port<tlm_uint32_t,tlm_uint32_t> ambaAPB;

      // Initiator Interface - Leon2_uart

      /* -----------------------------------------------------------------------
       * Variables taking the values of the constructor parameters
       * ----------------------------------------------------------------------- */
      bool resetOnInitialize_c;
      unsigned int debugLevel_c;

      // Model endianness
      tlm_endianness endianness_c;

      // internal usage for array of registers
      int index;
      tlm_uint32_t data_ambaAPB_tske;

      /* -----------------------------------------------------------------------
       * OverLoaded Virtual Functions
       * ----------------------------------------------------------------------- */
      // Generic register Reset
      void reset(void);

      void printstatus();

      // Read access
      virtual prt_tlm_tac::tac_status read(const tlm_uint32_t& address,  tlm_uint32_t& data,
                                           prt_tlm_tac::tac_error_reason& error_reason,
                                           const unsigned int byte_enable = prt_tlm_tac::NO_BE,
                                           const prt_tlm_tac::tac_mode mode = prt_tlm_tac::DEFAULT,
                                           const unsigned int target_port_id = 0
                                           );

      //----------------------------
      // Write access
      virtual prt_tlm_tac::tac_status write(const tlm_uint32_t& address, const tlm_uint32_t& data,
                                            prt_tlm_tac::tac_error_reason& error_reason,
                                            const unsigned int byte_enable = prt_tlm_tac::NO_BE,
                                            const prt_tlm_tac::tac_mode mode = prt_tlm_tac::DEFAULT,
                                            const unsigned int target_port_id = 0
                                            );

      //----------------------------
      // Read access block
      virtual prt_tlm_tac::tac_status read_block(const tlm_uint32_t& address, tlm_uint32_t * block_data,
                                                 const unsigned int number,
                                                 prt_tlm_tac::tac_error_reason& error_reason,
                                                 unsigned int * block_byte_enable = NULL,
                                                 const unsigned int block_byte_enable_period = 1,
                                                 const prt_tlm_tac::tac_mode mode = prt_tlm_tac::DEFAULT,
                                                 const unsigned int target_port_id = 0
                                                 );

      //----------------------------
      // Write access block
      virtual prt_tlm_tac::tac_status write_block(const tlm_uint32_t& address, const tlm_uint32_t * block_data,
                                                  const unsigned int number,
                                                  prt_tlm_tac::tac_error_reason& error_reason,
                                                  unsigned int * block_byte_enable = NULL,
                                                  const unsigned int block_byte_enable_period = 1,
                                                  const prt_tlm_tac::tac_mode mode = prt_tlm_tac::DEFAULT,
                                                  const unsigned int target_port_id = 0
                                                  );

      //---------------------------------------
      // Get info about target
      virtual prt_tlm_tac::tac_status get_target_info(const tlm_uint32_t& address,
                                                      prt_tlm_tac::tac_metadata& metadata,
                                                      prt_tlm_tac::tac_error_reason& error_reason,
                                                      const unsigned int target_port_id = 0
                                                      );

      //---------------------------------------
      // Set info about target
      virtual prt_tlm_tac::tac_status set_target_info(const tlm_uint32_t& address,
                                                      const prt_tlm_tac::tac_metadata& metadata,
                                                      prt_tlm_tac::tac_error_reason& error_reason,
                                                      const unsigned int target_port_id = 0
                                                      );


      /* -----------------------------------------------------------------------
       * sc_object kind infos
       * ----------------------------------------------------------------------- */

      static const char* const kind_string;

      virtual const char* kind() const
      {
        return kind_string;
      }

      /* -----------------------------------------------------------------------
       * Leon2_uart Internal SC_METHODS and SC_THREADS ( Functions )
       * ----------------------------------------------------------------------- */

      void method_and_thread_sensitivity();


      /* -----------------------------------------------------------------------
       * Constructor for Leon2_uart.
       * ----------------------------------------------------------------------- */

      SC_HAS_PROCESS(uart);
      uart(sc_module_name module_name,
                 bool resetOnInitialize = true,     //  whether reset() should be invoked at startup time
                 unsigned int debugLevel = 0,     //  level of debugging
                 tlm_endianness endianness = TLM_BIG_ENDIAN     //  endianness of the IP
                 );

      /* -----------------------------------------------------------------------
       * Destructor for Leon2_uart
       * ----------------------------------------------------------------------- */

      ~uart();
    };
}                                                 // end namespace Leon2
#endif        /* _LEON2_UART_H_ */
