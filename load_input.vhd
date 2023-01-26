

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity load_input is
  Port ( 
            clk, reset  : in std_logic;
            -----------------------------------------------------
            ld_input    : in std_logic;
            input       : in std_logic_vector(15 downto 0);
            ld_input_done   : out std_logic;--feedback to controller
            
            --op part ------------------------------------------- 
            --signal from controller 
            op_en       : in std_logic;
            
            start_ld_input  : out std_logic;
            data_input  : out std_logic_vector(15 downto 0)
            
            -----------------------------------------------------
  
  
  );
end load_input;

architecture Behavioral of load_input is

component ff is
  generic(N:integer:=1);
  port(   D  :  in std_logic_vector(N-1 downto 0);
          Q  :  out std_logic_vector(N-1 downto 0);
        clk  :  in std_logic;
        reset:  in std_logic
      );
end component;

type state_type is (s_initial, s_ld_input, s_send2multi, s_send2multi_w1, s_send2multi_w2);
signal state_reg, state_nxt : state_type;

signal reg_1, reg_1_nxt : std_logic_vector(15 downto 0);
signal reg_2, reg_2_nxt : std_logic_vector(15 downto 0);
signal reg_3, reg_3_nxt : std_logic_vector(15 downto 0);
signal reg_4, reg_4_nxt : std_logic_vector(15 downto 0);

--enable write in reg
signal flag1 : std_logic;
--enable send data
signal flag2 : std_logic;

signal hold, hold_nxt : std_logic_vector(0 downto 0) := (others => '0');

--control load
signal counter1, counter1_nxt : std_logic_vector(2 downto 0) := (others => '0');
--control send
signal counter2, counter2_nxt : std_logic_vector(1 downto 0) := (others => '0');
--control the loop will be executed 14 times
signal counter3, counter3_nxt : std_logic_vector(3 downto 0) := (others => '0');


begin

--state contrl----------------------------------------------
process(clk, reset)
begin
    if reset = '1' then 
        state_reg <= s_initial; 
    elsif (clk'event and clk = '1') then 
        state_reg <= state_nxt; 
    end if;

end process;

--state machine --------------------------------------------
process(state_reg, ld_input, op_en, counter1, counter2, counter3, hold)
begin 
    start_ld_input <= '0';
    ld_input_done <= '0';
    counter1_nxt <= (others => '0');
    counter2_nxt <= (others => '0');                    
    counter3_nxt <= (others => '0'); 
    flag1 <= '0';
    flag2 <= '0';
    hold_nxt <= (others => '0'); 
    
    case state_reg is 
    
        when s_initial => 
            if ld_input = '1' and op_en = '0' then 
                start_ld_input <= '1';--give signal to outside
                state_nxt <= s_ld_input;
            elsif ld_input = '0' and op_en = '1' then 
                state_nxt <= s_send2multi_w1;
            else
                state_nxt <= s_initial;
            end if;
        
        when s_ld_input => 
            
            flag1 <= '1'; 
            if counter1 = "011" then 
                start_ld_input <= '1';
                ld_input_done <= '1';
                counter1_nxt <= (others => '0');
                state_nxt <= s_initial;
            else
                start_ld_input <= '1';
                ld_input_done <= '0';
                counter1_nxt <= counter1 + 1;
                state_nxt <= s_ld_input;
            end if;
        
                
        when s_send2multi_w1 =>
            state_nxt <= s_send2multi_w2;
        
        when s_send2multi_w2 =>
            state_nxt <= s_send2multi;
        
        
        
        
        when s_send2multi =>
            flag2 <= '1';
            if hold = "0" then 
                hold_nxt <= hold + 1;
                state_nxt <= s_send2multi;
                counter2_nxt <= counter2;
                counter3_nxt <= counter3;
            else 
                hold_nxt <= (others => '0');
                if counter3 = "1101" and counter2 = "11" then 
                    counter2_nxt <= (others => '0');                    
                    counter3_nxt <= (others => '0'); 
                    state_nxt <= s_initial;              
                elsif counter3 < "1101" and counter2 = "11" then
                    counter3_nxt <= counter3 + 1;
                    counter2_nxt <= (others => '0');
                    state_nxt <= s_send2multi;
                else 
                    counter3_nxt <= counter3;
                    counter2_nxt <= counter2 + 1;
                    state_nxt <= s_send2multi;
                end if;
            end if;
            
    
    end case;


end process;



reg_1_nxt <= input when counter1 = "000" and flag1 = '1' else reg_1;
reg_2_nxt <= input when counter1 = "001" and flag1 = '1' else reg_2;
reg_3_nxt <= input when counter1 = "010" and flag1 = '1' else reg_3;
reg_4_nxt <= input when counter1 = "011" and flag1 = '1' else reg_4;



--Send the data --------------------------------------------
data_input <=   reg_1 when counter2 = "00" and flag2 = '1' else 
                reg_2 when counter2 = "01" and flag2 = '1' else
                reg_3 when counter2 = "10" and flag2 = '1' else
                reg_4 when counter2 = "11" and flag2 = '1' else 
                (others => '0');

--Flip Flop ------------------------------------------------
reg_01: FF 
  generic map(N => 16)
  port map(   D     =>reg_1_nxt,
              Q     =>reg_1,
            clk     =>clk,
            reset   =>reset
      );

reg_02: FF 
  generic map(N => 16)
  port map(   D     =>reg_2_nxt,
              Q     =>reg_2,
            clk     =>clk,
            reset   =>reset
      );

reg_03: FF 
  generic map(N => 16)
  port map(   D     =>reg_3_nxt,
              Q     =>reg_3,
            clk     =>clk,
            reset   =>reset
      );

reg_04: FF 
  generic map(N => 16)
  port map(   D     =>reg_4_nxt,
              Q     =>reg_4,
            clk     =>clk,
            reset   =>reset
      );

counter_01: FF 
  generic map(N => 3)
  port map(   D     =>counter1_nxt,
              Q     =>counter1,
            clk     =>clk,
            reset   =>reset
      );

counter_02: FF 
  generic map(N => 2)
  port map(   D     =>counter2_nxt,
              Q     =>counter2,
            clk     =>clk,
            reset   =>reset
      );      
      
counter_03: FF 
  generic map(N => 4)
  port map(   D     =>counter3_nxt,
              Q     =>counter3,
            clk     =>clk,
            reset   =>reset
      );

hold_time : FF 
  generic map(N => 1)
  port map(   D     =>hold_nxt,
              Q     =>hold,
            clk     =>clk,
            reset   =>reset
      );


end Behavioral;
