-- ****************************************************************************
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
-- Derived from work by: NXP Semiconductors 2007               
-- _____________________________________________________________
--  NXP RESERVES THE RIGHTS TO MAKE CHANGES WITHOUT NOTICE AT ANY 
--  TIME. NXP MAKES NO WARRANTY, EXPRESSED, IMPLIED OR STATUTARY, 
--  INCLUDING BUT NOT LIMITED TO ANY IMPLIED WARRANTY OR MERCHANTABILITY 
--  OR FITNESS FOR ANY PARTICULAR PURPOSE, OR THAT THE USE WILL NOT 
--  INFRINGE ANY THIRD PARTY PATENT, COPYRIGHT OR TRADEMARK. NXP 
--  SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE ARISING FROM THE 
--  USE OF ITS LIBRARIES OR SOFTWARE. 
--
-- Simple AHB to AHB bridge, synchronous only, may not handle bursts.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- AHB to AHB bridge. This only does single word transfers where both sides
-- must run on the same clock

entity ahb2ahb is
port (hclk:       in     std_logic;
      hresetn:    in     std_logic;

      -- Master port
      hready_m:     in     std_logic;
      hresp_m:      in     std_logic_vector(1 downto 0);
      haddr_m:      out    std_logic_vector(31 downto 0);
      hwrite_m:     out    std_logic;
      hsize_m:      out    std_logic_vector(2 downto 0);
      htrans_m:     out    std_logic_vector(1 downto 0);
      hburst_m:     out    std_logic_vector(2 downto 0);
      hprot_m:      out    std_logic_vector(3 downto 0);
      hwdata_m:     out    std_logic_vector(31 downto 0);
      hrdata_m:     in     std_logic_vector(31 downto 0);
      hgrant_m:     in     std_logic;
      hbusreq_m:    out    std_logic;


      -- Slave port
      hreadyi_s:    in     std_logic;
      hreadyo_s:    out    std_logic;
      hresp_s:      out    std_logic_vector(1 downto 0);
      haddr_s:      in     std_logic_vector(31 downto 0);
      hwrite_s:     in     std_logic;
      hsel_s:       in     std_logic;
      hsize_s:      in     std_logic_vector(2 downto 0);
      htrans_s:     in     std_logic_vector(1 downto 0);
      hburst_s:     in     std_logic_vector(2 downto 0);
      hprot_s:      in     std_logic_vector(3 downto 0);
      hwdata_s:     in     std_logic_vector(31 downto 0);
      hrdata_s:     out    std_logic_vector(31 downto 0)
      );
end ahb2ahb;

-- -----------------------------------------------------------------------------
architecture rtl of ahb2ahb is
-- -----------------------------------------------------------------------------

   type    state_type is (ST_RESET, ST_SLAVE_CMD, ST_MASTER_REQUEST, ST_MASTER_CMD, ST_MASTER_DATA, ST_SLAVE_DATA);

   signal   nextState    : state_type;
   signal   state        : state_type;
   signal   copySignals  : std_logic;
   signal   grabrdata    : std_logic;
   signal   hrdataReg    : std_logic_vector(31 downto 0);
   signal   maskhtrans_m : std_logic_vector(1 downto 0);
   signal   htrans_m_r   : std_logic_vector(1 downto 0);
   signal   maskhresp_s  : std_logic_vector(1 downto 0);
   signal   hresp_s_r    : std_logic_vector(1 downto 0);

begin

-- ---------------------------------------------------------------------------
-- assign outputs
-- ---------------------------------------------------------------------------

  htrans_m <= htrans_m_r and maskhtrans_m;

-- ---------------------------------------------------------------------------
-- processes
-- ---------------------------------------------------------------------------


  stateMachineReg: process(hclk, hresetn)
  begin
    if (hresetn = '0') then
      hresp_s_r  <= "00"; -- OK
      htrans_m_r <= "00";  -- IDLE
      hburst_m <= "000"; -- SINGLE
      hprot_m  <= "0001"; -- DATA transfer
      hsize_m  <= "010"; -- WORD
      hwrite_m <= '0';
      haddr_m <= (others => '0');
      hwdata_m <= (others => '0');

      state <= ST_RESET;
    elsif (rising_edge(hclk)) then
      if (grabrdata = '1') then
	hrdataReg <= hrdata_m after 5.0 ns; -- grab the data from the master side
	hresp_s_r  <= hresp_m after 5.0 ns; -- grab the response from teh master side
      end if;

      if (copySignals = '1') then
	-- master outputs
	htrans_m_r <= htrans_s after 5.0 ns;
	hburst_m <= hburst_s after 5.0 ns;
	hprot_m  <= hprot_s after 5.0 ns;
	hsize_m  <= hsize_s after 5.0 ns;
	hwrite_m <= hwrite_s after 5.0 ns;
	haddr_m  <= haddr_s after 5.0 ns;
	hwdata_m <= hwdata_s after 5.0 ns;
      end if;

      state <= nextState after 5.0 ns;
    end if;
  end process;

  StateMachineCombo: process(state, htrans_s, hsel_s, hready_m, hgrant_m)

  begin
   
    -- defaults
    nextState <= state;
    copySignals <= '0';
    hbusreq_m <= '0';
    hreadyo_s <= '0';
    grabrdata <= '0';
    hrdata_s <= hrdata_m;
    maskhtrans_m <= "11";
    maskhresp_s <= "11";
    hresp_s <= "00";

    case (state) is
      when ST_RESET =>
	nextState <= ST_SLAVE_CMD;
	maskhtrans_m <= "00";

      when ST_SLAVE_CMD =>
	maskhtrans_m <= "00";
	maskhresp_s <= "00";
	if (hsel_s = '1' and htrans_s = "10" and hreadyi_s = '1') then 
	  nextState <= ST_MASTER_REQUEST;
	  copySignals <= '1';  -- grab the command
	end if;

      when ST_MASTER_REQUEST  =>
        hbusreq_m <= '1';
	maskhtrans_m <= "00";
        if (hgrant_m = '1' and hready_m = '1') then
 	  nextState <= ST_MASTER_CMD;
        end if;

      when ST_MASTER_CMD =>
        if (hready_m = '1') then  -- last data of previous transfer & new command
 	  nextState <= ST_MASTER_DATA;
	  copySignals <= '1'; -- copy signals from slave to start the next cmd
	end if;

      when ST_MASTER_DATA =>
	nextState <= ST_MASTER_DATA;
        if (hready_m = '1') then
	  nextState <= ST_SLAVE_DATA;
	  copySignals <= '1';
	  grabrdata <= '1';
	end if;
        if (hsel_s = '1' and htrans_s = "10") then
	  maskhtrans_m <= "00";
        end if;
	hresp_s <= hresp_m;

      when ST_SLAVE_DATA =>
        hreadyo_s <= '1';
	hrdata_s <= hrdataReg;
	hresp_s <= hresp_s_r;  -- hold the registered response
        if (hsel_s = '0' or htrans_s = "00") then
 	 nextState <= ST_SLAVE_CMD;
        end if;
        if (hsel_s = '1' and htrans_s = "11") then
	  nextState <= ST_MASTER_DATA;
        end if;
        if (hsel_s = '1' and htrans_s = "10") then
	  nextState <= ST_MASTER_REQUEST;
	  maskhtrans_m <= "00";
        end if;

    end case;
  end process;

end rtl;

