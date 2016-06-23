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
-- Entity:      icache
-- File:        icache.vhd
-- Author:      Jiri Gaisler - Gaisler Research
-- Description: This unit implements the instruction cache controller.
------------------------------------------------------------------------------  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use work.config.all;
use work.sparcv8.all;		-- ASI declarations
use work.iface.all;
use work.macro.all;		-- xorv()
use work.amba.all;

entity icache is
  port (
    rst : in  std_logic;
    clk : in  clk_type;
    ici : in  icache_in_type;
    ico : out icache_out_type;
    dci : in  dcache_in_type;
    dco : in  dcache_out_type;
    mcii : out memory_ic_in_type;
    mcio : in  memory_ic_out_type;
    icrami : out icram_in_type;
    icramo : in  icram_out_type;
    fpuholdn : in  std_logic
);
end; 

architecture rtl of icache is

constant TAG_HIGH   : integer := ITAG_HIGH;
constant TAG_LOW    : integer := IOFFSET_BITS + ILINE_BITS + 2;
constant OFFSET_HIGH: integer := TAG_LOW - 1;
constant OFFSET_LOW : integer := ILINE_BITS + 2;
constant LINE_HIGH  : integer := OFFSET_LOW - 1;
constant LINE_LOW   : integer := 2;

constant lline : std_logic_vector((ILINE_BITS -1) downto 0) := (others=>'1');

type rdatatype is (itag, idata, memory);	-- sources during cache read

type icache_control_type is record			-- all registers
  req, burst, holdn : std_logic;
  overrun       : std_logic;			-- 
  underrun      : std_logic;			-- 
  istate 	: std_logic_vector(1 downto 0);		-- FSM vector
  waddress      : std_logic_vector(31 downto PCLOW); -- write address buffer
  valid         : std_logic_vector(ILINE_SIZE-1 downto 0); -- valid bits
  hit           : std_logic;
  su 		: std_logic;
  flush		: std_logic;				-- flush in progress
  flush2	: std_logic;				-- flush in progress
  faddr : std_logic_vector(IOFFSET_BITS - 1 downto 0);	-- flush address
  diagrdy  	: std_logic;

end record;

signal r, c : icache_control_type;	-- r is registers, c is combinational
 
begin

  ictrl : process(rst, r, mcio, ici, dci, dco, icramo, fpuholdn)
  variable rdatasel : rdatatype;
  variable faddress : std_logic_vector(31 downto PCLOW);
  variable twrite, diagen, dwrite : std_logic;
  variable taddr : std_logic_vector(TAG_HIGH  downto LINE_LOW); -- tag address
  variable wtag : std_logic_vector(TAG_HIGH  downto TAG_LOW); -- write tag value
  variable ddatain : std_logic_vector(31 downto 0);
  variable rdata : std_logic_vector(31 downto 0);
  variable diagdata : std_logic_vector(31 downto 0);
  variable vmaskraw, vmask : std_logic_vector((ILINE_SIZE -1) downto 0);
  variable xaddr_inc : std_logic_vector((ILINE_BITS -1) downto 0);
  variable lastline, nlastline, nnlastline : std_logic;
  variable enable : std_logic;
  variable error : std_logic;
  variable whit, cachable, hit, valid : std_logic;
  variable cacheon  : std_logic;
  variable v : icache_control_type;
  variable branch  : std_logic;
  variable eholdn  : std_logic;
  variable mds, write  : std_logic;
  variable tparerr, dparerr  : std_logic;
  variable memaddr : std_logic_vector(31 downto PCLOW);

  begin

-- init local variables

    v := r;

    mds := '1'; dwrite := '0'; twrite := '0'; diagen := '0'; error := '0';
    write := mcio.ready; v.diagrdy := '0'; v.holdn := '1'; 

    cacheon := mcio.ics(0) and not r.flush;
    enable := '1'; branch := '0';
    eholdn := dco.hold and fpuholdn;

    rdatasel := idata;	-- read data from cache as default
    ddatain := mcio.data;	-- load full word from memory
    wtag := r.waddress(TAG_HIGH downto TAG_LOW);
    tparerr := '0'; dparerr := '0';

-- generate access parameters during pipeline stall

    if r.overrun = '1' then faddress := ici.dpc;
    else faddress := ici.fpc; end if;



