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
-- Entity:      tech_tsmc25
-- File:        tech_tsmc25.vhd
-- Author:      Jiri Gaisler - Gaisler Research
-- Author:      Daniel Mok - Institute for Communications Research
-- Description: Contains TSMC 0.25um process specific pads and ram generators
--              from Artisan libraries (http: 
--              
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package tech_tsmc25 is

-- sync ram generator

component tsmc25_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic);
  end component;

-- regfile generator

component tsmc25_regfile_iu
  generic ( abits : integer := 8; dbits : integer := 32; words : integer := 128);
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    clkn     : in std_logic;
    rfi      : in rf_in_type;
    rfo      : out rf_out_type);
end component;

component tsmc25_regfile_cp
  generic ( 
    abits : integer := 4;
    dbits : integer := 32;
    words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end component;

component tsmc25_dpram
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
 
-- pads

  component tsmc25_inpad 
    port (pad : in std_logic; q : out std_logic);
  end component; 
  component tsmc25_smpad
    port (pad : in std_logic; q : out std_logic);
  end component;
  component tsmc25_outpad
    generic (drive : integer := 2);
    port (d : in  std_logic; pad : out  std_logic);
  end component; 
  component tsmc25_toutpadu
    generic (drive : integer := 2);
    port (d, en : in  std_logic; pad : out  std_logic);
  end component; 
  component tsmc25_iopad
    generic (drive : integer := 2);
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc25_iodpad 
    generic (drive : integer := 2);
    port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;
  component tsmc25_odpad
    generic (drive : integer := 2);
    port ( d : in std_logic; pad : out std_logic);
  end component;
  component tsmc25_smiopad
    generic (drive : integer := 2);
    port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
  end component;

end;

------------------------------------------------------------------
-- Behavioural models only needed for simulation, not synthesis.
------------------------------------------------------------------

-- synopsys translate_off

------------------------------------------------------------------
-- behavioural ram models ----------------------------------------
------------------------------------------------------------------

-- Synchronous SRAM simulation model

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity tsmc25_syncram_ss is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    CLK: in std_logic;
    CEN: in std_logic;
    WEN: in std_logic_vector(3 downto 0);
    A:  in  std_logic_vector((abits -1) downto 0);
    D:  in  std_logic_vector((dbits -1) downto 0);
    Q:  out std_logic_vector((dbits -1) downto 0)
  ); 
end;     

architecture behavioral of tsmc25_syncram_ss is
  subtype word is std_logic_vector((dbits -1) downto 0);
  type mem is array(0 to (2**abits -1)) of word;
begin
g0:if dbits = 32 generate
  main : process(CLK)
  variable memarr : mem;
  begin
    if rising_edge(CLK) and (CEN = '0') then
      if not is_x(A) then
        if WEN(0) = '0' then
          memarr(conv_integer(unsigned(A)))(7 downto 0) := D(7 downto 0);
        end if;
        if WEN(1) = '0' then
          memarr(conv_integer(unsigned(A)))(15 downto 8) := D(15 downto 8);
        end if;
        if WEN(2) = '0' then
          memarr(conv_integer(unsigned(A)))(23 downto 16) := D(23 downto 16);
        end if;
        if WEN(3) = '0' then
          memarr(conv_integer(unsigned(A)))(31 downto 24) := D(31 downto 24);
        end if;
        Q <= memarr(conv_integer(unsigned(A)));
      else
        Q <= (others => 'Z');
      end if;
    end if;
  end process;
  end generate;

g1:if dbits /= 32 generate
  main : process(CLK)
  variable memarr : mem;
  begin
    if rising_edge(CLK) and (CEN = '0') then
      if not is_x(A) then
        if WEN(0) = '0' then
          memarr(conv_integer(unsigned(A))) := D;
        end if;
        Q <= memarr(conv_integer(unsigned(A)));
      else
        Q <= (others => 'Z');
      end if;
    end if;
  end process;
  end generate;

end behavioral;


