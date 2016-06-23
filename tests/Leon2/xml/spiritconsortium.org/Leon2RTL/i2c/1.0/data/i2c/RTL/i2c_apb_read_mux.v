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
module i2c_apb_read_mux(
		     dOut,
                     psel,
		     paddr,
		     rxData,
		     status,
		     control,
                     clkdivhi,
                     clkdivlo,
                     id
		     );

`include "i2c_defs.v"

   output [31:0] dOut;		// Output data
   input  psel;   		// Select data
   input  [11:0] paddr;		// Address
   input  [7:0] rxData;		// Top of Rx FIFO, oldest data
   input  [9:0] status;		// I2C status register
   input  [31:0] control;	// I2C control register
   input  [5:0] clkdivhi;	// I2C SCL high time clock divider value
   input  [5:0] clkdivlo;	// I2C SCL low time clock divider value
   input  [31:0] id;	        // I2C module ID



   reg [31:0] nextDataOut;

   assign dOut = nextDataOut;

   always @ (psel or paddr or rxData or status or control
	     or clkdivhi or clkdivlo
	    )
   begin
    if (psel == 1'b1)
    begin
      case (paddr)
	 DM_RXDATA : begin
	    nextDataOut = { 24'h0, rxData};
	    end
	 DM_STATUS : begin
	    nextDataOut = { 22'h0, status};
	    end
	 DM_CONTROL : begin
	    nextDataOut = {control};
	    end
	 DM_CLKDIVHI : begin
	    nextDataOut = { 26'h0, clkdivhi};
	    end
	 DM_CLKDIVLO : begin
	    nextDataOut = { 26'h0, clkdivlo};
	    end
	 DM_ID : begin
	    nextDataOut = {id};
	    end
	 default : begin
	    nextDataOut = 32'b0;
	    end
      endcase
    end
    else
    begin
      nextDataOut = 32'b0;
    end
   end

endmodule
