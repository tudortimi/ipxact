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
-- Package:     sparcv8
-- File:        sparcv8.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Package with SPARC V8 instruction definitions
------------------------------------------------------------------------------
-- Version control:
-- 01-09-1997:  First implemetation
-- 26-09-1999:  Release 1.0
------------------------------------------------------------------------------
   
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.conv_unsigned;
use work.config.all;

package sparcv8 is

-- These are computed automatically - do not change!!
constant RSTCWP  : std_logic_vector(NWINLOG2 downto 1) := (others => '0');
constant GRFILL  : std_logic_vector(NWINLOG2 downto 0) := (others => '0');
constant CWPFILL : std_logic_vector(4 downto NWINLOG2) := (others => '0');
constant WIMFILL  : std_logic_vector(31 downto NWINDOWS) := (others => '0');
constant CWPMIN : std_logic_vector(NWINLOG2-1  downto 0) := (others => '0');
constant CWPMAX : std_logic_vector(NWINLOG2-1  downto 0) := 
	std_logic_vector(conv_unsigned(NWINDOWS-1, NWINLOG2));
constant R0ADDR : std_logic_vector(RABITS-5  downto 0) := 
	std_logic_vector(conv_unsigned(NWINDOWS + FPREG/16, RABITS-4));
constant F0ADDR : std_logic_vector(RABITS-5  downto 0) := 
	std_logic_vector(conv_unsigned(NWINDOWS, RABITS-4));

-- OP codes (INST[31..30])
constant CALL     : std_logic_vector(1 downto 0) := "01";
constant FMT2     : std_logic_vector(1 downto 0) := "00";
constant FMT3     : std_logic_vector(1 downto 0) := "10";
constant LDST     : std_logic_vector(1 downto 0) := "11";

-- OP2 codes (INST[31..30])
constant UNIMP    : std_logic_vector(2 downto 0) := "000";
constant BICC     : std_logic_vector(2 downto 0) := "010";
constant SETHI    : std_logic_vector(2 downto 0) := "100";
constant FBFCC    : std_logic_vector(2 downto 0) := "110";
constant CBCCC    : std_logic_vector(2 downto 0) := "111";

