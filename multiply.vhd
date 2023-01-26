
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiply is
  Port (    
            clk, reset  : in std_logic;
            -----------------------------------------------------
            --signal from load_coeff 
            multi_en    : in std_logic;
            --data in
            data_input  : in std_logic_vector(15 downto 0);
            data_coeff  : in std_logic_vector(15 downto 0); 
            
            -----------------------------------------------------
            --ctrl out 
            multi_done  : out std_logic;
            store_en    : out std_logic;
            max_en      : out std_logic;
            --data out
            data_out    : out std_logic_vector(17 downto 0)
            
            -----------------------------------------------------


    );
end multiply;

architecture Behavioral of multiply is

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;


type state_type is (s_initial, s_multi, s_add, s_send);--, s_wait);
signal state_reg, state_nxt : state_type;

signal input_1, input_2 : std_logic_vector(7 downto 0);

signal coeff_1, coeff_2 : std_logic_vector(6 downto 0);

signal result_1, result_2   : std_logic_vector(17 downto 0);


--the matrix is [14*8]*[8*14], when counting 111 in binary means one number is done.
signal counter_8, counter_8_nxt     : std_logic_vector(1 downto 0) := (others => '0');
signal counter_14, counter_14_nxt   : std_logic_vector(3 downto 0) := (others => '0');
signal counter_6, counter_6_nxt     : std_logic_vector(2 downto 0) := (others => '0');
--------------------------------------------------------------------------------------
signal data, data_nxt   : std_logic_vector(17 downto 0);

signal store, store_nxt : std_logic_vector(0 downto 0);


begin
  
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
process(state_reg, multi_en, counter_8, data, result_1, result_2, counter_14, counter_6)
begin
    multi_done <= '0';
    data_nxt <= (others => '0');
    counter_8_nxt <= (others => '0'); 
    counter_14_nxt <= (others => '0'); 
    counter_6_nxt <= (others => '0');
    store_nxt <= "0";
     input_1 <= (others => '0');
     input_2 <= (others => '0');
     coeff_1 <= (others => '0');
     coeff_2 <= (others => '0');


    
    case state_reg is 
    
        when s_initial => 
            if multi_en = '1' then 
                state_nxt <= s_multi;
            else
                state_nxt <= s_initial;
            end if;
        
        
        when s_multi =>
            input_1 <= data_input(7 downto 0);--the input has 8 bits
            input_2 <= data_input(15 downto 8);
            coeff_1 <= data_coeff(6 downto 0);--the coeff only has 7 bits
            coeff_2 <= data_coeff(14 downto 8);
            
            
            
            if counter_8 = "00" then 
                data_nxt <= (others => '0');
            else 
                data_nxt <= data;
            end if;
            counter_8_nxt <= counter_8;
            counter_14_nxt <= counter_14;
            state_nxt <= s_add;
     
            
        when s_add => 
            data_nxt <= result_1 + result_2 + data;
            input_1 <= data_input(7 downto 0);--the input has 8 bits
            input_2 <= data_input(15 downto 8);
            coeff_1 <= data_coeff(6 downto 0);--the coeff only has 7 bits
            coeff_2 <= data_coeff(14 downto 8);


            
            if counter_8 = "11" then 
                counter_8_nxt <= (others => '0');
                store_nxt <= "1";--signal to store 
                if counter_14 = "1101" then 
                    counter_14_nxt <= (others => '0');
                    state_nxt <= s_send; 
                else 
                    counter_14_nxt <= counter_14 + 1;
                    state_nxt <= s_multi;
                end if;
                
            else 
                store_nxt <= "0";--signal to store
                counter_14_nxt <= counter_14; 
                counter_8_nxt <= counter_8 + 1;
                state_nxt <= s_multi; 
            end if;
            
               
        when s_send => 
            multi_done <= '1';--feedback to controller & average 
            
            state_nxt <= s_initial;
        
        
    end case;


end process;

--Computing part with two multipliers-----------------------

result_1 <= input_1 * coeff_1 + "000000000000000000"; --to make they have the same digits
result_2 <= input_2 * coeff_2 + "000000000000000000";

--Send data-------------------------------------------------
store_en <= store(0);
max_en <= store(0);
data_out <= data when store = "1" else (others => '0');


--Flip Flop-------------------------------------------------
counter1: FF 
  generic map(N => 2)
  port map(   D     =>counter_8_nxt,
              Q     =>counter_8,
            clk     =>clk,
            reset   =>reset
      );
      
counter2: FF 
  generic map(N => 4)
  port map(   D     =>counter_14_nxt,
              Q     =>counter_14,
            clk     =>clk,
            reset   =>reset
      );

counter3: FF 
  generic map(N => 3)
  port map(   D     =>counter_6_nxt,
              Q     =>counter_6,
            clk     =>clk,
            reset   =>reset
      );

add: FF 
  generic map(N => 18)
  port map(   D     =>data_nxt,
              Q     =>data,
            clk     =>clk,
            reset   =>reset
      );

send_data: FF 
  generic map(N => 1)
  port map(   D     =>store_nxt,
              Q     =>store,
            clk     =>clk,
            reset   =>reset
      );

end Behavioral;
