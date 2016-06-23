--
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
use IEEE.Std_Logic_TEXTIO.all;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
library Std;
use Std.TextIO.all;


use work.processorPackage.all;


entity processorApbSlave is

port (pclk:       in     std_logic;
      presetn:    in     std_logic;
      paddr:      in     std_logic_vector(11 downto 0);
      pwrite:     in     std_logic;
      penable:    in     std_logic;
      psel:       in     std_logic;
      pwdata:     in     std_logic_vector(31 downto 0);
      prdata:     out    std_logic_vector(31 downto 0);
      failures:   in     std_logic_vector(31 downto 0);
      initMem:    in     std_logic
      );
end processorApbSlave;

-- -----------------------------------------------------------------------------
architecture processorApbSlave of processorApbSlave is
-- -----------------------------------------------------------------------------

   -- Depth of the APB registers in bytes
   constant MEMORYBITS: natural := 10;
   constant DEPTH: natural := 2**(MEMORYBITS+2);  -- in bytes

   type mem_type is record
      data : std_logic_vector(31 downto 0);
   end record;

   type mem_vec_type is array (natural range <>) of mem_type;

   signal  memory: mem_vec_type (DEPTH/4-1 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

  ReadMem: process(paddr, psel, pwrite, penable, failures, memory)
  variable addr: natural;
  variable L: line;
  begin
    
-- pragma translate_off
    addr := 0;
    if not is_x(paddr) then
-- pragma translate_on
      addr := conv_integer(unsigned(paddr(11 downto 2)));
-- pragma translate_off
    end if;
-- pragma translate_on

    if (pwrite = '0' and psel = '1' and penable = '1') then
      if addr < DEPTH/4 then 
	if (addr < 4) then
	  prdata <= failures;
	else
	  prdata <= memory(addr).data;
	end if;
      else
	prdata <= "00000000000000000000000000000000";
      end if;
--      write(L,string'("  read data = "));
--      write(L,hstr(memory(addr).data));
--      write(L,string'(" from address "));
--      write(L,addr);
--      writeline(OUTPUT,L);
    end if;
  end process;


  WriteMem: process(pclk)
  variable addr: natural;
  variable L: line;
  begin
    
  if rising_edge(pclk) then
-- pragma translate_off
    addr := 0;
    if not is_x(paddr) then
-- pragma translate_on
      addr := conv_integer(unsigned(paddr(11 downto 2)));
-- pragma translate_off
    end if;
-- pragma translate_on

    if (pwrite = '1' and psel = '1' and penable = '1') then
      if addr < DEPTH then 
        memory(addr).data <= pwdata;
      end if;
--      write(L,string'("  write data = "));
--      write(L,hstr(pwdata));
--      write(L,string'(" to address "));
--      write(L,addr);
--      writeline(OUTPUT,L);
    end if;

    if initMem = '0' then
      for addr in 0 to DEPTH/4-1 loop
        memory(addr).data <= "00000000000000000000000000000000";
      end loop;
    end if;

  end if;
  end process;

end processorApbSlave;

