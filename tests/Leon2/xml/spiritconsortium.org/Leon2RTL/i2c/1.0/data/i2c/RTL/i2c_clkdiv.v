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
module i2c_clkdiv(
	       clk,
	       ip_clk,
	       rst_an,
	       writeHi,
	       writeLo,
	       data,
	       load,
	       loadValHi,
	       loadValLo,
	       zero
	       );

`include "i2c_defs.v"

   input  clk;
   input  ip_clk;
   input  rst_an;
   input  writeHi;	//write new data to startValHi
   input  writeLo;	//write new data to startValLo
   input  [5:0] data;	//new initial value for countdown timer from DTL bus
   input  [1:0] load;		//write startVal to counter, bit 1 high count, bit 0 low count
   output [5:0] loadValHi;	//current high time clock divider value
   output [5:0] loadValLo;	//current low time clock divider value
   output zero;		//counter has reached zero


   reg  [5:0] startValHi;	//start value for high time countdown timer
   reg  [5:0] startValLo;	//start value for low time countdown timer
   reg  [5:0] nextStartValHi;	//next start value for high time countdown timer
   reg  [5:0] nextStartValLo;	//next start value for low time countdown timer
   wire enable;
   wire [5:0] tloadVal;	//selected high-low clock divider value
   wire loadOr;

   assign enable  = !zero;	// freeze counter when we reach zero
   assign loadValHi = startValHi;
   assign loadValLo = startValLo;
   assign tloadVal = (load[0]) ? startValLo : startValHi ;
   assign loadOr  = load[1] | load[0];


   i2c_clkcnt cntr (
                 .clk(ip_clk),		// Clock Input
                 .rst_an(rst_an),		// Asynchronous Reset Input
                 .load(loadOr),		// Load Control Input
                 .datain(tloadVal),	// Data Input
                 .cen(enable),		// Count Enable Input
                 .q(),         		// counter output (not used)
                 .tci(zero));		// Terminal Count Indicator

   always @ (writeHi or data or startValHi) begin
      if (writeHi == 1) nextStartValHi = data;
      else            nextStartValHi = startValHi;
   end

   always @ (writeLo or data or startValLo) begin
      if (writeLo == 1) nextStartValLo = data;
      else            nextStartValLo = startValLo;
   end

   always @ (negedge rst_an or posedge clk) begin
      if (!rst_an) begin
	 startValHi <= #(`tQ) 6'h30;	// or some other default
	 startValLo <= #(`tQ) 6'h30;	// or some other default
	 end
      else begin
	 startValHi <= #(`tQ) nextStartValHi;
	 startValLo <= #(`tQ) nextStartValLo;
	 end
      end
endmodule