-- OP3 codes (INST[24..19])
constant IADD     : std_logic_vector(5 downto 0) := "000000";
constant IAND     : std_logic_vector(5 downto 0) := "000001";
constant IOR      : std_logic_vector(5 downto 0) := "000010";
constant IXOR     : std_logic_vector(5 downto 0) := "000011";
constant ISUB     : std_logic_vector(5 downto 0) := "000100";
constant ANDN     : std_logic_vector(5 downto 0) := "000101";
constant ORN      : std_logic_vector(5 downto 0) := "000110";
constant IXNOR    : std_logic_vector(5 downto 0) := "000111";
constant ADDX     : std_logic_vector(5 downto 0) := "001000";
constant UMUL     : std_logic_vector(5 downto 0) := "001010";
constant SMUL     : std_logic_vector(5 downto 0) := "001011";
constant SUBX     : std_logic_vector(5 downto 0) := "001100";
constant UDIV     : std_logic_vector(5 downto 0) := "001110";
constant SDIV     : std_logic_vector(5 downto 0) := "001111";
constant ADDCC    : std_logic_vector(5 downto 0) := "010000";
constant ANDCC    : std_logic_vector(5 downto 0) := "010001";
constant ORCC     : std_logic_vector(5 downto 0) := "010010";
constant XORCC    : std_logic_vector(5 downto 0) := "010011";
constant SUBCC    : std_logic_vector(5 downto 0) := "010100";
constant ANDNCC   : std_logic_vector(5 downto 0) := "010101";
constant ORNCC    : std_logic_vector(5 downto 0) := "010110";
constant XNORCC   : std_logic_vector(5 downto 0) := "010111";
constant ADDXCC   : std_logic_vector(5 downto 0) := "011000";
constant UMULCC   : std_logic_vector(5 downto 0) := "011010";
constant SMULCC   : std_logic_vector(5 downto 0) := "011011";
constant SUBXCC   : std_logic_vector(5 downto 0) := "011100";
constant UDIVCC   : std_logic_vector(5 downto 0) := "011110";
constant SDIVCC   : std_logic_vector(5 downto 0) := "011111";
constant TADDCC   : std_logic_vector(5 downto 0) := "100000";
constant TSUBCC   : std_logic_vector(5 downto 0) := "100001";
constant TADDCCTV : std_logic_vector(5 downto 0) := "100010";
constant TSUBCCTV : std_logic_vector(5 downto 0) := "100011";
constant MULSCC   : std_logic_vector(5 downto 0) := "100100";
constant ISLL     : std_logic_vector(5 downto 0) := "100101";
constant ISRL     : std_logic_vector(5 downto 0) := "100110";
constant ISRA     : std_logic_vector(5 downto 0) := "100111";
constant RDY      : std_logic_vector(5 downto 0) := "101000";
constant RDPSR    : std_logic_vector(5 downto 0) := "101001";
constant RDWIM    : std_logic_vector(5 downto 0) := "101010";
constant RDTBR    : std_logic_vector(5 downto 0) := "101011";
constant WRY      : std_logic_vector(5 downto 0) := "110000";
constant WRPSR    : std_logic_vector(5 downto 0) := "110001";
constant WRWIM    : std_logic_vector(5 downto 0) := "110010";
constant WRTBR    : std_logic_vector(5 downto 0) := "110011";
constant FPOP1    : std_logic_vector(5 downto 0) := "110100";
constant FPOP2    : std_logic_vector(5 downto 0) := "110101";
constant CPOP1    : std_logic_vector(5 downto 0) := "110110";
constant CPOP2    : std_logic_vector(5 downto 0) := "110111";
constant JMPL     : std_logic_vector(5 downto 0) := "111000";
constant TICC     : std_logic_vector(5 downto 0) := "111010";
constant FLUSH    : std_logic_vector(5 downto 0) := "111011";
constant RETT     : std_logic_vector(5 downto 0) := "111001";
constant SAVE     : std_logic_vector(5 downto 0) := "111100";
constant RESTORE  : std_logic_vector(5 downto 0) := "111101";
constant UMAC     : std_logic_vector(5 downto 0) := "111110";
constant SMAC     : std_logic_vector(5 downto 0) := "111111";

constant LD       : std_logic_vector(5 downto 0) := "000000";
constant LDUB     : std_logic_vector(5 downto 0) := "000001";
constant LDUH     : std_logic_vector(5 downto 0) := "000010";
constant LDD      : std_logic_vector(5 downto 0) := "000011";
constant LDSB     : std_logic_vector(5 downto 0) := "001001";
constant LDSH     : std_logic_vector(5 downto 0) := "001010";
constant LDSTUB   : std_logic_vector(5 downto 0) := "001101";
constant SWAP     : std_logic_vector(5 downto 0) := "001111";
constant LDA      : std_logic_vector(5 downto 0) := "010000";
constant LDUBA    : std_logic_vector(5 downto 0) := "010001";
constant LDUHA    : std_logic_vector(5 downto 0) := "010010";
constant LDDA     : std_logic_vector(5 downto 0) := "010011";
constant LDSBA    : std_logic_vector(5 downto 0) := "011001";
constant LDSHA    : std_logic_vector(5 downto 0) := "011010";
constant LDSTUBA  : std_logic_vector(5 downto 0) := "011101";
constant SWAPA    : std_logic_vector(5 downto 0) := "011111";
constant LDF      : std_logic_vector(5 downto 0) := "100000";
constant LDFSR    : std_logic_vector(5 downto 0) := "100001";
constant LDDF     : std_logic_vector(5 downto 0) := "100011";
constant LDC      : std_logic_vector(5 downto 0) := "110000";
constant LDCSR    : std_logic_vector(5 downto 0) := "110001";
constant LDDC     : std_logic_vector(5 downto 0) := "110011";

