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


// uart.h

#ifndef H_UART
#define H_UART

//***************************
//*		Includes			*
//***************************
#include "scml.h"							            // For 'scml_memory' and 'scml_bitfield'
#include "tlm_interfaces/tlm_core_ifs.h"	// For 'tlm_blocking_put_if'
#include "PV/PV.h"							          // For 'PVTarget_port'

#include "uart_fifo.h"					// For 'UART_FIFO'
#include "uart_types.h"					// For UART data types
#include "uart_memory_map.h"		// For the register and bit positions

//***********************
//*		Definitions		*
//***********************
#define TX_FIFO_SIZE	16		// Size of Transmit FIFO
#define RX_FIFO_SIZE	16		// Size of Receive FIFO

//***********************************
//*		UART Module Class		*
//***********************************
class uart : 
	public sc_module,
	virtual public tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE> {
public:
	//**** Port Declarations ****//
	PVTarget_port<DATA_TYPE, ADDRESS_TYPE> pPVTargetPort;		// PV port
	
	sc_in<bool> pReset;									  // Reset pin to reset the registers to their default values. active high
	sc_out<int> pInterrupt;								// Interrupt Line, active high
	
	sc_port<tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE> > pSerialOut;	// Serial data output port.
	sc_export<tlm::tlm_blocking_put_if<SERIAL_DATA_STRUCTURE> > pSerialIn;	// Serial data input port. export bound to this module.
	
	SC_HAS_PROCESS(uart);
	//**** Constructor ****//
	uart(sc_module_name Name);

private:
	void Reset();		// Function to reset all registers to their default values (which are defined in 'uart_memory_map.h')
	
	// ******************
	// * Register Bank	*
	// ******************
	scml_memory<DATA_TYPE> mRegisterBank;
	// Aliases of 'mRegisterBank'
		scml_memory<DATA_TYPE> rRBR_THR;	// Shared RBR(read-only) and THR(write-only) location
		scml_memory<DATA_TYPE> rIIR_FCR;	// Shared IIR(read-only) and FCR(write-only) location
		scml_memory<DATA_TYPE> rIER;		// Interrupt Enable (Mask) Register
		// Bitfield aliases of IER register:
			scml_bitfield	bIER_ELSI;		// Enable Line Status Interrupt bit
			scml_bitfield	bIER_ETBEI;		// Enable Transmit Buffer Empty Interrupt bit
			scml_bitfield	bIER_ERBFI;		// Enable Receive Buffer Full Interrupt bit
		scml_memory<DATA_TYPE> rLCR;		// Line Control Register
		// Bitfield aliases of LCR register:
			scml_bitfield	bLCR_SB;		// Set Break bit
			scml_bitfield	bLCR_SP;		// Stick Parity bit
			scml_bitfield	bLCR_EPS;		// Even Parity Select bit
			scml_bitfield	bLCR_PEN;		// Parity ENable bit
			scml_bitfield	bLCR_STB;		// number of STop Bits bit
			scml_bitfield	bLCR_WLS1;		// Word Length Select bit 1
			scml_bitfield	bLCR_WLS0;		// Word Length Select bit 0
		scml_memory<DATA_TYPE> rLSR;		// Line Status Register
		// Bitfield aliases of LSR register:
			scml_bitfield	bLSR_THRE;		// THR Empty bit
			scml_bitfield	bLSR_BI;		// Break Indicator bit
			scml_bitfield	bLSR_FE;		// Frame Error bit
			scml_bitfield	bLSR_PE;		// Parity Error bit
			scml_bitfield	bLSR_OE;		// Overflow Error bit
			scml_bitfield	bLSR_DR;		// Data Ready bit

	// Seperate registers (1 word big)
	scml_memory<DATA_TYPE> rRBR;		// Receiver Buffer Register (read-only)
	scml_memory<DATA_TYPE> rTHR;		// Transmitter Holding Register (write-only)
	scml_memory<DATA_TYPE> rIIR;		// Interrupt Identification Register (read-only)
	scml_memory<DATA_TYPE> rFCR;		// FIFO Control Register (write-only)
		// Bitfield aliases of FCR register:
		scml_bitfield	bFCR_FIFOE;		// FIFOs Enable bit
	
	// **********************************
	// *  Register Call-back Functions	*
	// **********************************
	void		RegCB_RBR_THR_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset);
	DATA_TYPE	RegCB_RBR_THR_Read(unsigned int AccessSize, unsigned int Offset);
	
	void		RegCB_IIR_FCR_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset);
	DATA_TYPE	RegCB_IIR_FCR_Read(unsigned int AccessSize, unsigned int Offset);

	DATA_TYPE	RegCB_LSR_Read(unsigned int AccessSize, unsigned int Offset);
	
	void RegCB_IER_Write(DATA_TYPE WriteData, unsigned int AccessSize, unsigned int Offset);
	
	// ****************
	// * FIFO Buffers *
	// ****************
	UART_FIFO<DATA_TYPE>	TX_FIFO;	// Transmit FIFO
	UART_FIFO<DATA_TYPE>	RX_FIFO;	// Receive FIFO

	// ********************************
	// * Serial Transmit and Receive  *
	// ********************************
	void Serial_Transmit();		// Method triggerd by 'TransmitEvent' event
	sc_event TransmitEvent;		// Event to trigger 'Serial_Transmit()'
	
	//**** Interface Method of 'tlm_blocking_put_if' ****//
	void put( const SERIAL_DATA_STRUCTURE &DataStruct );		// All 'put' method calls made to pSerialIn call this function.

	// *********************
	// * Interrupt Handler *
	// *********************
	bool Clear_LS_Interrupt;	// Boolean to clear the Line Status Interrupt
	bool Clear_RX_Interrupt;	// Boolean to clear the Receive buffer full Interrupt
	bool Clear_TX_Interrupt;	// Boolean to clear the Transmit buffer empty Interrupt
	int CurrentInterruptPriority; // Indicator of the priority of the current interrupt.
	
	void Handle_Interrupts();	// Method triggered by 'InterruptEvent' event
	sc_event InterruptEvent;	// Event to trigger 'Handle_Interrupts()'
	
};

#endif // H_UART

