

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity store is
  Port ( 
            clk, reset  : in std_logic;
            
            store_en    : in std_logic;
            data_out    : in std_logic_vector(17 downto 0)
  
  );
end store;

architecture Behavioral of store is

component SRAM_store
  port (
    clk     : in  std_logic;            --Active Low
    we      : in std_logic;
    a       : in  std_logic_vector (8 downto 0);
    d       : in  std_logic_vector (31 downto 0);
    qspo    : out std_logic_vector (31 downto 0)
    );
end component;

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;

--SRAM---------------------------------------------
signal choose       : std_logic;
signal r_or_w       : std_logic; 
signal address      : std_logic_vector(8 downto 0) := (others => '0');
signal RY_ram       : std_logic;
signal sram_out     : std_logic_vector(31 downto 0);
---------------------------------------------------
signal address_nxt  : std_logic_vector(8 downto 0);


signal store_data_32 : std_logic_vector(31 downto 0);

begin
--SRAM bits transfer----------------------
store_data_32 <= "00000000000000" & data_out;
------------------------------------------


Ram_store: SRAM_store
  port map(
    clk     => clk,            
    we      => r_or_w,
    a       => address,
    d       => store_data_32,
    qspo    => sram_out 
    );


address_nxt <= address + 1 when store_en = '1' else address;
r_or_w <= '1' when store_en = '1' else '0';
choose <= '0';

data_address: FF 
  generic map(N => 9)
  port map(   D     =>address_nxt,
              Q     =>address,
            clk     =>clk,
            reset   =>reset
      );

end Behavioral;
