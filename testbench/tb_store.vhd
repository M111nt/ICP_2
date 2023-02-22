library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity tb_store is
end tb_store;

architecture Behavioral of tb_store is

component store is
  Port ( 
            clk, reset  : in std_logic;
            store_en    : in std_logic;
            data_out    : in std_logic_vector(17 downto 0)
  );
end component;

    signal clk          : std_logic := '1';      
    signal reset        : std_logic;  
    signal store_en     : std_logic;
    signal data_out     : std_logic_vector(17 downto 0);
    
    constant period1    : time := 5ns;



begin

dut: store 
port map(
    clk        => clk,       
    reset      => reset,     
    store_en   => store_en,
    data_out   => data_out   
);


clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 
         
store_en <= '0',
             '1' after 8*period1,
             '0' after 10*period1,
             '1' after 16*period1,
             '0' after 18*period1;        
         
data_out <= "000000000000000000",
            "000000000000000011" after 8*period1,
            "000000000000000000" after 10*period1,
            "000000000000000011" after 16*period1,
            "000000000000000000" after 18*period1;         








end Behavioral;