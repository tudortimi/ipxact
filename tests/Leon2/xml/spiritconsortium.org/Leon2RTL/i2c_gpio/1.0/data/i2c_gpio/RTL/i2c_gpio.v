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

// A GPIO module on I2C that does NOT use an address in the first byte of
// data. 
// 
//
// Write byte 0 = GP output register
// Read byte 0 = GP input register
// Read byte 1 = GP output register


`define DEBUG 1
`define I2CDELAY 300
`timescale 1ns/100ps

module i2c_gpio(
	sda,		// serial bus data
	scl,		// serial bus clock
	address,        // i2c device address
	gpi,            // general purpose input
	gpo             // general purpose output
	);

parameter gpibits = 4;      // range from 1-8
parameter gpobits = 4;      // range from 1-8

inout	sda;		// data - input from sda pin
input	scl;		// clock - input from scl pin
input [9:0]  address;	// address
input [gpibits-1:0]  gpi;	// 
output [gpobits-1:0] gpo;	// 


// States
parameter
   StIdle	= 4'h0,
   StAdr	= 4'h1,
   StAckAdr	= 4'h2,
   StAdr2	= 4'h3,
   StAckAdr2	= 4'h4,
   StRead	= 4'h7,
   StAckRead	= 4'h8,
   StWriteData	= 4'h9,
   StAckWriteData	= 4'hA,
   StBusBusy	= 4'hB;

reg active;		// between start and stop
reg sdaOut;		// data - enable to open collector output

reg [2:0] count;     	// bit counter for shifting
reg [2:0] nextCount;    //

reg [3:0] state;	// current state
reg [3:0] nextState;	// next state

reg [7:0] shiftReg;	// shiftRegister
reg [1:0] adr98;	// bits 9 and 8 of 10 bit address
reg [9:0] i2caddress;	// Full I2C address.
reg readFlag;		// is a read operation, bit 0 for first address byte
reg [7:0] gpoReg;	// Output holding register

initial begin
  gpoReg = 0;
  active = 0;
  state = StIdle;
  sdaOut = 1;
end

// assign the outputs from the gpoReg location
assign gpo = gpoReg;

// Buffer to drive the acknowledge
bufif0 buf1 (sda, 1'b0, sdaOut);
pullup (sda);
pullup (scl);

always @ (posedge sda) begin
   if (scl) begin
      active = 0;		// stop condition
      state = StIdle;
   end
      else active = active;
end

always @ (negedge sda) begin
   if (scl) begin
      active = 1;		// start condition
      count = 3'h7;
      state = StIdle;
   end
      else active = active;
end

// Logic clocked by scl
always @ (scl) begin
  // default outputs
  nextCount = count;
  nextState = state;
  sdaOut = sdaOut;

  // Rising clock comes first then falling clock in a state.
  case (state)
     StIdle : begin
	if (active && scl) nextState = StAdr;      // rising clock
     end

     StBusBusy : begin
	if (!active) nextState = StIdle;
     end

     StAdr : begin
	if (active && !scl) begin		// falling clock
	   shiftReg = { shiftReg[6:0], sda};
	   if (count == 0) begin

	      i2caddress = {3'b000,shiftReg[7:1]};
	      readFlag = shiftReg[0];

	      if (shiftReg[7:3] == 'b11110 && shiftReg[0] == 0) begin
		 $display("### %t i2c_gpio waiting for 2nd half of 10-bit address", $realtime);
		 adr98 = shiftReg[2:1];
		 nextState = StAckAdr;
	      end
	      else begin

		if (`DEBUG > 0) begin
		   $display("### %t i2c_gpio received i2c 7-bit address is 0x%x , my adddress is 0x%x", $realtime, i2caddress,address);
		end

		if (i2caddress == address) begin
		  nextState = StAckAdr2;
		  sdaOut = #(`I2CDELAY) 0;
		end
		else begin
		  nextState = StBusBusy;
	        end
	      end
	   end
	   else begin
	      nextCount = count - 1;
	   end
	end
     end

     StAckAdr : begin
	if (active && !scl) begin
	      sdaOut = #(`I2CDELAY) 1;
	      nextCount = 3'h7;
	      nextState = StAdr2;
	end
     end

     StAdr2 : begin
	if (active && !scl) begin		// falling clock
	   shiftReg = { shiftReg[6:0], sda};
	   if (count == 0) begin

	      i2caddress = {adr98,shiftReg};

	      if (`DEBUG > 0) begin
		 $display("### %t i2c_gpio received i2c 10-bit address is 0x%x , my address is 0x%x", $realtime, i2caddress,address);
              end
	      if (i2caddress == address) begin
		nextState = StAckAdr2;
		sdaOut = #(`I2CDELAY) 0;
	      end
	      else begin
		nextState = StBusBusy;
	      end
	   end
	   else begin
	      nextCount = count - 1;
	   end
	end
     end

     StAckAdr2 : begin
	if (active && !scl) begin
	      sdaOut = #(`I2CDELAY) 1;
	      nextCount = 3'h7;
	      if (readFlag) begin
		nextState = StRead;
		shiftReg = gpi;
		sdaOut = #(`I2CDELAY) shiftReg[7];
	      end
	      else begin
		nextState = StWriteData;
	      end
	end
     end


     StRead : begin
	if (active && !scl) begin		// falling clock
	      if (count == 0) begin
		 nextState = StAckRead;
		 sdaOut = #(`I2CDELAY) 1;
	      end
	      else begin
		 sdaOut = #(`I2CDELAY) shiftReg[7];
		 nextCount = count - 1;
	      end
	end
	if (active && scl) begin		// rising clock
	    shiftReg = {shiftReg[6:0], 1'b0};
	end
     end

     StAckRead : begin
	if (active && scl) begin		// rising clock
	   if (sda)	begin			// no acknowledge
	      if (`DEBUG > 0 )
		$display("### %t i2c_gpio sent 0x%x, but not acknowledged, last byte", $realtime, shiftReg);
	      nextCount = 3'h7;
	      nextState = StIdle;
	   end
	   else begin
	     if (`DEBUG > 0) 
		$display("### %t i2c_gpio sent 0x%x", $realtime, shiftReg);
	   end
	end
	if (active && !scl) begin		// falling clock
//	      $display("### %t i2c dummy slave sent %x", $realtime, shiftReg);
	      shiftReg = gpoReg;
	      sdaOut = #(`I2CDELAY) shiftReg[7];
	      nextCount = 3'h7;
	      nextState = StRead;
	end
     end

     StWriteData : begin
	if (active && !scl) begin		// falling clock
	      shiftReg = {shiftReg[6:0], sda};
	      if (count == 0) begin
		 nextState = StAckWriteData;
		 sdaOut = #(`I2CDELAY) 0;
	      end
	      else begin
		 nextCount = count - 1;
	      end
	end
     end

     StAckWriteData : begin
	if (active && !scl) begin		// falling clock
	      sdaOut = #(`I2CDELAY) 1;
	      gpoReg = shiftReg;
	      if (`DEBUG > 0) 
		 $display("### %t i2c_gpio received 0x%x", $realtime, shiftReg);
	      nextCount = 3'h7;
	      nextState = StWriteData;
	end
     end

     default : begin
       nextState = StIdle;
     end
  endcase

  state = nextState;
  count = nextCount;
end
   
endmodule 
