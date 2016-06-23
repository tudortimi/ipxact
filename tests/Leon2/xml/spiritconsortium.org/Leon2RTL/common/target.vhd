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
-- Entity: 	target
-- File:	target.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	LEON target configuration package
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package target is
type targettechs is 
  (gen, virtex, atc35, atc25, fs90, umc18, tsmc25, proasic, axcel);

-- synthesis configuration
type syn_config_type is record
  targettech	: targettechs;
  infer_ram 	: boolean;	-- infer cache and dsu ram automatically 
  infer_regf 	: boolean;	-- infer regfile automatically 
  infer_rom	: boolean;	-- infer boot prom automatically
  infer_pads	: boolean;	-- infer pads automatically
  infer_mult	: boolean;	-- infer multiplier automatically
  rftype   	: integer;	-- regfile implementation option
end record;

-- processor configuration
type multypes is (none, iterative, m32x8, m16x16, m32x16, m32x32);
type divtypes is (none, radix2);
type iu_config_type is record
  nwindows	: integer;	-- # register windows (2 - 32)
  multiplier	: multypes;	-- multiplier type
  divider   	: divtypes;	-- divider type
  mac 		: boolean;	-- multiply/accumulate
  fpuen		: integer range 0 to 1;	-- FPU enable (integer due to synopsys limitations....sigh!)
  cpen		: boolean;	-- co-processor enable 
  fastjump   	: boolean;	-- enable fast jump address generation
  icchold   	: boolean;	-- enable fast branch logic
  lddelay	: integer range 1 to 2; -- # load delay cycles (1-2)
  fastdecode 	: boolean;	-- optimise instruction decoding (FPGA only)
  rflowpow   	: boolean;	-- disable regfile when not accessed
  watchpoints	: integer range 0 to 4; -- # hardware watchpoints (0-4)
  impl   	: integer range 0 to 15; -- IU implementation ID
  version	: integer range 0 to 15; -- IU version ID
end record;

-- FPU configuration
type fpucoretype  is (meiko, lth); 	 		-- FPU core type
type fpuiftype is (none, serial, parallel); 	        -- FPU interface type
type fpu_config_type is record
  core		: fpucoretype;	-- FPU core type
  interface	: fpuiftype;	-- FPU inteface type
  fregs		: integer;	-- 32 for serial interface, 0 for parallel 
  version	: integer range 0 to 7; -- FPU version ID
end record;

-- co-processor configuration
type cptype is (none, cpc); -- CP type
type cp_config_type is record
  cp		: cptype;	-- Co-processor type
  version	: integer range 0 to 7; -- CP version ID
-- add your CP-specific configuration options here!!
end record;

-- cache configuration
type dsnoop_type is (none, slow, fast); -- snoop implementation type
constant PROC_CACHE_MAX	: integer := 4;   -- maximum cacheability ranges
constant PROC_CACHE_ADDR_MSB : integer := 3; -- MSB address bits to decode cacheability
subtype proc_cache_addr_type is std_logic_vector(PROC_CACHE_ADDR_MSB-1 downto 0);
type proc_cache_config_type is record
  firstaddr	: proc_cache_addr_type;
  lastaddr	: proc_cache_addr_type;
end record;
type proc_cache_config_vector is array (Natural Range <> ) of proc_cache_config_type;
constant proc_cache_config_void : proc_cache_config_type :=
  ((others => '0'), (others => '0'));

type cache_config_type is record
  icachesize	: integer;	-- size of I-cache in Kbytes
  ilinesize	: integer;	-- # words per I-cache line
  dcachesize	: integer;	-- size of D-cache in Kbytes
  dlinesize	: integer;	-- # words per D-cache line
  dsnoop    	: dsnoop_type;	-- data-cache snooping
  cachetable 	: proc_cache_config_vector(0 to PROC_CACHE_MAX-1);
end record;

-- memory controller configuration
type mctrl_config_type is record
  bus8en    	: boolean;	-- enable 8-bit bus operation
  bus16en    	: boolean;	-- enable 16-bit bus operation
  wendfb   	: boolean;	-- enable wen feed-back to data bus drivers
  ramsel5    	: boolean;	-- enable 5th ram select
  sdramen    	: boolean;	-- enable sdram controller
  sdinvclk   	: boolean;	-- invert sdram clock
end record;

type boottype is (memory, prom, dual);
type boot_config_type is record
  boot 		: boottype;	-- select boot source
  ramrws   	: integer range 0 to 3;	-- ram read waitstates
  ramwws   	: integer range 0 to 3;	-- ram write waitstates
  sysclk   	: integer;	-- cpu clock
  baud     	: positive;	-- UART baud rate
  extbaud  	: boolean;	-- use external baud rate setting
  pabits   	: positive;	-- internal boot-prom address bits
end record;

-- PCI configuration
type pcitype is (none, insilicon, esa, actel); -- PCI core type
type pci_config_type is record
  pcicore   	: pcitype;	-- PCI core type
  ahbmasters	: integer;	-- number of ahb master interfaces
  ahbslaves 	: integer;	-- number of ahb slave interfaces
  arbiter 	: boolean;	-- enable PCI arbiter
  fixpri  	: boolean;	-- use fixed arbitration priority
  prilevels 	: integer;	-- number of priority levels in arbiter
  pcimasters	: integer;	-- number of PCI masters to be handled by arbiter
  vendorid  	: integer;	-- PCI vendor ID
  deviceid  	: integer;	-- PCI device ID
  subsysid  	: integer;	-- PCI subsystem ID
  revisionid	: integer;	-- PCI revision ID
  classcode 	: integer;	-- PCI class code
  pmepads 	: boolean;	-- enable power down pads
  p66pad  	: boolean;	-- enable PCI66 pad
  pcirstall	: boolean;	-- PCI reset affects complete processor
