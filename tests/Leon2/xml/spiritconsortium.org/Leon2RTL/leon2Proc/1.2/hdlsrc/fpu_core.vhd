-- ****************************************************************************
-- ** Leon 2 code
-- ** 
-- ** Revision:    $Revision: 1506 $
-- ** Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- ** 
-- ** Copyright (c) 2008, 2009 The SPIRIT Consortium.
-- ** 
-- ** This work forms part of a deliverable of The SPIRIT Consortium.
-- ** 
-- ** Use of these materials are governed by the legal terms and conditions
-- ** outlined in the disclaimer available from www.spiritconsortium.org.
-- ** 
-- ** This source file is provided on an AS IS basis.  The SPIRIT
-- ** Consortium disclaims any warranty express or implied including
-- ** any warranty of merchantability and fitness for use for a
-- ** particular purpose.
-- ** 
-- ** The user of the source file shall indemnify and hold The SPIRIT
-- ** Consortium and its members harmless from any damages or liability.
-- ** Users are requested to provide feedback to The SPIRIT Consortium
-- ** using either mailto:feedback@lists.spiritconsortium.org or the forms at 
-- ** http://www.spiritconsortium.org/about/contact_us/
-- ** 
-- ** This file may be copied, and distributed, with or without
-- ** modifications; this notice must be included on any copy.
-- ****************************************************************************
-- Derived from European Space Agency (ESA) code as described below

----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------
-- Entity: 	fpu_core
-- File:	fpu_core.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	Wrapper around Meiko compatible FPU cores
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

use work.target.all;
use work.config.all;
use work.iface.all;
use work.fpulib.all;

entity fpu_core is
port (
    clk    : in  clk_type;			-- main clock	
    fpui   : in  fpu_in_type;
    fpuo   : out fpu_out_type
  );
end;

architecture rtl of fpu_core is
begin

  meiko0 : if FPCORE = meiko generate
    fpu0 : fpu port map (
    ss_clock   => clk,
    FpInst     => fpui.FpInst, 
    FpOp       => fpui.fpop, 
    FpLd       => fpui.FpLd, 
    Reset      => fpui.reset, 
    fprf_dout1 => fpui.fprf_dout1, 
    fprf_dout2 => fpui.fprf_dout2, 
    RoundingMode => fpui.RoundingMode, 
    FpBusy    => fpuo.FpBusy,
    FracResult => fpuo.FracResult,
    ExpResult  => fpuo.ExpResult,
    SignResult => fpuo.SignResult,
    SNnotDB    => fpuo.SNnotDB,
    Excep      => fpuo.Excep,
    ConditionCodes => fpuo.ConditionCodes,
    ss_scan_mode => fpui.ss_scan_mode,
    fp_ctl_scan_in => fpui.fp_ctl_scan_in,
    fp_ctl_scan_out => fpuo.fp_ctl_scan_out
   );
  end generate;

  lth0 : if FPCORE = lth generate
    fpu0 : fpu_lth port map (

    ss_clock   => clk,

    FpInst     => fpui.FpInst, 
    FpOp       => fpui.fpop, 
    FpLd       => fpui.FpLd, 
    Reset      => fpui.reset, 
    fprf_dout1 => fpui.fprf_dout1, 
    fprf_dout2 => fpui.fprf_dout2, 
    RoundingMode => fpui.RoundingMode, 
    FpBusy    => fpuo.FpBusy,
    FracResult => fpuo.FracResult,
    ExpResult  => fpuo.ExpResult,
    SignResult => fpuo.SignResult,
    SNnotDB    => fpuo.SNnotDB,
    Excep      => fpuo.Excep,
    ConditionCodes => fpuo.ConditionCodes,
    ss_scan_mode => fpui.ss_scan_mode,
    fp_ctl_scan_in => fpui.fp_ctl_scan_in,
    fp_ctl_scan_out => fpuo.fp_ctl_scan_out
   );
  end generate;

end;


