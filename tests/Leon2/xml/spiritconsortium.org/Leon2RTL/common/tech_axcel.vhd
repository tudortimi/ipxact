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
-- Entity: 	tech_axcel
-- File:	tech_axcel.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	Ram generators for Actel Axcelerator FPGAs
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;
package tech_axcel is

-- generic sync ram

component axcel_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
   ); 
end component;

-- regfile generator

component axcel_regfile_iu
  generic ( 
    rftype : integer := 1;
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    clkn     : in std_logic;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
  end component;

component axcel_regfile_cp
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end component;

end;

------------------------------------------------------------------
-- behavioural ram models --------------------------------------------
------------------------------------------------------------------

-- pragma translate_off

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAM64K36 is generic (abits : integer := 16); port(
  WRAD0, WRAD1, WRAD2, WRAD3, WRAD4, WRAD5, WRAD6, WRAD7, WRAD8, WRAD9, WRAD10,
  WRAD11, WRAD12, WRAD13, WRAD14, WRAD15, WD0, WD1, WD2, WD3, WD4, WD5, WD6,
  WD7, WD8, WD9, WD10, WD11, WD12, WD13, WD14, WD15, WD16, WD17, WD18, WD19,
  WD20, WD21, WD22, WD23, WD24, WD25, WD26, WD27, WD28, WD29, WD30, WD31, WD32,
  WD33, WD34, WD35, WEN, DEPTH0, DEPTH1, DEPTH2, DEPTH3, WW0, WW1, WW2, WCLK,
  RDAD0, RDAD1, RDAD2, RDAD3, RDAD4, RDAD5, RDAD6, RDAD7, RDAD8, RDAD9, RDAD10,
  RDAD11, RDAD12, RDAD13, RDAD14, RDAD15, REN, RW0, RW1, RW2, RCLK : in std_logic;
  RD0, RD1, RD2, RD3, RD4, RD5, RD6, RD7, RD8, RD9, RD10, RD11, RD12, RD13,
  RD14, RD15, RD16, RD17, RD18, RD19, RD20, RD21, RD22, RD23, RD24, RD25, RD26,
  RD27, RD28, RD29, RD30, RD31, RD32, RD33, RD34, RD35 : out std_logic);
end;

architecture rtl of RAM64K36 is
  signal re : std_logic;
begin

  rp : process(RCLK, WCLK)
  constant words : integer := 2**abits;
  subtype word is std_logic_vector(35 downto 0);
  type dregtype is array (0 to words - 1) of word;
  variable rfd : dregtype;
  variable wa, ra : std_logic_vector(15 downto 0);
  variable q : std_logic_vector(35 downto 0);
  begin
    if rising_edge(WCLK) and (wen = '0') then
      wa := WRAD15 & WRAD14 & WRAD13 & WRAD12 & WRAD11 & WRAD10 & WRAD9 &
            WRAD8 & WRAD7 & WRAD6 & WRAD5 & WRAD4 & WRAD3 & WRAD2 & WRAD1 & WRAD0;
      if not is_x (wa) then 
   	rfd(conv_integer(unsigned(wa)) mod words) :=
          WD35 & WD34 & WD33 & WD32 & WD31 & WD30 & WD29 & WD28 & WD27 &
	  WD26 & WD25 & WD24 & WD23 & WD22 & WD21 & WD20 & WD19 & WD18 &
	  WD17 & WD16 & WD15 & WD14 & WD13 & WD12 & WD11 & WD10 & WD9 &
	  WD8 & WD7 & WD6 & WD5 & WD4 & WD3 & WD2 & WD1 & WD0;
      end if;
    end if;
    if rising_edge(RCLK) then
      ra := RDAD15 & RDAD14 & RDAD13 & RDAD12 & RDAD11 & RDAD10 & RDAD9 &
            RDAD8 & RDAD7 & RDAD6 & RDAD5 & RDAD4 & RDAD3 & RDAD2 & RDAD1 & RDAD0;
      if not (is_x (ra)) and REN = '0' then 
        q := rfd(conv_integer(unsigned(ra)) mod words);
      else q := (others => 'X'); end if;
    end if;
    RD35 <= q(35); RD34 <= q(34); RD33 <= q(33); RD32 <= q(32); RD31 <= q(31);
    RD30 <= q(30); RD29 <= q(29); RD28 <= q(28); RD27 <= q(27); RD26 <= q(26);
    RD25 <= q(25); RD24 <= q(24); RD23 <= q(23); RD22 <= q(22); RD21 <= q(21);
    RD20 <= q(20); RD19 <= q(19); RD18 <= q(18); RD17 <= q(17); RD16 <= q(16);
    RD15 <= q(15); RD14 <= q(14); RD13 <= q(13); RD12 <= q(12); RD11 <= q(11);
    RD10 <= q(10); RD9 <= q(9); RD8 <= q(8); RD7 <= q(7); RD6 <= q(6);
    RD5 <= q(5); RD4 <= q(4); RD3 <= q(3); RD2 <= q(2); RD1 <= q(1);
    RD0 <= q(0);
  end process;
end;

-- pragma translate_on

--------------------------------------------------------------------
-- regfile generators
--------------------------------------------------------------------

-- integer unit regfile
LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.iface.all;
use work.tech_generic.all;
entity axcel_regfile_iu is
  generic ( 
    rftype : integer := 1;
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    clkn     : in std_logic;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
end;

architecture rtl of axcel_regfile_iu is
signal wen, gnd : std_logic;
component RAM64K36 
-- pragma translate_off
  generic (abits : integer := 16);
-- pragma translate_on
  port(
  WRAD0, WRAD1, WRAD2, WRAD3, WRAD4, WRAD5, WRAD6, WRAD7, WRAD8, WRAD9, WRAD10,
  WRAD11, WRAD12, WRAD13, WRAD14, WRAD15, WD0, WD1, WD2, WD3, WD4, WD5, WD6,
  WD7, WD8, WD9, WD10, WD11, WD12, WD13, WD14, WD15, WD16, WD17, WD18, WD19,
  WD20, WD21, WD22, WD23, WD24, WD25, WD26, WD27, WD28, WD29, WD30, WD31, WD32,
  WD33, WD34, WD35, WEN, DEPTH0, DEPTH1, DEPTH2, DEPTH3, WW0, WW1, WW2, WCLK,
  RDAD0, RDAD1, RDAD2, RDAD3, RDAD4, RDAD5, RDAD6, RDAD7, RDAD8, RDAD9, RDAD10,
  RDAD11, RDAD12, RDAD13, RDAD14, RDAD15, REN, RW0, RW1, RW2, RCLK : in std_logic;
  RD0, RD1, RD2, RD3, RD4, RD5, RD6, RD7, RD8, RD9, RD10, RD11, RD12, RD13,
  RD14, RD15, RD16, RD17, RD18, RD19, RD20, RD21, RD22, RD23, RD24, RD25, RD26,
  RD27, RD28, RD29, RD30, RD31, RD32, RD33, RD34, RD35 : out std_logic);
end component;
signal width : std_logic_vector(2 downto 0);
signal depth : std_logic_vector(4 downto 0);
signal wa, ra1, ra2 : std_logic_vector(15 downto 0);
signal di, q1, qq1, q2, qq2 : std_logic_vector(35 downto 0);
signal ren1, ren2 : std_logic;
begin

  depth <= "00011"; width <= "101";
  wen <= not rfi.wren; gnd <= '0';
  wa(15 downto abits) <= (others =>'0');
  wa(abits-1 downto 0) <= rfi.wraddr(abits-1 downto 0);
  ra1(15 downto abits) <= (others =>'0');
  ra1(abits-1 downto 0) <= rfi.rd1addr(abits-1 downto 0);
  ra2(15 downto abits) <= (others =>'0');
  ra2(abits-1 downto 0) <= rfi.rd2addr(abits-1 downto 0);
  di(35 downto dbits) <= (others =>'0');
  di(dbits-1 downto 0) <= rfi.wrdata(dbits-1 downto 0);
  rfo.data1 <= q1(dbits-1 downto 0);
  rfo.data2 <= q2(dbits-1 downto 0);
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;

  rt1 : if RFIMPTYPE = 1 generate
    u0 : RAM64K36
-- pragma translate_off
    generic map (abits => 8) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clkn,
      RDAD0 => ra1(0), RDAD1 => ra1(1), RDAD2 => ra1(2), RDAD3 => ra1(3),
      RDAD4 => ra1(4), RDAD5 => ra1(5), RDAD6 => ra1(6), RDAD7 => ra1(7),
      RDAD8 => ra1(8), RDAD9 => ra1(9), RDAD10 => ra1(10), RDAD11 => ra1(11),
      RDAD12 => ra1(12), RDAD13 => ra1(13), RDAD14 => ra1(14), RDAD15 => ra1(15),
      REN => ren1, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clkn,
      RD0 => q1(0), RD1 => q1(1), RD2 => q1(2), RD3 => q1(3), RD4 => q1(4),
      RD5 => q1(5), RD6 => q1(6), RD7 => q1(7), RD8 => q1(8), RD9 => q1(9),
      RD10 => q1(10), RD11 => q1(11), RD12 => q1(12), RD13 => q1(13), RD14 => q1(14),
      RD15 => q1(15), RD16 => q1(16), RD17 => q1(17), RD18 => q1(18), RD19 => q1(19),
      RD20 => q1(20), RD21 => q1(21), RD22 => q1(22), RD23 => q1(23), RD24 => q1(24),
      RD25 => q1(25), RD26 => q1(26), RD27 => q1(27), RD28 => q1(28), RD29 => q1(29),
      RD30 => q1(30), RD31 => q1(31), RD32 => q1(32), RD33 => q1(33), RD34 => q1(34),
      RD35 => q1(35));
    u1 : RAM64K36
-- pragma translate_off
    generic map (abits => 8) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clkn,
      RDAD0 => ra2(0), RDAD1 => ra2(1), RDAD2 => ra2(2), RDAD3 => ra2(3),
      RDAD4 => ra2(4), RDAD5 => ra2(5), RDAD6 => ra2(6), RDAD7 => ra2(7),
      RDAD8 => ra2(8), RDAD9 => ra2(9), RDAD10 => ra2(10), RDAD11 => ra2(11),
      RDAD12 => ra2(12), RDAD13 => ra2(13), RDAD14 => ra2(14), RDAD15 => ra2(15),
      REN => ren2, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clkn,
      RD0 => q2(0), RD1 => q2(1), RD2 => q2(2), RD3 => q2(3), RD4 => q2(4),
      RD5 => q2(5), RD6 => q2(6), RD7 => q2(7), RD8 => q2(8), RD9 => q2(9),
      RD10 => q2(10), RD11 => q2(11), RD12 => q2(12), RD13 => q2(13), RD14 => q2(14),
      RD15 => q2(15), RD16 => q2(16), RD17 => q2(17), RD18 => q2(18), RD19 => q2(19),
      RD20 => q2(20), RD21 => q2(21), RD22 => q2(22), RD23 => q2(23), RD24 => q2(24),
      RD25 => q2(25), RD26 => q2(26), RD27 => q2(27), RD28 => q2(28), RD29 => q2(29),
      RD30 => q2(30), RD31 => q2(31), RD32 => q2(32), RD33 => q2(33), RD34 => q2(34),
      RD35 => q2(35));
  end generate;
  rt2 : if RFIMPTYPE = 2 generate
    u0 : RAM64K36