end record;

-- debug configuration
type debug_config_type is record
  enable    	: boolean;	-- enable debug port
  uart     	: boolean;	-- enable fast uart data to console
  iureg    	: boolean;	-- enable tracing of iu register writes
  fpureg      	: boolean;	-- enable tracing of fpu register writes
  nohalt      	: boolean;	-- dont halt on error
  pclow       	: integer;	-- set to 2 for synthesis, 0 for debug
  dsuenable    	: boolean;	-- enable DSU
  dsutrace     	: boolean;	-- enable trace buffer
  dsumixed     	: boolean;	-- enable mixed-mode trace buffer
  dsudpram     	: boolean;	-- use dual-port ram for trace buffer
  tracelines	: integer range 64 to 1024; -- # trace lines (needs 16 bytes/line)
end record;



-- AMBA configuration types
constant AHB_MST_MAX	: integer := 4;   -- maximum AHB masters
constant AHB_SLV_MAX	: integer := 7;   -- maximum AHB slaves
constant AHB_SLV_ADDR_MSB : integer := 4; -- MSB address bits to decode slaves
subtype ahb_range_addr_type is std_logic_vector(AHB_SLV_ADDR_MSB-1 downto 0);
type ahb_slv_config_type is record
  firstaddr	: ahb_range_addr_type;
  lastaddr	: ahb_range_addr_type;
  index   	: integer range 0 to AHB_SLV_MAX-1;
  split		: boolean;
  enable	: boolean;
end record;
type ahb_slv_config_vector is array (Natural Range <> ) of ahb_slv_config_type;
constant ahb_slv_config_void : ahb_slv_config_type :=
  ((others => '0'), (others => '0'), 0, false, false);



-- ---------------------------------------------------------------------------------
-- New AHB types for AHB channel, uses simple integers
type ahb_slave_config_type is record
  startaddr	: integer; 
  addrrange  	: integer;
  index   	: integer range 0 to AHB_SLV_MAX-1;
  split		: boolean;
  mstaccess  	: integer; -- bit mask for master to slave access
end record;
type ahb_slave_config_vector is array (Natural Range <> ) of ahb_slave_config_type;
constant ahb_slave_config_void : ahb_slave_config_type :=
  (0, 0, 0, false, 0);
-- ---------------------------------------------------------------------------------




type ahb_config_type is record
  masters	: integer range 1 to AHB_MST_MAX;
  defmst 	: integer range 0 to AHB_MST_MAX-1;
  split  	: boolean;	-- add support for SPLIT reponse
  slvtable 	: ahb_slv_config_vector(0 to AHB_SLV_MAX-1);
  testmod	: boolean;	-- add AHB test module (not for synthesis!)
end record;

constant APB_SLV_MAX	   : integer := 16;  -- maximum APB slaves
constant APB_SLV_ADDR_BITS : integer := 18;  -- address bits to decode APB slaves
subtype apb_range_addr_type is std_logic_vector(APB_SLV_ADDR_BITS-1 downto 0);
type apb_slv_config_type is record
  firstaddr	: apb_range_addr_type;
  lastaddr	: apb_range_addr_type;
  index   	: integer;
  enable	: boolean;
end record;
type apb_slv_config_vector is array (Natural Range <> ) of apb_slv_config_type;
constant apb_slv_config_void : apb_slv_config_type :=
  ((others => '0'), (others => '0'), 0, false);

-- ---------------------------------------------------------------------------------
-- New APB types added for APB channel, uses simple integers
type apb_slave_config_type is record
  startaddr	: integer;
  addrrange		: integer;
  index   	: integer;
end record;
type apb_slave_config_vector is array (Natural Range <> ) of apb_slave_config_type;
constant apb_slave_config_void : apb_slave_config_type :=
  (0, 0, 0);
-- ---------------------------------------------------------------------------------



type apb_config_type is record
  table    	: apb_slv_config_vector(0 to APB_SLV_MAX-1);
end record;

type irq_filter_type is (lvl0, lvl1, edge0, edge1);
type irq_filter_vec is array (0 to 31) of irq_filter_type;

type irq2type is record
  enable   	: boolean;	-- enable chained interrupt controller
  channels 	: integer;	-- number of additional interrupts (1 - 32)
  filter	: irq_filter_vec; -- irq filter definitions
end record;

type peri_config_type is record
  cfgreg   	: boolean;	-- enable LEON configuration register
  ahbstat  	: boolean;	-- enable AHB status register
  wprot  	: boolean;	-- enable RAM write-protection unit
  wdog   	: boolean;	-- enable watchdog
  irq2cfg      	: irq2type;	-- chained interrupt controller config
end record;

-- complete configuration record type
type config_type is record
  synthesis	: syn_config_type;
  iu   		: iu_config_type;
  fpu  		: fpu_config_type;
  cp  		: cp_config_type;
  cache		: cache_config_type;
  ahb  		: ahb_config_type;
  apb  		: apb_config_type;
  mctrl		: mctrl_config_type;
  boot 		: boot_config_type;
  debug		: debug_config_type;
  pci  		: pci_config_type;
  peri 		: peri_config_type;

