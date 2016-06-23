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
module i2c_apb_write_decode(
                     psel,
                     pwrite,
                     penable,
		     paddr,
		     txDataWrite,
		     statusWrite,
		     controlWrite,
                     clkdivhiWrite,
                     clkdivloWrite
		     );

`include "i2c_defs.v"

   input  psel;   		// Select data
   input  pwrite;   		
   input  penable;   		
   input  [11:0] paddr;		// Address
   output txDataWrite;		// Write enable for tx FIFO
   output statusWrite;		// Write enable for status register
   output controlWrite;		// Write enable for control register
   output clkdivhiWrite;	// Write enable clock high time divider
   output clkdivloWrite;	// Write enable clock low time divider


   reg [31:0] nextDataOut;
   reg txDataWrite;
   reg statusWrite;
   reg controlWrite;
   reg clkdivhiWrite;
   reg clkdivloWrite;

   assign dOut = nextDataOut;

   always @ (psel or pwrite or penable or paddr)
   begin

    txDataWrite = 1'b0;
    statusWrite = 1'b0;
    controlWrite = 1'b0;
    clkdivhiWrite = 1'b0;
    clkdivloWrite = 1'b0;

    if (psel == 1'b1 & pwrite == 1'b1 & penable == 1'b1)
    begin
      case (paddr)
	 DM_RXDATA : begin
	     txDataWrite = 1'b1;
	    end
	 DM_STATUS : begin
	     statusWrite = 1'b1;
	    end
	 DM_CONTROL : begin
	     controlWrite = 1'b1;
	    end
	 DM_CLKDIVHI : begin
	     clkdivhiWrite = 1'b1;
	    end
	 DM_CLKDIVLO : begin
	     clkdivloWrite = 1'b1;
	    end
      endcase
    end
   end

endmodule
