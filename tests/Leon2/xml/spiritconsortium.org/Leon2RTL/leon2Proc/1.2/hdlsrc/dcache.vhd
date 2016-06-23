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
-- Entity:      dcache
-- File:        dcache.vhd
-- Author:      Jiri Gaisler - Gaisler Research
-- Description: This unit implements the data cache controller.
------------------------------------------------------------------------------  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned.conv_integer;
use work.amba.all;
use work.target.all;
use work.config.all;
use work.sparcv8.all;		-- ASI declarations
use work.iface.all;
use work.macro.all;		-- xorv()


entity dcache is
  port (
    rst : in  std_logic;
    clk : in  clk_type;
    dci : in  dcache_in_type;
    dco : out dcache_out_type;
    ico : in  icache_out_type;
    mcdi : out memory_dc_in_type;
    mcdo : in  memory_dc_out_type;
    ahbsi : in  ahb_slv_in_type;
    dcrami : out dcram_in_type;
    dcramo : in  dcram_out_type;
    fpuholdn : in  std_logic
);
end; 

architecture rtl of dcache is

constant TAG_HIGH   : integer := DTAG_HIGH;
constant TAG_LOW    : integer := DOFFSET_BITS + DLINE_BITS + 2;
constant OFFSET_HIGH: integer := TAG_LOW - 1;
constant OFFSET_LOW : integer := DLINE_BITS + 2;
constant LINE_HIGH  : integer := OFFSET_LOW - 1;
constant LINE_LOW   : integer := 2;
constant LINE_ZERO  : std_logic_vector(DLINE_BITS-1 downto 0) := (others => '0');

type rdatatype is (dtag, ddata, icache, memory);  -- sources during cache read
type vmasktype is (clearone, clearall, merge, tnew);	-- valid bits operation

type write_buffer_type is record			-- write buffer 
  addr, data1, data2 : std_logic_vector(31 downto 0);
  size : std_logic_vector(1 downto 0);
  asi  : std_logic_vector(3 downto 0);
  read : std_logic;
  lock : std_logic;
end record;

type dcache_control_type is record			-- all registers
  read : std_logic;					-- access direction
  signed : std_logic;					-- signed/unsigned read
  size : std_logic_vector(1 downto 0);			-- access size
  req, burst, holdn, nomds, stpend  : std_logic;
  xaddress : std_logic_vector(31 downto 0);		-- common address buffer
  faddr : std_logic_vector(DOFFSET_BITS - 1 downto 0);	-- flush address
  valid : std_logic_vector(DLINE_SIZE - 1 downto 0);	-- registered valid bits
  dstate : std_logic_vector(2 downto 0);			-- FSM vector
  hit : std_logic;
  flush		: std_logic;				-- flush in progress
  mexc 		: std_logic;				-- latched mexc
  wb 		: write_buffer_type;			-- write buffer
  asi  		: std_logic_vector(3 downto 0);
  icenable	: std_logic;				-- icache diag access

end record;

type snoop_reg_type is record			-- snoop control registers
  snoop   : std_logic;				-- snoop access to tags
  writebp : std_logic;				-- snoop write bypass
  addr 	  : std_logic_vector(TAG_HIGH downto OFFSET_LOW);-- snoop tag
end record;

type snoop_hit_reg_type is record
  hit 	  : std_logic_vector(2**DOFFSET_BITS-1 downto 0);-- snoop hit bits
  taddr	  : std_logic_vector(OFFSET_HIGH downto OFFSET_LOW);-- saved tag address
end record;

signal r, c : dcache_control_type;	-- r is registers, c is combinational
signal rs, cs : snoop_reg_type;		-- rs is registers, cs is combinational
signal rh, ch : snoop_hit_reg_type;	-- rs is registers, cs is combinational
 
