----------------------------------------------------------------------------
-- 
-- Revision:    $Revision: 1506 $
-- Date:        $Date: 2009-04-25 23:51:56 -0700 (Sat, 25 Apr 2009) $
-- 
-- Copyright (c) 2004, 2008, 2009 The SPIRIT Consortium.
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
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use work.target.all;
use work.config.all;
use work.amba.all;
use work.iface.all;

entity leon2Proc is
  port (
    rst    : in  std_logic;
    clk    : in clk_type;			-- main clock
    clkn   : in clk_type;			-- inverted main clock
    -- apbi   : in  apb_slv_in_type;
    psel      : in   Std_Logic;                     -- slave select
    penable   : in   Std_Logic;                     -- strobe
    paddr     : in   Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite    : in   Std_Logic;                     -- write
    pwdata    : in   Std_Logic_Vector(31 downto 0); -- write data bus   
    -- apbo   : out apb_slv_out_type;
    prdata    : out  std_logic_vector(31 downto 0);
    -- ahbi   : in  ahb_mst_in_type;
    hgrant    : in  Std_ULogic;                    -- bus grant
    hready    : in  Std_ULogic;                    -- transfer done
    hresp     : in  Std_Logic_Vector(1  downto 0); -- response type
    hrdata    : in  Std_Logic_Vector(31 downto 0); -- read data bus
    -- ahbo   : out ahb_mst_out_type;
    hbusreq   : out   Std_ULogic;                    -- bus request
    hlock     : out   Std_ULogic;                    -- lock request
    htrans    : out   Std_Logic_Vector(1  downto 0); -- transfer type 
    haddr     : out   Std_Logic_Vector(31 downto 0); -- address bus (byte)
    hwrite    : out   Std_ULogic;                    -- read/write
    hsize     : out   Std_Logic_Vector(2  downto 0); -- transfer size
    hburst    : out   Std_Logic_Vector(2  downto 0); -- burst type
    hprot     : out   Std_Logic_Vector(3  downto 0); -- protection control
    hwdata    : out   Std_Logic_Vector(31 downto 0); -- write data bus
    -- ahbsi  : in  ahb_slv_in_type;
    hsel_s    : in    Std_ULogic;                         -- slave select
    haddr_s   : in    Std_Logic_Vector(31 downto 0);      -- address bus (byte)
    hwrite_s  : in    Std_ULogic;                         -- read/write
    htrans_s  : in    Std_Logic_Vector(1       downto 0); -- transfer type
    hsize_s   : in    Std_Logic_Vector(2       downto 0); -- transfer size
    hburst_s  : in    Std_Logic_Vector(2       downto 0); -- burst type
    hwdata_s  : in    Std_Logic_Vector(31 downto 0);      -- write data bus
    hprot_s   : in    Std_Logic_Vector(3       downto 0); -- protection control
    hready_s  : in    Std_ULogic;                         -- transfer done
    hmaster_s : in    Std_Logic_Vector(3       downto 0); -- current master
    hmastlock_s : in  Std_ULogic;                         -- locked access
    -- iui    : in  iu_in_type;
    irl       : in std_logic_vector(3 downto 0);  -- interrupt request level
    dsuen     : in std_logic;  			  -- DSU enable
    dbreak    : in std_logic;  			  -- debug break-in
    btrapa    : in std_logic;			  -- break on IU trap
    btrape    : in std_logic;			  -- break on IU trap
    berror    : in std_logic;			  -- break on IU error mode
    bwatch    : in std_logic;			  -- break on IU watchpoint
    bsoft     : in std_logic;			  -- break on software breakpoint (TA 1)
    rerror    : in std_logic;			  -- reset processor error mode
    step      : in std_logic;			  -- single step
    denable   : in std_logic; 			  -- diagnostic register access enable
    dwrite    : in std_logic;  			  -- read/write
    daddr     : in std_logic_vector(20 downto 2); -- diagnostic address
    ddata     : in std_logic_vector(31 downto 0); -- diagnostic data    
    -- iuo    : out iu_out_type
    error     : out std_logic;
    intack    : out std_logic;
    irqvec    : out std_logic_vector(3 downto 0);
    ipend     : out std_logic;
    dclk      : out std_logic;
    drst      : out std_logic;
    holdn     : out std_logic;
    inst_ex   : out std_logic_vector(31 downto 0);     -- instruction word
    pc_ex     : out std_logic_vector(31 downto 2);     -- program counter
    annul_ex  : out std_logic;			      -- instruction annul
    cnt_ex    : out std_logic_vector(1 downto 0);      -- cycle number (multi-cycle inst)
    ld_ex     : out std_logic;			      -- load cycle
    pv_ex     : out std_logic;			      -- PC valid
    rett_ex   : out std_logic;			      -- RETT indicator
    trap_ex   : out std_logic;			      -- trap pending flag
    tt_ex     : out std_logic_vector(5 downto 0);      -- trap type
    rd_ex     : out std_logic_vector(7 downto 0); -- destination register address
    inst_me   : out std_logic_vector(31 downto 0);     -- instruction word
    pc_me     : out std_logic_vector(31 downto 2);     -- program counter
    annul_me  : out std_logic;			      -- instruction annul
    cnt_me    : out std_logic_vector(1 downto 0);      -- cycle number (multi-cycle inst)
    ld_me     : out std_logic;			      -- load cycle
    pv_me     : out std_logic;			      -- PC valid
    rett_me   : out std_logic;			      -- RETT indicator
    trap_me   : out std_logic;			      -- trap pending flag
    tt_me     : out std_logic_vector(5 downto 0);      -- trap type
    rd_me     : out std_logic_vector(7 downto 0); -- destination register address
    inst_wr   : out std_logic_vector(31 downto 0);     -- instruction word
    pc_wr     : out std_logic_vector(31 downto 2);     -- program counter
    annul_wr  : out std_logic;			      -- instruction annul
    cnt_wr    : out std_logic_vector(1 downto 0);      -- cycle number (multi-cycle inst)
    ld_wr     : out std_logic;			      -- load cycle
    pv_wr     : out std_logic;			      -- PC valid
    rett_wr   : out std_logic;			      -- RETT indicator
    trap_wr   : out std_logic;			      -- trap pending flag
    tt_wr     : out std_logic_vector(5 downto 0);      -- trap type
    rd_wr     : out std_logic_vector(7 downto 0); -- destination register address
    write_reg : out std_logic;
    mresult   : out std_logic_vector(31 downto 0);
    result    : out std_logic_vector(31 downto 0);
    trap      : out std_logic;
    derror    : out std_logic;
    dmode     : out std_logic;
    dmode2    : out std_logic;
    vdmode    : out std_logic;
    dbreak_o  : out std_logic;
    tt        : out std_logic_vector(7 downto 0);
    psrtt     : out std_logic_vector(7 downto 0);
    psrpil    : out std_logic_vector(3 downto 0);
    diagrdy   : out std_logic;
    ddata_o   : out std_logic_vector(31 downto 0)   -- diagnostic data
  );
