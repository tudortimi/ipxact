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
// I2C channel for 1 master and 1 slaves module

`timescale 1ns/100ps

module i2c_channel_1m_1s (

// I2C Ports mirrored master
  scl_m1,
  sda_m1,

// I2C Ports mirrored slaves
  scl_s1,
  sda_s1
);

//===========================
// input/output declarations
//===========================

// I2C Ports mirrored master
inout  scl_m1;
inout  sda_m1;

// I2C Ports mirrored slave
inout scl_s1;
inout sda_s1;


// pullups inside the channel
tri1 scl;
tri1 sda;

tran (scl, scl_m1);
tran (scl, scl_s1);

tran (sda, sda_m1);
tran (sda, sda_s1);

endmodule
