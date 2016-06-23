/*
  Description: uart.cpp
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
// uart.cpp

//***************************
//*		Includes			*
//***************************
#include "uart.h"

//***************************************
//*		UART Module: Constructor	*
//***************************************
uart::uart(sc_module_name Name) :
	sc_module(Name),
	pPVTargetPort("pPVTargetPort"),
	pReset("pReset"),
	pInterrupt("pInterrupt"),
	pSerialOut("pSerialOut"),
	pSerialIn("pSerialIn"),
	mRegisterBank("mRegisterBank", scml_memsize(UART_MEM_SIZE)),
	rRBR_THR("rRBR_THR", mRegisterBank, UART_REG_RBR, 1),
	rIIR_FCR("rIIR_FCR", mRegisterBank, UART_REG_IIR, 1),
	rIER("rIER", mRegisterBank, UART_REG_IER, 1),
	bIER_ELSI("bIER_ELSI", rIER, UART_BIT_IER_ELSI, 1),
	bIER_ETBEI("bIER_ETBEI", rIER, UART_BIT_IER_ETBEI, 1),
	bIER_ERBFI("bIER_ERBFI", rIER, UART_BIT_IER_ERBFI, 1),
	rLCR("rLCR", mRegisterBank, UART_REG_LCR, 1),
	bLCR_SB("bLCR_SB", rLCR, UART_BIT_LCR_SB, 1),
	bLCR_SP("bLCR_SP", rLCR, UART_BIT_LCR_SP, 1),
	bLCR_EPS("bLCR_EPS", rLCR, UART_BIT_LCR_EPS, 1),
	bLCR_PEN("bLCR_PEN", rLCR, UART_BIT_LCR_PEN, 1),
	bLCR_STB("bLCR_STB", rLCR, UART_BIT_LCR_STB, 1),
	bLCR_WLS1("bLCR_WLS1", rLCR, UART_BIT_LCR_WLS1, 1),
	bLCR_WLS0("bLCR_WLS0", rLCR, UART_BIT_LCR_WLS0, 1),
	rLSR("rLSR", mRegisterBank, UART_REG_LSR, 1),
	bLSR_THRE("bLSR_THRE", rLSR, UART_BIT_LSR_THRE, 1),
	bLSR_BI("bLSR_BI", rLSR, UART_BIT_LSR_BI, 1),
	bLSR_FE("bLSR_FE", rLSR, UART_BIT_LSR_FE, 1),
	bLSR_PE("bLSR_PE", rLSR, UART_BIT_LSR_PE, 1),
	bLSR_OE("bLSR_OE", rLSR, UART_BIT_LSR_OE, 1),
	bLSR_DR("bLSR_DR", rLSR, UART_BIT_LSR_DR, 1),
	rRBR("rRBR", scml_memsize(1)),
	rTHR("rTHR", scml_memsize(1)),
	rIIR("rIIR", scml_memsize(1)),
	rFCR("rFCR", scml_memsize(1)),
	bFCR_FIFOE("bFCR_FIFOE", rFCR, UART_BIT_FCR_FIFOE, 1),
	TX_FIFO("TX_FIFO", TX_FIFO_SIZE),
	RX_FIFO("RX_FIFO", RX_FIFO_SIZE)
	{

	mRegisterBank.set_addressing_mode(8);	// Set memory to byte addressing

	pPVTargetPort(mRegisterBank);			// Bind the PV port to the register bank
	
	// Initialize global class variables
	Clear_LS_Interrupt = false;
	Clear_RX_Interrupt = false;
	Clear_TX_Interrupt = false;
	CurrentInterruptPriority = 6;

	pSerialIn.bind(*this);					// bind the 'pSerialIn' export to this module

	// Register the call-back functions of the register aliases
	MEMORY_REGISTER_NB_WRITE(rRBR_THR, RegCB_RBR_THR_Write);
	MEMORY_REGISTER_NB_READ(rRBR_THR, RegCB_RBR_THR_Read);

	MEMORY_REGISTER_NB_WRITE(rIIR_FCR, RegCB_IIR_FCR_Write);
	MEMORY_REGISTER_NB_READ(rIIR_FCR, RegCB_IIR_FCR_Read);

	MEMORY_REGISTER_NB_READ(rLSR, RegCB_LSR_Read);
	
	MEMORY_REGISTER_NB_WRITE(rIER, RegCB_IER_Write);

	// Declare methods
	SC_METHOD(Serial_Transmit);
	sensitive << TransmitEvent;
	dont_initialize();

	SC_METHOD(Handle_Interrupts);
	sensitive << InterruptEvent;
	dont_initialize();

	SC_METHOD(Reset);
	sensitive << pReset.pos();
};

//*******************************************************************
//*		UART Module: Reset()									*
//*		This Function resets all registers to their default value.	*
//*******************************************************************
void uart::Reset() {
	mRegisterBank.initialize(0);
	rRBR = UART_DEFAULT_RBR;
	rTHR = UART_DEFAULT_THR;
	rIER = UART_DEFAULT_IER;
	rIIR = UART_DEFAULT_IIR;
	rFCR = UART_DEFAULT_FCR;
	rLCR = UART_DEFAULT_LCR;
	rLSR = UART_DEFAULT_LSR;
};
