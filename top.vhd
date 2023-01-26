
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity top is
  Port ( 
        --input
        clki            : in std_logic;
        reseti          : in std_logic;
        starti          : in std_logic;
        inputi          : in std_logic_vector(15 downto 0);
        --output
        start_ld_inputo : out std_logic;
        start_ld_coeffo : out std_logic;
        max_outo        : out std_logic_vector(17 downto 0)
  );
end top;

architecture Behavioral of top is

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


component load_coeff is
  Port ( 
            clk, reset          : in std_logic;
            ld2mem              : in std_logic;
            coeff               : in std_logic_vector(15 downto 0);     
            start_ld_coeff      : out std_logic;
            ld2mem_done         : out std_logic;
            op_en               : in std_logic;
            multi_en            : out std_logic;
            data_coeff          : out std_logic_vector(15 downto 0)
  );
end component;


component load_input is
  Port ( 
            clk, reset  : in std_logic;
            ld_input    : in std_logic;
            input       : in std_logic_vector(15 downto 0);
            ld_input_done   : out std_logic;--feedback to controller
            op_en       : in std_logic;
            start_ld_input  : out std_logic;
            data_input  : out std_logic_vector(15 downto 0)
  );
end component;


component multiply is
  Port (    
            clk, reset  : in std_logic;
            multi_en    : in std_logic;
            data_input  : in std_logic_vector(15 downto 0);
            data_coeff  : in std_logic_vector(15 downto 0); 
            multi_done  : out std_logic;
            store_en    : out std_logic;
            max_en      : out std_logic;
            data_out    : out std_logic_vector(17 downto 0)
    );
end component;


component store is
  Port ( 
            clk, reset  : in std_logic;
            store_en    : in std_logic;
            data_out    : in std_logic_vector(17 downto 0)
  );
end component;

component max is
  Port ( 
            clk, reset  : in std_logic;
            max_en      : in std_logic;
            data_out    : in std_logic_vector(17 downto 0);
            max_out     : out std_logic_vector(17 downto 0) 
  );
end component;


--controller                         
signal ld2mem_done      : std_logic;
signal ld_input_done    : std_logic;
signal multi_done       : std_logic;
signal ld2mem           : std_logic;
signal ld_input         : std_logic;
signal op_en            : std_logic;

--ld_coeff
--signal coeff               : std_logic_vector(15 downto 0);     
signal multi_en            :  std_logic;
signal data_coeff          :  std_logic_vector(15 downto 0);

--ld_input
signal data_input      :  std_logic_vector(15 downto 0);

--multiply
signal store_en    :  std_logic;
signal data_out    :  std_logic_vector(17 downto 0);

--store 

--max
signal max_en      : std_logic;

---------------------------------------------------------

begin

controller_part: controller
port map(
            clk           => clki          ,
            reset         => reseti         ,
            start         => starti        , 
            ld2mem_done   => ld2mem_done  , 
            ld_input_done => ld_input_done  ,
            multi_done    => multi_done    ,               
            ld2mem        => ld2mem       , 
            ld_input      => ld_input      ,
            op_en         => op_en   
);

coeff_part: load_coeff
port map(
            clk             => clki          ,
            reset           => reseti         ,
            ld2mem          => ld2mem       ,
            coeff           => inputi        ,
            start_ld_coeff  => start_ld_coeffo,
            ld2mem_done     => ld2mem_done  ,
            op_en           => op_en        ,
            multi_en        => multi_en     ,
            data_coeff      => data_coeff   
);

input_part: load_input
port map(
            clk             => clki          ,
            reset           => reseti         ,
            ld_input        => ld_input     , 
            input           => inputi        , 
            ld_input_done   => ld_input_done  ,                  
            op_en           => op_en        , 
            start_ld_input  => start_ld_inputo    ,
            data_input      => data_input    
);

multiply_part: multiply 
port map(
            clk        => clki,       
            reset      => reseti,     
            multi_en   => multi_en, 
            data_input => data_input,
            data_coeff => data_coeff,
            multi_done => multi_done,
            store_en => store_en,
            max_en   => max_en,  
            data_out   => data_out    
);

store_part: store
port map(
    clk        => clki,       
    reset      => reseti,     
    store_en   => store_en,
    data_out   => data_out   
);


max_part: max 
port map(
            clk      => clki,     
            reset    => reseti,   
            max_en   => max_en,  
            data_out => data_out,
            max_out  => max_outo 
);


end Behavioral;
