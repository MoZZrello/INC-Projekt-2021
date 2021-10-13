-- uart_fsm.vhd: UART controller - finite state machine
-- Author: Richard Harman
-- Login: xharma05
-- Year: 2021
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK      : in std_logic;
   RST      : in std_logic;
   DIN      : in std_logic;
   CNT      : in std_logic_vector(4 downto 0);
   CNT2     : in std_logic_vector(3 downto 0);
   RXEN     : out std_logic;
   CNTEN    : out std_logic;
   DOUTVLD  : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type statetype is (START_BIT, DATA_RECEIVE, DATA_VALID, STOP_BIT);
signal state: statetype := START_BIT;
begin
    RXEN <= '1' when state = DATA_RECEIVE else '0';
    CNTEN <= '1' when state = DATA_RECEIVE else '0';
    DOUTVLD <= '1' when state = DATA_VALID else '0';
    process (CLK) begin
        if rising_edge(CLK) then
            if RST = '1' then
                state <= START_BIT;
            else
                case state is
                when START_BIT =>   if DIN = '0' then
                                        state <= DATA_RECEIVE;
                                    end if;
                when DATA_RECEIVE => if CNT2 = "1000" then
                                        state <= STOP_BIT;
                                     end if;
                when STOP_BIT => if DIN = '1' then
                                    state <= DATA_VALID;
                                 end if;
                when DATA_VALID => state <= START_BIT;
                when others => null;
                end case;
            end if;
        end if;
    end process;
end behavioral;