-- pragma translate_off
    generic map (abits => 8) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clk,
      RDAD0 => ra1(0), RDAD1 => ra1(1), RDAD2 => ra1(2), RDAD3 => ra1(3),
      RDAD4 => ra1(4), RDAD5 => ra1(5), RDAD6 => ra1(6), RDAD7 => ra1(7),
      RDAD8 => ra1(8), RDAD9 => ra1(9), RDAD10 => ra1(10), RDAD11 => ra1(11),
      RDAD12 => ra1(12), RDAD13 => ra1(13), RDAD14 => ra1(14), RDAD15 => ra1(15),
      REN => ren1, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clkn,
      RD0 => qq1(0), RD1 => qq1(1), RD2 => qq1(2), RD3 => qq1(3), RD4 => qq1(4),
      RD5 => qq1(5), RD6 => qq1(6), RD7 => qq1(7), RD8 => qq1(8), RD9 => qq1(9),
      RD10 => qq1(10), RD11 => qq1(11), RD12 => qq1(12), RD13 => qq1(13), RD14 => qq1(14),
      RD15 => qq1(15), RD16 => qq1(16), RD17 => qq1(17), RD18 => qq1(18), RD19 => qq1(19),
      RD20 => qq1(20), RD21 => qq1(21), RD22 => qq1(22), RD23 => qq1(23), RD24 => qq1(24),
      RD25 => qq1(25), RD26 => qq1(26), RD27 => qq1(27), RD28 => qq1(28), RD29 => qq1(29),
      RD30 => qq1(30), RD31 => qq1(31), RD32 => qq1(32), RD33 => qq1(33), RD34 => qq1(34),
      RD35 => qq1(35));
    u1 : RAM64K36
