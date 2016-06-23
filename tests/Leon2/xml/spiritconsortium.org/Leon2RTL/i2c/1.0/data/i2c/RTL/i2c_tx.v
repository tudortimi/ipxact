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
module i2c_tx(
	       clk,
	       rst_an,
	       enable,
	       bitCount,
	       sdaOut,
	       sdaOut_int,
	       count_hold_over,
	       shift,
	       clearShift,
	       fromShiftReg,
	       setArbFail,
	       i2ctrans
	       );

`include "i2c_defs.v"

input  clk;
input  rst_an;
input  enable;		// transmit enable from slave or master controller
input  [3:0] bitCount;	// number of bits in shift register
output sdaOut;		// value to place on I2C data line
input  sdaOut_int;	// value to be placed on I2C data line
output count_hold_over;	// indicated min. hold time counter is overrun
output shift;		// tell the shift register to shift
output clearShift;      // reset shift register counter
input  fromShiftReg;	// serial out from shift register
input  [`T_BUSSIZE:0] i2ctrans;		// I2C bus transitions
output setArbFail;	// set arbitration failure bit in status register

reg [3:0] state;
reg [3:0] nextState;
reg shift;
reg clearShift;
reg sdaOut;
reg setArbFail;
reg lastActive;
reg sdaOut_previous;
integer counter_hold;
reg count_hold_over;

always @ (posedge  clk) begin
    // default values
    if (~rst_an) begin
   counter_hold      <= #(`tQ) 0;
   count_hold_over   <= #(`tQ) 0;
   sdaOut_previous   <= #(`tQ) 1;
   end
   else begin
    if (`T_RAWSCL) begin
   count_hold_over   <= #(`tQ) 0;
   sdaOut_previous   <= #(`tQ) sdaOut_int;
   end
    if (~`T_RAWSCL & ~count_hold_over) begin
   counter_hold      <= #(`tQ) counter_hold + 1;
end
    if (counter_hold == 2) begin 

   counter_hold      <= #(`tQ) 0;
   count_hold_over   <= #(`tQ) 1;
   sdaOut_previous   <= #(`tQ) sdaOut_int;
end    
end    
end 

// Combinational logic
always @ (  state or
	    rst_an or
	    bitCount or
	    i2ctrans or
	    enable or
	    fromShiftReg or
	    lastActive or
	    count_hold_over or
	    sdaOut_previous
	    ) begin
   // default values
   nextState	= state;
   shift	= 0;
   clearShift	= 0;
   sdaOut	= 1;
   setArbFail	= 0;


   case (state)
      //NOTE:  this assumes I am not enabled until START condition is seen
      //       the enable comes from the master or slave controller
      ST_TX_IDLE : begin
	    if (enable)
	       sdaOut = fromShiftReg;
	    if (!`T_SCL)
	       nextState = ST_TX_CLKLO;
	 end
      ST_TX_CLKLO : begin
           if (!count_hold_over) begin
	    sdaOut = sdaOut_previous;
	    end
	   else begin
	    sdaOut = fromShiftReg;
	    end
	    if (`T_SCLRISE) begin
		  if (`T_SDA != sdaOut) begin
                     setArbFail = 1;
		     nextState = ST_TX_IDLE;
		  end
		  else
		     nextState = ST_TX_CLKHI;
	    end
	 end
      ST_TX_CLKHI : begin
	    sdaOut = fromShiftReg;
	    if (`T_SCLFALL) begin
	       shift = 1;
	       if (bitCount == 'h7)
		  nextState = ST_TX_ACKLO;
	       else
		  nextState = ST_TX_CLKLO;
	    end
	 end
      ST_TX_ACKLO : begin
	    if (`T_SCLRISE) begin
	       nextState = ST_TX_ACKHI;
	    end
	 end
      ST_TX_ACKHI : begin
	    if (!`T_SCL) begin
	       clearShift = 1;
	       nextState = ST_TX_CLKLO;
	    end
	 end
   endcase

   if (`T_STOP | !rst_an | !enable) nextState = ST_TX_IDLE;
end

// State register
always @ (posedge clk) begin
   state      <= #(`tQ) nextState;
end

endmodule