begin

  dctrl : process(rst, r, rs, rh, dci, mcdo, ico, dcramo, ahbsi, fpuholdn)
  variable dcramov : dcram_out_type;
  variable rdatasel : rdatatype;
  variable maddress : std_logic_vector(31 downto 0);
  variable maddrlow : std_logic_vector(1 downto 0);
  variable edata : std_logic_vector(31 downto 0);
  variable size : std_logic_vector(1 downto 0);
  variable read : std_logic;
  variable twrite, tdiagwrite, ddiagwrite, dwrite : std_logic;
  variable taddr : std_logic_vector(OFFSET_HIGH  downto LINE_LOW); -- tag address
  variable newtag : std_logic_vector(TAG_HIGH  downto TAG_LOW); -- new tag
  variable align_data : std_logic_vector(31 downto 0); -- aligned data
  variable ddatain : std_logic_vector(31 downto 0);
  variable rdata : std_logic_vector(31 downto 0);
  variable wdata : std_logic_vector(31 downto 0);

  variable vmaskraw, vmask : std_logic_vector((DLINE_SIZE -1) downto 0);
  variable vmaskdbl : std_logic_vector((DLINE_SIZE/2 -1) downto 0);
  variable enable : std_logic;
  variable mds : std_logic;
  variable mexc : std_logic;
  variable hit, valid, validraw, forcemiss : std_logic;
  variable signed   : std_logic;
  variable flush    : std_logic;
  variable iflush   : std_logic;
  variable v : dcache_control_type;
  variable eholdn : std_logic;				-- external hold
  variable tparerr  : std_logic;
  variable dparerr  : std_logic;
  variable snoopwe  : std_logic;
  variable hcache   : std_logic;
  variable snoopaddr: std_logic_vector(OFFSET_HIGH downto OFFSET_LOW);
  variable vs : snoop_reg_type;
  variable vh : snoop_hit_reg_type;
  variable dsudata   : std_logic_vector(31 downto 0);

  begin

-- init local variables

    v := r; vs := rs; vh := rh; dcramov := dcramo;

    mds := '1'; dwrite := '0'; twrite := '0'; 
    ddiagwrite := '0'; tdiagwrite := '0'; v.holdn := '1'; mexc := '0';
    flush := '0'; v.icenable := '0'; iflush := '0';
    eholdn := ico.hold and fpuholdn;
    tparerr  := '0'; dparerr  := '0'; 
    vs.snoop := '0'; vs.writebp := '0'; snoopwe := '0';
    snoopaddr := ahbsi.haddr(OFFSET_HIGH downto OFFSET_LOW);
    hcache := '0';

    enable := '1';

    rdatasel := ddata;	-- read data from cache as default

-- AHB snoop handling

    if DSNOOP then

      -- snoop only in cacheable areas
      for i in PROC_CACHETABLE'range loop	--'
        if (ahbsi.haddr(31 downto 32-PROC_CACHE_ADDR_MSB) >= PROC_CACHETABLE(i).firstaddr) and
           (ahbsi.haddr(31 downto 32-PROC_CACHE_ADDR_MSB) <= PROC_CACHETABLE(i).lastaddr) 
        then hcache := '1';  end if;
      end loop;

      -- save snoop tag
      vs.addr := ahbsi.haddr(TAG_HIGH downto OFFSET_LOW); 
      -- snoop on NONSEQ or SEQ and first word in cache line
      -- do not snoop during own transfers or during cache flush
      if (ahbsi.hready and ahbsi.hwrite and not mcdo.bg) = '1' and
         ((ahbsi.htrans = HTRANS_NONSEQ) or 
	    ((ahbsi.htrans = HTRANS_SEQ) and 
	     (ahbsi.haddr(LINE_HIGH downto LINE_LOW) = LINE_ZERO))) 
      then
	vs.snoop := mcdo.dsnoop and hcache;
      end if;
      -- clear valid bits on snoop hit (or set hit bits)
      if ((rs.snoop and (not mcdo.ba) and not r.flush) = '1') 
          and (dcramov.dtramoutsn.tag = rs.addr(TAG_HIGH downto TAG_LOW))
      then
	if DSNOOP_FAST then