-- Synchronous DPRAM simulation model

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity tsmc25_dpram_ss is
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
    CLKA: in std_logic;
    CENA: in std_logic;
    WENA: in std_logic;
    AA: in std_logic_vector (abits -1 downto 0);
    DA: in std_logic_vector (dbits -1 downto 0);
    QA: out std_logic_vector (dbits -1 downto 0);
    CLKB: in std_logic;
    CENB: in std_logic;
    WENB: in std_logic;
    AB: in std_logic_vector (abits -1 downto 0);
    DB: in std_logic_vector (dbits -1 downto 0);
    QB: out std_logic_vector (dbits -1 downto 0)
  );
end;

architecture behav of tsmc25_dpram_ss is

  signal writea : std_logic := '0';
  signal writeb : std_logic := '0';
  signal reada  : std_logic := '0';
  signal readb  : std_logic := '0';

  subtype word is std_logic_vector((dbits -1) downto 0);
  type mem is array(0 to words-1) of word;

  constant t_cc : time := 2 ns;  -- clock collision time
  constant t_ac : time := 3 ns;  -- access time
  
begin

  portA : process(CLKA,CLKB)

  variable memarr : mem;
  variable last_addr: std_logic_vector (abits -1 downto 0);

  begin
    if rising_edge(CLKA) and (CENA = '0') then
      if not is_x(AA) then
        if writeb = '1'  and last_addr = AA then
          if WENA = '0' then  -- write-write collision
            memarr(conv_integer(unsigned(AA))) := (others => 'X');
            QA <= DA  after t_ac;
            writea <= '1', '0' after t_cc;
          else
            QA <= (others => 'X'); -- write-read collision
          end if;
        else
          if WENA = '0' then
            memarr(conv_integer(unsigned(AA))) := DA;
            writea <= '1', '0' after t_cc;
            if readb = '1' and last_addr = AA then
              QB <= (others => 'X');  -- read-write collision
            end if;
          else
            reada <= '1', '0' after t_cc;
          end if;
          last_addr := AA;
          QA <= memarr(conv_integer(unsigned(AA))) after t_ac;
        end if;
      else
        QA <= (others => 'X');
      end if;
    end if;

    if rising_edge(CLKB) and (CENB = '0') then
      if not is_x(AB) then
        if writea = '1' and last_addr = AA then 
          if WENB = '0' then   -- write-write collision
            memarr(conv_integer(unsigned(AB))) := (others => 'X');
            QB <= DB after t_ac;
            writeb <= '1', '0' after t_cc;
          else
            QB <= (others => 'X'); -- write-read collision
          end if;
        else
          if WENB = '0' then
            memarr(conv_integer(unsigned(AB))) := DB;
            writeb <= '1', '0' after t_cc;
            if reada = '1' and last_addr = AB then
              QA <= (others => 'X');  -- read-write collision
            end if;
          else
            readb <= '1', '0' after t_cc;
          end if;
          last_addr := AB;
          QB <= memarr(conv_integer(unsigned(AB))) after t_ac;
        end if;
      else
        QB <= (others => 'X');
      end if;
    end if;

  end process;

end behav;


-----------------------------------------------------------
-- syncronous tsmc25 sram simulation model package --------
-----------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
package tech_tsmc25_sim is

component tsmc25_syncram_ss
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
  CLK: in std_logic;
  CEN: in std_logic;
  WEN: in std_logic_vector(3 downto 0);
  A: in std_logic_vector((abits -1) downto 0);
  D: in std_logic_vector((dbits -1) downto 0);
  Q: out std_logic_vector((dbits -1) downto 0)
  ); 
end component;     

component tsmc25_dpram_ss
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector (abits -1 downto 0);
   DA: in std_logic_vector (dbits -1 downto 0);
   QA: out std_logic_vector (dbits -1 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector (abits -1 downto 0);
   DB: in std_logic_vector (dbits -1 downto 0);
   QB: out std_logic_vector (dbits -1 downto 0)
  );
end component;

end;

-----------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram4096x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram4096x32 is
begin
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 12, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram1024x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram1024x32 is
begin
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 10, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram2400x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram2400x32 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 12, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram2048x32 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of ram2048x32 is
begin
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 11, dbits => 32)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => WEN,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram256x24 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end;

architecture behavioral of ram256x24 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 8, dbits => 24)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram256x27 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end;

