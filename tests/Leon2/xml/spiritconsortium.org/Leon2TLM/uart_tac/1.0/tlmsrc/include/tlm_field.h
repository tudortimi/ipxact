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

#ifndef _tlm_field_H_ 
#define _tlm_field_H_

//----------------------------------------------------------------------------
///  CLASS : tlm_field
//----------------------------------------------------------------------------

template<typename DATATYPE, int width>
class tlm_field
{
 private:
	DATATYPE m_value;
	DATATYPE m_mask;
	
 public:
	
	/* Build a new tlm_field item.*/
	tlm_field() {
		m_mask = 0;
		for(int bit = 0; bit < width; bit++)
		{
			m_mask |= (1U << bit);
		}
	}
	/* Destructor */
	~tlm_field(){};
	
	
	void write(DATATYPE value) {
		m_value = m_mask & value;
	};
	
	const tlm_field& operator=(DATATYPE value) {
		write(value);
		return( *this );
	}
  
  DATATYPE read() {
		return(m_value);
	};
};

#endif //_tlm_field_H_




