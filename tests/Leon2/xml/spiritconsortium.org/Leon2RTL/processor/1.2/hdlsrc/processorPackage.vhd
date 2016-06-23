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

package processorPackage is

   component processorAhbMaster
      generic (
	  local_memory_start_addr : integer := 16#1000#;    -- upper 16 bits of address
	  local_memory_addr_bits  : integer := 12;          -- number of address bits
	  code_file               : string  := "master.tbl" -- file to read commands from
      );
      port (

      hclk:       in     std_logic;
      hresetn:    in     std_logic;
      hready:     in     std_logic;
      hresp:      in     std_logic_vector(1 downto 0);
      haddr:      out    std_logic_vector(31 downto 0);
      hwrite:     out    std_logic;
      hsize:      out    std_logic_vector(2 downto 0);
      htrans:     out    std_logic_vector(1 downto 0);
      hburst:     out    std_logic_vector(2 downto 0);
      hprot:      out    std_logic_vector(3 downto 0);
      hwdata:     out    std_logic_vector(31 downto 0);
      hrdata:     in     std_logic_vector(31 downto 0);
      hgrant:     in     std_logic;
      hbusreq:    out    std_logic;
      failures:   out    std_logic_vector(31 downto 0);
      SimDone:    out    std_logic);

   end component;
   

  component processorApbSlave 
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
  end component;


  function hstr(slv: std_logic_vector) return string; 

end processorPackage;

package body processorPackage is

   -- converts a std_logic_vector into a hex string.
   function hstr(slv: std_logic_vector) return string is
       variable hexlen: integer;
       variable longslv : std_logic_vector(67 downto 0) := (others => '0');
       variable hex : string(1 to 16);
       variable fourbit : std_logic_vector(3 downto 0);
     begin
       hexlen := (slv'left+1)/4;
       if (slv'left+1) mod 4 /= 0 then
         hexlen := hexlen + 1;
       end if;
       longslv(slv'left downto 0) := slv;
       for i in (hexlen -1) downto 0 loop
         fourbit := longslv(((i*4)+3) downto (i*4));
         case fourbit is
           when "0000" => hex(hexlen -I) := '0';
           when "0001" => hex(hexlen -I) := '1';
           when "0010" => hex(hexlen -I) := '2';
           when "0011" => hex(hexlen -I) := '3';
           when "0100" => hex(hexlen -I) := '4';
           when "0101" => hex(hexlen -I) := '5';
           when "0110" => hex(hexlen -I) := '6';
           when "0111" => hex(hexlen -I) := '7';
           when "1000" => hex(hexlen -I) := '8';
           when "1001" => hex(hexlen -I) := '9';
           when "1010" => hex(hexlen -I) := 'A';
           when "1011" => hex(hexlen -I) := 'B';
           when "1100" => hex(hexlen -I) := 'C';
           when "1101" => hex(hexlen -I) := 'D';
           when "1110" => hex(hexlen -I) := 'E';
           when "1111" => hex(hexlen -I) := 'F';
           when "ZZZZ" => hex(hexlen -I) := 'z';
           when "UUUU" => hex(hexlen -I) := 'u';
           when "XXXX" => hex(hexlen -I) := 'x';
           when others => hex(hexlen -I) := '?';
         end case;
       end loop;
       return hex(1 to hexlen);
     end hstr;


end;

