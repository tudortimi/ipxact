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


// SIMPLE APB MEMORY EXAMPLE. Size = 4K - 4 bytes 
//
// read only ID register at 0xFFC = 0x00000D08


`timescale 1ns/100ps
`define tQ 1ns

module rgu (
      pclk,
      presetn,
      paddr,
      pwrite,
      penable,
      psel,
      pwdata,
      prdata
      );

parameter MEMORYDEPTH = 1023; // memory depth

input  pclk;
input  presetn;
input  [11:0]  paddr;
input  psel;
input  penable;
input  pwrite;
input [31:0]  pwdata;
output [31:0]  prdata;


reg [31:0] memory [MEMORYDEPTH-1:0];	// memory
reg [9:0] addr;
reg [31:0] prdata;

integer i;

   always @ (presetn or posedge clk) begin
     if (!presetn) begin
       for (i=0; i < MEMORYDEPTH; i=i+1)
	 memory[i] = 0;
     end
     else begin
       addr = paddr >> 2;
       if (pwrite && penable && psel && addr < MEMORYDEPTH)  // Memory Write
         memory[addr] = pwdata;
       if (!pwrite && penable && psel && addr < MEMORYDEPTH) // Memory Read
         prdata <= #(`tQ) memory[addr];
       if (!pwrite && penable && psel && addr == MEMORYDEPTH) // ID register
         prdata <= #(`tQ) 8'hD08;
     end
   end


endmodule

