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
// modifications; but this notice must be included on any copy.


// uart_types.h

#ifndef H_UART_TYPES
#define H_UART_TYPES

//*******************************
//*		Type Definitions		*
//*******************************
typedef unsigned int DATA_TYPE;						
typedef unsigned int ADDRESS_TYPE;

typedef struct SerialDataStructure {			// This structure is send and received through the serial UART interface
	bool StartBit;
	unsigned char Data;
	bool Parity;
	bool StopBit;

	// Default Constructor
	SerialDataStructure() {
		StartBit = 1;
		Data = '0';
		Parity = 1;
		StopBit = 1;
	};
	// Constructor with argument passing
	SerialDataStructure(bool pStartBit, unsigned char pData, bool pParity, bool pStopBit) {
		StartBit = pStartBit;
		Data = pData;
		Parity = pParity;
		StopBit = pStopBit;
	}
} SERIAL_DATA_STRUCTURE;

#endif // H_UART_TYPES