-- pragma translate_off
	  if not is_x(rs.addr(OFFSET_HIGH downto OFFSET_LOW)) then
-- pragma translate_on
	    vh.hit(conv_integer(rs.addr(OFFSET_HIGH downto OFFSET_LOW))) := '1';
-- pragma translate_off
	  end if;
-- pragma translate_on
        else
	  snoopaddr := rs.addr(OFFSET_HIGH downto OFFSET_LOW); snoopwe := '1';
        end if;
      end if;
      -- bypass tag data on read/write contention
      if (not DSNOOP_FAST) and (rs.writebp = '1') then 
	dcramov.dtramout.tag := (others => '0');
	dcramov.dtramout.valid := (others => '0');

      end if;
    end if;

-- generate access parameters during pipeline stall

    if ((r.holdn) = '0') or (DEBUG_UNIT and (dci.dsuen = '1')) then
      taddr := r.xaddress(OFFSET_HIGH downto LINE_LOW);
    elsif ((dci.enaddr and not dci.read) = '1') or (eholdn = '0')
    then
      taddr := dci.maddress(OFFSET_HIGH downto LINE_LOW);
    else
      taddr := dci.eaddress(OFFSET_HIGH downto LINE_LOW);
    end if;

    if (dci.write or not r.holdn) = '1' then
      maddress := r.xaddress(31 downto 0); signed := r.signed; 
      read := r.read; size := r.size; edata := dci.maddress;
    else
      maddress := dci.maddress(31 downto 0); signed := dci.signed; 
      read := dci.read; size := dci.size; edata := dci.edata;
    end if;

    newtag := dci.maddress(TAG_HIGH downto TAG_LOW);


-- generate cache hit and valid bits

    forcemiss := not dci.asi(3);
    if (dcramov.dtramout.tag = dci.maddress(TAG_HIGH downto TAG_LOW)) then 
      hit := (not r.flush) and not tparerr; 
    else 
      hit := '0'; 
    end if;

-- force miss on snoop hit

    if DSNOOP and DSNOOP_FAST then
-- pragma translate_off
      if not is_x(rh.taddr) then
-- pragma translate_on
        hit := hit and not rh.hit(conv_integer(rh.taddr));
-- pragma translate_off
      end if;
-- pragma translate_on
    end if;

    validraw := genmux(dci.maddress(LINE_HIGH downto LINE_LOW), 
		    dcramov.dtramout.valid);
    valid := validraw and not dparerr;
    
    if ((r.holdn and dci.enaddr) = '1')  and (r.dstate = "000") then
        v.hit := hit; v.xaddress := dci.maddress;
	v.read := dci.read; v.size := dci.size;
	v.asi := dci.asi(3 downto 0); 
	v.signed := dci.signed;
    end if;

-- Store buffer

    wdata := r.wb.data1;
    if mcdo.ready = '1' then
      v.wb.addr(2) := r.wb.addr(2) or (r.wb.size(0) and r.wb.size(1));
      if r.stpend = '1' then
        v.stpend := r.req; v.wb.data1 := r.wb.data2; 
	v.wb.lock := r.wb.lock and r.req;
      end if;
    end if;
    if mcdo.grant = '1' then v.req := r.burst; v.burst := '0'; end if;

