-- ISLEMCI TASARIMI

library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

entity eIslemci is
generic(n:natural:=8);
port( s, r,secme,sec: in std_logic; 
         adr: in std_logic_vector(3 downto 0); 
         kmt: in std_logic_vector(2*n-1 downto 0); 
         F: out std_logic_vector(7 downto 0)); 
end entity;

Architecture struct of eIslemci is

TYPE tMEM IS ARRAY(0 TO 63) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Ram : tMEM;  -- RAM

TYPE tREG IS ARRAY(0 TO 15) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Reg : tREG;

TYPE tROM IS ARRAY(0 TO 31) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Rom : tROM;
Constant ROMbellek: tROM :=(
      0 => "00110000",
	    1 => "00110001",
      2 =>	"00110010",	
      3	=> "00110011"	,
      4	=> "00110100"	,
      5	=> "00110101"	,
      6	=> "01000111"	,
      7	=> "01001000"	,
      8	=> "01001001"	,
      9	=> "01001010"	,
      10 => "01001011"	,
      11 => "01001100",
      12 => "01001101"	,
      13 => "01001110"	,
      14 => "01001111"	,
      15 => "01010000",
      16 => "01010001"	,
      17 => "01010010"	,
      18 => "01010011"	,
      19 => "01010100"	,
      20 => "01010101"	,
      21 => "01010110"	,
      22 => "01010111"	,
      23 => "01011000"	,
      24 => "01011001"	,
      25 => "01011010",
      OTHERS => "11111111" );

   
Begin -- mimari

Komut:
process(s, r)
Begin
     
  If( Rising_edge(s) ) then 
    If(r='1') then
      If(secme='1')then
        Ram(to_integer(unsigned(Kmt(7 downto 0)))) <= "ZZZZZZZZ";
      Else 
        Reg(to_integer(unsigned(Kmt(11 downto 0)))) <= "ZZZZZZZZ";
      End if;
    End if;
  If(sec='1') then
    F <= ROMbellek(to_integer(unsigned(adr)));
    End if;
  Else
     Case Kmt(15 downto 12) is 
     
	When "0000" =>
	    null;  

	When "0001" =>
		Reg(to_integer(unsigned(Kmt(11 downto 8))))<= Kmt(7 downto 0);  


	When "0010" =>  
		Reg(to_integer(unsigned(Kmt(11 downto 8))))<= Reg(to_integer(unsigned(Kmt(7 downto 4)) ))  ;

	When "0011" =>  
    Ram( to_integer(unsigned(Kmt(7 downto 0))) ) <= 
			Reg(to_integer(unsigned(Kmt(11 downto 8))));
	
	When "0100" =>   
		Reg(  to_integer(unsigned(Kmt(11 downto 8))))  <= 
			Ram( to_integer(unsigned( Reg( to_integer(unsigned(Kmt(7 downto 4)))  ))))  ;
    
 	When "0101" =>
 	    Reg(to_integer(unsigned(Kmt(11 downto 8))))<=
 	       Ram(to_integer(unsigned(Kmt(7 downto 0)) ))  ;  
      
 	When "0110" =>  
           Reg(  to_integer(unsigned(Kmt(11 downto 8))) )  
            <= std_logic_vector(unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))
					     + unsigned(ROMbellek(to_integer(unsigned(Kmt (3 downto 0))))));
					     
 	When "0111" =>  
           Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			+ unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
 
  When "1000" =>
        Reg(  to_integer(unsigned(Kmt(11 downto 8))) )   <= 
				  std_logic_vector(
				    unsigned (Reg( to_integer(unsigned(Kmt(7 downto 4)))))
					     - unsigned(Kmt (7 downto 0)));
   
  When "1001" =>
         Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			     std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			       -  unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
  
  When "1010" => 
        Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			AND unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
  
  When "1011" =>
         Ram( to_integer(unsigned(Kmt(7 downto 0)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))
			OR unsigned(Kmt(7 downto 0)));
		  
  When "1100" =>
    Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			XOR unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
  
  When "1101" =>
    Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) 
			/ unsigned(Kmt(3 downto 0)));  

  
  When "1110" =>
    Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			* unsigned(Kmt(3 downto 0)) );
  
  When "1111" =>
    Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) 
			mod unsigned(ROMbellek(to_integer(unsigned(Kmt (3 downto 0))))));

 	When others => 
	    null;
      end case;  
   end if;
end Process;

end struct;