constant ST       : std_logic_vector(5 downto 0) := "000100";
constant STB      : std_logic_vector(5 downto 0) := "000101";
constant STH      : std_logic_vector(5 downto 0) := "000110";
constant ISTD     : std_logic_vector(5 downto 0) := "000111";
constant STA      : std_logic_vector(5 downto 0) := "010100";
constant STBA     : std_logic_vector(5 downto 0) := "010101";
constant STHA     : std_logic_vector(5 downto 0) := "010110";
constant STDA     : std_logic_vector(5 downto 0) := "010111";
constant STF      : std_logic_vector(5 downto 0) := "100100";
constant STFSR    : std_logic_vector(5 downto 0) := "100101";
constant STDFQ    : std_logic_vector(5 downto 0) := "100110";
constant STDF     : std_logic_vector(5 downto 0) := "100111";
constant STC      : std_logic_vector(5 downto 0) := "110100";
constant STCSR    : std_logic_vector(5 downto 0) := "110101";
constant STDCQ    : std_logic_vector(5 downto 0) := "110110";
constant STDC     : std_logic_vector(5 downto 0) := "110111";

-- BICC codes
constant BA  : std_logic_vector(3 downto 0) := "1000";

-- FPOP1
constant FITOS    : std_logic_vector(8 downto 0) := "011000100";
constant FITOD    : std_logic_vector(8 downto 0) := "011001000";
constant FSTOI    : std_logic_vector(8 downto 0) := "011010001";
constant FDTOI    : std_logic_vector(8 downto 0) := "011010010";
constant FSTOD    : std_logic_vector(8 downto 0) := "011001001";
constant FDTOS    : std_logic_vector(8 downto 0) := "011000110";
constant FMOVS    : std_logic_vector(8 downto 0) := "000000001";
constant FNEGS    : std_logic_vector(8 downto 0) := "000000101";
constant FABSS    : std_logic_vector(8 downto 0) := "000001001";
constant FSQRTS   : std_logic_vector(8 downto 0) := "000101001";
constant FSQRTD   : std_logic_vector(8 downto 0) := "000101010";
constant FADDS    : std_logic_vector(8 downto 0) := "001000001";
constant FADDD    : std_logic_vector(8 downto 0) := "001000010";
constant FSUBS    : std_logic_vector(8 downto 0) := "001000101";
constant FSUBD    : std_logic_vector(8 downto 0) := "001000110";
constant FMULS    : std_logic_vector(8 downto 0) := "001001001";
constant FMULD    : std_logic_vector(8 downto 0) := "001001010";
constant FSMULD   : std_logic_vector(8 downto 0) := "001101001";
constant FDIVS    : std_logic_vector(8 downto 0) := "001001101";
constant FDIVD    : std_logic_vector(8 downto 0) := "001001110";

-- FPOP2
constant FCMPS    : std_logic_vector(8 downto 0) := "001010001";
constant FCMPD    : std_logic_vector(8 downto 0) := "001010010";
constant FCMPES   : std_logic_vector(8 downto 0) := "001010101";
constant FCMPED   : std_logic_vector(8 downto 0) := "001010110";

-- ALU operation codes

constant ALU_AND   : std_logic_vector(2 downto 0) := "000";
constant ALU_XOR   : std_logic_vector(2 downto 0) := "001";-- must be equal to ALU_PASS2
constant ALU_OR    : std_logic_vector(2 downto 0) := "010";
constant ALU_XNOR  : std_logic_vector(2 downto 0) := "011";
constant ALU_ANDN  : std_logic_vector(2 downto 0) := "100";
constant ALU_ORN   : std_logic_vector(2 downto 0) := "101";
constant ALU_DIV   : std_logic_vector(2 downto 0) := "110";

