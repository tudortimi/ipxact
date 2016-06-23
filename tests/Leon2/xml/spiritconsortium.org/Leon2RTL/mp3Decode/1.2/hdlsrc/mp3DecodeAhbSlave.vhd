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

use work.mp3DecodeFifoGrayPkg.all;

entity mp3DecodeAhbSlave is
    generic ( abits : integer := 12);
    port (
        hresetn     : in  std_logic;
        hclk        : in  std_logic;
        hsel        : in  std_logic;                          -- slave select
        haddr       : in  std_logic_vector(abits-1 downto 0);  -- address bus (byte)
        hwrite      : in  std_logic;                          -- read/write
        htrans      : in  std_logic_vector(1 downto 0);       -- transfer type
        hsize       : in  std_logic_vector(2 downto 0);       -- transfer size
        hburst      : in  std_logic_vector(2 downto 0);       -- burst type
        hwdata      : in  std_logic_vector(31 downto 0);      -- write data bus
        hprot       : in  std_logic_vector(3 downto 0);       -- protection control
        hreadyi     : in  std_logic;                          -- transfer done on any slave
        hreadyo     : out std_logic;                          -- transfer done in this slave
        hresp       : out std_logic_vector(1 downto 0);       -- response type
        hrdata      : out std_logic_vector(31 downto 0);      -- read data bus
        reg1        : out std_logic_vector(31 downto 0);      -- registered data out
        fifofull    : in  std_logic;                          -- FIFO full signal
        fifowrite   : out std_logic;                          -- write to FIFO
        fifodata    : out std_logic_vector(31 downto 0)       -- data to FIFO
    );
end; 

architecture rtl of mp3DecodeAhbSlave is

   constant REGISTERBITS: natural := 3;             -- in words
   constant DEPTH: natural := 2**(REGISTERBITS+2);  -- in bytes

   type mem_type is record
      data : std_logic_vector(31 downto 0);
   end record;

   type mem_vec_type is array (natural range <>) of mem_type;

   signal  registers: mem_vec_type (DEPTH/4-1 downto 1);

  type    state_type is (ST_CMD, ST_DATA, ST_CMD_DATA);

  type cmd_type is record
    write  : std_logic;
    read   : std_logic;
    addr   : std_logic_vector(abits-1 downto 0);
    size   : std_logic_vector(2 downto 0);
    hwdata : std_logic_vector(31 downto 0);
  end record;


  signal  nextState: state_type;
  signal  state: state_type;
  signal  command: cmd_type;
 
  signal grabcmd : std_logic;
  signal grabdata : std_logic;
  signal hreadyOut : std_logic;


begin

  hreadyo <= hreadyOut;
  fifowrite <= grabdata WHEN command.addr = "000000000000" ELSE '0';
  fifodata <= hwdata;
  reg1 <= registers(1).data;


  stateCombo : process (state, hsel, hwrite, hreadyi, command, fifofull)

  begin

  hresp <= "00";  --OK
  grabdata <= '0';
  hreadyOut <= '0';


  case (state) is

    when ST_CMD =>
      hreadyOut <= '0';
      if (hreadyi = '1') then --incomming command
	grabcmd <= '1';
      end if;
      if (hreadyi = '1' and htrans = "10" and hsel = '1') then -- NONSEQ
        nextstate <= ST_CMD_DATA;
      end if;

    when ST_CMD_DATA =>

      if (command.write = '1') then
	hreadyOut <= not fifofull;
	grabdata <= not fifofull;
      end if;
      
      if (command.read = '1') then
	hreadyOut <= '1';
      end if;
      
      if (hreadyOut = '1' and htrans = "00") then -- IDLE
        nextstate <= ST_CMD;
	grabcmd <= '1';
      end if;
      if (hreadyOut = '1' and htrans = "11") then -- SEQ continue for me
        nextstate <= ST_CMD_DATA;
	grabcmd <= '1';
      end if;
      if (hreadyOut = '1' and htrans = "10" and hsel = '1') then -- NONSEQ new transaction for me
        nextstate <= ST_CMD_DATA;
	grabcmd <= '1';
      end if;
      if (hreadyOut = '1' and htrans = "10" and hsel = '0') then -- NONSEQ new transaction not for me
	grabcmd <= '1';
        nextstate <= ST_CMD;
      end if;

    when others =>
        nextstate <= ST_CMD;
	grabdata <= '0';
	hreadyOut <= '0';

  end case;

  end process;



  readproc : process (command, registers) 
  variable addr : natural;
  begin

-- pragma translate_off
    addr := 0;
    if not is_x(command.addr) then
-- pragma translate_on
    addr := conv_integer(unsigned(command.addr(11 downto 2)));
-- pragma translate_off
    end if;
-- pragma translate_on
        
    if (addr >= registers'low and addr <= registers'high) then 
      hrdata <= registers(addr).data;
    elsif (addr = 16#3FF#) then
      hrdata <= "00000000000000000000110100000100";
    else
      hrdata <= (others => '0');
    end if;

  end process;
	


  registerProc : process (hclk, hresetn)
  variable addr : natural;
  begin
    if (hresetn = '0') then
      state <= ST_CMD;
      command.write <= '0';
      command.read <= '0';
      command.addr <= (others => '0');
      command.size <=  "000";
      command.hwdata <= (others => '0');

      for addr in 1 to DEPTH/4-1 loop
        registers(addr).data <= "00000000000000000000000000000000";
      end loop;

    elsif rising_edge(hclk) then
      state <= nextstate;
      if (grabcmd = '1') then
	command.write <= hsel and hwrite;
	command.read <= hsel and not hwrite;
	command.addr <=  haddr;
	command.size <=  hsize;
      end if;

      if (grabdata = '1') then
	command.hwdata <= hwdata;

-- pragma translate_off
	addr := 0;
	if not is_x(command.addr) then
-- pragma translate_on
	  addr := conv_integer(unsigned(command.addr(11 downto 2)));
-- pragma translate_off
	end if;
-- pragma translate_on
        
	if (addr >= registers'low and addr <= registers'high) then 
	  registers(addr).data <= hwdata;
	end if;
	
      end if;
    end if;
  end process;


end rtl; 