end;

architecture STRUCT of leon2Proc is

component proc
  port (
    rst    : in  std_logic;
    clk    : clk_type;			-- main clock
    clkn   : clk_type;			-- inverted main clock
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    ahbi   : in  ahb_mst_in_type;
    ahbo   : out ahb_mst_out_type;
    ahbsi  : in  ahb_slv_in_type;
    iui    : in  iu_in_type;
    iuo    : out iu_out_type
  );
end component;


begin

	u1: proc
		port map (
			rst => rst,
			clk => clk,
			clkn => clkn,

			apbi.psel => psel,
			apbi.penable => penable,
			apbi.paddr => paddr,
			apbi.pwrite => pwrite,
			apbi.pwdata => pwdata,

			apbo.prdata => prdata,

			ahbi.hgrant => hgrant,
			ahbi.hready => hready,
			ahbi.hresp => hresp,
			ahbi.hrdata => hrdata,

			ahbo.hbusreq => hbusreq,
			ahbo.hlock => hlock,
			ahbo.htrans => htrans,
			ahbo.haddr => haddr,
			ahbo.hwrite => hwrite,
			ahbo.hsize => hsize,
			ahbo.hburst => hburst,
			ahbo.hprot => hprot,
			ahbo.hwdata => hwdata,

			ahbsi.hsel => hsel_s,
			ahbsi.haddr => haddr_s,
			ahbsi.hwrite => hwrite_s,
			ahbsi.htrans => htrans_s,
			ahbsi.hsize => hsize_s,
			ahbsi.hburst => hburst_s,
			ahbsi.hwdata => hwdata_s,
			ahbsi.hprot => hprot_s,
			ahbsi.hready => hready_s,
			ahbsi.hmaster => hmaster_s,
			ahbsi.hmastlock => hmastlock_s,

			iui.irl => irl,
			iui.debug.dsuen => dsuen,
			iui.debug.dbreak => dbreak,
			iui.debug.btrapa => btrapa,
			iui.debug.btrape => btrape,
			iui.debug.berror => berror,
			iui.debug.bwatch => bwatch,
			iui.debug.bsoft => bsoft,
			iui.debug.rerror => rerror,
			iui.debug.step => step,
			iui.debug.denable => denable, 
			iui.debug.dwrite => dwrite,
			iui.debug.daddr => daddr,
			iui.debug.ddata => ddata,

			iuo.error => error,
			iuo.intack => intack,
			iuo.irqvec => irqvec,
			iuo.ipend => ipend,
			iuo.debug.clk => dclk,
			iuo.debug.rst => drst,
			iuo.debug.holdn => holdn,
			iuo.debug.ex.inst => inst_ex,
			iuo.debug.ex.pc => pc_ex,
			iuo.debug.ex.annul => annul_ex,
			iuo.debug.ex.cnt => cnt_ex,
			iuo.debug.ex.ld => ld_ex,
			iuo.debug.ex.pv => pv_ex,
			iuo.debug.ex.rett => rett_ex,
			iuo.debug.ex.trap => trap_ex,
			iuo.debug.ex.tt => tt_ex,
			iuo.debug.ex.rd => rd_ex,
			iuo.debug.me.inst => inst_me,
			iuo.debug.me.pc => pc_me,
			iuo.debug.me.annul => annul_me,
			iuo.debug.me.cnt => cnt_me,
			iuo.debug.me.ld => ld_me,
			iuo.debug.me.pv => pv_me,
			iuo.debug.me.rett => rett_me,
			iuo.debug.me.trap => trap_me,
			iuo.debug.me.tt => tt_me,
			iuo.debug.me.rd => rd_me,
			iuo.debug.wr.inst => inst_wr,
			iuo.debug.wr.pc => pc_wr,
			iuo.debug.wr.annul => annul_wr,
			iuo.debug.wr.cnt => cnt_wr,
			iuo.debug.wr.ld => ld_wr,
			iuo.debug.wr.pv => pv_wr,
			iuo.debug.wr.rett => rett_wr,
			iuo.debug.wr.trap => trap_wr,
			iuo.debug.wr.tt => tt_wr,
			iuo.debug.wr.rd => rd_wr,
			iuo.debug.write_reg => write_reg,
			iuo.debug.mresult => mresult,
			iuo.debug.result => result,
			iuo.debug.trap => trap,
			iuo.debug.error => derror,
			iuo.debug.dmode => dmode,
			iuo.debug.dmode2 => dmode2,
			iuo.debug.vdmode => vdmode,
			iuo.debug.dbreak => dbreak_o,
			iuo.debug.tt => tt,
			iuo.debug.psrtt => psrtt,
			iuo.debug.psrpil => psrpil,
			iuo.debug.diagrdy => diagrdy,
			iuo.debug.ddata => ddata_o
			);
end;