-- pragma translate_off
    generic map (abits => 8) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clk,
      RDAD0 => ra2(0), RDAD1 => ra2(1), RDAD2 => ra2(2), RDAD3 => ra2(3),
      RDAD4 => ra2(4), RDAD5 => ra2(5), RDAD6 => ra2(6), RDAD7 => ra2(7),
      RDAD8 => ra2(8), RDAD9 => ra2(9), RDAD10 => ra2(10), RDAD11 => ra2(11),
      RDAD12 => ra2(12), RDAD13 => ra2(13), RDAD14 => ra2(14), RDAD15 => ra2(15),
      REN => ren2, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clkn,
      RD0 => qq2(0), RD1 => qq2(1), RD2 => qq2(2), RD3 => qq2(3), RD4 => qq2(4),
      RD5 => qq2(5), RD6 => qq2(6), RD7 => qq2(7), RD8 => qq2(8), RD9 => qq2(9),
      RD10 => qq2(10), RD11 => qq2(11), RD12 => qq2(12), RD13 => qq2(13), RD14 => qq2(14),
      RD15 => qq2(15), RD16 => qq2(16), RD17 => qq2(17), RD18 => qq2(18), RD19 => qq2(19),
      RD20 => qq2(20), RD21 => qq2(21), RD22 => qq2(22), RD23 => qq2(23), RD24 => qq2(24),
      RD25 => qq2(25), RD26 => qq2(26), RD27 => qq2(27), RD28 => qq2(28), RD29 => qq2(29),
      RD30 => qq2(30), RD31 => qq2(31), RD32 => qq2(32), RD33 => qq2(33), RD34 => qq2(34),
      RD35 => qq2(35));

    wb : rfbypass generic map (abits, dbits)

       port map ( clk => clk, 

       write => rfi.wren, datain => rfi.wrdata,
       raddr1 => rfi.rd1addr, raddr2 => rfi.rd2addr, waddr => rfi.wraddr,
       q1 => qq1(dbits-1 downto 0), q2 => qq2(dbits-1 downto 0),
       dataout1 => q1(dbits-1 downto 0), dataout2 => q2(dbits-1 downto 0));

  end generate;
