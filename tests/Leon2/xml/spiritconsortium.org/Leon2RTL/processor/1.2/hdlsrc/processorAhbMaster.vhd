--
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Std_Logic_TEXTIO.all;
library Std;
use Std.TextIO.all;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.processorPackage.all;


entity processorAhbMaster is
  generic (
      local_memory_start_addr : integer := 16#1000#;      -- upper 16 bits of address
      local_memory_addr_bits  : integer := 12;            -- number of address bits
      code_file	              : string  := "master.tbl"   -- file to read commans from
  );
port (hclk:       in     std_logic;
      hresetn:    in     std_logic;
      hready:     in     std_logic;
      hresp:      in     std_logic_vector(1 downto 0);
      haddr:      out    std_logic_vector(31 downto 0);
      hwrite:     out    std_logic;
      hsize:      out    std_logic_vector(2 downto 0);
      htrans:     out    std_logic_vector(1 downto 0);
      hburst:     out    std_logic_vector(2 downto 0);
      hprot:      out    std_logic_vector(3 downto 0);
      hwdata:     out    std_logic_vector(31 downto 0);
      hrdata:     in     std_logic_vector(31 downto 0);
      hgrant:     in     std_logic;
      hbusreq:    out    std_logic;
      failures:   out    std_logic_vector(31 downto 0);
      SimDone:    out    std_logic
      );
end processorAhbMaster;

-- -----------------------------------------------------------------------------
architecture bfm of processorAhbMaster is
-- -----------------------------------------------------------------------------

   constant fileIn: string := code_file;
   constant zero32: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
   constant one32: std_logic_vector (31 downto 0) := "11111111111111111111111111111111";

   constant LOCALMEMORYADDR: std_logic_vector (31 downto 0) := conv_std_logic_vector(local_memory_start_addr,16) & "0000000000000000";
   constant LOCALMEMORYBITS: natural := local_memory_addr_bits+2;  -- number of address bits
   constant LOCALMEMORYSIZE: natural := 2**LOCALMEMORYBITS; -- number of memory locations
   constant MAXCOMMANDS: natural := 256;

-- define state machine states
   type    cmd_type is (NOP, READ, WRITE, IDLE, CMT);
   type    state_type is (ST_RESET, ST_CMD, ST_INTERNAL, ST_IDLE, ST_REQUEST, ST_ADDR, ST_DATA);

   
   type data_type is record
      cmd  : cmd_type;
      addr : std_logic_vector(31 downto 0);
      idle : integer;
      data : std_logic_vector(31 downto 0);
      mask : std_logic_vector(31 downto 0);
      comment : string(1 to 128);
   end record;

   type data_file_type is file of data_type;

   type data_vec_type is array (natural range <>) of data_type;

   signal  nextState: state_type;
   signal  state: state_type;
   signal  lasthresp: std_logic_vector(1 downto 0);
   signal  start: std_logic;
   signal  nextSimDone: std_logic;
   signal  regSimDone: std_logic;
   signal  getNextCommand: std_logic;
   signal  transaction: data_type;
   signal  idleCount: integer;
   signal  nextIdleCount: integer;
   signal  fails: integer;

   -- localMemoryMap
   type mem_type is record
      data : std_logic_vector(31 downto 0);
   end record;

   type mem_vec_type is array (natural range <>) of mem_type;

   signal  memory: mem_vec_type (LOCALMEMORYSIZE/4-1 downto 0);


