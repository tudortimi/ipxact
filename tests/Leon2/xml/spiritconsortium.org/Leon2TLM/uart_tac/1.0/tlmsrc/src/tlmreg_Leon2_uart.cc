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

#include "tlmreg_Leon2_uart.h"

namespace Leon2 {

  uart_data_tlm_register::uart_data_tlm_register() :
    field()
  {}

  void uart_data_tlm_register::write(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  void uart_data_tlm_register::poke(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  tlm_uint32_t uart_data_tlm_register::peek()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  tlm_uint32_t uart_data_tlm_register::read()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  void uart_data_tlm_register::reset()
  {
    field.write(0x0);

    return;
  }

  uart_status_tlm_register::uart_status_tlm_register() :
    field()
  {}

  void uart_status_tlm_register::write(tlm_uint32_t value)
  {

    return;
  }

  void uart_status_tlm_register::poke(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  tlm_uint32_t uart_status_tlm_register::peek()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  tlm_uint32_t uart_status_tlm_register::read()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  void uart_status_tlm_register::reset()
  {
    field.write(0x6);

    return;
  }

  uart_control_tlm_register::uart_control_tlm_register() :
    field()
  {}

  void uart_control_tlm_register::write(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  void uart_control_tlm_register::poke(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  tlm_uint32_t uart_control_tlm_register::peek()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  tlm_uint32_t uart_control_tlm_register::read()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  void uart_control_tlm_register::reset()
  {
    field.write(0x0);

    return;
  }

  uart_scalarReload_tlm_register::uart_scalarReload_tlm_register() :
    field()
  {}

  void uart_scalarReload_tlm_register::write(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  void uart_scalarReload_tlm_register::poke(tlm_uint32_t value)
  {
    field.write(value >> 0);

    return;
  }

  tlm_uint32_t uart_scalarReload_tlm_register::peek()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  tlm_uint32_t uart_scalarReload_tlm_register::read()
  {
    tlm_uint32_t value = 0;
    value |= field.read() << 0;

    return(value);
  }

  void uart_scalarReload_tlm_register::reset()
  {
    field.write(0x0);

    return;
  }

}                                                 // end namespace Leon2