end record;

----------------------------------------------------------------------------
-- Synthesis configurations
----------------------------------------------------------------------------

constant syn_atc25 : syn_config_type := (  
  targettech => atc25, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);
constant syn_atc35 : syn_config_type := (  
  targettech => atc35, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);
constant syn_gen  : syn_config_type := (
  targettech => gen, infer_pads => true,
  infer_ram => true, infer_regf => true, infer_rom => true,
  infer_mult => true, rftype => 1);
constant syn_virtex  : syn_config_type := (
  targettech => virtex, infer_pads => true,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => true, rftype => 2);
constant syn_virtex_blockprom  : syn_config_type := (
  targettech => virtex, infer_pads => true,
  infer_ram => false, infer_regf => false, infer_rom => false,
  infer_mult => true, rftype => 2);
constant syn_systel_asic : syn_config_type := (  
  targettech => atc25, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);
constant syn_fs90 : syn_config_type := (  
  targettech => fs90, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);
constant syn_umc18 : syn_config_type := (  
  targettech => umc18, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);
constant syn_umc18_infer : syn_config_type := (  
  targettech => umc18, infer_pads => true,
  infer_ram => true, infer_regf => true, infer_rom => true,
  infer_mult => false, rftype => 1);

constant syn_tsmc25 : syn_config_type := (
  targettech => tsmc25, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  infer_mult => false, rftype => 1);

----------------------------------------------------------------------------
-- IU configurations
----------------------------------------------------------------------------

constant iu_std : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => false, lddelay => 1, 
  fastdecode => false, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_std_mac : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => true,
  fpuen => 0, cpen => false, fastjump => true, icchold => false, lddelay => 1, 
  fastdecode => false, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpu : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 1, cpen => false, fastjump => false, icchold => false, lddelay => 1, 
  fastdecode => false, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpga : iu_config_type := (
  nwindows => 8, multiplier => none, divider => none, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpga_dsu : iu_config_type := (
  nwindows => 8, multiplier => none, divider => none, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 4, impl => 0, version => 0);
constant iu_fpga_v8 : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpga_v8_dsu : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1,
  fastdecode => true, rflowpow => false, watchpoints => 4, impl => 0, version => 0);
constant iu_fpga_v8_fpu : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 1, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpga_v8_fpu_dsu : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => false,
  fpuen => 1, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 4, impl => 0, version => 0);
constant iu_fpga_v8_mac : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => true,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_fpga_v8_small : iu_config_type := (
  nwindows => 8, multiplier => iterative, divider => radix2, mac => false,
  fpuen => 0, cpen => false, fastjump => true, icchold => true, lddelay => 1, 
  fastdecode => true, rflowpow => false, watchpoints => 0, impl => 0, version => 0);
constant iu_atc25 : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => true,
  fpuen => 0, cpen => false, fastjump => true, icchold => false, lddelay => 1, 
  fastdecode => false, rflowpow => false, watchpoints => 4, impl => 0, version => 0);
constant iu_atc25_fpu : iu_config_type := (
  nwindows => 8, multiplier => m16x16, divider => radix2, mac => true,
  fpuen => 1, cpen => false, fastjump => true, icchold => false, lddelay => 1, 
  fastdecode => false, rflowpow => false, watchpoints => 4, impl => 0, version => 0);

----------------------------------------------------------------------------
-- FPU configurations
----------------------------------------------------------------------------

constant fpu_none : fpu_config_type := 
  (core => meiko, interface => none, fregs => 0, version => 0);
constant fpu_meiko_ser: fpu_config_type := 
  (core => meiko, interface => serial, fregs => 32, version => 0);
constant fpu_lth_ser: fpu_config_type := 
  (core => lth, interface => serial, fregs => 32, version => 0);
constant fpu_meiko_par  : fpu_config_type := 
  (core => meiko, interface => parallel, fregs => 0, version => 0);

----------------------------------------------------------------------------
-- CP configurations
----------------------------------------------------------------------------

constant cp_none : cp_config_type := (cp => none, version => 0);
constant cp_cpc  : cp_config_type := (cp => cpc, version => 0);

----------------------------------------------------------------------------
-- cache configurations
----------------------------------------------------------------------------

-- standard cacheability config
constant cachetbl_std : proc_cache_config_vector(0 to PROC_CACHE_MAX-1) := (
-- first    last        function   address[31:29]
  ("000", "000"),   -- PROM area    0x0- 0x0
  ("010", "011"),   -- RAM area     0x2- 0x3
   others => proc_cache_config_void);