constant ALU_PASS1 : std_logic_vector(2 downto 0) := "000";
constant ALU_PASS2 : std_logic_vector(2 downto 0) := "001";
constant ALU_STB   : std_logic_vector(2 downto 0) := "010";
constant ALU_STH   : std_logic_vector(2 downto 0) := "011";
constant ALU_ONES  : std_logic_vector(2 downto 0) := "100";
constant ALU_RDY   : std_logic_vector(2 downto 0) := "101";
constant ALU_FSR   : std_logic_vector(2 downto 0) := "110";
constant ALU_FOP   : std_logic_vector(2 downto 0) := "111";

constant ALU_SLL   : std_logic_vector(2 downto 0) := "001";
constant ALU_SRL   : std_logic_vector(2 downto 0) := "010";
constant ALU_SRA   : std_logic_vector(2 downto 0) := "100";

constant ALU_NOP   : std_logic_vector(2 downto 0) := "000";

-- ALU result select

constant ALU_RES_ADD   : std_logic_vector(1 downto 0) := "00";
constant ALU_RES_SHIFT : std_logic_vector(1 downto 0) := "01";
constant ALU_RES_LOGIC : std_logic_vector(1 downto 0) := "10";
constant ALU_RES_MISC  : std_logic_vector(1 downto 0) := "11";

-- ALU operand 2 codes

constant ALU_RS2   : std_logic := '0';
constant ALU_SIMM  : std_logic := '1';

-- Load types

constant LDBYTE    : std_logic_vector(1 downto 0) := "00";
constant LDHALF    : std_logic_vector(1 downto 0) := "01";
constant LDWORD    : std_logic_vector(1 downto 0) := "10";
constant LDDBL     : std_logic_vector(1 downto 0) := "11";

-- Trap types

constant IAEX_TT   : std_logic_vector(5 downto 0) := "000001";
constant IINST_TT  : std_logic_vector(5 downto 0) := "000010";
constant PRIV_TT   : std_logic_vector(5 downto 0) := "000011";
constant FPDIS_TT  : std_logic_vector(5 downto 0) := "000100";
constant WINOF_TT  : std_logic_vector(5 downto 0) := "000101";
constant WINUF_TT  : std_logic_vector(5 downto 0) := "000110";
constant UNALA_TT  : std_logic_vector(5 downto 0) := "000111";
constant FPEXC_TT  : std_logic_vector(5 downto 0) := "001000";
constant DAEX_TT   : std_logic_vector(5 downto 0) := "001001";
constant TAG_TT    : std_logic_vector(5 downto 0) := "001010";
constant WATCH_TT  : std_logic_vector(5 downto 0) := "001011";

constant CPDIS_TT  : std_logic_vector(5 downto 0) := "100100";
constant CPEXC_TT  : std_logic_vector(5 downto 0) := "101000";
constant DIV_TT    : std_logic_vector(5 downto 0) := "101010";
constant DSEX_TT   : std_logic_vector(5 downto 0) := "101011";
constant TICC_TT   : std_logic_vector(5 downto 0) := "111111";

-- ASI types

constant ASI_PCI     : std_logic_vector(3 downto 0) := "0100";
constant ASI_IFLUSH  : std_logic_vector(3 downto 0) := "0101";
constant ASI_DFLUSH  : std_logic_vector(3 downto 0) := "0110";
constant ASI_UINST   : std_logic_vector(3 downto 0) := "1000";
constant ASI_SINST   : std_logic_vector(3 downto 0) := "1001";
constant ASI_UDATA   : std_logic_vector(3 downto 0) := "1010";
constant ASI_SDATA   : std_logic_vector(3 downto 0) := "1011";
constant ASI_ITAG    : std_logic_vector(3 downto 0) := "1100";
constant ASI_IDATA   : std_logic_vector(3 downto 0) := "1101";
constant ASI_DTAG    : std_logic_vector(3 downto 0) := "1110";
constant ASI_DDATA   : std_logic_vector(3 downto 0) := "1111";

-- FSR ftt codes

constant FPIEEE_ERR  : std_logic_vector(2 downto 0) := "001";
constant FPSEQ_ERR   : std_logic_vector(2 downto 0) := "100";

end;



