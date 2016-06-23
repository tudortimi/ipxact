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
module i2c_shift(
	    clk,
	    rst_an,
	    clear,
	    shift,
	    load,
	    count,
	    serIn,
	    parIn,
	    serOut,
	    parOut
	    );

`include "i2c_defs.v"

   input  clk;
   input  rst_an;
   input  clear;
   input  shift;
   input  load;
   input  serIn;
   input  [7:0] parIn;
   output serOut;
   output [7:0] parOut;
   output [3:0] count;

   wire serOut = parOut[7];
   reg [7:0] nextParOut;
   reg [7:0] parOut;
   reg [7:0] nextCount;
   reg [3:0] count;

   always @ (rst_an or clear or shift or load or count or
             parIn or serIn or parOut) begin

      nextParOut <= parOut;
      nextCount <= count;

      if (!rst_an | clear | load) begin
         nextCount <= 'h0;
      end

      if (load) begin
         nextParOut <= parIn;
      end
      else begin
         if (shift) begin
            nextParOut <= {parOut[6:0],serIn};
            nextCount  <= count + 1;
         end
      end
   end

   always @ (posedge clk) begin
      count  <= #(`tQ) nextCount;
      parOut <= #(`tQ) nextParOut;
   end

endmodule
