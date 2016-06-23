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


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.mp3DecodeAhbSlavePkg.all;
use work.mp3DecodeFifoPkg.all;
use work.mp3DecodeCrcPkg.all;
use work.types.dac_word_type;

entity mp3Decode is
    port (
        dac_clk     : in  std_ulogic;                          -- clock to DAC
        dac_data    : out dac_word_type;                      -- data to DAC

        mp3_clk     : in  std_ulogic;
        mp3_rst_an  : in  std_ulogic;

        hresetn     : in  std_ulogic;
        hclk        : in  std_ulogic;
        hsel        : in  std_ulogic;                          -- slave select
        haddr       : in  std_ulogic_vector(11 downto 0);      -- address bus (byte)
        hwrite      : in  std_ulogic;                          -- read/write
        htrans      : in  std_ulogic_vector(1 downto 0);       -- transfer type
        hsize       : in  std_ulogic_vector(2 downto 0);       -- transfer size
        hburst      : in  std_ulogic_vector(2 downto 0);       -- burst type
        hwdata      : in  std_ulogic_vector(31 downto 0);      -- write data bus
        hprot       : in  std_ulogic_vector(3 downto 0);       -- protection control
        hreadyi     : in  std_ulogic;                          -- transfer done on any slave
        hreadyo     : out std_ulogic;                          -- transfer done in this slave
        hresp       : out std_ulogic_vector(1 downto 0);       -- response type
        hrdata      : out std_ulogic_vector(31 downto 0)       -- read data bus
    );
end; 

architecture rtl of mp3Decode is

-- synopsys translate_off
  for all: mp3DecodeAhbSlave
    use entity work.mp3DecodeAhbSlave(rtl);

  for all: mp3DecodeFifo
    use entity work.mp3DecodeFifo(rtl);
-- synopsys translate_on


    signal fifoInFull : std_logic;
    signal fifoInEmpty : std_logic;
    signal fifoOutFull : std_logic;
    signal fifoOutEmpty : std_logic;

    signal fifoInDataIn : std_logic_vector (31 downto 0);
    signal fifoInDataOut : std_logic_vector (31 downto 0);
    signal fifoOutDataIn : std_logic_vector (23 downto 0);
    signal fifoOutDataOut : std_logic_vector (23 downto 0);

    signal fifoInRead : std_logic;
    signal fifoInWrite : std_logic;
    signal fifoInWriteN : std_logic;
    signal fifoOutWrite : std_logic;

    type    state_type is (ST_IDLE, ST_WAIT_DATA, ST_PROCESS);
    signal  nextState: state_type;
    signal  state: state_type;
 
 
    signal controlReg : std_logic_vector (31 downto 0);
    signal nextcount : integer;
    signal count : integer;

    signal decompressed : std_logic_vector (23 downto 0);
    signal decompress : std_logic_vector (23 downto 0);
 
    signal hresp_slv : std_logic_vector (1 downto 0);
    signal hrdata_slv : std_logic_vector (31 downto 0);
 
begin

    fifoOutDataIn <= decompressed;
    fifoInWriteN <= not fifoInWrite;
    dac_data <= dac_word_type(fifoOutDataOut) WHEN fifoOutEmpty = '0' ELSE (others => '0');
    hresp <= std_ulogic_vector(hresp_slv);
    hrdata <= std_ulogic_vector(hrdata_slv);

    u1 : mp3DecodeAhbSlave
         generic map ( abits => 12)
            port map ( 
                hresetn   => hresetn,
                hclk      => hclk,
                hsel      => hsel, 
                haddr     => std_logic_vector(haddr), 
                hwrite    => hwrite, 
                htrans    => std_logic_vector(htrans), 
                hsize     => std_logic_vector(hsize), 
                hburst    => std_logic_vector(hburst), 
                hwdata    => std_logic_vector(hwdata), 
                hprot     => std_logic_vector(hprot), 
                hreadyi   => hreadyi,
                hreadyo   => hreadyo,
                hresp     => hresp_slv,
                hrdata    => hrdata_slv,
		reg1      => controlReg,
		fifofull  => fifoInFull,
		fifowrite => fifoInWrite,
		fifodata  => fifoInDataIn
                );

    fifoin : mp3DecodeFifo
         generic map ( FIFO_WIDTH => 32)
            port map ( 
                wr_cp     => hclk,
                nwr       => fifoInWriteN,
                rd_cp     => mp3_clk, 
                nrd       => fifoInRead, 
                nreset    => mp3_rst_an,
		di        => fifoInDataIn,
		full      => fifoInFull,
		empty     => fifoInEmpty,
		do        => fifoInDataOut);
 

    fifoout : mp3DecodeFifo
         generic map ( FIFO_WIDTH => 24)
            port map ( 
                wr_cp     => mp3_clk,
                nwr       => fifoOutWrite,
                rd_cp     => dac_clk, 
                nrd       => fifoOutEmpty,  -- read a new value if we are not empty 
                nreset    => mp3_rst_an,
		di        => fifoOutDataIn,
		full      => fifoOutFull,
		empty     => fifoOutEmpty,
		do        => fifoOutDataOut);
 

    DECOMPRESS_FF: process (mp3_clk, mp3_rst_an) 
    begin
      if (mp3_rst_an = '0') then
	state <= ST_IDLE;
	count <= 0;
	decompressed <= "000000000000000000000000";
      elsif (rising_edge(mp3_clk)) then
	if (controlReg(0) = '0') then
	  state <= ST_IDLE;
	else
	  state <= nextstate;
	  count <= nextcount;
	  decompressed <= decompress;
	end if;
      end if;
    end process;

    DECOMPRESS_CMB: process (state, fifoInDataOut, decompressed, count, fifoInEmpty, fifoOutFull,controlReg) 
    begin

      fifoOutWrite <= '1';
      fifoInRead <= '1';
      decompress <= decompressed;
      nextcount <= count;
      nextstate <= state;
      
      case (state) is

      WHEN ST_IDLE => 
        if (controlReg(0) = '1') then
	  nextstate <= ST_WAIT_DATA;
	end if;

      WHEN ST_WAIT_DATA => 
        if (fifoInEmpty = '0' and fifoOutFull = '0') then
	  nextstate <= ST_PROCESS;
	  nextcount <= 0;
	  decompress <= "001000111010101011101100";
	end if;

      WHEN ST_PROCESS => 
        if (count = 32) then
	  fifoOutWrite <= '0';
	  fifoInRead <= '0';
	  nextstate <= ST_WAIT_DATA;
	else
	  decompress <= nextCRC24_D1(fifoInDataOut(count),decompressed);
	  nextcount <= count + 1;
	end if;

      end case;
    end process;



end rtl; 