constant cache_1k1k : cache_config_type := ( icachesize => 1, 
  ilinesize => 4, dcachesize => 1, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_2k1k : cache_config_type := ( icachesize => 2,
  ilinesize => 4, dcachesize => 1, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_2k2k : cache_config_type := ( icachesize => 2,
  ilinesize => 4, dcachesize => 2, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_2k2k_snoop : cache_config_type := ( icachesize => 2,
  ilinesize => 4, dcachesize => 2, dlinesize => 4, dsnoop => slow,
  cachetable => cachetbl_std);
constant cache_2kl8_2kl4 : cache_config_type := ( icachesize => 2,
  ilinesize => 8, dcachesize => 2, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_4k2k : cache_config_type := ( icachesize => 4,
  ilinesize => 8, dcachesize => 2, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_1k4k : cache_config_type := ( icachesize => 1,
  ilinesize => 4, dcachesize => 4, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_4k4k : cache_config_type := ( icachesize => 4,
  ilinesize => 4, dcachesize => 4, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_4k2k_snoop_slow : cache_config_type := ( icachesize => 4,
  ilinesize => 4, dcachesize => 2, dlinesize => 4, dsnoop => slow,
  cachetable => cachetbl_std);
constant cache_4k4k_snoop_slow : cache_config_type := ( icachesize => 4,
  ilinesize => 4, dcachesize => 4, dlinesize => 4, dsnoop => slow,
  cachetable => cachetbl_std);
constant cache_4k4k_snoop_fast : cache_config_type := ( icachesize => 4,
  ilinesize => 4, dcachesize => 4, dlinesize => 4, dsnoop => fast,
  cachetable => cachetbl_std);
constant cache_8k8k : cache_config_type := ( icachesize => 8,
  ilinesize => 8, dcachesize => 8, dlinesize => 4, dsnoop => none,
  cachetable => cachetbl_std);
constant cache_8k8k_snoop : cache_config_type := ( icachesize => 8,
  ilinesize => 8, dcachesize => 8, dlinesize => 4, dsnoop => slow,
  cachetable => cachetbl_std);
constant cache_16k16k_snoop : cache_config_type := ( icachesize => 16,
  ilinesize => 8, dcachesize => 16, dlinesize => 4, dsnoop => slow,
  cachetable => cachetbl_std);

----------------------------------------------------------------------------
-- Memory controller configurations
----------------------------------------------------------------------------

constant mctrl_std : mctrl_config_type := ( bus8en => true, bus16en => true, 
  wendfb => true, ramsel5 => true, sdramen => false, sdinvclk => false);
constant mctrl_mem32 : mctrl_config_type := ( bus8en => false, bus16en => false, 
  wendfb => true, ramsel5 => true, sdramen => false, sdinvclk => false);
constant mctrl_mem16 : mctrl_config_type := ( bus8en => false, bus16en => true,
  wendfb => true, ramsel5 => true, sdramen => false, sdinvclk => false);
constant mctrl_sdram : mctrl_config_type := ( bus8en => true, bus16en => true,
  wendfb => false, ramsel5 => false, sdramen => true, sdinvclk => false);
constant mctrl_sdram_invclk : mctrl_config_type := ( bus8en => true, bus16en => true,
  wendfb => false, ramsel5 => false, sdramen => true, sdinvclk => true);

----------------------------------------------------------------------------
-- boot configurations
----------------------------------------------------------------------------

constant boot_mem : boot_config_type := (boot => memory, ramrws => 0,
  ramwws => 0, sysclk => 1000000, baud => 19200, extbaud => false,
  pabits => 8);
constant boot_pmon : boot_config_type := (boot => prom, ramrws => 0,
  ramwws => 0, sysclk => 24576000, baud => 38400, extbaud=> false,
  pabits => 8);
constant boot_rdbmon : boot_config_type := (boot => prom, ramrws => 0,
  ramwws => 0, sysclk => 24576000, baud => 38400, extbaud=> false,
  pabits => 11);
constant boot_prom_xess16 : boot_config_type := (boot => prom, ramrws => 0,
  ramwws => 0, sysclk => 25000000, baud => 38400, extbaud=> false,
  pabits => 8);

----------------------------------------------------------------------------
--  PCI configurations
----------------------------------------------------------------------------
-- NOTE: 0x16E3 is ESA vendor ID - do NOT use without authorisation!!
-- NOTE: 0x1438 is ATMEL vendor ID - do NOT use without authorisation!!

constant pci_none : pci_config_type := (
  pcicore => none, ahbmasters => 0, ahbslaves => 0,
  arbiter => false, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#16E3#, deviceid => 16#1E0F#, subsysid => 16#2103#,
  revisionid => 16#01#, classcode =>16#00000B#, pmepads => false,
  p66pad => false, pcirstall => false);
constant pci_insilicon : pci_config_type := (
  pcicore => insilicon, ahbmasters => 2, ahbslaves => 1,
  arbiter => true, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#16E3#, deviceid => 16#1E0F#, subsysid => 16#2103#,
  revisionid => 16#01#, classcode =>16#00000B#, pmepads => false,
  p66pad => false, pcirstall => false);
constant pci_insilicon_noarb : pci_config_type := (
  pcicore => insilicon, ahbmasters => 2, ahbslaves => 1,
  arbiter => false, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#16E3#, deviceid => 16#1E0F#, subsysid => 16#2103#,
  revisionid => 16#01#, classcode =>16#00000B#, pmepads => false,
  p66pad => false, pcirstall => false);
constant pci_actelif : pci_config_type := (
  pcicore => actel, ahbmasters => 1, ahbslaves => 1,
  arbiter => false, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#16E3#, deviceid => 16#0001#, subsysid => 16#0000#,
  revisionid => 16#01#, classcode =>16#0B5000#, pmepads => false,
  p66pad => false, pcirstall => false);
constant pci_esaif : pci_config_type := (
  pcicore => esa, ahbmasters => 1, ahbslaves => 1,
  arbiter => true, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#16E3#, deviceid => 16#0BAD#, subsysid => 16#0ACE#,
  revisionid => 16#01#, classcode =>16#00000B#, pmepads => false,
  p66pad => false, pcirstall => false);
-- In-Silicon PCI core in ATMEL configuration
constant pci_atmel : pci_config_type := (
  pcicore => insilicon, ahbmasters => 2, ahbslaves => 1,
  arbiter => true, fixpri => false, prilevels => 4, pcimasters => 4,
  vendorid => 16#1438#, deviceid => 16#1E0F#, subsysid => 16#2103#,
  revisionid => 16#01#, classcode =>16#00000B#, pmepads => false,
  p66pad => false, pcirstall => false);


----------------------------------------------------------------------------
--  Peripherals configurations
----------------------------------------------------------------------------

constant irq2none : irq2type := ( enable => false, channels => 32,
  filter => (others => lvl1));
constant irq2chan4 : irq2type := ( enable => true, channels => 4,
  filter => (lvl1, lvl1, edge0, edge1, others => lvl0));
constant peri_std : peri_config_type := (
  cfgreg => true, ahbstat => true, wprot => true, wdog => true, 
  irq2cfg => irq2none);
constant peri_fpga : peri_config_type := (
  cfgreg => true, ahbstat => false, wprot => false, wdog => false, 
  irq2cfg => irq2none);
constant peri_irq2 : peri_config_type := (
  cfgreg => true, ahbstat => false, wprot => false, wdog => false, 
  irq2cfg => irq2chan4);

----------------------------------------------------------------------------
-- Debug configurations
----------------------------------------------------------------------------

constant debug_none : debug_config_type := ( enable => false, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2,
  dsuenable => false, dsutrace => false, dsumixed => false,
  dsudpram => false, tracelines => 128);
constant debug_disas : debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2,
  dsuenable => false, dsutrace => false, dsumixed => false,
  dsudpram => false, tracelines => 128);
constant debug_dsu : debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2,
  dsuenable => true, dsutrace => true, dsumixed => true,
  dsudpram => true, tracelines => 128);
constant debug_atc25 : debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2,
  dsuenable => true, dsutrace => true, dsumixed => true,
  dsudpram => true, tracelines => 256);
constant debug_umc: debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2,
  dsuenable => true, dsutrace => true, dsumixed => true,
  dsudpram => false, tracelines => 256);
constant debug_msp : debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => true, pclow => 2,
  dsuenable => true, dsutrace => true, dsumixed => true,
  dsudpram => true, tracelines => 256);
constant debug_uart : debug_config_type := ( enable => true, uart => true, 
  iureg => false, fpureg => false, nohalt => false, pclow => 0,
  dsuenable => false, dsutrace => false, dsumixed => false,
  dsudpram => false, tracelines => 128);
constant debug_fpu : debug_config_type := ( enable => true, uart => true, 
  iureg => false, fpureg => true, nohalt => false, pclow => 2,
  dsuenable => false, dsutrace => false, dsumixed => false,
  dsudpram => false, tracelines => 128);
constant debug_all  : debug_config_type := ( enable => true, uart => true, 
  iureg => true, fpureg => true, nohalt => false, pclow => 0,
  dsuenable => false, dsutrace => false, dsumixed => false,
  dsudpram => false, tracelines => 128);

----------------------------------------------------------------------------
-- Amba AHB configurations
----------------------------------------------------------------------------

-- standard slave config
constant ahbslvcfg_std : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 256 MB   0x8- 0x8
   others => ahb_slv_config_void);

-- DSU config
constant ahbslvcfg_dsu : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1001", "1001",  2,   false, true), -- DSU         128 MB   0x9- 0x9
  ("1010", "1010",  4,   false, false),-- TEST module          0xA- 0xA
   others => ahb_slv_config_void);