-- main Dcache state machine

    case r.dstate is
    when "000" =>			-- Idle state
      v.nomds := r.nomds and not eholdn; v.valid := dcramov.dtramout.valid;
      if (r.stpend  = '0') or ((mcdo.ready and not r.req)= '1') then -- wait for store queue
	v.wb.addr := dci.maddress; v.wb.size := dci.size; 
	v.wb.read := dci.read; v.wb.data1 := dci.edata; v.wb.lock := dci.lock;
	v.wb.asi := dci.asi(3 downto 0); 
      end if;
      if (eholdn and (not r.nomds)) = '1' then -- avoid false path through nullify
	if dci.asi(3 downto 0) = ASI_DTAG then rdatasel := dtag; end if;
      end if;
      if (dci.enaddr and eholdn and (not r.nomds) and not dci.nullify) = '1' then
	case dci.asi(3 downto 0) is
	when ASI_ITAG | ASI_IDATA =>		-- Read/write Icache tags
	  if ico.flush = '1' then mexc := '1';
 	 else v.dstate := "101"; v.holdn := '0'; end if;
 	when ASI_IFLUSH =>		-- flush instruction cache
	  if dci.read = '0' then iflush := '1'; end if;
 	when ASI_DFLUSH =>		-- flush data cache
	  if dci.read = '0' then flush := '1'; end if;
 	when ASI_DDATA =>		-- Read/write Dcache data
 	  if (dci.size /= "10") or (r.flush = '1') then -- only word access is allowed
 	    mexc := '1';
 	  elsif (dci.read = '0') then
 	    dwrite := '1'; ddiagwrite := '1';
 	  end if;
 	when ASI_DTAG =>		-- Read/write Dcache tags
 	  if (dci.size /= "10") or (r.flush = '1') then -- allow only word access
 	    mexc := '1';
 	  elsif (dci.read = '0') then
 	    twrite := '1'; tdiagwrite := '1';
 	  end if;
	when others =>
	  if dci.read = '1' then	-- read access
	    if (not ((mcdo.dcs(0) = '1') 
	       and ((hit and valid and not forcemiss) = '1')))

	    then	-- read miss
	      v.holdn := '0'; v.dstate := "001";
	      if ((r.stpend  = '0') or ((mcdo.ready and not r.req) = '1'))
	      then	-- wait for store queue
	        v.req := '1'; 
	        v.burst := dci.size(1) and dci.size(0) and not dci.maddress(2);
              end if;
            end if;
	  else			-- write access
	    if (r.stpend  = '0') or ((mcdo.ready and not r.req)= '1') then	-- wait for store queue

	      v.req := '1'; v.stpend := '1'; 
	      v.burst := dci.size(1) and dci.size(0);

	      if (dci.size = "11") then v.dstate := "100"; end if; -- double store
	    else		-- wait for store queue
	      v.dstate := "110"; v.holdn := '0';
	    end if;
	    if (mcdo.dcs(0) = '1') and ((hit and (dci.size(1) or validraw)) = '1') 
	    then  -- write hit

	      twrite := '1'; dwrite := '1';
	    end if;
	    if (dci.size = "11") then v.xaddress(2) := '1'; end if;
	  end if;

	end case;
      end if;
    when "001" => 		-- read miss, wait for memory data
      taddr := r.xaddress(OFFSET_HIGH downto LINE_LOW);
      newtag := r.xaddress(TAG_HIGH downto TAG_LOW);
      v.nomds := r.nomds and not eholdn;
      v.holdn := v.nomds; rdatasel := memory;
      if r.stpend = '0' then

        if mcdo.ready = '1' then
          mds := r.holdn or r.nomds; v.xaddress(2) := '1'; v.holdn := '1';
          if (mcdo.dcs = "01") then 
	    v.hit := mcdo.cache and r.hit; twrite := v.hit;
          elsif (mcdo.dcs(1) = '1') then 
	    v.hit := mcdo.cache and (r.hit or not r.asi(2)); twrite := v.hit;
	  end if; 
          dwrite := twrite; rdatasel := memory;
          mexc := mcdo.mexc;

	  if r.req = '0' then

	    if (((dci.enaddr and not mds) = '1') or 
              ((dci.eenaddr and mds and eholdn) = '1')) and (mcdo.dcs(0) = '1') then
	      v.dstate := "011"; v.holdn := '0';
	    else v.dstate := "000"; end if;
	  else v.nomds := '1'; end if;
        end if;
	v.mexc := mcdo.mexc; v.wb.data2 := mcdo.data;
      else
	if ((mcdo.ready and not r.req) = '1') then	-- wait for store queue
	  v.burst := r.size(1) and r.size(0) and not r.xaddress(2);
	  v.wb.addr := r.xaddress; v.wb.size := r.size; 
	  v.wb.read := r.read; v.wb.data1 := dci.maddress; v.req := '1'; 
	  v.wb.lock := dci.lock; v.wb.asi := r.asi; 
        end if;
      end if;
    when "011" =>		-- return from read miss with load pending
      taddr := dci.maddress(OFFSET_HIGH downto LINE_LOW);
      v.dstate := "000"; 
    when "100" => 		-- second part of double store cycle
      v.dstate := "000"; v.wb.data2 := dci.edata; 
      edata := dci.edata;  -- needed for STD store hit
      taddr := r.xaddress(OFFSET_HIGH downto LINE_LOW); 
      if (mcdo.dcs(0) = '1') and (r.hit = '1') then dwrite := '1'; end if;

    when "101" =>		-- icache diag access
      rdatasel := icache; v.icenable := '1'; v.holdn := '0';
      if  ico.diagrdy = '1' then
	v.dstate := "011"; v.icenable := '0'; mds := not r.read;
      end if;

    when "110" => 		-- wait for store buffer to empty (store access)
      edata := dci.edata;  -- needed for STD store hit

      if ((mcdo.ready and not r.req) = '1') then	-- store queue emptied

	if (mcdo.dcs(0) = '1') and (r.hit = '1') and (r.size = "11") then  -- write hit
          taddr := r.xaddress(OFFSET_HIGH downto LINE_LOW); dwrite := '1';
	end if;
        v.dstate := "000"; 

	v.req := '1'; v.burst := r.size(1) and r.size(0); v.stpend := '1';

	v.wb.addr := r.xaddress; v.wb.size := r.size;
	v.wb.read := r.read; v.wb.data1 := dci.maddress;
	v.wb.lock := dci.lock; v.wb.data2 := dci.edata;
	v.wb.asi := r.asi; 
	if r.size = "11" then v.wb.addr(2) := '0'; end if;
      else  -- hold cpu until buffer empty
        v.holdn := '0';
      end if;
    when others => v.dstate := "000";
    end case;

    dsudata := (others => '0');
    if DEBUG_UNIT and dci.dsuen = '1' then
      case dci.asi(3 downto 0) is
      when ASI_ITAG | ASI_IDATA =>		-- Read/write Icache tags
	v.icenable := not ico.diagrdy;
        dsudata := ico.diagdata;
      when ASI_DTAG  => 
	if dci.write = '1' then 
	  twrite := not dci.eenaddr; tdiagwrite := '1';
	end if;
        dsudata(TAG_HIGH downto TAG_LOW) := dcramov.dtramout.tag;
        dsudata(DLINE_SIZE -1 downto 0) := dcramov.dtramout.valid;

      when ASI_DDATA =>
	if dci.write = '1' then dwrite := '1'; ddiagwrite := '1'; end if;
        dsudata := dcramov.ddramout.data;
      when others =>
      end case;
    end if;

