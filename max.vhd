
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity max is
  Port ( 
            clk, reset  : in std_logic;
            -----------------------------------------------------
            --control signal from multiply 
            max_en      : in std_logic;
            --data from multiply 
            data_out    : in std_logic_vector(17 downto 0);
            
            -----------------------------------------------------
            --find the maximum data
            max_out     : out std_logic_vector(17 downto 0) 
            
            -----------------------------------------------------
  
  );
end max;

architecture Behavioral of max is

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;

signal count, count_nxt : std_logic_vector(6 downto 0); 
signal data_max, data_max_nxt   : std_logic_vector(17 downto 0) := (others => '0');

begin

process(max_en)
begin
    if max_en = '1' then 
        max_out <= data_max; 
    else 
        max_out <= (others => '0'); 
    end if;
    
end process;

data_max_nxt <= data_out when data_max < data_out else data_max; 


--Flip Flop-------------------------------------------------
compare_data: FF 
  generic map(N => 18)
  port map(   D     =>data_max_nxt,
              Q     =>data_max,
            clk     =>clk,
            reset   =>reset
      );


end Behavioral;