-- PCI slave config
constant ahbslvcfg_pci : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1001", "1001",  2,   false, false),-- DSU         128 MB   0x9- 0x9
  ("1010", "1111",  3,   false, true), -- PCI initiator        0xA- 0xF
   others => ahb_slv_config_void);

-- PCI+DSU slave config
constant ahbslvcfg_pci_dsu : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1001", "1001",  2,   false, true), -- DSU         128 MB   0x9- 0x9
  ("1010", "1111",  3,   false, true), -- PCI initiator        0xA- 0xF
   others => ahb_slv_config_void);

-- AHB test+DSU slave config
constant ahbslvcfg_test : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1001", "1001",  2,   false, true), -- DSU         128 MB   0x9- 0x9
  ("1010", "1010",  5,   true , true), -- TEST module          0xA- 0xA
   others => ahb_slv_config_void);

-- standard config record
constant ahb_std : ahb_config_type := (	masters => 1, defmst => 0,
  split => false, slvtable => ahbslvcfg_std, testmod => false);
-- FPGA config record
constant ahb_fpga : ahb_config_type := (masters => 1, defmst => 0,
  split => false, slvtable => ahbslvcfg_std, testmod => false);
-- Insilicon PCI core config record (uses two AHB master interfaces)
constant ahb_is_pci : ahb_config_type := ( masters => 3, defmst => 0,
  split => false, slvtable => ahbslvcfg_pci, testmod => false);