end;

-- co-processor regfile
-- synchronous operation without write-through support
LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.iface.all;
entity axcel_regfile_cp is
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end;

architecture rtl of axcel_regfile_cp is
signal wen, gnd : std_logic;
component RAM64K36 
-- pragma translate_off
  generic (abits : integer := 16);
-- pragma translate_on
  port(
  WRAD0, WRAD1, WRAD2, WRAD3, WRAD4, WRAD5, WRAD6, WRAD7, WRAD8, WRAD9, WRAD10,
  WRAD11, WRAD12, WRAD13, WRAD14, WRAD15, WD0, WD1, WD2, WD3, WD4, WD5, WD6,
  WD7, WD8, WD9, WD10, WD11, WD12, WD13, WD14, WD15, WD16, WD17, WD18, WD19,
  WD20, WD21, WD22, WD23, WD24, WD25, WD26, WD27, WD28, WD29, WD30, WD31, WD32,
  WD33, WD34, WD35, WEN, DEPTH0, DEPTH1, DEPTH2, DEPTH3, WW0, WW1, WW2, WCLK,
  RDAD0, RDAD1, RDAD2, RDAD3, RDAD4, RDAD5, RDAD6, RDAD7, RDAD8, RDAD9, RDAD10,
  RDAD11, RDAD12, RDAD13, RDAD14, RDAD15, REN, RW0, RW1, RW2, RCLK : in std_logic;
  RD0, RD1, RD2, RD3, RD4, RD5, RD6, RD7, RD8, RD9, RD10, RD11, RD12, RD13,
  RD14, RD15, RD16, RD17, RD18, RD19, RD20, RD21, RD22, RD23, RD24, RD25, RD26,
  RD27, RD28, RD29, RD30, RD31, RD32, RD33, RD34, RD35 : out std_logic);
