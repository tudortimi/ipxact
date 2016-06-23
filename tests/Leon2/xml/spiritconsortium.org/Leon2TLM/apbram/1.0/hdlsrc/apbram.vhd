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


-- SIMPLE APB MEMORY EXAMPLE. Size = 4K - 4 bytes 
--
-- read only ID register at 0xFFC = 0x00000D08


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_Logic_TEXTIO.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity rgu is


port (
      pclk:       in     std_logic;
      presetn:    in     std_logic;
      paddr:      in     std_logic_vector(11 downto 0);
      pwrite:     in     std_logic;
      penable:    in     std_logic;
      psel:       in     std_logic;
      pwdata:     in     std_logic_vector(31 downto 0);
      prdata:     out    std_logic_vector(31 downto 0)
      );
end rgu;

-- -----------------------------------------------------------------------------
architecture rtl of rgu is
-- -----------------------------------------------------------------------------

   -- Depth of the APB registers in words
   constant MEMORYDEPTH: natural := 4092;

   type mem_type is record
      data : std_logic_vector(31 downto 0);
   end record;

   type mem_vec_type is array (natural range <>) of mem_type;

   signal  memory: mem_vec_type (MEMORYDEPTH-1 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

  ReadMem: process(paddr, psel, pwrite, penable)
  variable addr: natural;
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
      if addr < MEMORYDEPTH then 
	prdata <= memory(addr).data;        -- read the memory registers
      elsif addr = 1023 then
	prdata <= "00000000000000000000110100001000";   -- read the ID register = 0x00000D08
      else
	prdata <= "00000000000000000000000000000000";   -- else read 0
      end if;
    end if;
  end process;


  WriteMem: process(pclk, presetn)
  variable addr: natural;
  begin
    
  if presetn = '0' then
    for addr in 0 to MEMORYDEPTH-1 loop
      memory(addr).data <= "00000000000000000000000000000000";
    end loop;

  elsif rising_edge(pclk) then
-- pragma translate_off
    addr := 0;
    if not is_x(paddr) then
-- pragma translate_on
      addr := conv_integer(unsigned(paddr(11 downto 2)));
-- pragma translate_off
    end if;
-- pragma translate_on

-- the values are writeable but they get reset again before they are used
    if (pwrite = '1' and psel = '1' and penable = '1') then
      if addr < MEMORYDEPTH then 
        memory(addr).data <= pwdata;
      end if;
    end if;

  end if;
  end process;

end rtl;

