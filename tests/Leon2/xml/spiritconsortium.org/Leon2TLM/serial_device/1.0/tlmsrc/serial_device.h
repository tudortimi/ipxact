//
//Revision:    $Revision: 1506 $
//Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
//
//Copyright (c) 2008, 2009 The SPIRIT Consortium.
//
//This work forms part of a deliverable of The SPIRIT Consortium.
//
//Use of these materials are governed by the legal terms and conditions
//outlined in the disclaimer available from www.spiritconsortium.org.
//
//This source file is provided on an AS IS basis.  The SPIRIT
//Consortium disclaims any warranty express or implied including
//any warranty of merchantability and fitness for use for a
//particular purpose.
//
//The user of the source file shall indemnify and hold The SPIRIT
//Consortium and its members harmless from any damages or liability.
//Users are requested to provide feedback to The SPIRIT Consortium
//using either mailto:feedback@lists.spiritconsortium.org or the forms at 
//http://www.spiritconsortium.org/about/contact_us/
//
//This file may be copied, and distributed, with or without
//modifications; but this notice must be included on any copy.


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
