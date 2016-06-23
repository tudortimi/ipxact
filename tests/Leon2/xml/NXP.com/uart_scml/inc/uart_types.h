//copyright (c) The SPIRIT Consortium.  All rights reserved.
//www.spiritconsortium.org
// 
//THIS WORK FORMS PART OF A SPIRIT CONSORTIUM SPECIFICATION.
//USE OF THESE MATERIALS ARE GOVERNED BY
//THE LEGAL TERMS AND CONDITIONS OUTLINED IN THE SPIRIT
//SPECIFICATION DISCLAIMER AVAILABLE FROM
//www.spiritconsortium.org
// 
//This source file is provided on an AS IS basis. The SPIRIT Consortium disclaims 
//ANY WARRANTY EXPRESS OR IMPLIED INCLUDING ANY WARRANTY OF
//MERCHANTABILITY AND FITNESS FOR USE FOR A PARTICULAR PURPOSE. 
//The user of the source file shall indemnify and hold The SPIRIT Consortium harmless
//from any damages or liability arising out of the use thereof or the performance or
//implementation or partial implementation of the schema.


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