-- generate cache hit and valid bits

    if (faddress(31) = '0') and (faddress(30 downto 29) /= "01") then
      cachable := not r.flush;
    else cachable := '0'; end if;

    if (icramo.itramout.tag = ici.fpc(TAG_HIGH downto TAG_LOW)) then 
      hit := cachable and not tparerr;
    else hit := '0'; end if;

    if ici.fpc(LINE_HIGH downto LINE_LOW) = lline then lastline := '1';
    else lastline := '0'; end if;

    if r.waddress(LINE_HIGH downto LINE_LOW) = lline((ILINE_BITS -1) downto 0) then
      nlastline := '1';
    else nlastline := '0'; end if;

    if r.waddress(LINE_HIGH downto LINE_LOW+1) = lline((ILINE_BITS -1) downto 1) then
      nnlastline := '1';
    else nnlastline := '0'; end if;

-- pragma translate_off
    if not is_x(faddress(LINE_HIGH downto LINE_LOW)) then
-- pragma translate_on
      valid := genmux(ici.fpc(LINE_HIGH downto LINE_LOW), icramo.itramout.valid);
-- pragma translate_off
    end if;
-- pragma translate_on

-- pragma translate_off
    if not is_x(r.waddress) then
-- pragma translate_on
      xaddr_inc := r.waddress(LINE_HIGH downto LINE_LOW) + 1;
-- pragma translate_off
    end if;
-- pragma translate_on

    if mcio.ready = '1' then 
      v.waddress(LINE_HIGH downto LINE_LOW) := xaddr_inc;
    end if;

    taddr := ici.rpc(TAG_HIGH downto LINE_LOW);

-- main Icache state machine

    case r.istate is
    when "00" =>	-- main state and cache hit
      v.valid := icramo.itramout.valid;
      v.hit := hit; v.su := ici.su;
      if (ici.nullify or eholdn)  = '0' then 
        taddr := ici.fpc(TAG_HIGH downto LINE_LOW);
      else taddr := ici.rpc(TAG_HIGH downto LINE_LOW); end if;
      v.burst := mcio.burst and not lastline;
      if (eholdn and not ici.nullify ) = '1' then
	if not ((cacheon and hit and valid) and not dparerr) = '1' then  
	  v.istate := "01"; v.req := '1'; 
          v.holdn := '0'; v.overrun := '1';
        end if;
        v.waddress := ici.fpc(31 downto PCLOW);

      end if;
      if dco.icdiag.enable = '1' then
	diagen := '1';
      end if;
      ddatain := dci.maddress;
    when "01" =>		-- streaming: update cache and send data to IU
      rdatasel := memory;
      taddr(TAG_HIGH downto LINE_LOW) := r.waddress(TAG_HIGH downto LINE_LOW);
      branch := (ici.fbranch and r.overrun) or
		      (ici.rbranch and (not r.overrun));
      v.underrun := r.underrun or 
        (write and ((ici.nullify or not eholdn) and (mcio.ready and not (r.overrun and not r.underrun))));
      v.overrun := (r.overrun or (eholdn and not ici.nullify)) and 
		    not (write or r.underrun);
      if mcio.ready = '1' then
--        mds := not (v.overrun and not r.underrun);
        mds := not (r.overrun and not r.underrun);
--        v.req := r.burst; 
        v.burst := v.req and not nnlastline;
      end if;
      if mcio.grant = '1' then 
        v.req := mcio.burst and r.burst and 
	         (not (nnlastline and mcio.ready)) and (not branch) and
		 not (v.underrun and not cacheon);
        v.burst := v.req and not nnlastline;
      end if;
      v.underrun := (v.underrun or branch) and not v.overrun;
      v.holdn := not (v.overrun or v.underrun);
      if (mcio.ready = '1') and (r.req = '0') then --(v.burst = '0') then
        v.underrun := '0'; v.overrun := '0';
        if (mcio.ics(0) and not r.flush2) = '1' then
	  v.istate := "10"; v.holdn := '0';
	else
          v.istate := "00"; v.flush := r.flush2; v.holdn := '1';
	  if r.overrun = '1' then taddr := ici.fpc(TAG_HIGH downto LINE_LOW);
	  else taddr := ici.rpc(TAG_HIGH downto LINE_LOW); end if;
	end if;
      end if;
    when "10" => 		-- return to main
      taddr := ici.fpc(TAG_HIGH downto LINE_LOW);
      v.istate := "00"; v.flush := r.flush2;
    when others => v.istate := "00";
    end case;

    if mcio.retry = '1' then v.req := '1'; end if;