architecture behavioral of ram256x27 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 8, dbits => 27)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity ram512x23 is
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end;

architecture behavioral of ram512x23 is
signal wen_s: std_logic_vector(3 downto 0);
begin
  wen_s(0) <= wen;
  wen_s(1) <= wen;
  wen_s(2) <= wen;
  wen_s(3) <= wen;
  syncram0 : tsmc25_syncram_ss
    generic map ( abits => 9, dbits => 23)
    port map ( 
    CLK => CLK,
    CEN => CEN,
    WEN => wen_s,
    A   => A,
    D   => D,
    Q   => Q
    ); 
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram16x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(3 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(3 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram16x32 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 4,
    dbits => 32,
    words => 16)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram136x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram136x32 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 136)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram168x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram168x32 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 168)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram256x26 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end;

architecture behavioral of dpram256x26 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 26,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram256x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram256x28 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 28,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram256x30 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of dpram256x30 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 30,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram256x32 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end;

architecture behavioral of dpram256x32 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 8,
    dbits => 32,
    words => 256)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram512x28 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end;

architecture behavioral of dpram512x28 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 9,
    dbits => 28,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_sim.all;

entity dpram512x30 is
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end;

architecture behavioral of dpram512x30 is
begin
dpram0: tsmc25_dpram_ss
  generic map(
    abits => 9,
    dbits => 30,
    words => 512)
  port map (
   CLKA => CLKA,
   CENA => CENA,
   WENA => WENA,
   AA   => AA,
   DA   => DA,
   QA   => QA,
   CLKB => CLKB,
   CENB => CENB,
   WENB => WENB,
   AB   => AB,
   DB   => DB,
   QB   => QB
  );
end behavioral;


------------------------------------------------
-- Behavioural models for tie high/low cells
------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

entity TIEHI is
  port(
  Y : out std_logic
  );
end;

architecture behavioral of TIEHI is
begin
  Y <= '1';
end behavioral;


library ieee;
use IEEE.std_logic_1164.all;

entity TIELO is
  port(
  Y : out std_logic
  );
end;

architecture behavioral of TIELO is
begin
  Y <= '0';
end behavioral;


  
------------------------------------------------------------------
-- behavioural pad models for TSMC 0.25um : fb_tpz873g_200d ------
------------------------------------------------------------------

-- input pad 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDIDGZ is port (PAD : in std_logic; C : out std_logic); end; 
architecture rtl of PDIDGZ is begin C <= to_x01(PAD) after 1 ns; end;

-- schmitt trigger input pad 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDISDGZ is port (PAD : in std_logic; C : out std_logic); end; 
architecture rtl of PDISDGZ is begin C <= to_x01(PAD) after 1 ns; end;

-- CMOS 3-state output pads 5V tolerant (2,4,8,12,16,24 mA)
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT02DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT04DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT08DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT12DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT16DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDT24DGZ is port (I : in  std_logic; PAD : out  std_logic;
                         OEN: in std_logic); end; 
architecture rtl of PDT24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns; end;


-- CMOS 3-state Output pad with input and Pullup 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU02DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU04DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU08DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU12DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU16DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDU24DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDU24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'H' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;


-- CMOS 3-state Output pad with input 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB02DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB02DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB04DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB04DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB08DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB08DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB12DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB12DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB16DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB16DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB24DGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB24DGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;


-- CMOS 3-state Output pad with schmitt trigger input 5V tolerant
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB02SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB02SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB04SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB04SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB08SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB08SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB12SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB12SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB16SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB16SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity PDB24SDGZ is port (I : in  std_logic; PAD : inout  std_logic;
                         OEN: in std_logic; C : out std_logic); end; 
architecture rtl of PDB24SDGZ is begin 
   PAD <= to_x01(I) after 2 ns when OEN = '0' else 'Z' after 2 ns;
   C   <= to_x01(PAD) after 1 ns; end;

------------------------------------------------------------------
-- End of Behavioural models
------------------------------------------------------------------

-- synopsys translate_on

------------------------------------------------------------------
-- component declarations from true tech library
------------------------------------------------------------------
LIBRARY ieee;
use IEEE.std_logic_1164.all;

