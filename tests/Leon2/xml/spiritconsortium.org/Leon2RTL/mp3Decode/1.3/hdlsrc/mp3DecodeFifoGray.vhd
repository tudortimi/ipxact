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
entity mp3DecodeFifoGray is

 

   port ( clk  : in  STD_LOGIC;
          cdn  : in  STD_LOGIC;
          cen  : in  STD_LOGIC;
          q    : out STD_LOGIC_VECTOR(4 downto 0));
end mp3DecodeFifoGray;


architecture rtl of mp3DecodeFifoGray is

SIGNAL A  : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL S  : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL CI : STD_LOGIC;
SIGNAL D2 : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL D1 : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL D0 : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL Qv : STD_LOGIC_VECTOR(4 downto 0);
CONSTANT  areset_value : STD_LOGIC_VECTOR(4 downto 0) := "00000";

    function GrayIncr (A: Std_Logic_Vector) return Std_Logic_Vector is
        variable L : std_logic_vector(A'range);
        variable R : std_logic_vector(A'range);
        variable N : std_logic_vector(A'range);
        variable S : std_logic_vector(A'range);
    begin
      
      L(A'high) := '1'; 
      for index in A'length-2 downto 0 loop
        L(index) := A(index+1) xor L(index+1); 
      end loop;
 
      N(0) := '1';
      for index in 1 to (A'length-1) loop
        N(index) := not(A(index-1)) and N(index-1);
      end loop;
 
      R(0) := '1';
      for index in 1 to (A'length-2) loop 
        R(index) := A(index-1) and N(index-1);
      end loop;
      R(A'high) := (not(A(A'high)) and A(A'high-1) and N(A'high-1)) or (N(A'high) and A(A'high));
 
      S(0) := L(0);
      for index in 1 to (A'length-2) loop
        S(index) := A(index) xor (R(index) and L(index-1));
      end loop;
      S(A'high) := A(A'high) xor R(A'high);

      return S;

    end;


begin

-- -----------------------------------------------------------------------------
   incr : process (A, ci)
-- -----------------------------------------------------------------------------
   VARIABLE SV   : STD_LOGIC_VECTOR(4 downto 0);

   begin
     SV := GrayIncr(A);
      if (ci = '1') then
        S <= SV;
      else S <= A;
      end if;
   end process;

-- -----------------------------------------------------------------------------
   stod2 : process (S, cen)
-- -----------------------------------------------------------------------------
   begin
     D2 <= S;
   end process;

-- -----------------------------------------------------------------------------
   d2tod1 : process (D2, cen, S)
-- -----------------------------------------------------------------------------
   begin
     if (CEN = '1') then
       D1 <= D2;
     else
       D1 <= S;
     end if;
     CI <= CEN;
   end process;

-- -----------------------------------------------------------------------------
   d1tod0 : process (D1)
-- -----------------------------------------------------------------------------
   begin
     D0 <= D1;
   end process;

-- -----------------------------------------------------------------------------
   d0toq : process (clk, D0, cdn)
-- -----------------------------------------------------------------------------
   begin
     if (cdn = '0') then
       Qv <= areset_value after 1 ns;
     elsif (clk = '1') and (clk'event) then
       Qv <= D0 after 1 ns;
     end if;
   end process;

-- -----------------------------------------------------------------------------
-- Hookup internal signals to ports
-- -----------------------------------------------------------------------------
   A <= Qv;
   Q <= Qv;

end rtl; 


