
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_controller is
end tb_controller;

architecture Behavioral of tb_controller is

component controller is
  Port ( 
            clk, reset  : in std_logic;
            start       : in std_logic;
            
            ld2mem_done : in std_logic;
            ld_input_done   : in std_logic;
            multi_done  : in std_logic;
            
            ld2mem      : out std_logic;
            ld_input    : out std_logic;
            op_en       : out std_logic
  
  );
end component;


    signal clk          : std_logic := '1';      
    signal reset        : std_logic;  
    signal start        : std_logic;
    signal ld2mem_done  : std_logic;
    signal ld_input_done   : std_logic;
    signal multi_done   : std_logic;

    signal ld2mem       : std_logic;
    signal ld_input     : std_logic;
    signal op_en        : std_logic;

    constant period1    : time := 5ns;


begin

dut: controller
port map(
clk           => clk          ,
reset         => reset         ,
start         => start        , 
ld2mem_done   => ld2mem_done  , 
ld_input_done => ld_input_done  ,
multi_done    => multi_done    ,               
ld2mem        => ld2mem       , 
ld_input      => ld_input      ,
op_en         => op_en         

);




clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 

start <= '0',
            '1' after 6*period1,
            '0' after 8*period1;
            
            
ld2mem_done <= '0',
            '1' after 12*period1,
            '0' after 14*period1;
            
ld_input_done   <= '0',
            '1' after 20*period1,
            '0' after 22*period1,
            
            '1' after 28*period1,
            '0' after 30*period1,
            
            '1' after 36*period1,
            '0' after 38*period1,
            
            '1' after 44*period1,
            '0' after 46*period1,
            
            '1' after 52*period1,
            '0' after 54*period1,
            
            '1' after 60*period1,
            '0' after 62*period1,                      
            
            '1' after 68*period1,
            '0' after 70*period1,
            
            '1' after 76*period1,
            '0' after 78*period1,
            
            '1' after 84*period1,
            '0' after 86*period1,
            
            '1' after 92*period1,
            '0' after 94*period1,
            
            '1' after 100*period1,
            '0' after 102*period1,
            
            '1' after 108*period1,
            '0' after 110*period1,
            
            '1' after 116*period1,
            '0' after 118*period1,
            
            '1' after 124*period1,
            '0' after 126*period1;
            
            
multi_done  <= '0',
            '1' after 24*period1,
            '0' after 26*period1,
            
            '1' after 32*period1,
            '0' after 34*period1,
            
            '1' after 40*period1,
            '0' after 42*period1,
            
            '1' after 48*period1,
            '0' after 50*period1,
            
            '1' after 56*period1,
            '0' after 58*period1,
            
            '1' after 64*period1,
            '0' after 66*period1,
            
            '1' after 72*period1,
            '0' after 74*period1,
            
            '1' after 80*period1,
            '0' after 82*period1,          
            
            '1' after 88*period1,
            '0' after 90*period1,
            
            '1' after 96*period1,
            '0' after 98*period1,
            
            '1' after 104*period1,
            '0' after 106*period1,
            
            '1' after 112*period1,
            '0' after 114*period1,
            
            '1' after 120*period1,
            '0' after 122*period1,
            
            '1' after 128*period1,
            '0' after 130*period1;



end Behavioral;