package tech_tsmc25_syn is

-- Sync single-port RAM cells for instr/data cache & scratch-pad RAM
component ram4096x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram2400x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(11 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 
   
component ram2048x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(10 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

component ram1024x32
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic_vector(3 downto 0);
   A: in std_logic_vector(9 downto 0);
   D: in std_logic_vector(31 downto 0);
   Q: out std_logic_vector(31 downto 0)
   );
end component; 

-- Sync single-port RAM cells for cache tags
component ram256x24
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(23 downto 0);
   Q: out std_logic_vector(23 downto 0)
   );
end component; 

component ram256x27
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(7 downto 0);
   D: in std_logic_vector(26 downto 0);
   Q: out std_logic_vector(26 downto 0)
   );
end component; 

component ram512x23
   port ( 
   CLK: in std_logic;
   CEN: in std_logic;
   WEN: in std_logic;
   A: in std_logic_vector(8 downto 0);
   D: in std_logic_vector(22 downto 0);
   Q: out std_logic_vector(22 downto 0)
   );
end component; 

-- Sync dpram cell for regfile iu & cp
component dpram16x32
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(3 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(3 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end component; 

component dpram136x32
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end component; 

component dpram168x32
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end component; 

-- Sync dpram cells for tags when snooping is enabled or DSU trace buffer
component dpram256x26
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(25 downto 0);
   QA: out std_logic_vector(25 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(25 downto 0);
   QB: out std_logic_vector(25 downto 0)
   );
end component; 

component dpram256x28
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end component; 

component dpram256x30
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end component; 

component dpram256x32
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(7 downto 0);
   DA: in std_logic_vector(31 downto 0);
   QA: out std_logic_vector(31 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(7 downto 0);
   DB: in std_logic_vector(31 downto 0);
   QB: out std_logic_vector(31 downto 0)
   );
end component; 

component dpram512x28
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(27 downto 0);
   QA: out std_logic_vector(27 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(27 downto 0);
   QB: out std_logic_vector(27 downto 0)
   );
end component; 

component dpram512x30
   port ( 
   CLKA: in std_logic;
   CENA: in std_logic;
   WENA: in std_logic;
   AA: in std_logic_vector(8 downto 0);
   DA: in std_logic_vector(29 downto 0);
   QA: out std_logic_vector(29 downto 0);
   CLKB: in std_logic;
   CENB: in std_logic;
   WENB: in std_logic;
   AB: in std_logic_vector(8 downto 0);
   DB: in std_logic_vector(29 downto 0);
   QB: out std_logic_vector(29 downto 0)
   );
end component; 

-- Tie high/low cells

component TIEHI
   port(
   Y : out std_logic
   );
end component; 

component TIELO
   port(
   Y : out std_logic
   );
end component; 

-- high drive clock input pad 5V tolerant
component PDCH0DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH1DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH2DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 
component PDCH3DGZ  port (CLK : in std_logic; CP : out std_logic); end component; 

-- input pad 5V tolerant
component PDIDGZ  port (PAD : in std_logic; C : out std_logic); end component; 

-- schmitt trigger input pad 5V tolerant
component PDISDGZ port (PAD : in std_logic; C : out std_logic); end component; 

-- CMOS 3-state output pads 5V tolerant (2,4,8,12,16,24 mA)
component PDT02DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT04DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT08DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT12DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT16DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 
component PDT24DGZ port (I  : in std_logic; PAD : out  std_logic;
                            OEN: in std_logic); end component; 

-- CMOS 3-state Output pad with input and Pullup 5V tolerant
component PDU02DGZ port (I  : in std_logic; PAD : inout std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU04DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU08DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU12DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU16DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 
component PDU24DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C   : out std_logic); end component; 

-- CMOS 3-state Output pad with input 5V tolerant
component PDB02DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB04DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB08DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB12DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB16DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 
component PDB24DGZ port (I  : in std_logic; PAD : inout  std_logic;
                            OEN: in std_logic; C : out std_logic); end component; 

-- CMOS 3-state Output pad with schmitt trigger input 5V tolerant
component PDB02SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB04SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB08SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB12SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB16SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 
component PDB24SDGZ port (I  : in std_logic; PAD : inout  std_logic;
                             OEN: in std_logic; C : out std_logic); end component; 

end;

------------------------------------------------------------------
-- sync ram generator --------------------------------------------
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;

entity tsmc25_syncram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic
  );
end;

architecture rtl of tsmc25_syncram is
  signal cen  : std_logic;
  signal wen  : std_logic_vector(3 downto 0);
  signal a    : std_logic_vector(19 downto 0);
  signal d, q : std_logic_vector(34 downto 0);
  constant synopsys_bug : std_logic_vector(37 downto 0) := (others => '0');
begin

  wen(0) <= not write; 
  wen(1) <= not write; 
  wen(2) <= not write; 
  wen(3) <= not write; 
  cen <= not enable;
  a(abits -1 downto 0) <= address; 
  a(abits+1 downto abits) <= synopsys_bug(abits+1 downto abits);
  d(dbits -1 downto 0) <= datain; 
  d(dbits+1 downto dbits) <= synopsys_bug(dbits+1 downto dbits);

  dataout <= q(dbits -1 downto 0);

a12d32: if (abits = 12) and (dbits = 32) generate
   id0: ram4096x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a(11 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a11d32: if (abits = 11) and (dbits = 32) generate
   id0: ram2048x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a(10 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a10d32: if (abits = 10) and (dbits = 32) generate
   id0: ram1024x32
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen,
        A => a( 9 downto 0),
        D => d(31 downto 0),
        Q => q(31 downto 0)
        );
end generate;

a8d24: if (abits = 8) and (dbits = 24) generate
   id0: ram256x24
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(23 downto 0),
        Q => q(23 downto 0)
        );
end generate;

a8d27: if (abits = 8) and (dbits = 27) generate
   id0: ram256x27
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 7 downto 0),
        D => d(26 downto 0),
        Q => q(26 downto 0)
        );