end component;
signal width : std_logic_vector(2 downto 0);
signal depth : std_logic_vector(4 downto 0);
signal wa, ra1, ra2 : std_logic_vector(15 downto 0);
signal di, q1, q2 : std_logic_vector(35 downto 0);
signal ren1, ren2 : std_logic;
begin

  depth <= "00001"; width <= "101";
  wen <= not rfi.wren; gnd <= '0';
  wa(15 downto abits) <= (others =>'0');
  wa(abits-1 downto 0) <= rfi.wraddr(abits-1 downto 0);
  ra1(15 downto abits) <= (others =>'0');
  ra1(abits-1 downto 0) <= rfi.rd1addr(abits-1 downto 0);
  ra2(15 downto abits) <= (others =>'0');
  ra2(abits-1 downto 0) <= rfi.rd2addr(abits-1 downto 0);
  di(35 downto dbits) <= (others =>'0');
  di(dbits-1 downto 0) <= rfi.wrdata(dbits-1 downto 0);
  rfo.data1 <= q1(dbits-1 downto 0);
  rfo.data2 <= q2(dbits-1 downto 0);
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;

    u0 : RAM64K36
-- pragma translate_off
    generic map (abits => 7) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clk,
      RDAD0 => ra1(0), RDAD1 => ra1(1), RDAD2 => ra1(2), RDAD3 => ra1(3),
      RDAD4 => ra1(4), RDAD5 => ra1(5), RDAD6 => ra1(6), RDAD7 => ra1(7),
      RDAD8 => ra1(8), RDAD9 => ra1(9), RDAD10 => ra1(10), RDAD11 => ra1(11),
      RDAD12 => ra1(12), RDAD13 => ra1(13), RDAD14 => ra1(14), RDAD15 => ra1(15),
      REN => ren1, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clk,
      RD0 => q1(0), RD1 => q1(1), RD2 => q1(2), RD3 => q1(3), RD4 => q1(4),
      RD5 => q1(5), RD6 => q1(6), RD7 => q1(7), RD8 => q1(8), RD9 => q1(9),
      RD10 => q1(10), RD11 => q1(11), RD12 => q1(12), RD13 => q1(13), RD14 => q1(14),
      RD15 => q1(15), RD16 => q1(16), RD17 => q1(17), RD18 => q1(18), RD19 => q1(19),
      RD20 => q1(20), RD21 => q1(21), RD22 => q1(22), RD23 => q1(23), RD24 => q1(24),
      RD25 => q1(25), RD26 => q1(26), RD27 => q1(27), RD28 => q1(28), RD29 => q1(29),
      RD30 => q1(30), RD31 => q1(31), RD32 => q1(32), RD33 => q1(33), RD34 => q1(34),
      RD35 => q1(35));
    u1 : RAM64K36
