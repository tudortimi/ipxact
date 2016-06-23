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


// uart_interrupt_handler.cpp

//***************************
//*		Includes			*
//***************************
#include "uart.h"

//***********************************************************************************
//*		UART Module: Handle_Interrupts()										*
//*		This Method is triggered by the 'InterruptEvent' event.						*
//*		It checks the status of the UART and issues interrupts when necessary.		*
//***********************************************************************************
void uart::Handle_Interrupts() {
	
	rIIR = (bFCR_FIFOE << 7) | (bFCR_FIFOE << 6) | UART_IRQ_NONE;					// Set the IIR register do default value (NO interrupt pending)

	if (CurrentInterruptPriority == 1 && Clear_LS_Interrupt == true) {					// If the Line Status Interrupt is to be cleared...
		cout << sc_time_stamp() << ": " << name() << ": Line Status Interrupt Cleared." << endl;
		Clear_LS_Interrupt = false;
		bLSR_OE = 0;								// Clear the Overflow Error bit
		bLSR_PE = 0;								// Clear the Parity Error bit
		bLSR_FE = 0;								// Clear the Framing Error bit
		bLSR_BI = 0;								// Clear the Break Indicator bit
		CurrentInterruptPriority = 6;				// Reset interrupt priority level
		pInterrupt = 0;							// Clear Interrupt line
		InterruptEvent.notify();		// Check for additional interrupts
		return;
	}
	if (CurrentInterruptPriority == 2 && Clear_RX_Interrupt == true) {				// If the Receive Buffer full Interrupt is to be cleared...
		cout << sc_time_stamp() << ": " << name() << ": Receiver Interrupt Cleared." << endl;
		Clear_RX_Interrupt = false;
		CurrentInterruptPriority = 6;		// Reset interrupt priority level
		pInterrupt = 0;					// Clear Interrupt line
		InterruptEvent.notify();			// Check for additional interrupts
		return;
	}
	if (CurrentInterruptPriority == 3 && Clear_TX_Interrupt == true) {				// If the Transmit Buffer empty Interrupt is to be cleared...
		cout << sc_time_stamp() << ": " << name() << ": Transmitter Interrupt Cleared." << endl;
		Clear_TX_Interrupt = false;
		CurrentInterruptPriority = 6;		// Reset interrupt priority level
		pInterrupt = 0;					// Clear Interrupt line
		InterruptEvent.notify();			// Check for additional interrupts
		return;
	}
	// Reset the Clear Interrupt variables
	Clear_LS_Interrupt = false;	
	Clear_TX_Interrupt = false;
	Clear_RX_Interrupt = false;

	// Check for new Interrupts:
	if (bIER_ELSI){								// If the Line Status Interrupt is Enabled...
		if (bLSR_OE | bLSR_PE | bLSR_FE | bLSR_BI) {			// If the Overflow Error, Parity Error, Framing Error or Break Indicator flag is set...
			rIIR = (bFCR_FIFOE << 7) | (bFCR_FIFOE << 6) | UART_IRQ_LS;		// Update IIR to indicate a Line Status Interrupt is set
			CurrentInterruptPriority = 1;						// Update Interrupt Priority level
			if (pInterrupt == 1) {							// If there already is an interrupt pending
				pInterrupt = 0;								// Clear the interrupt line
				InterruptEvent.notify(SC_ZERO_TIME);	// Call this function again, with a delta cycle delay. This should make the interrupt line low for one delta cycle.
				return;
			}
			pInterrupt = 1;									// Set the interrupt line
			return;
		}
	}
	if (bIER_ERBFI) {							// If the Receive Buffer Full Interrupt is Enabled...
		if (bLSR_DR) {									// If the Data Ready flag is set...
			if (bFCR_FIFOE) {							// If the FIFOs are Enabled...
				if (RX_FIFO.IsAboveTriggerLevel()) {	// If the Receive FIFO is above its trigger level...
					rIIR = (bFCR_FIFOE << 7) | (bFCR_FIFOE << 6) | UART_IRQ_RX;	// Update IIR to indicate a Receive Buffer Full Interrupt is set
					CurrentInterruptPriority = 2;		// Update Interrupt Priority level
					if (pInterrupt == 1) {			// If there already is an interrupt pending...
						pInterrupt = 0;				// Clear the interrupt line
						InterruptEvent.notify(SC_ZERO_TIME);	// Call this function again, with a delta cycle delay. This should make the interrupt line low for one delta cycle.
						return;
					}
					pInterrupt = 1;					// Set the interrupt line
					return;
				}
			} else {
				rIIR = (bFCR_FIFOE << 7) | (bFCR_FIFOE << 6) | UART_IRQ_RX;	// Update IIR to indicate a Receive Buffer Full Interrupt is set
				CurrentInterruptPriority = 2;						// Update Interrupt Priority level
				if (pInterrupt == 1) {							// If there already is an interrupt pending...
					pInterrupt = 0;								// Clear the interrupt line
					InterruptEvent.notify(SC_ZERO_TIME);	// Call this function again, with a delta cycle delay. This should make the interrupt line low for one delta cycle.
					return;
				}
				pInterrupt = 1;						// Set the interrupt line
				return;
			}
		}
	}
	if (bIER_ETBEI) {								// If the Transmit Buffer Empty Interrupt is Enabled...
		if (bLSR_THRE) {										// If the THR Empty bit is set...
			rIIR = (bFCR_FIFOE << 7) | (bFCR_FIFOE << 6) | UART_IRQ_TX;		// Update IIR to indicate a Transmit Buffer Empty Interrupt is set
			CurrentInterruptPriority = 3;						// Update Interrupt Priority level
			if (pInterrupt == 1) {							// If there already is an interrupt pending...
				pInterrupt = 0;								// Clear the interrupt line
				InterruptEvent.notify(SC_ZERO_TIME);	// Call this function again, with a delta cycle delay. This should make the interrupt line low for one delta cycle.
				return;
			}
			pInterrupt = 1;							// Set the interrupt line
			return;
		}
	}

	// No interrups 
	CurrentInterruptPriority = 6;						// Reset interrupt priority level
	pInterrupt = 0;									// Clear the interrupt line
	
	return;
};