-- Insilicon PCI core config record (uses two AHB master interfaces)
constant ahb_is_pci_dsu : ahb_config_type := ( masters => 4, defmst => 0,
  split => false, slvtable => ahbslvcfg_pci_dsu, testmod => false);
-- Actel PCI core config record (uses one AHB master insteface)
constant ahb_act_pci_dsu : ahb_config_type := ( masters => 4, defmst => 0,
  split => false, slvtable => ahbslvcfg_pci_dsu, testmod => false);
-- ESTEC PCI core config record (uses one AHB master insteface)
constant ahb_esa_pci : ahb_config_type := ( masters => 2, defmst => 0,
  split => false, slvtable => ahbslvcfg_pci, testmod => false);
-- AHB DSU config
constant ahb_dsu : ahb_config_type := ( masters => 2, defmst => 0,
  split => false, slvtable => ahbslvcfg_dsu, testmod => false);
-- AHB TEST config
constant ahb_test : ahb_config_type := ( masters => 3, defmst => 0,
  split => true, slvtable => ahbslvcfg_test, testmod => true);

----------------------------------------------------------------------------
-- Amba APB configurations
----------------------------------------------------------------------------

-- standard config
constant apbslvcfg_std : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "000000000000000000", "000000000000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "000000000000001100", "000000000000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "000000000000010100", "000000000000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "000000000000011100", "000000000000100000",  3,   true), -- write protection,  0x1C - 0x20
( "000000000000100100", "000000000000100100",  4,   true), -- config register,   0x24 - 0x24
( "000000000001000000", "000000000001101100",  5,   true), -- timers,            0x40 - 0x6C
( "000000000001110000", "000000000001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "000000000010000000", "000000000010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "000000000010010000", "000000000010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "000000000010100000", "000000000010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "000000000010110000", "000000000010111100", 10,   false),-- 2nd interrupt ctrl 0xB0 - 0xBC
( "000000000011000000", "000000000011001100", 11,   false),-- DSU uart           0xC0 - 0xCC
( "000000000100000000", "000000000111111100", 12,   false),-- PCI configuration  0x100- 0x1FC
( "000000001000000000", "000000001011111100", 13,   false),-- PCI arbiter        0x200- 0x2FC
  others => apb_slv_config_void);

-- standard config with secondary interrupt controller
constant apbslvcfg_irq2 : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "000000000000000000", "000000000000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "000000000000001100", "000000000000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "000000000000010100", "000000000000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "000000000000011100", "000000000000100000",  3,   true), -- write protection,  0x1C - 0x20
( "000000000000100100", "000000000000100100",  4,   true), -- config register,   0x24 - 0x24
( "000000000001000000", "000000000001101100",  5,   true), -- timers,            0x40 - 0x6C
( "000000000001110000", "000000000001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "000000000010000000", "000000000010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "000000000010010000", "000000000010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "000000000010100000", "000000000010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "000000000010110000", "000000000010111100", 10,   true), -- 2nd interrupt ctrl 0xB0 - 0xBC
( "000000000011000000", "000000000011001100", 11,   false),-- DSU uart           0xC0 - 0xCC
( "000000000100000000", "000000000111111100", 12,   false),-- PCI configuration  0x100- 0x1FC
( "000000001000000000", "000000001011111100", 13,   false),-- PCI arbiter        0x200- 0x2FC
  others => apb_slv_config_void);

-- PCI config
constant apbslvcfg_pci : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "000000000000000000", "000000000000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "000000000000001100", "000000000000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "000000000000010100", "000000000000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "000000000000011100", "000000000000100000",  3,   true), -- write protection,  0x1C - 0x20
( "000000000000100100", "000000000000100100",  4,   true), -- config register,   0x24 - 0x24
( "000000000001000000", "000000000001101100",  5,   true), -- timers,            0x40 - 0x6C
( "000000000001110000", "000000000001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "000000000010000000", "000000000010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "000000000010010000", "000000000010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "000000000010100000", "000000000010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "000000000010110000", "000000000010111100", 10,   false),-- 2nd interrupt ctrl 0xB0 - 0xBC
( "000000000011000000", "000000000011001100", 11,   false),-- DSU uart           0xC0 - 0xCC
( "000000000100000000", "000000000111111100", 12,   true), -- PCI configuration  0x100- 0x1FC
( "000000001000000000", "000000001011111100", 13,   true), -- PCI arbiter        0x200- 0x2FC
  others => apb_slv_config_void);

-- DSU config
constant apbslvcfg_dsu : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "000000000000000000", "000000000000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "000000000000001100", "000000000000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "000000000000010100", "000000000000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "000000000000011100", "000000000000100000",  3,   true), -- write protection,  0x1C - 0x20
( "000000000000100100", "000000000000100100",  4,   true), -- config register,   0x24 - 0x24
( "000000000001000000", "000000000001101100",  5,   true), -- timers,            0x40 - 0x6C
( "000000000001110000", "000000000001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "000000000010000000", "000000000010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "000000000010010000", "000000000010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "000000000010100000", "000000000010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "000000000010110000", "000000000010111100", 10,   false),-- 2nd interrupt ctrl 0xB0 - 0xBC
( "000000000011000000", "000000000011001100", 11,   true), -- DSU uart           0xC0 - 0xCC
( "000000000100000000", "000000000111111100", 12,   false),-- PCI configuration  0x100- 0x1FC
( "000000001000000000", "000000001011111100", 13,   false),-- PCI arbiter        0x200- 0x2FC
  others => apb_slv_config_void);

