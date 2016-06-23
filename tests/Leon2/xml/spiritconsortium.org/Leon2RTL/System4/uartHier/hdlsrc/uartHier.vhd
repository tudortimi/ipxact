----------------------------------------------------------------------------
-- Copyright (c) 2007 SPIRIT.  All rights reserved.
-- www.spiritconsortium.org
--
-- THIS WORK FORMS PART OF A SPIRIT CONSORTIUM SPECIFICATION.  
-- THIS WORK CONTAINS TRADE SECRETS AND PROPRIETARY INFORMATION 
-- WHICH IS THE EXCLUSIVE PROPERTY OF INDIVIDUAL MEMBERS OF THE 
-- SPIRIT CONSORTIUM. USE OF THESE MATERIALS ARE GOVERNED BY 
-- THE LEGAL TERMS AND CONDITIONS OUTLINED IN THE THE SPIRIT 
-- SPECIFICATION DISCLAIMER AVAILABLE FROM
-- www.spiritconsortium.org
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library leon2uart_lib;
library SpiritAPB2ArmAPB_lib;

entity uartHier is
  port (
    rst    : in  std_logic;
    clk    : in  std_logic;
    --apbi   : in  apb_slv_in_type;
    psel    : in  Std_ULogic;                         -- slave select
    penable : in  Std_ULogic;                         -- strobe
    paddr   : in  Std_Logic_Vector(31 downto 0); -- address bus (byte)
    pwrite  : in  Std_ULogic;                         -- write
    pwdata  : in  Std_Logic_Vector(31 downto 0); -- write data bus
    --apbo   : out apb_slv_out_type;
    prdata  : out Std_Logic_Vector(31 downto 0); -- read data bus
    -- uarti  : in  uart_in_type;
    rxd     : in std_logic;
    ctsn    : in std_logic;
    scaler  : in std_logic_vector(7 downto 0);
    -- uarto  : out uart_out_type
    rxen    : out std_logic;
    txen    : out std_logic;
    flow    : out std_logic;
    irq     : out std_logic;
    rtsn    : out std_logic;
    txd     : out std_logic  );
end uartHier; 

architecture struct of uartHier is

  for all: leon2Uart
    use entity leon2uart_lib.leon2Uart;

  for all: SpiritAPB2ArmAPB
    use entity SpiritAPB2ArmAPB_lib.SpiritAPB2ArmAPB;


   component leon2Uart
     generic (
         EXTBAUD  : boolean
      );
     port (
    	rst    : in  std_logic;
    	clk    : in  std_logic;

    	psel    : in  Std_ULogic;
    	penable : in  Std_ULogic;
    	paddr   : in  Std_Logic_Vector(31 downto 0);
    	pwrite  : in  Std_ULogic;
    	pwdata  : in  Std_Logic_Vector(31 downto 0);

    	prdata  : out Std_Logic_Vector(31 downto 0);

    	rxd     : in std_logic;
    	ctsn    : in std_logic;
    	scaler  : in std_logic_vector(7 downto 0);

    	rxen    : out std_logic;
    	txen    : out std_logic;
    	flow    : out std_logic;
    	irq     : out std_logic;
    	rtsn    : out std_logic;
    	txd     : out std_logic
     	);
    end component;

    component SpiritAPB2ArmAPB
     port (
    	-- Mirrored Slave Side
    	pselMS    : in  Std_ULogic;
    	penableMS : in  Std_ULogic;
    	paddrMS   : in  Std_Logic_Vector(31 downto 0);
    	pwriteMS  : in  Std_ULogic;
    	pwdataMS  : in  Std_Logic_Vector(31 downto 0);
    	prdataMS  : out Std_Logic_Vector(31 downto 0);
    	-- Slave Side
    	pselS    : out  Std_ULogic;
    	penableS : out  Std_ULogic;
    	paddrS   : out  Std_Logic_Vector(31 downto 0);
    	pwriteS  : out  Std_ULogic;
    	pwdataS  : out  Std_Logic_Vector(31 downto 0);
    	prdataS  : in Std_Logic_Vector(31 downto 0)
     	);
    end component;

    signal psel_sig : Std_Logic;
    signal penable_sig : Std_Logic;
    signal paddr_sig : Std_Logic_Vector(31 downto 0);
    signal pwrite_sig : Std_Logic;
    signal pwdata_sig : Std_Logic_Vector(31 downto 0);
    signal prdata_sig : Std_Logic_Vector(31 downto 0);

  begin

    u1 : leon2Uart
       generic map (
                     EXTBAUD => false)
       port map (
		    	rst     => rst,
    			clk     => clk,

    			psel    => psel_sig,
    			penable => penable_sig,
    			paddr   => paddr_sig,
    			pwrite  => pwrite_sig,
    			pwdata  => pwdata_sig,

    			prdata  => prdata_sig,

    			rxd     => rxd,
    			ctsn    => ctsn,
    			scaler  => scaler,

    			rxen    => rxen,
    			txen    => txen,
    			flow    => flow,
    			irq     => irq,
    			rtsn    => rtsn,
    			txd     => txd
		);

    u2 : SpiritAPB2ArmAPB
       port map (
    			pselMS    => psel,
    			penableMS => penable,
    			paddrMS   => paddr,
    			pwriteMS  => pwrite,
    			pwdataMS  => pwdata,
    			prdataMS  => prdata,

    			pselS     => psel_sig,
    			penableS  => penable_sig,
    			paddrS    => paddr_sig,
    			pwriteS   => pwrite_sig,
    			pwdataS   => pwdata_sig,
    			prdataS   => prdata_sig

		);


  end struct;
