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
-- Package: 	tech_virtex
-- File:	tech_virtex.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Xilinx Virtex specific regfile and cache ram generators
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package tech_virtex is

component virtex_syncram
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

-- three-port regfile with sync read, sync write
  component virtex_regfile
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

  component virtex_regfile_cp
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
  end component;

  component virtex_bprom
  port (
    clk       : in std_logic;
    addr      : in std_logic_vector(29 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
  end component;

component virtex_dpram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic
   ); 
end component;

end;

-- xilinx pre-loaded cache

-- pragma translate_off
-- boot prom

library IEEE;
use IEEE.std_logic_1164.all;

entity virtex_prom256 is port (
  addr: in  std_logic_vector(7 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end;
library IEEE;
use IEEE.std_logic_1164.all;
entity virtex_prom512 is port (
  addr: in  std_logic_vector(8 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end;
library IEEE;
use IEEE.std_logic_1164.all;
entity virtex_prom1024 is port (
  addr: in  std_logic_vector(9 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end;
library IEEE;
use IEEE.std_logic_1164.all;
entity virtex_prom2048 is port (
  addr: in  std_logic_vector(10 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end;
-- pragma translate_on

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;

entity virtex_bprom is
  port (
    clk       : in std_logic;
    addr      : in std_logic_vector(29 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
end;

architecture rtl of virtex_bprom is
component virtex_prom256 port (
  addr: in  std_logic_vector(7 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end component;
component virtex_prom512 port (
  addr: in  std_logic_vector(8 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end component;
component virtex_prom1024 port (
  addr: in  std_logic_vector(9 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end component;
component virtex_prom2048 port (
  addr: in  std_logic_vector(10 downto 0);
  clk : in  std_logic;
  do  : out std_logic_vector(31 downto 0));
end component;
begin
 
  p256 : if PABITS = 8 generate
    dt0 : virtex_prom256 port map ( 
  	  addr => addr(7 downto 0), clk => clk, do => data(31 downto 0));
  end generate;
  p512 : if PABITS = 9 generate
    dt0 : virtex_prom512 port map ( 
  	  addr => addr(8 downto 0), clk => clk, do => data(31 downto 0));
  end generate;
  p1024 : if PABITS = 10 generate
    dt0 : virtex_prom1024 port map ( 
  	  addr => addr(9 downto 0), clk => clk, do => data(31 downto 0));
  end generate;
  p2048 : if PABITS = 11 generate
    dt0 : virtex_prom2048 port map ( 
  	  addr => addr(10 downto 0), clk => clk, do => data(31 downto 0));
  end generate;
end;

-- pragma translate_off

-- simulation models for select-rams

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAMB4_S16 is
  port (DI     : in std_logic_vector (15 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (7 downto 0);
        DO     : out std_logic_vector (15 downto 0)
       );
end;
architecture behav of RAMB4_S16 is
begin x : generic_syncram generic map (8,16)
          port map (addr, clk, di, do, en, we); 
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAMB4_S8 is
  port (DI     : in std_logic_vector (7 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (8 downto 0);
        DO     : out std_logic_vector (7 downto 0)
       );
end;
architecture behav of RAMB4_S8 is
begin x : generic_syncram generic map (9,8)
          port map (addr, clk, di, do, en, we); 
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAMB4_S4 is
  port (DI     : in std_logic_vector (3 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (9 downto 0);
        DO     : out std_logic_vector (3 downto 0)
       );
end;
architecture behav of RAMB4_S4 is
begin x : generic_syncram generic map (10,4)
          port map (addr, clk, di, do, en, we); 
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAMB4_S2 is
  port (DI     : in std_logic_vector (1 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (10 downto 0);
        DO     : out std_logic_vector (1 downto 0)
       );
end;
architecture behav of RAMB4_S2 is
begin x : generic_syncram generic map (11,2)
          port map (addr, clk, di, do, en, we); 
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAMB4_S1 is
  port (DI     : in std_logic_vector (0 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (11 downto 0);
        DO     : out std_logic_vector (0 downto 0)
       );
end;
architecture behav of RAMB4_S1 is
begin x : generic_syncram generic map (12,1)
          port map (addr, clk, di, do, en, we); 
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAMB4_S1_S1 is
  port (DIA    : in std_logic_vector (0 downto 0);
        DIB    : in std_logic_vector (0 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (11 downto 0);
        ADDRB  : in std_logic_vector (11 downto 0);
        DOA    : out std_logic_vector (0 downto 0);
        DOB    : out std_logic_vector (0 downto 0)
       );
end;
architecture behav of RAMB4_S1_S1 is
begin
  rp : process(clka, clkb)
  subtype dword is std_logic_vector(0 downto 0);
  type dregtype is array (0 to 4095) of DWord;
  variable rfd : dregtype;
  begin
    if rising_edge(clka) and not is_x (addra) then 
      if ena = '1' then
        doa <= rfd(conv_integer(unsigned(addra)));
        if wea = '1' then 
	  rfd(conv_integer(unsigned(addra))) := dia;
        end if;
      end if;
    end if;
    if rising_edge(clkb) and not is_x (addrb) then 
      if enb = '1' then
        dob <= rfd(conv_integer(unsigned(addrb)));
        if web = '1' then 
	  rfd(conv_integer(unsigned(addrb))) := dib;
        end if;
      end if;
    end if;
  end process;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAMB4_S2_S2 is
  port (DIA    : in std_logic_vector (1 downto 0);
        DIB    : in std_logic_vector (1 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (10 downto 0);
        ADDRB  : in std_logic_vector (10 downto 0);
        DOA    : out std_logic_vector (1 downto 0);
        DOB    : out std_logic_vector (1 downto 0)
       );
end;
architecture behav of RAMB4_S2_S2 is
begin
  rp : process(clka, clkb)
  subtype dword is std_logic_vector(1 downto 0);
  type dregtype is array (0 to 2047) of DWord;
  variable rfd : dregtype;
  begin
    if rising_edge(clka) and not is_x (addra) then 
      if ena = '1' then
        doa <= rfd(conv_integer(unsigned(addra)));
        if wea = '1' then 
	  rfd(conv_integer(unsigned(addra))) := dia;
        end if;
      end if;
    end if;
    if rising_edge(clkb) and not is_x (addrb) then 
      if enb = '1' then
        dob <= rfd(conv_integer(unsigned(addrb)));
        if web = '1' then 
	  rfd(conv_integer(unsigned(addrb))) := dib;
        end if;
      end if;
    end if;
  end process;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAMB4_S8_S8 is
  port (DIA    : in std_logic_vector (7 downto 0);
        DIB    : in std_logic_vector (7 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (8 downto 0);
        ADDRB  : in std_logic_vector (8 downto 0);
        DOA    : out std_logic_vector (7 downto 0);
        DOB    : out std_logic_vector (7 downto 0)
       );
end;

architecture behav of RAMB4_S8_S8 is
begin
  rp : process(clka, clkb)
  subtype dword is std_logic_vector(7 downto 0);
  type dregtype is array (0 to 511) of DWord;
  variable rfd : dregtype;
  begin
    if rising_edge(clka) and not is_x (addra) then 
      if ena = '1' then
        doa <= rfd(conv_integer(unsigned(addra)));
        if wea = '1' then 
	  rfd(conv_integer(unsigned(addra))) := dia;
        end if;
      end if;
    end if;
    if rising_edge(clkb) and not is_x (addrb) then 
      if enb = '1' then
        dob <= rfd(conv_integer(unsigned(addrb)));
        if web = '1' then 
	  rfd(conv_integer(unsigned(addrb))) := dib;
        end if;
      end if;
    end if;
  end process;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAMB4_S4_S4 is
  port (DIA    : in std_logic_vector (3 downto 0);
        DIB    : in std_logic_vector (3 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (9 downto 0);
        ADDRB  : in std_logic_vector (9 downto 0);
        DOA    : out std_logic_vector (3 downto 0);
        DOB    : out std_logic_vector (3 downto 0)
       );
end;
architecture behav of RAMB4_S4_S4 is
begin
  rp : process(clka, clkb)
  subtype dword is std_logic_vector(3 downto 0);
  type dregtype is array (0 to 1023) of DWord;
  variable rfd : dregtype;
  begin
    if rising_edge(clka) and not is_x (addra) then 
      if ena = '1' then
        doa <= rfd(conv_integer(unsigned(addra)));
        if wea = '1' then 
	  rfd(conv_integer(unsigned(addra))) := dia;
        end if;
      end if;
    end if;
    if rising_edge(clkb) and not is_x (addrb) then 
      if enb = '1' then
        dob <= rfd(conv_integer(unsigned(addrb)));
        if web = '1' then 
	  rfd(conv_integer(unsigned(addrb))) := dib;
        end if;
      end if;
    end if;
  end process;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_generic.all;

entity RAMB4_S16_S16 is
  port (DIA    : in std_logic_vector (15 downto 0);
        DIB    : in std_logic_vector (15 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (7 downto 0);
        ADDRB  : in std_logic_vector (7 downto 0);
        DOA    : out std_logic_vector (15 downto 0);
        DOB    : out std_logic_vector (15 downto 0)
       );
end;
architecture behav of RAMB4_S16_S16 is
begin
  rp : process(clka, clkb)
  subtype dword is std_logic_vector(15 downto 0);
  type dregtype is array (0 to 255) of DWord;
  variable rfd : dregtype;
  begin
    if rising_edge(clka) and not is_x (addra) then 
      if ena = '1' then
        doa <= rfd(conv_integer(unsigned(addra)));
        if wea = '1' then 
	  rfd(conv_integer(unsigned(addra))) := dia;
        end if;
      end if;
    end if;
    if rising_edge(clkb) and not is_x (addrb) then 
      if enb = '1' then
        dob <= rfd(conv_integer(unsigned(addrb)));
        if web = '1' then 
	  rfd(conv_integer(unsigned(addrb))) := dib;
        end if;
      end if;
    end if;
  end process;
end;

-- pragma translate_on

-- package with virtex select-ram component declarations
library IEEE;
use IEEE.std_logic_1164.all;

package virtex_complib is
  component RAMB4_S16
  port (DI     : in std_logic_vector (15 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (7 downto 0);
        DO     : out std_logic_vector (15 downto 0)
       );
  end component;
  component RAMB4_S8
  port (DI     : in std_logic_vector (7 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (8 downto 0);
        DO     : out std_logic_vector (7 downto 0)
       );
  end component;
  component RAMB4_S4
  port (DI     : in std_logic_vector (3 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (9 downto 0);
        DO     : out std_logic_vector (3 downto 0)
       );
  end component;
  component RAMB4_S2
  port (DI     : in std_logic_vector (1 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (10 downto 0);
        DO     : out std_logic_vector (1 downto 0)
       );
  end component;
  component RAMB4_S1
  port (DI     : in std_logic_vector (0 downto 0);
        EN     : in std_logic;
        WE     : in std_logic;
        RST    : in std_logic;
        CLK    : in std_logic;
        ADDR   : in std_logic_vector (11 downto 0);
        DO     : out std_logic_vector (0 downto 0)
       );
  end component;
  component RAMB4_S1_S1
  port (DIA    : in std_logic_vector (0 downto 0);
        DIB    : in std_logic_vector (0 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (11 downto 0);
        ADDRB  : in std_logic_vector (11 downto 0);
        DOA    : out std_logic_vector (0 downto 0);
        DOB    : out std_logic_vector (0 downto 0)
       );
  end component;
  component RAMB4_S2_S2
  port (DIA    : in std_logic_vector (1 downto 0);
        DIB    : in std_logic_vector (1 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (10 downto 0);
        ADDRB  : in std_logic_vector (10 downto 0);
        DOA    : out std_logic_vector (1 downto 0);
        DOB    : out std_logic_vector (1 downto 0)
       );
  end component;
  component RAMB4_S4_S4
  port (DIA    : in std_logic_vector (3 downto 0);
        DIB    : in std_logic_vector (3 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (9 downto 0);
        ADDRB  : in std_logic_vector (9 downto 0);
        DOA    : out std_logic_vector (3 downto 0);
        DOB    : out std_logic_vector (3 downto 0)
       );
  end component;
  component RAMB4_S8_S8
  port (DIA    : in std_logic_vector (7 downto 0);
        DIB    : in std_logic_vector (7 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (8 downto 0);
        ADDRB  : in std_logic_vector (8 downto 0);
        DOA    : out std_logic_vector (7 downto 0);
        DOB    : out std_logic_vector (7 downto 0)
       );
  end component;
  component RAMB4_S16_S16
  port (DIA    : in std_logic_vector (15 downto 0);
        DIB    : in std_logic_vector (15 downto 0);
        ENA    : in std_logic;
        ENB    : in std_logic;
        WEA    : in std_logic;
        WEB    : in std_logic;
        RSTA   : in std_logic;
        RSTB   : in std_logic;
        CLKA   : in std_logic;
        CLKB   : in std_logic;
        ADDRA  : in std_logic_vector (7 downto 0);
        ADDRB  : in std_logic_vector (7 downto 0);
        DOA    : out std_logic_vector (15 downto 0);
        DOB    : out std_logic_vector (15 downto 0)
       );
  end component;

end;

-- parametrisable sync ram generator using virtex select rams
-- max size: 4096x128 bits

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.virtex_complib.all;

entity virtex_syncram is
  generic ( abits : integer := 8; dbits : integer := 32);
  port (
    address : in std_logic_vector (abits -1 downto 0);
    clk     : in std_logic;
    datain  : in std_logic_vector (dbits -1 downto 0);
    dataout : out std_logic_vector (dbits -1 downto 0);
    enable  : in std_logic;
    write   : in std_logic
  );
end;

architecture behav of virtex_syncram is
signal gnd : std_logic;
signal do, di : std_logic_vector(129 downto 0);
signal xa, ya : std_logic_vector(19 downto 0);
begin
  gnd <= '0';
  dataout <= do(dbits-1 downto 0);
  di(dbits-1 downto 0) <= datain; di(129 downto dbits) <= (others => '0');
  xa(abits-1 downto 0) <= address; xa(19 downto abits) <= (others => '0');
  ya(abits-1 downto 0) <= address; ya(19 downto abits) <= (others => '1');

  a7 : if (abits <= 7) and (dbits <= 32) generate
    r0 : RAMB4_S16_S16 port map ( di(31 downto 16), di(15 downto 0), 
   	enable, enable, write, write, gnd, gnd, clk, clk, xa(7 downto 0),
        ya(7 downto 0), do(31 downto 16), do(15 downto 0));
  end generate;
  a8 : if ((abits <= 7) and (dbits > 32)) or (abits = 8) generate
    x : for i in 0 to ((dbits-1)/16) generate
      r : RAMB4_S16 port map ( di (((i+1)*16)-1 downto i*16), 
	  enable, write, gnd, clk, xa(7 downto 0), 
	  do (((i+1)*16)-1 downto i*16));
    end generate;
  end generate;
  a9 : if abits = 9 generate
    x : for i in 0 to ((dbits-1)/8) generate
      r : RAMB4_S8 port map ( di (((i+1)*8)-1 downto i*8), 
	  enable, write, gnd, clk, xa(8 downto 0), 
	  do (((i+1)*8)-1 downto i*8));
    end generate;
  end generate;
  a10 : if abits = 10 generate
    x : for i in 0 to ((dbits-1)/4) generate
      r : RAMB4_S4 port map ( di (((i+1)*4)-1 downto i*4), 
	  enable, write, gnd, clk, xa(9 downto 0), 
	  do (((i+1)*4)-1 downto i*4));
    end generate;
  end generate;
  a11 : if abits = 11 generate
    x : for i in 0 to ((dbits-1)/2) generate
      r : RAMB4_S2 port map ( di (((i+1)*2)-1 downto i*2), 
	  enable, write, gnd, clk, xa(10 downto 0), 
	  do (((i+1)*2)-1 downto i*2));
    end generate;
  end generate;
  a12 : if abits = 12 generate
    x : for i in 0 to (dbits-1) generate
      r : RAMB4_S1 port map ( di(i downto i), 
	  enable, write, gnd, clk, xa(11 downto 0), 
	  do (i downto i));
    end generate;
  end generate;
end;

-- parametrisable regfile ram generator using virtex select rams
-- max size: 256x128 bits

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;
use work.virtex_complib.all;
use work.tech_generic.rfbypass;

entity virtex_regfile is
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

architecture behav of virtex_regfile is

signal gnd, vcc : std_logic;
signal do1, do2, di1, di2 : std_logic_vector(129 downto 0);
signal ra1, ra2, wa : std_logic_vector(19 downto 0);
signal gnd16 : std_logic_vector(15 downto 0);
begin
  gnd <= '0'; vcc <= '1'; gnd16 <= (others => '0');
  di1(dbits-1 downto 0) <= rfi.wrdata; di1(129 downto dbits) <= (others => '0');
  di2(129 downto 0) <= (others => '0');
  ra1(abits-1 downto 0) <= rfi.rd1addr; ra1(19 downto abits) <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr; ra2(19 downto abits) <= (others => '0');
  wa(abits-1 downto 0) <= rfi.wraddr; wa(19 downto abits) <= (others => '0');

  rf0 : if rftype = 1 generate
    a8 : if abits <= 8 generate
      x : for i in 0 to ((dbits-1)/16) generate
        r0 : RAMB4_S16_S16 port map ( 
	  di1(((i+1)*16)-1 downto i*16), gnd16,
   	  vcc, vcc, rfi.wren, gnd, gnd, gnd, clkn, clkn, wa(7 downto 0), 
	  ra1(7 downto 0), open, do1(((i+1)*16)-1 downto i*16));
        r1 : RAMB4_S16_S16 port map ( 
	  di1(((i+1)*16)-1 downto i*16), gnd16,
   	  vcc, vcc, rfi.wren, gnd, gnd, gnd, clkn, clkn, wa(7 downto 0), 
	  ra2(7 downto 0), open, do2(((i+1)*16)-1 downto i*16));
      end generate;
    end generate;
  rfo.data1 <= do1(dbits-1 downto 0); rfo.data2 <= do2(dbits-1 downto 0);
  end generate;

  rf1 : if rftype = 2 generate
    a8 : if abits <= 8 generate
      x : for i in 0 to ((dbits-1)/16) generate
        r0 : RAMB4_S16_S16 port map ( 
	  di1(((i+1)*16)-1 downto i*16), gnd16,
   	  vcc, vcc, rfi.wren, gnd, gnd, gnd, clk, clkn, wa(7 downto 0), 
	  ra1(7 downto 0), open, do1(((i+1)*16)-1 downto i*16));
        r1 : RAMB4_S16_S16 port map ( 
	  di1(((i+1)*16)-1 downto i*16), gnd16,
   	  vcc, vcc, rfi.wren, gnd, gnd, gnd, clk, clkn, wa(7 downto 0), 
	  ra2(7 downto 0), open, do2(((i+1)*16)-1 downto i*16));
      end generate;
    end generate;
    wb : rfbypass generic map (abits, dbits)

       port map ( clk => clk, 

       write => rfi.wren, datain => rfi.wrdata, raddr1 => rfi.rd1addr,
       raddr2 => rfi.rd2addr, waddr => rfi.wraddr, 
       q1 => do1(dbits-1 downto 0), q2 => do2(dbits-1 downto 0),
       dataout1 => rfo.data1, dataout2 => rfo.data2);
  end generate;


end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;
use work.virtex_complib.all;

entity virtex_regfile_cp is
  generic ( 
    abits : integer := 4; dbits : integer := 32; words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end;

architecture behav of virtex_regfile_cp is

signal gnd, vcc : std_logic;
signal do1, do2, di1, di2 : std_logic_vector(129 downto 0);
signal ra1, ra2, wa : std_logic_vector(19 downto 0);
signal gnd16 : std_logic_vector(15 downto 0);
begin
  gnd <= '0'; vcc <= '1'; gnd16 <= (others => '0');
  rfo.data1 <= do1(dbits-1 downto 0); rfo.data2 <= do2(dbits-1 downto 0);
  di1(dbits-1 downto 0) <= rfi.wrdata; di1(129 downto dbits) <= (others => '0');
  di2(129 downto 0) <= (others => '0');
  ra1(abits-1 downto 0) <= rfi.rd1addr; ra1(19 downto abits) <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr; ra2(19 downto abits) <= (others => '0');
  wa(abits-1 downto 0) <= rfi.wraddr; wa(19 downto abits) <= (others => '0');

  a8 : if abits <= 8 generate
    x : for i in 0 to ((dbits-1)/16) generate
      r0 : RAMB4_S16_S16 port map ( 
	di1(((i+1)*16)-1 downto i*16), gnd16,
   	vcc, vcc, rfi.wren, gnd, gnd, gnd, clk, clk, wa(7 downto 0), 
	ra1(7 downto 0), open, do1(((i+1)*16)-1 downto i*16));
      r1 : RAMB4_S16_S16 port map ( 
	di1(((i+1)*16)-1 downto i*16), gnd16,
   	vcc, vcc, rfi.wren, gnd, gnd, gnd, clk, clk, wa(7 downto 0), 
	ra2(7 downto 0), open, do2(((i+1)*16)-1 downto i*16));
    end generate;
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;
use work.virtex_complib.all;

entity virtex_dpram is
  generic ( 
    abits : integer := 4; dbits : integer := 32
  );
  port (
    address1 : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_logic;
    write1   : in std_logic;
    address2 : in std_logic_vector((abits -1) downto 0);
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_logic;
    write2   : in std_logic);
end;

architecture behav of virtex_dpram is

signal gnd, vcc : std_logic;
signal do1, do2, di1, di2 : std_logic_vector(129 downto 0);
signal addr1, addr2 : std_logic_vector(19 downto 0);
begin
  gnd <= '0'; vcc <= '1';
  dataout1 <= do1(dbits-1 downto 0); dataout2 <= do2(dbits-1 downto 0);
  di1(dbits-1 downto 0) <= datain1; di1(129 downto dbits) <= (others => '0');
  di2(dbits-1 downto 0) <= datain2; di2(129 downto dbits) <= (others => '0');
  addr1(abits-1 downto 0) <= address1; addr1(19 downto abits) <= (others => '0');
  addr2(abits-1 downto 0) <= address2; addr2(19 downto abits) <= (others => '0');

  a8 : if abits <= 8 generate
    x : for i in 0 to ((dbits-1)/16) generate
      r0 : RAMB4_S16_S16 port map ( 
	di1(((i+1)*16)-1 downto i*16), di2(((i+1)*16)-1 downto i*16),
   	enable1, enable2, write1, write2, gnd, gnd, clk, clk,
	addr1(7 downto 0), addr2(7 downto 0), 
	do1(((i+1)*16)-1 downto i*16), do2(((i+1)*16)-1 downto i*16));
    end generate;
  end generate;

  a9 : if abits = 9 generate
    x : for i in 0 to ((dbits-1)/8) generate
      r0 : RAMB4_S8_S8 port map ( 
	di1(((i+1)*8)-1 downto i*8), di2(((i+1)*8)-1 downto i*8),
   	enable1, enable2, write1, write2, gnd, gnd, clk, clk,
	addr1(8 downto 0), addr2(8 downto 0), 
	do1(((i+1)*8)-1 downto i*8), do2(((i+1)*8)-1 downto i*8));
    end generate;
  end generate;

  a10: if abits = 10 generate
    x : for i in 0 to ((dbits-1)/4) generate
      r0 : RAMB4_S4_S4 port map ( 
	di1(((i+1)*4)-1 downto i*4), di2(((i+1)*4)-1 downto i*4),
   	enable1, enable2, write1, write2, gnd, gnd, clk, clk,
	addr1(9 downto 0), addr2(9 downto 0), 
	do1(((i+1)*4)-1 downto i*4), do2(((i+1)*4)-1 downto i*4));
    end generate;
  end generate;

  a11: if abits = 11 generate
    x : for i in 0 to ((dbits-1)/2) generate
      r0 : RAMB4_S2_S2 port map ( 
	di1(((i+1)*2)-1 downto i*2), di2(((i+1)*2)-1 downto i*2),
   	enable1, enable2, write1, write2, gnd, gnd, clk, clk,
	addr1(10 downto 0), addr2(10 downto 0), 
	do1(((i+1)*2)-1 downto i*2), do2(((i+1)*2)-1 downto i*2));
    end generate;
  end generate;

  a12: if abits = 12 generate
    x : for i in 0 to ((dbits-1)/1) generate
      r0 : RAMB4_S1_S1 port map ( 
	di1(((i+1)*1)-1 downto i*1), di2(((i+1)*1)-1 downto i*1),
   	enable1, enable2, write1, write2, gnd, gnd, clk, clk,
	addr1(11 downto 0), addr2(11 downto 0), 
	do1(((i+1)*1)-1 downto i*1), do2(((i+1)*1)-1 downto i*1));
    end generate;
  end generate;

end;