-- select data to return on read access
-- align if byte/half word read from cache or memory.

    rdata := (others => '0');
    align_data := (others => '0');
    maddrlow := maddress(1 downto 0); -- stupid Synopsys VSS bug ...
    case rdatasel is
    when dtag	=> 
      rdata(TAG_HIGH downto TAG_LOW) := dcramov.dtramout.tag;
      rdata(DLINE_SIZE -1 downto 0) := dcramov.dtramout.valid;

    when icache => rdata := ico.diagdata;
    when ddata | memory =>
      if rdatasel = ddata then align_data := dcramov.ddramout.data;
      else align_data := mcdo.data; end if;
      case size is
      when "00" => 			-- byte read
        case maddrlow is
	when "00" => 
	  rdata(7 downto 0) := align_data(31 downto 24);
	  if signed = '1' then rdata(31 downto 8) := (others => align_data(31)); end if;
	when "01" => 
	  rdata(7 downto 0) := align_data(23 downto 16);
	  if signed = '1' then rdata(31 downto 8) := (others => align_data(23)); end if;
	when "10" => 
	  rdata(7 downto 0) := align_data(15 downto 8);
	  if signed = '1' then rdata(31 downto 8) := (others => align_data(15)); end if;
	when others => 
	  rdata(7 downto 0) := align_data(7 downto 0);
	  if signed = '1' then rdata(31 downto 8) := (others => align_data(7)); end if;
        end case;
      when "01" => 			-- half-word read
        if maddress(1) = '1' then 
	  rdata(15 downto 0) := align_data(15 downto 0);
	  if signed = '1' then rdata(31 downto 15) := (others => align_data(15)); end if;
	else
	  rdata(15 downto 0) := align_data(31 downto 16);
	  if signed = '1' then rdata(31 downto 15) := (others => align_data(31)); end if;
	end if;
      when others => 			-- single and double word read
	rdata := align_data;
      end case;
    end case;

