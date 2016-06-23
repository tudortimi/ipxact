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

#ifndef _TLM_REGISTER_H_
#define _TLM_REGISTER_H_

/*------------------------------------------------------------------------------
 * Includes
 *----------------------------------------------------------------------------*/

#include "tlm_field.h"
#include "tlm_host_def.h"
#include "systemc.h"                              /* SystemC include file */


//----------------------------------------------------------------------------
///  CLASS : tlm_register_<size>
//----------------------------------------------------------------------------


/* tlm_uint8_t */
class tlm_register_8 {
 public:                  
	
	tlm_register_8(){};
	
	/* Destructor */
	virtual ~tlm_register_8(){};
	
	virtual void write(tlm_uint8_t value){}; 
	
	const tlm_register_8& operator=(const tlm_uint8_t value) {
		write(value);
		return( *this );
	}
	
	virtual tlm_uint8_t read(){ return 0; }; 
	
	virtual void reset(){};
};

/* tlm_uint16_t */
class tlm_register_16 {
 public:                  
	
	tlm_register_16(){};
	
	/* Destructor */
	virtual ~tlm_register_16(){};
	
	virtual void write(tlm_uint16_t value){}; 
	
	const tlm_register_16& operator=(const tlm_uint16_t value) {
		write(value);
		return( *this );
	}
	
	virtual tlm_uint16_t read(){ return 0; }; 
	
	virtual void reset(){};
};


/* tlm_uint32_t */
class tlm_register_32 {
 public:                  
                     
	tlm_register_32(){};

	/* Destructor */
	virtual ~tlm_register_32(){};

	virtual void write(tlm_uint32_t value){}; 

	const tlm_register_32& operator=(const tlm_uint32_t value) {
		write(value);
		return( *this );
	}

	virtual tlm_uint32_t read(){ return 0; }; 

	virtual void reset(){};
};


/* tlm_uint64_t */
class tlm_register_64 {
 public:                  
                     
	tlm_register_64(){};

	/* Destructor */
	virtual ~tlm_register_64(){};

	virtual void write(tlm_uint64_t value){}; 

	const tlm_register_64& operator=(const tlm_uint64_t value) {
		write(value);
		return( *this );
	}

	virtual tlm_uint64_t read(){ return 0; }; 

	virtual void reset(){};
};

#endif                                            /* _TLM_REGISTER_H_ */
