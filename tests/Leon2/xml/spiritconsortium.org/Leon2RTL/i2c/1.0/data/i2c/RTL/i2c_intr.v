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
module i2c_intr(
	    status,
	    control,
	    interrupt
	    );

`include "i2c_defs.v"

input  [9:0] status;
input  [31:0] control;
output interrupt;

wire interrupt;

//assign Interrupt =  intr;
assign interrupt = (status[`STS_TD]  & control[`CTL_TDIE])
		   | (status[`STS_AF]  & control[`CTL_AFIE])
		   | (status[`STS_NA]  & control[`CTL_NAIE])
		   ;
endmodule
