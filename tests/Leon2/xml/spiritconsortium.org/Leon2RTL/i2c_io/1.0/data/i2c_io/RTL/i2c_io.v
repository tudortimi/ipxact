`timescale 1ns/100ps
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
//
// I2C IO module

module i2c_io (

// I2C Ports at IOs
  scl,
  sda,

// I2C Ports from IP
  scl_in,
  scl_out,
  scl_oen,
  sda_in,
  sda_out,
  sda_oen
);

//===========================
// input/output declarations
//===========================

// I2C Ports at IOs
inout  scl;
inout  sda;

// I2C Ports from IP
output scl_in;
input  scl_out;
input  scl_oen;
output sda_in;
input  sda_out;
input  sda_oen;

pullup (scl);
pullup (sda);

buf bufinscl (scl_in , scl);
bufif0 bufscl (scl, scl_out, scl_oen);

buf bufinsda (sda_in , sda);
bufif0 bufsda (sda, sda_out, sda_oen);


endmodule