-- pragma translate_off
    generic map (abits => 8) 
-- pragma translate_on
    port map (
      WRAD0 => wa(0), WRAD1 => wa(1), WRAD2 => wa(2), WRAD3 => wa(3),
      WRAD4 => wa(4), WRAD5 => wa(5), WRAD6 => wa(6), WRAD7 => wa(7),
      WRAD8 => wa(8), WRAD9 => wa(9), WRAD10 => wa(10), WRAD11 => wa(11),
      WRAD12 => wa(12), WRAD13 => wa(13), WRAD14 => wa(14), WRAD15 => wa(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clk,
      RDAD0 => ra2(0), RDAD1 => ra2(1), RDAD2 => ra2(2), RDAD3 => ra2(3),
      RDAD4 => ra2(4), RDAD5 => ra2(5), RDAD6 => ra2(6), RDAD7 => ra2(7),
      RDAD8 => ra2(8), RDAD9 => ra2(9), RDAD10 => ra2(10), RDAD11 => ra2(11),
      RDAD12 => ra2(12), RDAD13 => ra2(13), RDAD14 => ra2(14), RDAD15 => ra2(15),
      REN => ren2, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clk,
      RD0 => q2(0), RD1 => q2(1), RD2 => q2(2), RD3 => q2(3), RD4 => q2(4),
      RD5 => q2(5), RD6 => q2(6), RD7 => q2(7), RD8 => q2(8), RD9 => q2(9),
      RD10 => q2(10), RD11 => q2(11), RD12 => q2(12), RD13 => q2(13), RD14 => q2(14),
      RD15 => q2(15), RD16 => q2(16), RD17 => q2(17), RD18 => q2(18), RD19 => q2(19),
      RD20 => q2(20), RD21 => q2(21), RD22 => q2(22), RD23 => q2(23), RD24 => q2(24),
      RD25 => q2(25), RD26 => q2(26), RD27 => q2(27), RD28 => q2(28), RD29 => q2(29),
      RD30 => q2(30), RD31 => q2(31), RD32 => q2(32), RD33 => q2(33), RD34 => q2(34),
      RD35 => q2(35));
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.config.all;
use work.iface.all;
entity axcel_syncram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
   ); 
end;

architecture rtl of axcel_syncram is
signal wen, gnd : std_logic;
component RAM64K36 
-- pragma translate_off
  generic (abits : integer := 16);
-- pragma translate_on
  port(
  WRAD0, WRAD1, WRAD2, WRAD3, WRAD4, WRAD5, WRAD6, WRAD7, WRAD8, WRAD9, WRAD10,
  WRAD11, WRAD12, WRAD13, WRAD14, WRAD15, WD0, WD1, WD2, WD3, WD4, WD5, WD6,
  WD7, WD8, WD9, WD10, WD11, WD12, WD13, WD14, WD15, WD16, WD17, WD18, WD19,
  WD20, WD21, WD22, WD23, WD24, WD25, WD26, WD27, WD28, WD29, WD30, WD31, WD32,
  WD33, WD34, WD35, WEN, DEPTH0, DEPTH1, DEPTH2, DEPTH3, WW0, WW1, WW2, WCLK,
  RDAD0, RDAD1, RDAD2, RDAD3, RDAD4, RDAD5, RDAD6, RDAD7, RDAD8, RDAD9, RDAD10,
  RDAD11, RDAD12, RDAD13, RDAD14, RDAD15, REN, RW0, RW1, RW2, RCLK : in std_logic;
  RD0, RD1, RD2, RD3, RD4, RD5, RD6, RD7, RD8, RD9, RD10, RD11, RD12, RD13,
  RD14, RD15, RD16, RD17, RD18, RD19, RD20, RD21, RD22, RD23, RD24, RD25, RD26,
  RD27, RD28, RD29, RD30, RD31, RD32, RD33, RD34, RD35 : out std_logic);
