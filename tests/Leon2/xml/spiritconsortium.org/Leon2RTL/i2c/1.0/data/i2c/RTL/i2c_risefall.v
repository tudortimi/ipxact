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
module i2c_risefall(
	       clk,
	       rst_an,
	       dIn,
	       dReg,
	       dOut,
	       lohi,
	       hilo
	       );

`include "i2c_defs.v"

input  clk;  	// system clock
input  rst_an;	// system reset, active low
input  dIn;  	// serial data in
output dReg;	// serial data registered
output dOut;	// serial data registered twice
output lohi;	// 0 to 1 transition detected
output hilo;	// 1 to 0 transition detected

wire next_dOut;
wire next_dReg;
reg dRegInt;
reg dOutInt;

reg [3:0] shfreg;
reg [3:0] next_shfreg;
wire inOr;
wire inAnd;

assign dReg      = dRegInt;
assign dOut      = dOutInt;
assign lohi      =  dRegInt & !dOutInt;
assign hilo      = !dRegInt &  dOutInt;
assign inAnd     = shfreg[3] & shfreg[2] & shfreg[1] & shfreg[0];
assign inOr      = shfreg[3] | shfreg[2] | shfreg[1] | shfreg[0];
assign next_dReg = ~rst_an | inAnd | (inOr & dRegInt);
assign next_dOut = ~rst_an | dRegInt;

always @ (rst_an or dIn or shfreg) begin
   if (!rst_an) begin
      next_shfreg <= 'hf;
   end
   else begin
      next_shfreg <= {shfreg[2:0], dIn};
   end
end

always @ (posedge clk) begin
   dOutInt <= #(`tQ) next_dOut;
   dRegInt <= #(`tQ) next_dReg;
   shfreg <= #(`tQ) next_shfreg;
end
endmodule