end generate;

a9d23: if (abits = 9) and (dbits = 23) generate
   id0: ram512x23
        port map (
        CLK => clk,
        CEN => cen,
        WEN => wen(0),
        A => a( 8 downto 0),
        D => d(22 downto 0),
        Q => q(22 downto 0)
        );
end generate;
           
end rtl;


------------------------------------------------------------------
-- sync dpram generator --------------------------------------------
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
use work.iface.all;


entity tsmc25_dpram is
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
end;

architecture rtl of tsmc25_dpram is

signal cena, cenb, wena, wenb : std_logic;

begin
  cena <= not enable1;
  cenb <= not enable2;
  wena <= not write1;
  wenb <= not write2;
  
  dp256x26 : if (abits = 8) and (dbits = 26) generate
    dp0:dpram256x26
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

  dp256x28 : if (abits = 8) and (dbits = 28) generate
    dp0:dpram256x28
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

  dp256x30 : if (abits = 8) and (dbits = 30) generate
    dp0:dpram256x30
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

  dp256x32 : if (abits = 8) and (dbits = 32) generate
    dp0:dpram256x32
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

  dp512x28 : if (abits = 9) and (dbits = 28) generate
    dp0:dpram512x28
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

  dp512x30 : if (abits = 9) and (dbits = 30) generate
    dp0:dpram512x30
        port map( 
        CLKA => clk, CENA => cena, WENA => wena,
        AA   => address1(abits -1 downto 0),
        DA   => datain1 (dbits -1 downto 0),
        QA   => dataout1(dbits -1 downto 0),
        CLKB => clk, CENB => cenb, WENB => wenb,
        AB   => address2(abits -1 downto 0),
        DB   => datain2 (dbits -1 downto 0),
        QB   => dataout2(dbits -1 downto 0)
        );
end generate;

end rtl;

------------------------------------------------------------------
-- regfile generator for iu & cp ---------------------------------
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.iface.all;
use work.tech_tsmc25_syn.all;

entity tsmc25_regfile_iu is
  generic ( 
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 128
  );
  port (
    rst   : in std_logic;
    clk   : in std_logic;
    clkn  : in std_logic;
    rfi   : in rf_in_type;
    rfo   : out rf_out_type);
end;

architecture rtl of tsmc25_regfile_iu is

