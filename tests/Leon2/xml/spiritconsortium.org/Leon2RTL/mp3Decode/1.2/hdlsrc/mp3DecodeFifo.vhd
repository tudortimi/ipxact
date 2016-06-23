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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.mp3DecodeFifoGrayPkg.ALL;

entity mp3DecodeFifo is

 
   generic ( FIFO_WIDTH : natural := 32);
   port ( wr_cp   : in  STD_LOGIC;  -- FIFO write clock
          nwr     : in  STD_LOGIC;  -- FIFO Write enable
          rd_cp   : in  STD_LOGIC;  -- FIFO read clock
          nrd     : in  STD_LOGIC;  -- FIFO Read enable
          nreset  : in  STD_LOGIC;  -- FIFO Asynchronous Reset
          di      : in  STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);  -- FIFO Data input
          full    : out STD_LOGIC;  -- FIFO Full flag
          empty   : out STD_LOGIC;  -- FIFO Empty flag
          do      : out STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0));  -- FIFO Data output bus
end mp3DecodeFifo;


architecture RTL of mp3DecodeFifo is

-- DEFINE THE PHYSICAL PARAMETERS OF THE RAM

   constant  FIFO_DEPTH_SLV  : STD_LOGIC_VECTOR(4 downto 0) := "10000";
   constant  FIFO_DEPTH      : integer := 16;
   constant  FIFO_ADDR_BITS  : integer := 4;
   constant  FIFO_LEVEL_BITS : integer := 5;


-- DEFINE INTERNAL VARIABLES
   signal we_int  : STD_LOGIC;            -- Gated internal write signal 
   signal re_int  : STD_LOGIC;            -- Gated internal read signal 
   signal fl         : STD_LOGIC;            -- Internal full flag
   signal mt         : STD_LOGIC;            -- Internal empty flag
   signal read_ptr : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Read pointer
   signal read_ptr_conv : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Read pointer
   signal read_ptr_wr1_conv : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Read pointer sync to wr_cp 

   signal write_ptr  : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Write pointer
   signal write_ptr_conv  : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Write pointer


   signal ramout     : STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);  -- Output RAM data        
   signal dataout    : STD_LOGIC_VECTOR(FIFO_WIDTH-1 downto 0);  -- Read data latch
   type MEM is array(FIFO_DEPTH-1 downto 0) of Std_Logic_vector(FIFO_WIDTH-1 downto 0);
   signal ram_data   : MEM;
   signal read_ptr_wr1 : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Read pointer sync to wr_cp 
   signal write_ptr_rd1 : STD_LOGIC_VECTOR(FIFO_ADDR_BITS downto 0);   -- Write pointer sync to rd_cp 

-- synopsys translate_off
  for all: mp3DecodeFifoGray
    use entity work.mp3DecodeFifoGray(rtl);
-- synopsys translate_on

begin

-- Read pointer GRAY code counter
  grayrd: mp3DecodeFifoGray
      port map (clk      => rd_cp,       -- Clock Input
                cdn      => nreset,      -- ASync Reset
                cen      => re_int,      -- Count Enable Input
                q        => read_ptr);   -- Result
-- Write pointer GRAY code counter
  graywr: mp3DecodeFifoGray
      port map (clk      => wr_cp,       -- Clock Input
                cdn      => nreset,      -- Clear Input
                cen      => we_int,      -- Count Enable Input
                q        => write_ptr);  -- Result


-- Assign outputs and interal signals
ramout <= ram_data(conv_integer(unsigned(read_ptr_conv(FIFO_ADDR_BITS-1 downto 0))));
we_int <= NOT(nwr OR fl);
re_int <= NOT(nrd OR mt);
full <= fl;
empty <= mt;
do <= dataout;

