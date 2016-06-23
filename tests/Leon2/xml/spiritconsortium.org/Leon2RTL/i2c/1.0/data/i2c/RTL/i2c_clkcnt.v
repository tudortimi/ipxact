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
module i2c_clkcnt (
                           clk,
                           rst_an,
                           load,
                           datain,
                           cen,
                           q,
                           tci);

   input        clk;
   input        rst_an;
   input        load;
   input  [5:0] datain;
   input        cen;
   output [5:0] q;
   output       tci;


   parameter areset_value = 6'b000000;
   parameter maxval = 6'b111111;
   parameter minval = 6'b000000;

   reg [5:0] q;
   wire tci;

   always @(posedge clk or negedge rst_an)
   begin
      if (~rst_an)
         q <= areset_value;
      else if (load)
         q <= datain;
      else if (cen)
         q <= ((q <= minval || q >= maxval) && &(~q | minval)) ? maxval : (q-1);
   end

   assign tci = (q == minval);

endmodule // i2c_clkcnt