signal qq0, qq1 : std_logic_vector(dbits-1 downto 0);
signal wen, ren1, ren2 : std_logic;
signal high0, high1 : std_logic;
signal low0, low1 : std_logic;
signal qa0 : std_logic_vector(31 downto 0);
signal qa1 : std_logic_vector(31 downto 0);
signal db0 : std_logic_vector(31 downto 0);
signal db1 : std_logic_vector(31 downto 0);
signal ra1, ra2, wa : std_logic_vector(12 downto 0);

begin
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;
  wen  <= not rfi.wren;
  db0  <= (others => low0);
  db1  <= (others => low1);

  ra1(abits-1 downto 0) <= rfi.rd1addr;
  ra1(12 downto abits) <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr;
  ra2(12 downto abits) <= (others => '0');
  wa(abits-1 downto 0) <= rfi.wraddr;
  wa(12 downto abits) <= (others => '0');

  dp136x32 : if (words = 136) and (dbits = 32) generate
    u0: dpram136x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clkn, CENB => ren1, WENB => high0,
        AB   => ra1(abits -1 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram136x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clkn, CENB => ren2, WENB => high1,
        AB   => ra2(abits -1 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  dp168x32 : if (words = 168) and (dbits = 32) generate
    u0: dpram168x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => ra1(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clkn, CENB => ren1, WENB => high0,
        AB   => rfi.rd1addr(abits -1 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram168x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(abits -1 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clkn, CENB => ren2, WENB => high1,
        AB   => ra2(abits -1 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  rfo.data1 <= qq0(dbits-1 downto 0);
  rfo.data2 <= qq1(dbits-1 downto 0);

  th0: TIEHI
       port map(
       Y => high0
       );

  th1: TIEHI
       port map(
       Y => high1
       );

  tl0: TIELO
       port map(
       Y => low0
       );
   
  tl1: TIELO
       port map(
       Y => low1
       );

end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.iface.all;
use work.tech_tsmc25_syn.all;

entity tsmc25_regfile_cp is
  generic ( 
    abits : integer := 4;
    dbits : integer := 32;
    words : integer := 16
  );
  port (
    rst      : in std_logic;
    clk      : in std_logic;
    rfi      : in rf_cp_in_type;
    rfo      : out rf_cp_out_type);
end;

architecture rtl of tsmc25_regfile_cp is

signal qq0, qq1 : std_logic_vector(dbits-1 downto 0);
signal wen, ren1, ren2 : std_logic;
signal high0, high1 : std_logic;
signal low0, low1   : std_logic;
signal qa0 : std_logic_vector(31 downto 0);
signal qa1 : std_logic_vector(31 downto 0);
signal db0 : std_logic_vector(31 downto 0);
signal db1 : std_logic_vector(31 downto 0);
signal ra1, ra2, wa : std_logic_vector(12 downto 0);

begin
  ren1 <= not rfi.ren1;
  ren2 <= not rfi.ren2;
  wen  <= not rfi.wren;
  db0  <= (others => low0);
  db1  <= (others => low1);

  ra1(abits-1 downto 0) <= rfi.rd1addr;
  ra1(12 downto abits)  <= (others => '0');
  ra2(abits-1 downto 0) <= rfi.rd2addr;
  ra2(12 downto abits)  <= (others => '0');
  wa(abits-1 downto 0)  <= rfi.wraddr;
  wa(12 downto abits)   <= (others => '0');
  
  -- Port A: write port, B: read port
  dp16x32 : if (words = 16) and (dbits = 32) generate
    u0: dpram16x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(3 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa0,
        CLKB => clk, CENB => ren1, WENB => high0,
        AB   => ra1(3 downto 0),
        DB   => db0,
        QB   => qq0
        );
    u1: dpram16x32
        port map( 
        CLKA => clk, CENA => wen, WENA => wen,
        AA   => wa(3 downto 0),
        DA   => rfi.wrdata(dbits -1 downto 0),
        QA   => qa1,
        CLKB => clk, CENB => ren2, WENB => high1,
        AB   => ra2(3 downto 0),
        DB   => db1,
        QB   => qq1
        );
  end generate;

  rfo.data1 <= qq0(dbits-1 downto 0);
  rfo.data2 <= qq1(dbits-1 downto 0);

  th0: TIEHI
       port map(
       Y => high0
       );

  th1: TIEHI
       port map(
       Y => high1
       );

  tl0: TIELO
       port map(
       Y => low0
       );
   
  tl1: TIELO
       port map(
       Y => low1
       );

end;

      
------------------------------------------------------------------
-- mapping generic pads on tech pads -----------------------------
------------------------------------------------------------------

-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_inpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of tsmc25_inpad is begin 
  i0 : PDIDGZ port map (PAD => pad, C => q); 
end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_smpad is port (pad : in std_logic; q : out std_logic); end; 
architecture syn of tsmc25_smpad is begin 
  i0 : PDISDGZ port map (PAD => pad, C => q); 
end;

-- output pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_outpad is
  generic (drive : integer := 2);  --2,4,8,12,16,24 mA
  port (d : in std_logic; pad : out std_logic);
 end; 
architecture syn of tsmc25_outpad is 
signal en : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDT02DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d4 : if drive = 2 generate
    i0 : PDT04DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d8 : if drive = 3 generate
    i0 : PDT08DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d12: if drive = 4 generate
    i0 : PDT12DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d16: if drive = 5 generate
    i0 : PDT16DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;
  d24: if drive >= 5 generate
    i0 : PDT24DGZ port map (I => d, PAD => pad, OEN => en );
  end generate;

  tl0: TIELO
       port map(
       Y => en
       );

end;

-- tri-state output pads with pull-up
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_toutpadu is 
  generic (drive : integer := 2);   --2,4,8,12,16,24 mA
  port (d, en : in  std_logic; pad : out  std_logic);
end; 
architecture syn of tsmc25_toutpadu is 
signal nc, q: std_logic;
begin
pad <= q;
  d2 : if drive = 1 generate
    i0 : PDU02DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDU04DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d8: if drive = 3 generate
    i0 : PDU08DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d12: if drive = 4 generate
    i0 : PDU12DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d16: if drive = 5 generate
    i0 : PDU16DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDU24DGZ port map (I => d, PAD => q, OEN => en, C => nc);
  end generate;
end;

-- bidirectional pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_iopad is
  generic (drive : integer := 2);
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc25_iopad is 
begin 
  d2 : if drive = 1 generate
    i0 : PDB02DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDB08DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24DGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
end;

-- bidirectional open-drain pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_iodpad is
  generic (drive : integer := 2);
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc25_iodpad is 
signal dis : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDB02DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDB08DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24DGZ port map (I => dis, PAD => pad, OEN => d, C => q);
  end generate;

  tl0: TIELO
       port map(
       Y => dis
       );
end;

-- output open-drain pads
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_odpad is
  generic (drive : integer := 2);
  port (d : in std_logic; pad : out std_logic);
end;
architecture syn of tsmc25_odpad is 
signal dis : std_logic;
begin

  d2 : if drive = 1 generate
    i0 : PDT02DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDT04DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d8 : if drive = 3 generate
    i0 : PDT08DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d12: if drive = 4 generate
    i0 : PDT12DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d16: if drive = 5 generate
    i0 : PDT16DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDT24DGZ port map (I => dis, PAD => pad, OEN => d);
  end generate;

  tl0: TIELO
       port map(
       Y => dis
       );
end;

-- bidirectional I/O pads with schmitt trigger
library IEEE;
use IEEE.std_logic_1164.all;
use work.tech_tsmc25_syn.all;
entity tsmc25_smiopad is
  generic (drive : integer := 2);
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end;
architecture syn of tsmc25_smiopad is 
signal dis : std_logic;
begin
  d2 : if drive = 1 generate
    i0 : PDB02SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d4 : if drive = 2 generate
    i0 : PDB04SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d8: if drive = 3 generate
    i0 : PDB08SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d12: if drive = 4 generate
    i0 : PDB12SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d16: if drive = 5 generate
    i0 : PDB16SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
  d24: if drive >= 5 generate
    i0 : PDB24SDGZ port map (I => d, PAD => pad, OEN => en, C => q);
  end generate;
end;