write_ptr_conv(FIFO_ADDR_BITS) <= NOT(write_ptr(FIFO_ADDR_BITS));
write_ptr_conv(FIFO_ADDR_BITS-1) <= NOT(write_ptr(FIFO_ADDR_BITS-1)) WHEN write_ptr(FIFO_ADDR_BITS) = '1' ELSE write_ptr(FIFO_ADDR_BITS-1);
write_ptr_conv(FIFO_ADDR_BITS-2 downto 0) <= write_ptr(FIFO_ADDR_BITS-2 downto 0);

read_ptr_conv(FIFO_ADDR_BITS) <= NOT(read_ptr(FIFO_ADDR_BITS));
read_ptr_conv(FIFO_ADDR_BITS-1) <= NOT(read_ptr(FIFO_ADDR_BITS-1)) WHEN read_ptr(FIFO_ADDR_BITS) = '1' ELSE read_ptr(FIFO_ADDR_BITS-1);
read_ptr_conv(FIFO_ADDR_BITS-2 downto 0) <= read_ptr(FIFO_ADDR_BITS-2 downto 0);

read_ptr_wr1_conv(FIFO_ADDR_BITS) <= NOT(read_ptr_wr1(FIFO_ADDR_BITS));
read_ptr_wr1_conv(FIFO_ADDR_BITS-1) <= NOT(read_ptr_wr1(FIFO_ADDR_BITS-1)) WHEN read_ptr_wr1(FIFO_ADDR_BITS) = '1' ELSE read_ptr_wr1(FIFO_ADDR_BITS-1);
read_ptr_wr1_conv(FIFO_ADDR_BITS-2 downto 0) <= read_ptr_wr1(FIFO_ADDR_BITS-2 downto 0);






-- -----------------------------------------------------------------------------
-- Generate EMPTY and FULL flags
-- -----------------------------------------------------------------------------

FULL_EMPTY: process (read_ptr,write_ptr,write_ptr_rd1,write_ptr_conv,read_ptr_wr1,read_ptr_wr1_conv)
begin
  if (read_ptr = write_ptr_rd1) then
    mt <= '1';
  else
    mt <= '0';
  end if;

  if (write_ptr(FIFO_ADDR_BITS) = read_ptr_wr1(FIFO_ADDR_BITS)) then
    fl <= '0';
  elsif (write_ptr(FIFO_ADDR_BITS) = '1' AND write_ptr_conv = read_ptr_wr1) then
    fl <= '1';
  elsif (read_ptr_wr1(FIFO_ADDR_BITS) = '1' AND write_ptr = read_ptr_wr1_conv) then
    fl <= '1';
  else
    fl <= '0';
  end if;
end process FULL_EMPTY;



-- -----------------------------------------------------------------------------
-- Sync Read pointer to Write Clock (Asynchronous Reset)
-- -----------------------------------------------------------------------------
SYNC_READ: process (wr_cp, nreset)
begin
  if (nreset = '0') then
    read_ptr_wr1 <= (others => '0');
  elsif (wr_cp'event AND wr_cp = '1') then
    read_ptr_wr1 <= read_ptr;
  end if;
end process SYNC_READ;

-- -----------------------------------------------------------------------------
-- Sync Write pointer to Read Clock (Asynchronous Reset)
-- -----------------------------------------------------------------------------
SYNC_WRITE: process (rd_cp, nreset)
begin
  if (nreset = '0') then
    write_ptr_rd1 <= (others => '0');
  elsif (rd_cp'event AND rd_cp = '1') then
    write_ptr_rd1 <= write_ptr;
  end if;
end process SYNC_WRITE;



-- -----------------------------------------------------------------------------
-- FIFO RAM write
-- -----------------------------------------------------------------------------
RAM_LATCH: process(wr_cp)
begin
  if (wr_cp'event AND wr_cp = '1') then 
    if (fl = '0') then
      ram_data(conv_integer(unsigned(write_ptr_conv(FIFO_ADDR_BITS-1 downto 0)))) <= di;
    end if;
  end if;
end process RAM_LATCH;

dataout <= ramout;

end RTL; 


