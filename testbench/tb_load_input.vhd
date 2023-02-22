library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_load_input is
end tb_load_input;

architecture Behavioral of tb_load_input is

component load_input is
  Port ( 
            clk, reset  : in std_logic;
            -----------------------------------------------------
            ld_input    : in std_logic;
            --input       : in std_logic_vector(15 downto 0);
            ld_input_done   : out std_logic;--feedback to controller
            
            --op part ------------------------------------------- 
            --signal from controller 
            op_en       : in std_logic;
            
            start_ld_input  : out std_logic;
            data_input  : out std_logic_vector(15 downto 0)
            
            -----------------------------------------------------
  
  
  );
end component;

signal clk          : std_logic := '1';      
signal reset        : std_logic;
signal ld_input    :std_logic;
signal input       :std_logic_vector(15 downto 0);
signal ld_input_done   :std_logic;--feedback to controller

signal op_en       :std_logic;
signal start_ld_input  : std_logic;
signal data_input  : std_logic_vector(15 downto 0);

constant period1    : time := 5ns;


begin

dut: load_input
port map(
clk             => clk          ,
reset           => reset         ,
ld_input        => ld_input     , 
--input           => input        , 
ld_input_done   => ld_input_done  ,                  
op_en           => op_en        , 
start_ld_input      => start_ld_input    ,
data_input      => data_input    

);


clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 

ld_input <= '0', 
            '1' after 8*period1,
            '0' after 10*period1;


op_en <= '0', 
            '1' after 30*period1,
            '0' after 32*period1;





end Behavioral;