end component;
signal width : std_logic_vector(2 downto 0);
signal depth : std_logic_vector(4 downto 0);
signal a : std_logic_vector(15 downto 0);
signal di, q1 : std_logic_vector(35 downto 0);
signal ren  : std_logic;
begin
  depth <= "00001" when abits <= 11 else
           "00011" when abits = 12 else
           "00111" when abits = 13 else
           "01111" when abits = 14 else
           "11111";
  width <= "101";
  wen <= not write; gnd <= '0';
  a(15 downto abits) <= (others =>'0');
  a(abits-1 downto 0) <= address(abits-1 downto 0);
  di(35 downto dbits) <= (others =>'0');
  di(dbits-1 downto 0) <=datain(dbits-1 downto 0);
  dataout <= q1(dbits-1 downto 0);
  ren <= '0';

    u0 : RAM64K36
-- pragma translate_off
    generic map (abits => abits) 
-- pragma translate_on
    port map (
      WRAD0 => a(0), WRAD1 => a(1), WRAD2 => a(2), WRAD3 => a(3),
      WRAD4 => a(4), WRAD5 => a(5), WRAD6 => a(6), WRAD7 => a(7),
      WRAD8 => a(8), WRAD9 => a(9), WRAD10 => a(10), WRAD11 => a(11),
      WRAD12 => a(12), WRAD13 => a(13), WRAD14 => a(14), WRAD15 => a(15),
      WD0 => di(0), WD1 => di(1), WD2 => di(2), WD3 => di(3), WD4 => di(4),
      WD5 => di(5), WD6 => di(6), WD7 => di(7), WD8 => di(8), WD9 => di(9),
      WD10 => di(10), WD11 => di(11), WD12 => di(12), WD13 => di(13), WD14 => di(14),
      WD15 => di(15), WD16 => di(16), WD17 => di(17), WD18 => di(18), WD19 => di(19),
      WD20 => di(20), WD21 => di(21), WD22 => di(22), WD23 => di(23), WD24 => di(24),
      WD25 => di(25), WD26 => di(26), WD27 => di(27), WD28 => di(28), WD29 => di(29),
      WD30 => di(30), WD31 => di(31), WD32 => di(32), WD33 => di(33), WD34 => di(34),
      WD35 => di(35), WEN => wen, DEPTH0 => depth(0),
      DEPTH1 => depth(1), DEPTH2 => depth(2), DEPTH3 => depth(3),
      WW0 => width(0), WW1 => width(1), WW2 => width(2), WCLK => clk,
      RDAD0 => a(0), RDAD1 => a(1), RDAD2 => a(2), RDAD3 => a(3),
      RDAD4 => a(4), RDAD5 => a(5), RDAD6 => a(6), RDAD7 => a(7),
      RDAD8 => a(8), RDAD9 => a(9), RDAD10 => a(10), RDAD11 => a(11),
      RDAD12 => a(12), RDAD13 => a(13), RDAD14 => a(14), RDAD15 => a(15),
      REN => ren, RW0 => width(0), RW1 => width(1), RW2 => width(2),
      RCLK => clk,
      RD0 => q1(0), RD1 => q1(1), RD2 => q1(2), RD3 => q1(3), RD4 => q1(4),
      RD5 => q1(5), RD6 => q1(6), RD7 => q1(7), RD8 => q1(8), RD9 => q1(9),
      RD10 => q1(10), RD11 => q1(11), RD12 => q1(12), RD13 => q1(13), RD14 => q1(14),
      RD15 => q1(15), RD16 => q1(16), RD17 => q1(17), RD18 => q1(18), RD19 => q1(19),
      RD20 => q1(20), RD21 => q1(21), RD22 => q1(22), RD23 => q1(23), RD24 => q1(24),
      RD25 => q1(25), RD26 => q1(26), RD27 => q1(27), RD28 => q1(28), RD29 => q1(29),
      RD30 => q1(30), RD31 => q1(31), RD32 => q1(32), RD33 => q1(33), RD34 => q1(34),
      RD35 => q1(35));
end;
