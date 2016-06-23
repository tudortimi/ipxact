/*
  Description: uart_serial_tx_rx.cpp
  Author:      The SPIRIT Consortium
  Revision:    $Revision: 1506 $
  Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $

  Copyright (c) 2009 The SPIRIT Consortium.

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
  modifications; this notice must be included on any copy.
 */
// uart_serial_tx_rx.cpp

//***************************
//*		Includes			*
//***************************
#include "uart.h"

//***********************************************************************************
//*		UART Module: put Interface Method										*
//*		This method is bound to the 'tlm_blocking_put_if' of the pSerialIn export.	*
//*		It handles the incomming serial data.										*
//***********************************************************************************
void uart::put(const SERIAL_DATA_STRUCTURE &DataStruct) {
	DATA_TYPE ReceiveShiftRegister;
	unsigned short NrOfDataBits = 5 + ((bLCR_WLS1 << 1) | bLCR_WLS0);	// Number of data bits in character frame
	unsigned short WordMask = (0x1F << (NrOfDataBits-5)) | 0x07;		// Mask that has the lowest 'NrOfDataBits' set to 1

	if (bFCR_FIFOE) {	// If the FIFOs are enabled...
		if (RX_FIFO.IsFull()) {		// If the receive FIFO is full...
			bLSR_OE = 1;			// Set the Overflow Error flag
			cout << sc_time_stamp() << ": " << name() << ": RX FIFO Full! Discarding received character frame." << endl;
		} else {
			ReceiveShiftRegister = DataStruct.Data & WordMask;	// Store the data in 'ReceiveShiftRegister'
			RX_FIFO.write(ReceiveShiftRegister);				// Write data to the FIFO
		}
	} else {
		if (bLSR_DR) {			// If data is avialable in RBR...
			bLSR_OE = 1;		// Set the Overflow Error flag
			cout << sc_time_stamp() << ": " << name() << ": RBR Full! Discarding received character frame." << endl;
		} else {
			ReceiveShiftRegister = DataStruct.Data & WordMask;	// Store the data in 'ReceiveShiftRegister'

			rRBR = ReceiveShiftRegister;						// Write data to the Receive Buffer Register
		}
	}
	if (!bLSR_OE) {		// If there was no Overflow Error...
		bLSR_DR = 1;	// Set the Data Ready flag
		if (DataStruct.StartBit != 1)	// If Start Bit is invalid...
			bLSR_BI = 1;				// Set the Break Indicator flag

		if (bLCR_PEN) {								// If Parity is ENabled...
			if (bLCR_SP) {							// If Stick Parity is enabled...
				if (DataStruct.Parity == (bool)bLCR_EPS)	// If Parity bit does not match...
					bLSR_PE = 1;					// Set Parity Error flag
			} else {
				// Check the parity of data bits + parity bit
				bool ParityCheck = 1;	// 0 = odd, 1 = even
				for (int i = 0; i < NrOfDataBits; i++) {
					ParityCheck = ParityCheck ^ (ReceiveShiftRegister & 0x01);
					ReceiveShiftRegister >>= 1;
				}
				ParityCheck = ParityCheck ^ DataStruct.Parity;
				if (ParityCheck != (bool)bLCR_EPS)	// If the parity does not match...
					bLSR_PE = 1;				// Set Parity Error flag
			}
		}
		if (DataStruct.StopBit != 1)			// If Stop Bit is invalid...
			bLSR_FE = 1;						// Set Framing Error flag
		
		cout << sc_time_stamp() << ": " << name() << ": Serial Character received: " << DataStruct.Data << "." << endl;
	}
	InterruptEvent.notify();					// Trigger the Interrupt handler to check for interrupts.
}

//***********************************************************************************
//*		UART Module: Serial_Transmit()											*
//*		This method is triggered by the 'TransmitEvent' event.						*
//*		It sends a serial data frame to the 'pSerialOut' port.						*
//***********************************************************************************
void uart::Serial_Transmit() {
	unsigned char TransmitShiftRegister;
	SERIAL_DATA_STRUCTURE CharacterFrame;
	unsigned short NrOfDataBits = 5 + ((bLCR_WLS1 << 1) | bLCR_WLS0);		// Number of data bits in character frame
	unsigned short WordMask = (0x1F << (NrOfDataBits-5)) | 0x07;			// Mask that has the lowest 'NrOfDataBits' set to 1

	if (bFCR_FIFOE == 1) {				// If FIFOs are enabled...
		if (TX_FIFO.IsEmpty()) {		// If the transmit FIFO is empty...
			cout << sc_time_stamp() << ": " << name() << ": TX FIFO Empty. Stopping Transmission" << endl;
			return;						// Don't transmit anything
		}
		TransmitShiftRegister = TX_FIFO.read() & WordMask;		// Get character from the transmit FIFO
		if (TX_FIFO.IsBelowTriggerLevel()) {					// If the transmit FIFO is below the trigger level...
			bLSR_THRE = 1;										// Set the THR Empty bit
		}
	} else {
		if (bLSR_THRE == 1) {					// If THR is empty....
			cout << sc_time_stamp() << ": " << name() << ": THR Empty. Stopping Transmission" << endl;
			return;								// Don't transmit anything
		}
		TransmitShiftRegister = rTHR & WordMask;		// Get character from the THR
		rTHR = 0;										// Clear the THR
		bLSR_THRE = 1;									// Set the THR Empty bit
	}
	cout << sc_time_stamp() << ": " << name() << ": Writing " << TransmitShiftRegister << " to pSerialOut" << endl;	
	
	CharacterFrame.StartBit = ~bLCR_SB;					// If Set Break bit is set, the Start Bit becomes 0, otherwise it is 1
	CharacterFrame.Data = TransmitShiftRegister;		// Put the data from the 'TransmitShiftRegister' in the character frame
	if (bLCR_PEN) {										// If Parity is ENabled...
		if (bLCR_SP) {									// If Stick Parity is enabled...
			CharacterFrame.Parity = !bLCR_EPS;			// Set parity bit to 1 if 'bLCR_EPS' == 0, and to 0 otherwise
		} else {
			// Calculate parity of data character
			bool ParityCalc = 1;	// 0 = odd, 1 = even
			for (int i = 0; i < NrOfDataBits; i++) {
				ParityCalc = ParityCalc ^ (TransmitShiftRegister & 0x01);
				TransmitShiftRegister >>= 1;
			}
			ParityCalc = ParityCalc ^ bLCR_EPS;
			CharacterFrame.Parity = ParityCalc;			// Set the parity bit to match the selected (odd or even) parity
		}
		
	} 
	CharacterFrame.StopBit = 1;							// Set the stop bit
	
	pSerialOut->put(CharacterFrame);					// Put the character frame on the 'pSerialOut' port

	TransmitEvent.notify();								// Trigger this function again, there may be more data to send
	InterruptEvent.notify();							// Trigger the interrupt handler to check for interrupt conditions
}
