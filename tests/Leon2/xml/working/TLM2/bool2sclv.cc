/*******************************************************************************
 *                      SPIRIT 1.4 OSCI-TLM-PV example
 *------------------------------------------------------------------------------
 * Simple Leon2 TLM Design main
 *------------------------------------------------------------------------------
 * Revision: 1.0
 * Authors:  SWG
 * Description: conversion function from bool to sc_logic
 * 
 * Revision:    $Revision: 1506 $
 * Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
 * 
 * Copyright (c) 2007, 2008, 2009 The SPIRIT Consortium.
 * 
 * This work forms part of a deliverable of The SPIRIT Consortium.
 * 
 * Use of these materials are governed by the legal terms and conditions
 * outlined in the disclaimer available from www.spiritconsortium.org.
 * 
 * This source file is provided on an AS IS basis.  The SPIRIT
 * Consortium disclaims any warranty express or implied including
 * any warranty of merchantability and fitness for use for a
 * particular purpose.
 * 
 * The user of the source file shall indemnify and hold The SPIRIT
 * Consortium and its members harmless from any damages or liability.
 * Users are requested to provide feedback to The SPIRIT Consortium
 * using either mailto:feedback@lists.spiritconsortium.org or the forms at 
 * http://www.spiritconsortium.org/about/contact_us/
 * 
 * This file may be copied, and distributed, with or without
 * modifications; but this notice must be included on any copy.
 *******************************************************************************/

#include "bool2sclv.h"

/*------------------------------------------------------------------------------
 * Methods
 *----------------------------------------------------------------------------*/
bool2sclv::bool2sclv( sc_module_name module_name) :
  sc_module( module_name ) , 
  inbool ("inbool"),
  outsclv ("outsclv")
{
  SC_METHOD( conv );
  sensitive << inbool;
}

void bool2sclv::conv()
{
  outsclv.write(inbool==true?SC_LOGIC_1:SC_LOGIC_0);
  cout << name() << ": bool2sclv value=" << inbool << " at time " << sc_time_stamp() << endl;
}


