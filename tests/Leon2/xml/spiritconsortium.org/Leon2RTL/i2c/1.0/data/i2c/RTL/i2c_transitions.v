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



`timescale 1ns/100ps
module i2c_transitions(
	       clk,
	       rst_an,
	       rawScl,
	       rawSda,
	       i2ctrans
	       );

`include "i2c_defs.v"

   input  clk;  		// system clock
   input  rst_an;		// system reset, active low
   input  rawScl;		// from external I2C SCL line (clock)
   input  rawSda;		// from external I2C SDA line (data)
   output [`T_BUSSIZE:0] i2ctrans; // I2C bus transitions

   assign `T_START = `T_SCL & `T_LASTSCL & `T_SDAFALL;
   assign `T_STOP  = `T_SCL & `T_LASTSCL & `T_SDARISE;
   assign `T_RAWSCL  = rawScl;
   assign `T_RAWSDA  = rawSda;

   i2c_risefall scl_trans(
	 .clk(clk),
	 .rst_an(rst_an),
	 .dIn(rawScl),
	 .dReg(`T_SCL),
	 .dOut(`T_LASTSCL),
	 .lohi(`T_SCLRISE),
	 .hilo(`T_SCLFALL)
      );

   i2c_risefall sda_trans(
	 .clk(clk),
	 .rst_an(rst_an),
	 .dIn(rawSda),
	 .dReg(`T_SDA),
	 .dOut(`T_LASTSDA),
	 .lohi(`T_SDARISE),
	 .hilo(`T_SDAFALL)
      );

endmodule
