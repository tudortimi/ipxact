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


#ifndef H_UART_MEMORY_MAP
#define H_UART_MEMORY_MAP

// Register Address Map:
#define UART_MEM_SIZE	6					// Size of the UART address space
#define UART_REG_WIDTH	sizeof(DATA_TYPE)	// Byte width of the registers

// Index of UART registers
#define UART_REG_RBR	0	// Receiver Buffer Register
#define UART_REG_THR	0	// Transmitter Holding Register
#define UART_REG_IER	1	// Interrupt Enable (Mask) Register
#define UART_REG_IIR	2	// Interrupt Identification Register
#define UART_REG_FCR	2	// FIFO Control Register
#define UART_REG_LCR	3	// Line Control Register
#define UART_REG_LSR	5	// Line Status Register

// Individual Bit positions within registers
#define UART_BIT_FCR_FIFOE	0	// Position of FIFO Enable bit in FCR register	

#define UART_BIT_LSR_THRE	5	// Position of THR Empty bit in LSR register
#define UART_BIT_LSR_BI		4	// Position of Break Indicator bit in LSR register
#define UART_BIT_LSR_FE		3	// Position of Frame Error bit in LSR register
#define UART_BIT_LSR_PE		2	// Position of Parity Error bit in LSR register
#define UART_BIT_LSR_OE		1	// Position of Overflow Error bit in LSR register
#define UART_BIT_LSR_DR		0	// Position of Data Ready bit in LSR register

#define UART_BIT_IER_ELSI	2	// Position of Enable Line Status Interrupt bit in IER register
#define UART_BIT_IER_ETBEI	1	// Position of Enable Transmit Buffer Empty Interrupt bit in IER register
#define UART_BIT_IER_ERBFI	0	// Position of Enable Receive Buffer Full Interrupt bit in IER register

#define UART_BIT_LCR_SB		6	// Position of Set Break bit in LCR register
#define UART_BIT_LCR_SP		5	// Position of Stick Parity bit in LCR register
#define UART_BIT_LCR_EPS	4	// Position of Even Parity Select bit in LCR register
#define UART_BIT_LCR_PEN	3	// Position of Parity Enable bit in LCR register
#define UART_BIT_LCR_STB	2 	// Position of Number of Stop Bits bit in LCR register
#define UART_BIT_LCR_WLS1	1	// Position of Word Length Select bit 1 in LCR register
#define UART_BIT_LCR_WLS0	0	// Position of Word Length Select bit 0 in LCR register

// Line Control Register Options
#define UART_LCR_SET_BREAK		(1 << UART_BIT_LCR_SB)	

#define UART_LCR_NO_PARITY		((0 << UART_BIT_LCR_PEN) | (0 << UART_BIT_LCR_EPS) | (0 << UART_BIT_LCR_SP))
#define UART_LCR_ODD_PARITY		((1 << UART_BIT_LCR_PEN) | (0 << UART_BIT_LCR_EPS) | (0 << UART_BIT_LCR_SP))
#define UART_LCR_EVEN_PARITY	((1 << UART_BIT_LCR_PEN) | (1 << UART_BIT_LCR_EPS) | (0 << UART_BIT_LCR_SP))
#define UART_LCR_STICK1_PARITY	((1 << UART_BIT_LCR_PEN) | (0 << UART_BIT_LCR_EPS) | (1 << UART_BIT_LCR_SP))
#define UART_LCR_STICK0_PARITY	((1 << UART_BIT_LCR_PEN) | (1 << UART_BIT_LCR_EPS) | (1 << UART_BIT_LCR_SP))

#define UART_LCR_TWO_STOPBITS	(1 << UART_BIT_LCR_STB)

#define UART_LCR_WL5		((0 << UART_BIT_LCR_WLS1) | (0 << UART_BIT_LCR_WLS0))
#define UART_LCR_WL6		((0 << UART_BIT_LCR_WLS1) | (1 << UART_BIT_LCR_WLS0))
#define UART_LCR_WL7		((1 << UART_BIT_LCR_WLS1) | (0 << UART_BIT_LCR_WLS0))
#define UART_LCR_WL8		((1 << UART_BIT_LCR_WLS1) | (1 << UART_BIT_LCR_WLS0))

// Interrupt Identification
#define UART_IRQ_NONE		0x01	// No Interrupt			
#define UART_IRQ_LS			0x06	// Line Status Interrupt
#define UART_IRQ_RX			0x04	// Data Received or RX FIFO trigger level reached
#define UART_IRQ_TX			0x02	// THR Empty or TX FIFO below trigger level

// Default Register values
#define UART_DEFAULT_RBR	0x00	//00000000b
#define UART_DEFAULT_THR	0x00	//00000000b
#define UART_DEFAULT_IER	0x00	//00000001b
#define UART_DEFAULT_IIR	0x01	//00000001b
#define UART_DEFAULT_FCR	0x01	//00000001b
#define UART_DEFAULT_LCR	(UART_LCR_ODD_PARITY | UART_LCR_WL7)
#define UART_DEFAULT_LSR	0x60	//01100000b

#endif // H_UART_MEMORY_MAP
