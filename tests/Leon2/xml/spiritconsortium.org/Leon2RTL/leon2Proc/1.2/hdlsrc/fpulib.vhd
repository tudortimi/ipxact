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
-- Entity: 	fpulib
-- File:	fpulib.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	component declarations for FPU related modules
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package fpulib is

-- meiko core

component fpu 
  port (
    ss_clock   : in  clk_type;
    FpInst     : in  std_logic_vector(9 downto 0);
    FpOp       : in  std_logic;
    FpLd       : in  std_logic;
    Reset      : in  std_logic;
    fprf_dout1 : in  std_logic_vector(63 downto 0);
    fprf_dout2 : in  std_logic_vector(63 downto 0);
    RoundingMode : in  std_logic_vector(1 downto 0);
    FpBusy     : out std_logic;
    FracResult : out std_logic_vector(54 downto 3);
    ExpResult  : out std_logic_vector(10 downto 0);
    SignResult : out std_logic;
    SNnotDB    : out std_logic;
    Excep      : out std_logic_vector(5 downto 0);
    ConditionCodes : out std_logic_vector(1 downto 0);
    ss_scan_mode : in  std_logic;
    fp_ctl_scan_in : in  std_logic;
    fp_ctl_scan_out : out std_logic
  );
end component;

-- Martin Kasprzyk core

component fpu_lth 
  port (
    ss_clock   : in  std_logic;
    FpInst     : in  std_logic_vector(9 downto 0);
    FpOp       : in  std_logic;
    FpLd       : in  std_logic;
    Reset      : in  std_logic;
    fprf_dout1 : in  std_logic_vector(63 downto 0);
    fprf_dout2 : in  std_logic_vector(63 downto 0);
    RoundingMode : in  std_logic_vector(1 downto 0);
    FpBusy     : out std_logic;
    FracResult : out std_logic_vector(54 downto 3);
    ExpResult  : out std_logic_vector(10 downto 0);
    SignResult : out std_logic;
    SNnotDB    : out std_logic;
    Excep      : out std_logic_vector(5 downto 0);
    ConditionCodes : out std_logic_vector(1 downto 0);
    ss_scan_mode : in  std_logic;
    fp_ctl_scan_in : in  std_logic;
    fp_ctl_scan_out : out std_logic
  );
end component;

-- wrapper for meiko-compatible cores

component fpu_core 
port (
    clk    : in  clk_type;
    fpui   : in  fpu_in_type;
    fpuo   : out  fpu_out_type
  );
end component;

end; 



