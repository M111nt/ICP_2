

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity load_coeff is
  Port ( 
            clk, reset  : in std_logic;

            --signal from controller 
            op_en       : in std_logic;
            --control signal to multiply
            multi_en    : out std_logic;
            --coeff to multiply
            data_coeff  : out std_logic_vector(15 downto 0)
            
            -----------------------------------------------------

  
  );
end load_coeff;

architecture Behavioral of load_coeff is

component SRAM_coe
  port (
    clk     : in  std_logic;            --Active Low
    we      : in std_logic;
    a       : in  std_logic_vector (6 downto 0);
    d       : in  std_logic_vector (15 downto 0);
    qspo    : out std_logic_vector (15 downto 0)
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
signal r_or_w       : std_logic; -- Active Low (reand & write) --write '0' --read '1'
signal address      : std_logic_vector(6 downto 0);
---------------------------------------------------


type state_type is (s_initial, s_op, s_send2multi);
signal state_reg, state_nxt : state_type;

signal counter_1, counter_1_nxt : std_logic_vector(5 downto 0) := (others => '0');

signal coeff_32 : std_logic_vector(15 downto 0);
signal data_coeff_32 : std_logic_vector(15 downto 0);
signal coeff       : std_logic_vector(15 downto 0);

begin
--SRAM bits transfer----------------------
coeff_32 <= coeff;
data_coeff <= data_coeff_32(15 downto 0);
------------------------------------------


Ram_coeff: SRAM_coe
  port map(
    clk     => clk,            
    we      => r_or_w,
    a       => address,
    d       => coeff_32,
    qspo    => data_coeff_32
    );



--state contrl--------------------------------
process(clk, reset)
begin
    if reset = '1' then 
        state_reg <= s_initial; 
    elsif (clk'event and clk = '1') then 
        state_reg <= state_nxt; 
    end if;

end process;

--state machine--------------------------------------------

process(state_reg, op_en, counter_1)
begin
    
    --SRAM------------------------------
    choose <= '1';
    r_or_w <= '0';--read
    address <= "0" & counter_1;
    ------------------------------------

    counter_1_nxt <= (others => '0');
    multi_en <= '0';
    
    
    case state_reg is 
        
        when s_initial => 
            if op_en = '1' then     
                state_nxt <= s_op;
            else 
                state_nxt <= s_initial;
            end if;
        
        when s_op =>
            choose <= '0';
            r_or_w <= '0'; --read 
            address <= "0" & counter_1;
            counter_1_nxt <= counter_1;
            if counter_1 = "111000" then --counter = 56 (address = 0 -55)
                state_nxt <= s_initial; 
            elsif counter_1 = "000000" then 
                multi_en <= '1';
                state_nxt <= s_send2multi;
            else
                multi_en <= '0';
                state_nxt <= s_send2multi;
            end if;
            
         when s_send2multi => 
            choose <= '0';
            r_or_w <= '0'; --read
            address <= "0" & counter_1;

            counter_1_nxt <= counter_1 + 1;

            state_nxt <= s_op;
         
    
    end case;

end process;

counter1: FF 
  generic map(N => 6)
  port map(   D     =>counter_1_nxt,
              Q     =>counter_1,
            clk     =>clk,
            reset   =>reset
      );

end Behavioral;
