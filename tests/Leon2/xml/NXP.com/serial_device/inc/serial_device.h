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


// serial_device.h

#ifndef H_SERIALDEVICE
#define H_SERIALDEVICE

//***************************
//*		Includes			*
//***************************
#include "scml.h"							// For 'scml_memory' and 'scml_bitfield'
#include "tlm_interfaces/tlm_core_ifs.h"	// For 'tlm_blocking_put_if'

#include "uart_types.h"

//*******************************************************************************************
//*		Serial Device Module Class															*
//*		This module sends all the data it receives on 'pSerialIn' back over 'pSerialOut'	*
//*******************************************************************************************
class SerialDevice: public sc_module,
	virtual public tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE>
{
public:
	//**** Port Declarations ****//
	sc_port<tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE> > pSerialOut;	// Serial data output port.
	sc_export<tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE> > pSerialIn;	// Serial data input port. export bound to this module.


	SC_HAS_PROCESS(SerialDevice);
	//**** Constructor ****//
	SerialDevice(sc_module_name Name) : sc_module(Name),
		pSerialOut("pSerialOut"),
		pSerialIn("pSerialIn") {
		
		pSerialIn.bind(*this);		// Bind the export to this module

		SC_METHOD(SendData);
		sensitive << send_event;
		dont_initialize();
	}
private:
	sc_event send_event;		// Event to trigger 'SendData()'
	SERIAL_DATA_STRUCTURE CurrentDataStruct;

	//**** Interface Method of 'tlm_blocking_put_if' ****//
	void put( const SERIAL_DATA_STRUCTURE &DataStruct ) {
		cout << sc_time_stamp() << ": " << name() << ": Serial Character Frame Received (Data: " << DataStruct.Data << 
			", Startbit: " << DataStruct.StartBit << 
			", StopBit: " << DataStruct.StopBit << 
			", Parity: " << DataStruct.Parity << ")" <<	endl;
		CurrentDataStruct = DataStruct;	// Store the received data structure
		send_event.notify();			// Trigger to send the data back
	};
	// Function for sending the data in 'CurrentDataStruct' to 'pSerialOut'
	void SendData() {
		cout << sc_time_stamp() << ": " << name() << ": Serial Character Transmitted: " << CurrentDataStruct.Data << endl;
		pSerialOut->put(CurrentDataStruct);
	}
};

#endif // H_SERIALDEVICE
