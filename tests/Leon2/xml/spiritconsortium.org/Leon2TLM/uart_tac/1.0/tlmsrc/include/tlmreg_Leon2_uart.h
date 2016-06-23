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

#ifndef _LEON2_UART_TLM_REGISTERS_H_
#define _LEON2_UART_TLM_REGISTERS_H_

/* -----------------------------------------------------------------------
 * Includes
 * ----------------------------------------------------------------------- */

#include "tlm_field.h"
#include "tlm_register.h"

#include "tlm_host_def.h"

namespace Leon2 {

  class uart_data_tlm_register : public tlm_register_32
  {

  public:
    tlm_field<tlm_uint32_t,32>   field;     // Data read/write register


    uart_data_tlm_register();

    /* Destructor */
    ~uart_data_tlm_register(){};

    void write(tlm_uint32_t value);

    void poke(tlm_uint32_t value);

    tlm_uint32_t read();

    tlm_uint32_t peek();

    void reset();
  };

  class uart_status_tlm_register : public tlm_register_32
  {

  public:
    tlm_field<tlm_uint32_t,32>   field;     // Status register


    uart_status_tlm_register();

    /* Destructor */
    ~uart_status_tlm_register(){};

    void write(tlm_uint32_t value);

    void poke(tlm_uint32_t value);

    tlm_uint32_t read();

    tlm_uint32_t peek();

    void reset();
  };

  class uart_control_tlm_register : public tlm_register_32
  {

  public:
    tlm_field<tlm_uint32_t,32>   field;     // Control register


    uart_control_tlm_register();

    /* Destructor */
    ~uart_control_tlm_register(){};

    void write(tlm_uint32_t value);

    void poke(tlm_uint32_t value);

    tlm_uint32_t read();

    tlm_uint32_t peek();

    void reset();
  };

  class uart_scalarReload_tlm_register : public tlm_register_32
  {

  public:
    tlm_field<tlm_uint32_t,32>   field;     // Scalar reload register


    uart_scalarReload_tlm_register();

    /* Destructor */
    ~uart_scalarReload_tlm_register(){};

    void write(tlm_uint32_t value);

    void poke(tlm_uint32_t value);

    tlm_uint32_t read();

    tlm_uint32_t peek();

    void reset();
  };

}                                                 // end namespace Leon2
#endif                                            /* _Leon2_uart_TLM_REGISTERS_H_ */
