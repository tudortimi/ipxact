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

-- SIMPLE CGU EXAMPLE. PRODUCES 8 CLOCK OUTPUTS, EACH HAS AN 8 BIT DIVIDE
-- REGISTER. 4K byte addressSpace
--
-- Clock(0) = divide at address 0x0
-- Clock(1) = divide at address 0x4
-- Clock(2) = divide at address 0x8
-- Clock(3) = divide at address 0xC
-- Clock(4) = divide at address 0x10
-- Clock(5) = divide at address 0x14
-- Clock(6) = divide at address 0x18
-- Clock(7) = divide at address 0x1C
-- ...
--  
-- 0 = NO DIVIDE -- reset state
-- 1 = DIVIDE BY 2
-- 2 = DIVIDE BY 4
-- 3 = DIVIDE BY 6
-- ...
--
-- read only ID register at 0xFFC = 0x00000D00



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_Logic_TEXTIO.all;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity cgu is

port (
      clkin:      in     std_logic;
      clkout:     out    std_logic_vector(7 downto 0);

      pclk:       in     std_logic;
      presetn:    in     std_logic;
      paddr:      in     std_logic_vector(11 downto 0);
      pwrite:     in     std_logic;
      penable:    in     std_logic;
      psel:       in     std_logic;
      pwdata:     in     std_logic_vector(31 downto 0);
      prdata:     out    std_logic_vector(31 downto 0)
      );
end cgu;

-- -----------------------------------------------------------------------------
architecture rtl of cgu is
-- -----------------------------------------------------------------------------

   -- Depth of the APB registers in words
   constant NUMCLOCKS: natural := 8;

   type mem_type is record
      data : std_logic_vector(31 downto 0);
   end record;

   type mem_vec_type is array (natural range <>) of mem_type;

   signal  memory: mem_vec_type (NUMCLOCKS-1 downto 0);
   signal  clktmp: std_logic;
   signal  clkdiv: std_logic_vector (7 downto 0);

   type div_type is record
      count : std_logic_vector(7 downto 0);
   end record;

   type div_vec_type is array (natural range <>) of div_type;
   signal  div: div_vec_type (NUMCLOCKS-1 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

  gen1: for i in 0 to NUMCLOCKS-1 generate
    clkout(i) <= clkin WHEN memory(i).data(7 downto 0) = "00000000" ELSE clkdiv(i);
  end generate;

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

  clockProcess: process(clkin, presetn)

  variable i: natural;
  begin
    if (presetn = '0') then
      for i in 0 to NUMCLOCKS-1 loop
        div(i).count <= "00000000";
        clkdiv(i) <= '0';
      end loop;
    elsif rising_edge(clkin) then
     for i in 0 to NUMCLOCKS-1 loop
      if memory(i).data(7 downto 0) /= "00000000" then
	if div(i).count = "00000000" then
	  div(i).count <= unsigned(memory(i).data(7 downto 0)) - '1';
	  if clkdiv(i) = '1' then
	    clkdiv(i) <= '0';
	  else
	    clkdiv(i) <= '1';
	  end if;
	else
	  div(i).count <= unsigned(div(i).count) - '1';
	end if;
      end if;
     end loop;
    end if;
  end process;

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
      if addr < NUMCLOCKS then 
	prdata <= memory(addr).data;                    -- read the registers
      elsif addr = 1023 then
	prdata <= "00000000000000000000110100000000";   -- read the ID register = 0x00000D00
      else
	prdata <= "00000000000000000000000000000000";   -- else read 0
      end if;
    end if;
  end process;


  WriteMem: process(pclk, presetn)
  variable addr: natural;
  begin
    
  if presetn = '0' then
    for addr in 0 to NUMCLOCKS-1 loop
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

    if (pwrite = '1' and psel = '1' and penable = '1') then
      if addr < NUMCLOCKS then 
        memory(addr).data <= pwdata;
      end if;
    end if;

  end if;
  end process;

end rtl;