--   Table format (address and data values in HEX) (comments start with --)
--   R Address Data <MASK>
--   W Address Data
--   I Clocks 
  procedure readFile (
    fileName : in string;
    variable data : out data_vec_type (MAXCOMMANDS downto 0);
    variable numberOfCommands : out integer) is

    variable tmpdata : data_type;
    variable  L: line;
    variable  LS: line;
    variable  S: string (1 to 2);
    variable  lineCount: integer;
    variable  i: integer;
    variable status : file_open_status;
    variable c, previousc : character;
    variable comment : boolean;
    variable mask : boolean;
    variable start : boolean;
    FILE vector_file : text open read_mode is fileName;
  begin

    file_open(status, vector_file, fileName, read_mode);
    lineCount := 0;

    while not endfile(vector_file) loop

      loop 
	readline(vector_file, L);
	exit when (L'length > 0);
      end loop;

      -- Read the command
      read(L, c);
      case c is
        when 'R' => tmpdata.cmd := READ;
        when 'W' => tmpdata.cmd := WRITE;
        when 'I' => tmpdata.cmd := IDLE;
        when '-' => tmpdata.cmd := CMT;
        when others => ASSERT FALSE REPORT "Unknown Instruction type" SEVERITY failure;
      end case;


-- IDLE
      -- Read the number of idle cycle to wait
      if (tmpdata.cmd = IDLE) then
        read(L, tmpdata.idle);

	i := 1;
	previousc := nul;
	loop
	  exit when (L'length = 0);
	  read(L,c);
	  exit when ((c = '-') and (previousc = '-'));
	  previousc := c;
	end loop;

	loop                                    
	  exit when (L'length = 0);
	  read(L,c);
	  tmpdata.comment(i) := c;
	  i := i +1;
	end loop;

	tmpdata.comment(i) := nul;
      end if;


-- READ & WRITE
      -- Read the values for a read or write
      if (tmpdata.cmd = READ or tmpdata.cmd = WRITE) then

	-- Read the address value for a read or write
        hread(L, tmpdata.addr);

	-- Read the data value for a read or write
        hread(L, tmpdata.data);

        comment := false;
        mask := false;
	previousc := nul;
        loop                                    -- skip white space
                exit when (L'length = 0);
		read(L,c);
		write(LS,c);
                if (c = '-' and previousc = '-') then
                  comment := true;
                end if;
		if (comment = false and (c='0' or c='F')) then 
		  mask := true;
		end if;
	        previousc := c;
        end loop;

	-- If the mask is not specified then set it to all ones
	if (tmpdata.cmd = READ  and mask) then
	  hread(LS, tmpdata.mask);
	else
	  tmpdata.mask := one32;
	end if;

	i := 1;
	if (comment) then
	  previousc := nul;
	  loop
	    read(LS,c);
            exit when ((c = '-') and (previousc = '-'));
	    previousc := c;
	  end loop;

	  loop        
	    exit when (LS'length = 0);
	    read(LS,c);
	    tmpdata.comment(i) := c;
	    i := i +1;
	  end loop;
	end if;
	tmpdata.comment(i) := nul;

      end if;

-- COMMENT      
      if (tmpdata.cmd = CMT) then
	read(L,c);  -- read the second '-'
	i := 1;
	loop             
	  exit when (L'length = 0);
	  read(L,c);
          tmpdata.comment(i) := c;
	  i := i +1;
        end loop;
	tmpdata.comment(i) := nul;
      end if;

      if (lineCount = MAXCOMMANDS) then
	ASSERT FALSE REPORT "  Error: Too many commands in the table file" SEVERITY failure;
      end if;

      data(lineCount) := tmpdata;
      lineCount := lineCount + 1; 
    end loop;

    numberOfCommands := lineCount;

    write(L,string'("Number of commands read from "));
    write(L,fileName);
    write(L,string'(" = "));
    write(L,lineCount);
    writeline(OUTPUT, L);

    file_close(vector_file);
  end;

  procedure printTransaction (
    variable data : in data_type) is
    variable  L: line;
  begin
    case data.cmd is
      when READ => 
	write(L,string'("READ  "));
	write(L,hstr(data.addr));
	write(L,string'("   "));
	write(L,hstr(data.data));
	if (data.mask /= one32) then
	  write(L,string'("   "));
	  write(L,hstr(data.mask));
	end if;
      when WRITE => 
	write(L,string'("WRITE "));
	write(L,hstr(data.addr));
	write(L,string'("   "));
	write(L,hstr(data.data));
      when IDLE => 
	write(L,string'("IDLE  "));
	write(L,string'("   "));
	write(L,data.idle);
      when CMT => 
	write(L,string'("--"));
	write(L,data.comment);
      when others => write(L,string'("UNKNOWN "));
    end case;
    if data.cmd /= CMT and data.comment(1) /= nul then
      write(L,string'("  --"));
      write(L,data.comment);
    end if;
    writeline(OUTPUT,L);
  end;

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

  failures <= conv_std_logic_vector(fails,32);
  SimDone <= regSimDone;

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------

-- Manage the table file with the transactions to perform.
  Table: process(hresetn, getNextCommand, state, regSimDone)
    variable data : data_vec_type (MAXCOMMANDS downto 0);
    variable i : integer;
    variable numberOfCommands : integer := 0;
    variable commandNumber : integer := 0;
    variable L : line;
    variable  trans: data_type;
  begin
    
    
    if (rising_edge(hresetn)) then
      readFile(fileIn,data,numberOfCommands);  -- read the input file
      for i in 0 to numberOfCommands-1 loop
        printTransaction(data(i));
      end loop;
      commandNumber := 0;
      start <= '1';
      write(L,string'("--------------------------------------------------------------------"));
      write(L,lf);
      write(L,string'("--------------------------------------------------------------------"));
      write(L,lf);
      write(L,string'("--------------------------------------------------------------------"));
      write(L,lf);
      write(L,string'("Ready to start the simulation"));
      write(L,lf);
      write(L,lf);
      writeline(OUTPUT, L);
      transaction.cmd <= NOP;
    end if;

    nextSimDone <= regSimDone;
    if (rising_edge(getNextCommand)) then

      loop
	exit when (commandNumber = numberOfCommands);
	trans := data(commandNumber);
        if (trans.cmd = CMT) then
	  printTransaction(data(commandNumber));
	  commandNumber := commandNumber + 1;
	end if;
	exit when (trans.cmd /= CMT);
      end loop;
	   
      if (commandNumber < numberOfCommands) then
	transaction <= data(commandNumber);
        printTransaction(data(commandNumber));
	commandNumber := commandNumber + 1;
      else
	write(L,lf);
	if (fails = 0) then
	  write(L,string'("Simulation passed!"));
	else
	  write(L,string'("Simulation FAILED! with "));
	  write(L,fails);
	  write(L,string'(" Errors"));
	end if;
	write(L,string'(" table file = "));
	write(L, code_file);
	write(L,lf);
	writeline(OUTPUT, L);

	nextSimDone <= '1';
	start <= '0';
      end if;
    end if;

  end process;


  stateMachineReg: process(hclk, hresetn)
  begin
    if (hresetn = '0') then
      state <= ST_RESET;
      regSimDone <= '0';
      idleCount <= 0;
    elsif (hclk = '1') then
      state <= nextState after 5.0 ns;
      regSimDone <= nextSimDone;
      idleCount <= nextIdleCount;
    end if;
  end process;

  stateMachineCombo: process(state, start, hgrant, hready, transaction, idleCount)

  variable L: line;
  variable addr: integer;
  variable addrslv: std_logic_vector (LOCALMEMORYBITS-2 downto 0);
  begin
   
    -- defaults
    htrans <= "00";  -- IDLE
    hburst <= "000"; -- SINGLE
    hprot  <= "0001"; -- DATA transfer
    hsize  <= "010"; -- WORD
    hwrite <= '0';
    hbusreq <= '0';
    haddr <= (others => '0');
    hwdata <= (others => '0');
    nextState <= state;
    getNextCommand <= '0';
    nextIdleCount <= 0;

    case (state) is
      when ST_RESET =>
        if (start = '1') then
	  nextState <= ST_CMD;
	end if;

      when ST_CMD =>
	getNextCommand <= '1';
	if (transaction.cmd = IDLE) then 
	  nextState <= ST_IDLE;
	end if;
	-- For internal registers do not forward to AHB
	if (((transaction.cmd = READ) or (transaction.cmd = WRITE)) and (unsigned(transaction.addr) >= unsigned(LOCALMEMORYADDR) and unsigned(transaction.addr) < (unsigned(LOCALMEMORYADDR) + LOCALMEMORYSIZE-4))) then 
	  nextState <= ST_INTERNAL;
	elsif (transaction.cmd = READ or transaction.cmd = WRITE) then 
	  nextState <= ST_REQUEST;
	end if;

      when ST_INTERNAL =>
	nextState <= ST_CMD;
	addrslv := transaction.addr(LOCALMEMORYBITS-2 downto 0);
	addr := conv_integer(unsigned(addrslv));
	if (transaction.cmd = WRITE) then
	  memory(addr).data <= transaction.data;
	end if;

      when ST_IDLE =>
        if (idleCount < transaction.idle) then
 	  nextState <= ST_IDLE;
	else
 	  nextState <= ST_CMD;
        end if;
        nextIdleCount <= idleCount + 1;

      when ST_REQUEST  =>
        hbusreq <= '1';
        if (hgrant = '1' and hready = '1') then
 	 nextState <= ST_ADDR;
        end if;

      when ST_ADDR =>
        htrans <= "10";  -- NONSEQ
        haddr <= transaction.addr;
        if (transaction.cmd = WRITE) then
	  hwrite <= '1';
	end if;
        if (hready = '1') then
 	 nextState <= ST_DATA;
        end if;

      when ST_DATA =>
        if (hready = '1') then
	  if hresp(1) = '1' then   -- retry or split
	    nextState <= ST_REQUEST;
	  else
	    nextState <= ST_CMD;
	  end if;
        end if;

	if (transaction.cmd = WRITE) then
	  hwdata <= transaction.data;
        end if;

    end case;
  end process;

  readCheck: process(hclk, hresetn)
  variable L:line;
  variable addr: integer;
  variable maskedData: std_logic_vector (31 downto 0);
  variable addrslv: std_logic_vector (LOCALMEMORYBITS-2 downto 0);
  begin
	if (hresetn = '0') then
	  fails <= 0;
	end if;
        if (hready = '1' and state = ST_DATA) then
	  if ((transaction.cmd = READ or transaction.cmd = WRITE) and rising_edge(hclk) and
	      hresp /= "00") then
	      if hresp = "01" then
		write(L,string'("  Error: Error slave response"));
	      elsif hresp = "10" then
		write(L,string'("  Error: Retry slave response"));
	      elsif hresp = "11" then
		write(L,string'("  Error: Split slave response"));
	      else
		write(L,string'("  Error: Unknown slave response"));
	      end if;
	      write(L,lf);
	      writeline(OUTPUT,L);
	      fails <= fails + 1;
	  elsif (transaction.cmd = READ and rising_edge(hclk)) then
	    maskedData :=(hrdata xor transaction.data) and transaction.mask;
	    if (Is_X(maskedData) or maskedData /= zero32) then
	      write(L,string'("  Error: Read failed with data = "));
	      write(L,hstr(hrdata));
	      write(L,lf);
	      writeline(OUTPUT,L);
	      fails <= fails + 1;
	    else
	      write(L,string'("  Read passed"));
	      write(L,lf);
	      writeline(OUTPUT,L);
	    end if;

          end if;

        end if;
	if (state = ST_INTERNAL and transaction.cmd = READ and rising_edge(hclk)) then
	  addrslv := transaction.addr(LOCALMEMORYBITS-2 downto 0);
	  addr := conv_integer(unsigned(addrslv));
	  if (((memory(addr).data xor transaction.data) and transaction.mask) /= zero32) then
	    write(L,string'("  Error: Local memory read failed with data = "));
	    write(L,hstr(memory(addr).data));
	    write(L,lf);
	    writeline(OUTPUT,L);
	    fails <= fails + 1;
	  else
	    write(L,string'("  Local memory read passed"));
	    write(L,lf);
	    writeline(OUTPUT,L);
	  end if;
	end if;
  end process;

end bfm;