-- select which data to update the data cache with

    case size is		-- merge data during partial write
    when "00" =>
      case maddrlow is
      when "00" =>
	ddatain := edata(7 downto 0) & dcramov.ddramout.data(23 downto 0);
      when "01" =>
	ddatain := dcramov.ddramout.data(31 downto 24) & edata(7 downto 0) & 
		     dcramov.ddramout.data(15 downto 0);
      when "10" =>
	ddatain := dcramov.ddramout.data(31 downto 16) & edata(7 downto 0) & 
		     dcramov.ddramout.data(7 downto 0);
      when others =>
	ddatain := dcramov.ddramout.data(31 downto 8) & edata(7 downto 0); 
      end case;
    when "01" =>
      if maddress(1) = '0' then
        ddatain := edata(15 downto 0) & dcramov.ddramout.data(15 downto 0);
      else
        ddatain := dcramov.ddramout.data(31 downto 16) & edata(15 downto 0);
      end if;
    when others => 
      ddatain := edata;
    end case;

-- handle double load with pipeline hold

    if (r.dstate = "000") and (r.nomds = '1') then
      rdata := r.wb.data2; mexc := r.mexc;
    end if;

-- Handle AHB retry. Re-generate bus request and burst

    if mcdo.retry = '1' then
      v.req := '1';
      v.burst := r.wb.size(0) and r.wb.size(1) and not r.wb.addr(2);
    end if;

-- Generate new valid bits

    vmaskdbl := decode(maddress(LINE_HIGH downto LINE_LOW+1));
    if (size = "11") and (read = '0') then 
      for i in 0 to (DLINE_SIZE - 1) loop vmaskraw(i) := vmaskdbl(i/2); end loop;
    else
      vmaskraw := decode(maddress(LINE_HIGH downto LINE_LOW));
    end if;

    vmask := vmaskraw;
    if r.hit = '1' then vmask := r.valid or vmaskraw; end if;
    if r.dstate = "000" then 
      vmask := dcramov.dtramout.valid or vmaskraw;

    end if;

    if (mcdo.mexc or r.flush) = '1' then twrite := '0'; dwrite := '0'; end if;
    if twrite = '1' then v.valid := vmask; end if;
    if tdiagwrite = '1' then -- diagnostic tag write
      if DEBUG_UNIT and (dci.dsuen = '1') then
        vmask := dci.maddress(DLINE_SIZE - 1 downto 0);
      else
        vmask := dci.edata(DLINE_SIZE - 1 downto 0);
      end if;
    end if;



-- cache flush

    if (dci.flush or flush or mcdo.dflush) = '1' then
      v.flush := '1'; v.faddr := (others => '0');
    end if;

    if r.flush = '1' then
      twrite := '1'; vmask := (others => '0'); v.faddr := r.faddr +1; 
      newtag(TAG_HIGH downto TAG_LOW) := (others => '0');
      taddr(OFFSET_HIGH downto OFFSET_LOW) := r.faddr;
      if (r.faddr(DOFFSET_BITS -1) and not v.faddr(DOFFSET_BITS -1)) = '1' then
	v.flush := '0';
      end if;
    end if;


