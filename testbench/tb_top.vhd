library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

component top is
  Port ( 
        clki            : in std_logic;
        reseti          : in std_logic;
        starti          : in std_logic;
        start_ld_inputo : out std_logic;
        start_ld_coeffo : out std_logic;
        max_outo        : out std_logic_vector(17 downto 0)
  );
end component;


    signal clk             : std_logic := '1';      
    signal reset           : std_logic;    
    signal starti          : std_logic;
    signal start_ld_inputo : std_logic;
    signal start_ld_coeffo : std_logic;
    signal max_outo        : std_logic_vector(17 downto 0);
        
    constant period1       : time := 5ns;


begin

dut: top
port map(
            clki            => clk            ,
            reseti          => reset          ,
            starti          => starti          ,
            start_ld_inputo => start_ld_inputo ,
            start_ld_coeffo => start_ld_coeffo ,
            max_outo        => max_outo        
);

clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 
         
starti <= '0',
            '1' after 10*period1,
            '0' after 12*period1;


end Behavioral;