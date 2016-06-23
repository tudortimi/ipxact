-- 
-- Revision:    $Revision: 1506 $
-- Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- 
-- Copyright (c) 2005, 2006, 2007, 2008, 2009 The SPIRIT Consortium.
-- 
-- This work forms part of a deliverable of The SPIRIT Consortium.
-- 
-- Use of these materials are governed by the legal terms and conditions
-- outlined in the disclaimer available from www.spiritconsortium.org.
-- 
-- This source file is provided on an AS IS basis.  The SPIRIT
-- Consortium disclaims any warranty express or implied including
-- any warranty of merchantability and fitness for use for a
-- particular purpose.
-- 
-- The user of the source file shall indemnify and hold The SPIRIT
-- Consortium and its members harmless from any damages or liability.
-- Users are requested to provide feedback to The SPIRIT Consortium
-- using either mailto:feedback@lists.spiritconsortium.org or the forms at 
-- http://www.spiritconsortium.org/about/contact_us/
-- 
-- This file may be copied, and distributed, with or without
-- modifications; this notice must be included on any copy.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
library std;
use Std.TextIO.all;


entity dac is
  generic (
      WIDTH  : integer := 24          -- input word width
      );

port (
      clk:        in     std_logic;
      data:       in     std_logic_vector(WIDTH-1 downto 0)
      );
end dac;

-- -----------------------------------------------------------------------------
architecture bfm of dac is
-- -----------------------------------------------------------------------------

  signal lastData : std_logic_vector (WIDTH-1 downto 0);
  signal logic_zero : std_logic_vector (WIDTH-1 downto 0);


begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

  logic_zero <= (others => '0');

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------


  DACPROCESS: process(clk)
  variable  L: line;
  begin
    if (rising_edge(clk)) then
      if ( not is_x(data) and unsigned(data) > unsigned(logic_zero) and unsigned(data) /= unsigned(lastData)) then 
	write(L,string'("  DAC: New sample reveived "));
	write(L,conv_integer(unsigned(data)));
	writeline(OUTPUT,L);
      end if;
      lastData <= data;
    end if;
  end process;


end bfm;

