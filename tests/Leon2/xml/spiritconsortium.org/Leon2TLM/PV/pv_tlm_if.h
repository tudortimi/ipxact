/*****************************************************************************
  Description: pv_tlm_if.h
  Author:      The SPIRIT Consortium
  Revision:    $Revision: 1506 $
  Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $

  Copyright (c) 2008, 2009 The SPIRIT Consortium.

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
  modifications; but this notice must be included on any copy.

  The following code is derived, directly or indirectly, from the SystemC
  source code Copyright (c) 1996-2004 by all Contributors.
  All Rights reserved.

  The contents of this file are subject to the restrictions and limitations
  set forth in the SystemC Open Source License Version 2.4 (the "License");
  You may not use this file except in compliance with such restrictions and
  limitations. You may obtain instructions on how to receive a copy of the
  License at http://www.systemc.org/. Software distributed by Contributors
  under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied. See the License for the specific
  language governing rights and limitations under the License.

*****************************************************************************/

#ifndef _PV_TLM_IF_H_
#define _PV_TLM_IF_H_


/*------------------------------------------------------------------------------
 * Includes
 *----------------------------------------------------------------------------*/
#include "tlm.h"

//----------------------------------------------------------------------------
// extra definitions added to the tlm namespace

namespace tlm {
  class tlm_status {

  public:

    tlm_status() :
      m_status(TLM_ERROR_FLAG)
    {}

    inline bool is_ok() const {
      return (!is_error());
    }
    inline void set_ok() {
      reset_error();
    }
    inline bool is_error() const {
      return (m_status & TLM_ERROR_FLAG);
    }
    inline void set_error() {
      m_status |= TLM_ERROR_FLAG;
    }
    inline void reset_error() {
      m_status &= ~TLM_ERROR_FLAG;
    }
    inline bool is_no_response() const {
      return (m_status & TLM_NO_RESPONSE_FLAG);
    }
    inline void set_no_response() {
      m_status |= TLM_NO_RESPONSE_FLAG;
    }
    inline void reset_no_response() {
      m_status &= ~TLM_NO_RESPONSE_FLAG;
    }

  protected :

    unsigned int m_status;

    enum status_list {
      TLM_SUCCESS = 0,     ///< Successful completion
      TLM_ERROR,           ///< Target indicates an error occurs during the access
      TLM_NO_RESPONSE      ///< No target response to the initiator's request

    };

    enum status_flags {
      TLM_ERROR_FLAG       = 0x01ul << TLM_ERROR,           ///< Mask to set and reset TLM_ERROR flag
      TLM_NO_RESPONSE_FLAG = 0x01ul << TLM_NO_RESPONSE,     ///< Mask to set and reset TLM_NO_RESPONSE flag
    };

  };

  enum tlm_mode {
  REGULAR
  };

  enum tlm_endianness {
    TLM_LITTLE_ENDIAN,
    TLM_BIG_ENDIAN
  };

#if defined(_WIN32) && defined(_MSC_VER)

typedef unsigned __int64 tlm_uint64_t;
typedef unsigned __int32 tlm_uint32_t;
typedef unsigned __int16 tlm_uint16_t;
typedef unsigned __int8  tlm_uint8_t;

typedef __int64  tlm_sint64_t;
typedef __int32  tlm_sint32_t;
typedef __int16  tlm_sint16_t;
typedef __int8   tlm_sint8_t;

#else

typedef unsigned long long tlm_uint64_t;
typedef unsigned long tlm_uint32_t;
typedef unsigned short tlm_uint16_t;
typedef unsigned char tlm_uint8_t;

typedef long long  tlm_sint64_t;
typedef long  tlm_sint32_t;
typedef short tlm_sint16_t;
typedef char  tlm_sint8_t;

#endif

  static const unsigned int NO_BE = 0xffffffff;
}

/** Host arch. identification and associated typedef and define.
 **/

#if defined(__sparc) || defined(macintosh) || defined(__hppa)

/* Workstation endianness */
#define HOST_ENDIAN_BIG

/* SOC Endianness default value = host endianness */
#define PV_HOST_ENDIAN tlm::TLM_BIG_ENDIAN

#elif defined(__acorn) || defined(__mvs) || defined(_WIN32) || \
  (defined(__alpha) && defined(__osf__)) || defined(__i386) || defined(x86_64)

/* Workstation endianness */
#define HOST_ENDIAN_LITTLE

/* SOC Endianness default value = host endianness */
#define PV_HOST_ENDIAN tlm::TLM_LITTLE_ENDIAN

#else
/* Workstation endianness */
#define HOST_ENDIAN_UNKNOWN

#endif

//----------------------------------------------------------------------------
// PV_TLM abstract interface class, convenience API.

template< typename ADDRESS,typename DATA>
class pv_tlm_if {

public:

  virtual ~pv_tlm_if() {}

  virtual tlm::tlm_status read(const ADDRESS& address,
			       DATA& data,
			       const unsigned int byte_enable = tlm::NO_BE,
			       const tlm::tlm_mode mode = tlm::REGULAR,
			       const unsigned int export_id = 0
			       ) = 0;

  virtual tlm::tlm_status write(const ADDRESS& address,
				const DATA& data,
				const unsigned int byte_enable = tlm::NO_BE,
				const tlm::tlm_mode mode = tlm::REGULAR,
				const unsigned int export_id = 0
				) = 0;
};

//----------------------------------------------------------------------------
// PV request and response data structures

enum pv_command {
  PV_READ,
  PV_WRITE
};

template< typename ADDRESS , typename DATA >
class pv_request
{
public:

  typedef pv_request<ADDRESS,DATA> this_type;

  pv_request() :
    m_command(PV_READ),
    m_address(0),
    m_data(0)
  {}
  pv_request(const this_type& other) :
    m_command(other.m_command),
    m_address(other.m_address),
    m_data(other.m_data)
  {}

  this_type& operator= (const this_type& other) {
    m_command = other.m_command;
    m_address = other.m_address;
    m_data    = other.m_data;
    return *this;
  }

  inline pv_command get_command() const { return m_command; }
  inline void set_command(const pv_command command) { m_command = command; }

  inline ADDRESS get_address() const { return m_address; }
  inline void set_address(const ADDRESS address) { m_address = address; }

  inline const DATA& get_data() const { return m_data; }
  inline void set_data(const DATA& data) { m_data = data; }

protected:
  pv_command m_command;
  ADDRESS m_address;
  DATA m_data;
};

template< typename DATA >
class pv_response
{
public:

  typedef pv_response<DATA> this_type;

 pv_response() :
    m_status(),
    m_data(0)
  {}
  pv_response(const this_type& other) :
    m_status(other.m_status),
    m_data(other.m_data)
  {}

  this_type& operator= (const this_type& other) {
    m_status  = other.m_status;
    m_data    = other.m_data;
    return *this;
  }

  inline const tlm::tlm_status get_status() const { return m_status; }
  inline tlm::tlm_status get_status() { return m_status; }
  inline void set_status(const tlm::tlm_status& status) { m_status = status; }

  inline const DATA& get_data() const { return m_data; }
  inline DATA& get_data() { return m_data; }
  inline void set_data(const DATA& data) { m_data = data; }

protected:
  tlm::tlm_status m_status;
  DATA m_data;
};

#endif /* _PV_TLM_IF_H_ */