-- AHB snoop handling (2), bypass write data on read/write contention

    if DSNOOP then
      if DSNOOP_FAST then
        vh.taddr := taddr(OFFSET_HIGH downto OFFSET_LOW);
	if twrite = '1' then 
-- pragma translate_off
          if not is_x(taddr(OFFSET_HIGH downto OFFSET_LOW)) then
-- pragma translate_on
	    vh.hit(conv_integer(taddr(OFFSET_HIGH downto OFFSET_LOW))) := '0';
-- pragma translate_off
          end if;
-- pragma translate_on
	end if;
      else
        if rs.addr(OFFSET_HIGH  downto OFFSET_LOW) = 
	   r.xaddress(OFFSET_HIGH  downto OFFSET_LOW) 
	then 
	  if twrite = '0' then 
            if snoopwe = '1' then vs.writebp := '1'; end if;
	  else
            if snoopwe = '1' then twrite := '0'; end if; -- avoid write/write contention
	  end if;
	end if;
      end if;
    end if;

-- update cache with memory data during read miss

    if read = '1' then ddatain := mcdo.data; end if;

-- reset

    if rst = '0' then 
      v.dstate := "000"; v.stpend  := '0'; v.req := '0'; v.burst := '0';
      v.read := '0'; v.flush := '0'; v.nomds := '0';
    end if;

-- Drive signals

    c <= v; cs <= vs;	ch <= vh; -- register inputs

    -- tag ram inputs
    dcrami.dtramin.valid    <= vmask;
    dcrami.dtramin.tag      <= newtag(TAG_HIGH downto TAG_LOW);
    dcrami.dtramin.enable   <= enable;
    dcrami.dtramin.write    <= twrite;
    dcrami.dtraminsn.enable <= vs.snoop or snoopwe;
    dcrami.dtraminsn.write  <= snoopwe;
    dcrami.dtraminsn.address<= snoopaddr;

    -- data ram inputs
    dcrami.ddramin.enable   <= enable;
    dcrami.ddramin.address  <= taddr;
    dcrami.ddramin.data     <= ddatain;
    dcrami.ddramin.write    <= dwrite;

    -- memory controller inputs
    mcdi.address  <= r.wb.addr;
    mcdi.data     <= r.wb.data1;
    mcdi.burst    <= r.burst;
    mcdi.size     <= r.wb.size;
    mcdi.read     <= r.wb.read;
    mcdi.asi      <= r.wb.asi;
    mcdi.lock     <= r.wb.lock or dci.lock;
    mcdi.req      <= r.req;
    mcdi.flush    <= r.flush;

    -- diagnostic instruction cache access
    dco.icdiag.flush  <= iflush or mcdo.iflush;
    dco.icdiag.read   <= read;
    dco.icdiag.tag    <= not r.asi(0);
    dco.icdiag.addr   <= r.xaddress;
    dco.icdiag.enable <= r.icenable;
    dco.dsudata       <= dsudata;	-- debug unit
 
    -- IU data cache inputs
    dco.data  <= rdata;
    dco.mexc  <= mexc;
    dco.hold  <= r.holdn;
    dco.mds   <= mds;
    dco.werr  <= mcdo.werr;

  end process;

-- Local registers


  reg1 : process(clk)
  begin if rising_edge(clk) then r <= c; end if; end process;
  sn2 : if DSNOOP generate
    reg2 : process(clk)
    begin if rising_edge(clk) then rs <= cs; end if; end process;
  end generate;
  sn3 : if DSNOOP_FAST generate
    reg3 : process(clk)
    begin if rising_edge(clk) then rh <= ch; end if; end process;
  end generate;

end ;

