library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_load_coeff is

end tb_load_coeff;

architecture Behavioral of tb_load_coeff is

component load_coeff is
  Port ( 
            clk, reset  : in std_logic;
            --ld2mem      : in std_logic;
            --coeff       : in std_logic_vector(15 downto 0);     
            --start_ld_coeff    : out std_logic;
            --ld2mem_done : out std_logic;
            --coeff2mem   : out std_logic_vector(15 downto 0);
            op_en       : in std_logic;
            multi_en    : out std_logic;
            data_coeff  : out std_logic_vector(15 downto 0)
  );
end component;

signal clk         : std_logic := '1'; 
signal reset       : std_logic;                     
--signal ld2mem      : std_logic;                     
signal start_ld_coeff    : std_logic;                    
signal ld2mem_done : std_logic;                    
--signal coeff2mem   : std_logic_vector(15 downto 0);
signal op_en       : std_logic;                     
signal multi_en    : std_logic;                    
signal data_coeff  : std_logic_vector(15 downto 0); 

constant period1    : time := 5ns;


begin

dut: load_coeff
port map(
clk             => clk          ,
reset           => reset         ,
op_en           => op_en        ,
multi_en        => multi_en     ,
data_coeff      => data_coeff   
);




clk <= not (clk) after 1*period1;
reset <= '1' ,
         '0' after    4*period1; 



op_en <= '0', 
         '1' after 130*period1,
         '0' after 132*period1;








end Behavioral;