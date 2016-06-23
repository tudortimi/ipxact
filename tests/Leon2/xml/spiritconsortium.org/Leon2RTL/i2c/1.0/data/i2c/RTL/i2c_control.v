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
module i2c_control(
	 pclk,
	 rst_an,
	 write,
	 data,
	 control
	 );

`include "i2c_defs.v"

   input  pclk;
   input  rst_an;
   input  write;		// write ain to ctl register
   input  [31:0] data;	        // value to write to ctl register
   output [31:0] control;	// current value of ctl register


   reg [31:0] control;	// ctl register

   always @ (negedge rst_an or posedge pclk) begin
      if (!rst_an)
	 control <= #(`tQ) 32'h0;	// or some other default
      else begin
	 if (write)    // load ctl
	    control <= #(`tQ) data;	// load new value
	 else begin
	    if (control[`CTL_RESET])
	       control[`CTL_RESET] <= #(`tQ) 1'b0;	// always clear soft reset
	 end
      end
   end
endmodule
