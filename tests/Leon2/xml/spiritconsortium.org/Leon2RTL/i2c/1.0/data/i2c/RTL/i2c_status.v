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
module i2c_status(
		     clk,
		     rst_an,
		     di,
		     write,
		     RxEmpty,
		     RxFull,
		     TxEmpty,
		     TxFull,
		     setDone,
		     setNoAck,
		     clearNoAck,
		     setArbFail,
		     active,
		     scl,
		     sda,
		     status
		     );

`include "i2c_defs.v"

   input  clk;
   input  rst_an;
   input  [1:0] di;
   input  write;
   input  RxEmpty;
   input  RxFull;
   input  TxEmpty;
   input  TxFull;
   input  setDone;
   input  setNoAck;
   input  clearNoAck;
   input  setArbFail;
   input  active;
   input  scl;
   input  sda;
   output [9:0] status;	// current value of sts register

   reg  Done;
   wire nextDone;
   reg  NoAck;
   wire nextNoAck;
   reg  ArbFail;
   wire nextArbFail;

   assign status[`STS_TD]  = Done;
   assign status[`STS_NA]  = NoAck;
   assign status[`STS_AF]  = ArbFail;
   assign status[`STS_ACTIVE] = active;
   assign status[`STS_SCL] = scl;
   assign status[`STS_SDA] = sda;
   assign status[`STS_RFF] = RxFull;
   assign status[`STS_RFE] = RxEmpty;
   assign status[`STS_TFF] = TxFull;
   assign status[`STS_TFE] = TxEmpty;

   assign nextNoAck         = (NoAck | setNoAck);
   assign nextDone          = (Done | setDone);
   assign nextArbFail       = (ArbFail | setArbFail);
//   assign nextDone          = (Done | setDone) & ~(write & di[0]);
//   assign nextArbFail       = (ArbFail | setArbFail) & ~(write & di[1]);

   always @ (posedge clk or posedge clearNoAck) begin
      if (clearNoAck) begin		// asynchronous reset
	NoAck         <= #(`tQ) 0;
      end
      else 
      begin
	if (!rst_an) begin		// synchronous reset
	  NoAck         <= #(`tQ) 0;
	end
	else begin
	  NoAck         <= #(`tQ) nextNoAck;
	end
      end
   end

   always @ (posedge clk or posedge write) begin
      if (write) begin		// asynchronous reset
	Done         <= #(`tQ) Done & ~di[0];
      end
      else 
      begin
	if (!rst_an) begin		// synchronous reset
	  Done         <= #(`tQ) 0;
	end
	else begin
	  Done         <= #(`tQ) nextDone;
	end
      end
   end

   always @ (posedge clk or posedge write) begin
      if (write) begin		// asynchronous reset
	ArbFail         <= #(`tQ) ArbFail & ~di[1];
      end
      else 
      begin
	if (!rst_an) begin		// synchronous reset
	  ArbFail         <= #(`tQ) 0;
	end
	else begin
	  ArbFail         <= #(`tQ) nextArbFail;
	end
      end
   end

endmodule