-- Generate new valid bits write strobe

    vmaskraw := decode(r.waddress(LINE_HIGH downto LINE_LOW));
    twrite := write;
    if cacheon = '0' then
      twrite := '0'; vmask := (others => '0');
    elsif (mcio.ics = "01") then
      twrite := twrite and r.hit;
      vmask := icramo.itramout.valid or vmaskraw;
    else
      if r.hit = '1' then vmask := r.valid or vmaskraw;
      else vmask := vmaskraw; end if;
    end if; 
    if (mcio.mexc or not mcio.cache) = '1' then 
      twrite := '0'; dwrite := '0';
    else dwrite := twrite; end if;
    if twrite = '1' then v.valid := vmask; v.hit := '1'; end if;


-- diagnostic cache access

    diagdata := icramo.idramout.data;
    if diagen = '1' then -- diagnostic access
      taddr(OFFSET_HIGH downto LINE_LOW) := dco.icdiag.addr(OFFSET_HIGH downto LINE_LOW);
      wtag := dci.maddress(TAG_HIGH downto TAG_LOW);
      if dco.icdiag.tag = '1' then
	twrite := not dco.icdiag.read; dwrite := '0';
        diagdata := (others => '0');

        diagdata(TAG_HIGH downto TAG_LOW) := icramo.itramout.tag;
        diagdata(ILINE_SIZE -1 downto 0) := icramo.itramout.valid;
      else
	dwrite := not dco.icdiag.read; twrite := '0';
      end if;
      vmask := dci.maddress(ILINE_SIZE -1 downto 0);
      v.diagrdy := '1';
    end if;

-- select data to return on read access

    case rdatasel is
    when memory => rdata := mcio.data;
    when others => rdata := icramo.idramout.data;
    end case;

-- cache flush

    if (ici.flush or dco.icdiag.flush) = '1' then
      v.flush := '1'; v.flush2 := '1'; v.faddr := (others => '0');
    end if;

    if r.flush2 = '1' then
      twrite := '1'; vmask := (others => '0'); v.faddr := r.faddr +1; 
      taddr(OFFSET_HIGH downto OFFSET_LOW) := r.faddr;
      if (r.faddr(IOFFSET_BITS -1) and not v.faddr(IOFFSET_BITS -1)) = '1' then
	v.flush2 := '0';
      end if;
    end if;

-- reset

    if rst = '0' then 
      v.istate := "00"; v.req := '0'; v.burst := '0'; v.holdn := '1';
      v.flush := '0'; v.flush2 := '0';
      v.overrun := '0'; v.underrun := '0';
    end if;

-- Drive signals

    c <= v;	-- register inputs

    -- tag ram inputs
    icrami.itramin.valid    <= vmask;
    icrami.itramin.tag      <= wtag;
    icrami.itramin.enable   <= enable;
    icrami.itramin.write    <= twrite;

    -- data ram inputs
    icrami.idramin.enable   <= enable;
    icrami.idramin.address  <= taddr(OFFSET_HIGH downto LINE_LOW);
    icrami.idramin.data     <= ddatain;
    icrami.idramin.write    <= dwrite;

    -- memory controller inputs
    mcii.address(31 downto 2)  <= r.waddress(31 downto 2);
    mcii.address(1 downto 0)  <= "00";
    mcii.su       <= r.su;
    mcii.burst    <= r.burst;
    mcii.req      <= r.req;
    mcii.flush    <= r.flush;

    -- IU data cache inputs
    ico.data      <= rdata;
    ico.exception <= mcio.mexc or error;
    ico.hold      <= r.holdn;
    ico.mds       <= mds;
    ico.flush     <= r.flush;
    ico.diagdata  <= diagdata;
    ico.diagrdy   <= r.diagrdy;

  end process;

-- Local registers


  regs1 : process(clk)
  begin if rising_edge(clk) then r <= c; end if; end process;

end ;

