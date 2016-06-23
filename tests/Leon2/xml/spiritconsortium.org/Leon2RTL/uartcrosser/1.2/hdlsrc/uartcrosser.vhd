-- ****************************************************************************
-- ** Description: uartcrosser.vhd
-- ** Author:      The SPIRIT Consortium
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY  uartcrosser IS
  GENERIC (
    ScalerValue : std_logic_vector(7 downto 0) := "00000001"
  );
  PORT (
    rxd0 :  out std_logic;
    txd0 :  in std_logic;
    ctsn0 :  out std_logic;
    rtsn0 :  in std_logic;
    rxen0 :  in std_logic;
    rxd1 :  out std_logic;
    txd1 :  in std_logic;
    ctsn1 :  out std_logic;
    rtsn1 :  in std_logic;
    rxen1 :  in std_logic;
    scaler : out std_logic_vector(7 downto 0)
  );
END uartcrosser;

ARCHITECTURE struct of uartcrosser is
BEGIN

  scaler<= ScalerValue;

  rxd0 <= txd1;

  rxd1 <= txd0;

  ctsn0 <= not(not(rtsn0) and rxen1);

  ctsn1 <= not(not(rtsn1) and rxen0);

  
END struct;
