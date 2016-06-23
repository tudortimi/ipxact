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
module i2c_rx(
	    clk,
	    rst_an,
	    enable,
	    bitCount,
	    shift,
	    clearShift,
	    active,
	    nAck,
	    count_hold_over,
	    sdaOut_int,
	    toShiftReg,
	    i2ctrans
	    );

`include "i2c_defs.v"

   input  clk;
   input  rst_an;		// reset, active low
   input  enable;		// enable this receive controller
   input  [3:0] bitCount;	// number of bits in shift register
   output shift;		// tell the shift register to shift
   output clearShift;	// reset shift register counter
   output active;		// the I2C bus is actively being used
   output nAck;		// active low byte acknowledge
   input  count_hold_over;// indicates if min. hold is met
   input  sdaOut_int;  //Sda out put placed by module
   output toShiftReg;	// sent to shift register input
   input [`T_BUSSIZE:0] i2ctrans;		// I2C bus transitions



   reg [2:0] state;
   reg [2:0] nextState;
   reg active;
   reg clearShift;
   reg shift;
   reg nAck;

   assign toShiftReg = `T_LASTSDA;

   // Combinational logic
always @ (  state or
	    rst_an or
	    bitCount or
	    i2ctrans or
	    count_hold_over or
	    sdaOut_int or
	    enable) begin

   // default values
   nextState = state;
   shift      = 0;
   active     = 0;
   nAck      = 1;
   clearShift = 0;


   case (state)
      ST_RX_IDLE : begin
	    clearShift = 1;
	    if (`T_START) begin
	       nextState = ST_RX_DATALO;
	       active	 = 1;
	    end
	 end
      ST_RX_DATALO : begin	// SCL is low, shift in new data when it rises
	    active	 = 1;
	    if (count_hold_over) begin 
	       nAck	= 1;
	    end
	    else begin
	       nAck	= sdaOut_int;
	    end
	    if (`T_SCLRISE) begin
	       nextState = ST_RX_DATAHI;
	    end
	    if (bitCount == 'h8) begin
	       nextState = ST_RX_ACKLO;
	    end
	    // If not for us, busy wait
	 end
      ST_RX_DATAHI : begin	// SCL is high wait for it to fall
	    active	 = 1;
	    if (`T_SCLFALL) begin
	       shift  = 1;
	       nextState = ST_RX_DATALO;
	    end
	 end
      ST_RX_ACKLO : begin	// drive SDA low to acknowledge
	    active	= 1;
	       if (count_hold_over) begin 
	         nAck	= !enable;
	       end
	       else begin
	         nAck	= sdaOut_int;
	       end
	    if (`T_SCLRISE) 
	       nextState = ST_RX_ACKHI;
	 end
      ST_RX_ACKHI : begin	// wait for SCL to fall
	 active	= 1;
	 nAck	= 0;
	 if (`T_SCLFALL) begin
	    nextState = ST_RX_DATALO;
	    clearShift = 1;
	    end
	 end
      ST_RX_BUSY : begin	// wait for STOP
	    active	= 1;
	    if (enable) nextState = ST_RX_REENABLE;
	 end
      ST_RX_REENABLE : begin	// wait for STOP
	    active	= 1;
	    clearShift = 1;
	    active	 = 1;
	    if (!`T_SCL) nextState = ST_RX_DATALO;
	 end
   endcase

   // Busy wait if we are disabled between a START and a STOP
   if (!enable & (state != ST_RX_IDLE))
      nextState = ST_RX_BUSY;


   // Idle if we see a STOP condition
   if (`T_STOP) begin
      nextState = ST_RX_IDLE;
      active = 0;
   end

   // Override state if reset
   if (!rst_an)
      nextState = ST_RX_IDLE;
end

// State register
always @ (posedge clk) begin
      state     <= #(`tQ) nextState;
end

endmodule