-- DSU + PCI config
constant apbslvcfg_dsu_pci : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "000000000000000000", "000000000000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "000000000000001100", "000000000000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "000000000000010100", "000000000000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "000000000000011100", "000000000000100000",  3,   true), -- write protection,  0x1C - 0x20
( "000000000000100100", "000000000000100100",  4,   true), -- config register,   0x24 - 0x24
( "000000000001000000", "000000000001101100",  5,   true), -- timers,            0x40 - 0x6C
( "000000000001110000", "000000000001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "000000000010000000", "000000000010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "000000000010010000", "000000000010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "000000000010100000", "000000000010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "000000000010110000", "000000000010111100", 10,   false),-- 2nd interrupt ctrl 0xB0 - 0xBC
( "000000000011000000", "000000000011001100", 11,   true), -- DSU uart           0xC0 - 0xCC
( "000000000100000000", "000000000111111100", 12,   true), -- PCI configuration  0x100- 0x1FC
( "000000001000000000", "000000001011111100", 13,   true), -- PCI arbiter        0x200- 0x2FC
  others => apb_slv_config_void);

constant apb_std  : apb_config_type := (table => apbslvcfg_std);
constant apb_irq2 : apb_config_type := (table => apbslvcfg_irq2);
constant apb_pci  : apb_config_type := (table => apbslvcfg_pci);
constant apb_dsu  : apb_config_type := (table => apbslvcfg_dsu);
constant apb_dsu_pci   : apb_config_type := (table => apbslvcfg_dsu_pci);

----------------------------------------------------------------------------
-- Pre-defined LEON configurations
----------------------------------------------------------------------------

-- Any FPGA, 2 + 2 Kbyte cache
constant fpga_2k2k : config_type := (
  synthesis => syn_gen, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none, 

  peri => peri_fpga);


-- Any FPGA, 2 + 2 Kbyte cache, mul/div
constant fpga_2k2k_v8 : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none, 

  peri => peri_fpga);


-- Any FPGA, 2 + 2 Kbyte cache, secondary irq controller (test only)
constant fpga_2k2k_irq2 : config_type := (
  synthesis => syn_gen, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_irq2, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_irq2);


-- Any FPGA, 2 + 2 Kbyte cache, inferred boot-prom
constant fpga_2k2k_softprom : config_type := (
  synthesis => syn_gen, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- Any FPGA, 2 + 2 Kbyte cache, inferred boot-prom, mul/div
constant fpga_2k2k_v8_softprom : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- Any FPGA, 4 + 4 Kbyte cache, mul/div, fpu
constant fpga_4k4k_v8_fpu : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8_fpu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- Any FPGA, 4 + 4 Kbyte cache, inferred boot-prom, mul/div, fpu
constant fpga_4k4k_v8_fpu_softprom : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8_fpu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- Any FPGA, 2 + 2 Kbyte cache, inferred boot-prom, mul/div, MAC
constant fpga_2k2k_v8_mac_softprom : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8_mac, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 2 + 2 Kbyte cache, hard boot-prom
constant virtex_2k2k_blockprom : config_type := (
  synthesis => syn_virtex_blockprom, iu => iu_fpga_v8_fpu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 2 + 1 Kbyte cache, hard boot-prom with rdbmon
constant virtex_2k1k_rdbmon : config_type := (
  synthesis => syn_virtex_blockprom, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k1k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_rdbmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 2 + 2 Kbyte cache, hard boot-prom, mul/div
constant virtex_2k2k_v8_blockprom : config_type := (
  synthesis => syn_virtex_blockprom, iu => iu_fpga_v8, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_std,
  boot => boot_pmon, debug => debug_disas, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 4 + 2 Kbyte cache, snoop, DSU
constant virtex_4k2k_dsu : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_4k2k_snoop_slow, ahb => ahb_test, apb => apb_dsu, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_dsu, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 4 + 2 Kbyte cache, snoop, DSU, sdram
constant virtex_4k2k_dsu_sdram : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_4k2k_snoop_slow, ahb => ahb_dsu, apb => apb_dsu, 
  mctrl => mctrl_sdram, boot => boot_mem, debug => debug_dsu, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 4 + 2 Kbyte cache, snoop, DSU, sdram
constant virtex_4k2k_dsu_sdram_invclk : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_4k2k_snoop_slow, ahb => ahb_dsu, apb => apb_dsu, 
  mctrl => mctrl_sdram_invclk, boot => boot_mem, debug => debug_dsu, pci => pci_none,

  peri => peri_fpga);



-- VIRTEX, 8 + 8 Kbyte cache, snoop, DSU, Actel PCI, SDRAM with invclk
constant virtex_8k8k_dsu_pci_actel_sdram : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_act_pci_dsu, apb => apb_dsu_pci, 
  mctrl => mctrl_sdram_invclk, boot => boot_mem, debug => debug_dsu,
  pci => pci_actelif,

  peri => peri_fpga);


-- VIRTEX, 8 + 8 Kbyte cache, snoop, DSU, Actel PCI, SDRAM with invclk, V8, FPU
constant virtex_8k8k_dsu_pci_actel_sdram_v8_fpu : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_v8_fpu_dsu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_act_pci_dsu, apb => apb_dsu_pci, 
  mctrl => mctrl_sdram_invclk, boot => boot_mem, debug => debug_dsu,
  pci => pci_actelif,

  peri => peri_fpga);


-- VIRTEX, 8 + 8 Kbyte cache, snoop, DSU, Insilicon PCI, SDRAM, v8, FPU
constant virtex_8k8k_dsu_pci_is_sdram_invclk : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_v8_fpu_dsu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_is_pci_dsu, apb => apb_dsu_pci,
  mctrl => mctrl_sdram_invclk, boot => boot_mem, debug => debug_dsu, pci => pci_insilicon_noarb,

  peri => peri_fpga);


