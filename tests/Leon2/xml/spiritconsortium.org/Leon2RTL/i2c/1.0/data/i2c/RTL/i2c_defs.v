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


// Clock-to-Q delay for all storage elements:
`define tQ		 1

`define T_RAWSCL        i2ctrans[0]
`define T_RAWSDA        i2ctrans[1]
`define T_SCL           i2ctrans[2]
`define T_SDA           i2ctrans[3]
`define T_LASTSCL       i2ctrans[4]
`define T_LASTSDA       i2ctrans[5]
`define T_SCLRISE       i2ctrans[6]
`define T_SCLFALL       i2ctrans[7]
`define T_SDARISE       i2ctrans[8]
`define T_SDAFALL       i2ctrans[9]
`define T_START         i2ctrans[10]
`define T_STOP          i2ctrans[11]

`define T_BUSSIZE       11

`define STS_TD           0      // transmit done
`define STS_AF           1      // arbitration failure
`define STS_NA           2      // no acknowledge
`define STS_ACTIVE       3      // i2c bus is active
`define STS_SCL          4      // current state of i2c SCL line
`define STS_SDA          5      // current state of i2c SDA line
`define STS_RFF          6      // receive fifo full
`define STS_RFE          7      // receive fifo empty
`define STS_TFF          8      // transmit fifo full
`define STS_TFE          9      // transmit fifo empty

`define CTL_TDIE         0      // transaction done interrupt enable
`define CTL_AFIE         1      // arbitration failure interrupt enable
`define CTL_NAIE         2      // no acknowledge interrupt enable
`define CTL_RESET        3      // soft reset

// Address registers
parameter
   DM_RXDATA    = 12'h0,   // For a read
   DM_TXDATA    = 12'h0,   // For a write
   DM_STATUS    = 12'h4,
   DM_CONTROL   = 12'h8,
   DM_CLKDIVHI  = 12'hC,
   DM_CLKDIVLO  = 12'h10,
   DM_ID        = 12'hFFC;

parameter
   ST_M_IDLE        = 5'h0,
   ST_M_START       = 5'h1,
   ST_M_ADRLO       = 5'h2,
   ST_M_ADRHI1      = 5'h3,
   ST_M_ADRHI2      = 5'h4,
   ST_M_CLKLO       = 5'h5,
   ST_M_CLKHI1      = 5'h6,
   ST_M_CLKHI2      = 5'h7,
   ST_M_LASTRDLO    = 5'h8,
   ST_M_LASTRDHI1   = 5'h9,
   ST_M_LASTRDHI2   = 5'ha,
   ST_M_STOP1       = 5'hb,
   ST_M_STOP2       = 5'hc,
   ST_M_STOP3       = 5'hd,
   ST_M_RESTART1    = 5'he,
   ST_M_RESTART2    = 5'hf,
   ST_M_DATAREQ     = 5'h10,
   ST_M_DATAFULL    = 5'h11;

parameter
   ST_S_IDLE        = 4'h0,
   ST_S_START       = 4'h1,
   ST_S_ADR1        = 4'h2,
   ST_S_ADR1ACK     = 4'h3,
   ST_S_ADR2        = 4'h4,
   ST_S_ADR2ACK     = 4'h5,
   ST_S_WRITE       = 4'h6,
   ST_S_READ        = 4'h7,
   ST_S_READ2       = 4'h8,
   ST_S_READREQ     = 4'h9,
   ST_S_READREQ2    = 4'ha,
   ST_S_BUSY        = 4'hb;

parameter
   ST_RX_IDLE   = 3'h0,
   ST_RX_DATALO = 3'h1,
   ST_RX_DATAHI = 3'h2,
   ST_RX_ACKLO  = 3'h3,
   ST_RX_ACKHI  = 3'h4,
   ST_RX_BUSY   = 3'h5,
   ST_RX_REENABLE = 3'h6;

parameter
   ST_TX_IDLE	= 4'h0,
   ST_TX_CLKHI	= 4'h1,
   ST_TX_CLKLO	= 4'h2,
   ST_TX_ACK1	= 4'h3,
   ST_TX_ACKLO	= 4'h4,
   ST_TX_ACKHI	= 4'h5;
