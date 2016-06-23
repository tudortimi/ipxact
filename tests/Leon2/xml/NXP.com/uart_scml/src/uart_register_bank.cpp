/*
  Description: uart_register_bank.cpp
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
// uart_register_bank.cpp

//***************************
//*		Includes			*
//***************************
#include "uart.h"

//***********************************************************************************
//*		UART Module: Register Call-backs										*
//*		These functions are bound to the register aliases of the register bank.		*
//***********************************************************************************
// Non Blocking Write callback bound to RBR/THR register. A Write will access the THR
void		uart::RegCB_RBR_THR_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset) {
	if (bFCR_FIFOE == 1)				// If FIFOs are enabled...
		TX_FIFO.write(WriteData);		// Write data to the Transmit FIFO
	else {
		rTHR = WriteData;				// Write data to the Transmit Holding Register
	}
	bLSR_THRE = 0;						// Clear the THR Empty bit
	TransmitEvent.notify();				// Trigger the Transmitter
	InterruptEvent.notify();			// Check for Interrupts
};
// Non Blocking Read callback bound to RBR/THR register. A Read will access the RBR
DATA_TYPE	uart::RegCB_RBR_THR_Read(unsigned int AccessSize, unsigned int Offset) {
	DATA_TYPE ReturnValue;
	if (bFCR_FIFOE == 1) {					// If FIFOs are enabled...
		ReturnValue = RX_FIFO.read();		// Read data from the Receive FIFO
		if (RX_FIFO.IsBelowTriggerLevel())	// If Receive FIFO is below the trigger level...
			Clear_RX_Interrupt = true;		// Clear the Receive buffer full interrupt
		if (RX_FIFO.IsEmpty()) {			// If Receive FIFO is empty...
			bLSR_DR = 0;					// Clear the Data Ready bit
		}
	} else {
		ReturnValue = rRBR;					// Read data from the Receive Buffer Register
		rRBR = 0;							// Clear the RBR
		bLSR_DR = 0;						// Clear the Data Ready bit
		Clear_RX_Interrupt = true;			// Clear the Receive buffer full interrupt
	}
	InterruptEvent.notify();				// Update interrupts
	return ReturnValue;						// Return the value
};
// Non Blocking Write callback bound to IIR/FCR register. A Write will access the FCR
void		uart::RegCB_IIR_FCR_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset) {
	if (WriteData & 1) {							// If the first bit (FIFO Enable bit) is set...
		switch ((WriteData >> 6) & 0x03) {			// Set the Receive FIFO trigger level
			case 0x01:
				RX_FIFO.SetTriggerLevel(RX_FIFO_SIZE/4);
				break;
			case 0x02:
				RX_FIFO.SetTriggerLevel(RX_FIFO_SIZE/2);
				break;
			case 0x03:
				RX_FIFO.SetTriggerLevel(RX_FIFO_SIZE-2);
				break;
			default:
				RX_FIFO.SetTriggerLevel(1);
				break;
		}
		switch ((WriteData >> 4) & 0x03) {			// Set the Transmit FIFO trigger level
			case 0x01:
				TX_FIFO.SetTriggerLevel(TX_FIFO_SIZE/4);
				break;
			case 0x02:
				TX_FIFO.SetTriggerLevel(TX_FIFO_SIZE/2);
				break;
			case 0x03:
				TX_FIFO.SetTriggerLevel(TX_FIFO_SIZE-2);
				break;
			default:
				TX_FIFO.SetTriggerLevel(1);
				break;
		}
	} else {										// If FIFOs are (being) disabled...
		if (!RX_FIFO.IsEmpty())						// If the Receive FIFO is not empty...
			rRBR = RX_FIFO.read();					// Transfer the top item of the Receive FIFO to the RBR
		cout << sc_time_stamp() << ": " << name() << ": FIFOs Disabled." << endl;
	}
	rFCR = WriteData;								// Store the data word in the Fifo Control Register
};
// Non Blocking Read callback bound to IIR/FCR register. A Read will access the IIR
DATA_TYPE	uart::RegCB_IIR_FCR_Read(unsigned int AccessSize, unsigned int Offset) {
	DATA_TYPE	ReturnValue = rIIR;
	
	if ((ReturnValue & 0x0F) == UART_IRQ_TX) {				// If a Transmit buffer empty interrupt is returned...
		Clear_TX_Interrupt = true;								// Clear the Transmit buffer empty interrupt
	}

	InterruptEvent.notify();									// Update interrupts
	ReturnValue |= ((bFCR_FIFOE << 7) | (bFCR_FIFOE << 6));		// Set bit 6 and 7 to the same value as the FIFO Enable bit.
	return ReturnValue;											// Return the value of Interrupt Identification Register
};
// Non Blocking Read callback bound to LSR register.
DATA_TYPE	uart::RegCB_LSR_Read(unsigned int AccessSize, unsigned int Offset) {
	DATA_TYPE ReturnValue = rLSR;
	Clear_LS_Interrupt = true;									// Clear the Line Status Interrupt
	InterruptEvent.notify();									// Update interrupts
	return ReturnValue;											// Return the value of Line Status Register
};
// Non Blocking Write callback bound to IER register.
void		uart::RegCB_IER_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset) {
	rIER = WriteData;											// Write data word to Interrupt Enable Register
	InterruptEvent.notify();									// Update interrupts
};