-- VIRTEX, 4 + 2 Kbyte cache, snoop, DSU, Actel PCI
constant virtex_4k2k_dsu_pci : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_4k2k_snoop_slow, ahb => ahb_act_pci_dsu, apb => apb_dsu_pci, mctrl => mctrl_mem32,
  boot => boot_mem, debug => debug_dsu, pci => pci_actelif,

  peri => peri_fpga);


-- VIRTEX, 4 + 2 Kbyte cache, snoop, DSU
constant virtex_4k2k_v8_dsu : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_v8_dsu, fpu => fpu_none, cp => cp_none,
  cache => cache_4k2k_snoop_slow, ahb => ahb_dsu, apb => apb_dsu, mctrl => mctrl_mem32,
  boot => boot_mem, debug => debug_dsu, pci => pci_none,

  peri => peri_fpga);


-- VIRTEX, 2 + 2 Kbyte cache, snoop, DSU, V8, FPU
constant virtex_2k2k_v8_fpu_dsu : config_type := (
  synthesis => syn_virtex, iu => iu_fpga_v8_fpu_dsu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_2k2k_snoop, ahb => ahb_dsu, apb => apb_dsu, mctrl => mctrl_mem32,
  boot => boot_mem, debug => debug_dsu, pci => pci_none,

  peri => peri_fpga);


-- synthesis targetting ATC25 asic lib
constant gen_atc25 : config_type := (
  synthesis => syn_atc25, iu => iu_atc25, fpu => fpu_none, cp => cp_none,
  cache => cache_8k8k, ahb => ahb_dsu, apb => apb_dsu, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_atc25, pci => pci_none,

  peri => peri_std);


constant gen_atc25_snoop : config_type := (
  synthesis => syn_atc25, iu => iu_atc25, fpu => fpu_none, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_dsu, apb => apb_dsu, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_msp, pci => pci_none,

  peri => peri_std);


-- synthesis targetting ATC25 asic lib, serial Meiko FPU
constant gen_atc25_meiko : config_type := (
  synthesis => syn_atc25, iu => iu_atc25_fpu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_8k8k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


-- synthesis targetting ATC25 asic lib, parallel FPU
constant gen_atc25_fpc : config_type := (
  synthesis => syn_atc25, iu => iu_atc25_fpu, fpu => fpu_meiko_par, cp => cp_none,
  cache => cache_8k8k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


-- synthesis targetting ATC25 asic lib + Insilicon PCI core
constant gen_atc25_insilicon_pci : config_type := (
  synthesis => syn_atc25, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_is_pci, apb => apb_pci, 
  mctrl => mctrl_std, boot => boot_mem, debug => debug_disas, pci => pci_atmel,

  peri => peri_std);


-- synthesis targetting ATC25 asic lib, Meiko FPU, PCI
constant gen_atc25_meiko_pci : config_type := (
  synthesis => syn_atc25, iu => iu_atc25_fpu, fpu => fpu_meiko_ser, cp => cp_none,
  cache => cache_8k8k_snoop, ahb => ahb_is_pci_dsu, apb => apb_dsu_pci, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_atc25, pci => pci_atmel,

  peri => peri_std);




-- synthesis targetting ATC35 asic lib, synopsys
constant gen_atc35 : config_type := (
  synthesis => syn_atc35, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


-- Systel FPGA configuration
constant systel_fpga : config_type := (
  synthesis => syn_gen, iu => iu_fpga_v8, fpu => fpu_none, cp => cp_none,
  cache => cache_1k1k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


-- Systel ASIC configuration
constant systel_asic : config_type := (
  synthesis => syn_systel_asic, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_1k1k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


-- synthesis targetting UMC FS90A/B asic lib
constant gen_fs90 : config_type := (
  synthesis => syn_fs90, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);

-- synthesis targetting UMC18 asic lib, synopsys + AMBIT
constant gen_umc18 : config_type := (
  synthesis => syn_umc18, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


constant gen_tsmc25_4k4k : config_type := (
  synthesis => syn_tsmc25, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


constant gen_tsmc25_8k8k : config_type := (
  synthesis => syn_tsmc25, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_8k8k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_sdram,
  boot => boot_mem, debug => debug_disas, pci => pci_none,

  peri => peri_std);


type leon_config_vector is array (Natural Range <> ) of config_type;

constant leon_config_table : leon_config_vector(0 to 8) := (
  fpga_2k2k, fpga_2k2k_v8, fpga_2k2k_irq2, fpga_2k2k_softprom,
  fpga_2k2k_v8_softprom, fpga_4k4k_v8_fpu, virtex_4k2k_dsu, 
  virtex_4k2k_v8_dsu, gen_atc25_snoop
); 

constant def_cfgindex : integer := 7;
end;
