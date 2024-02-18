library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


ENTITY alu8bit_unsigned is
    port(
        u_a, u_b : in std_logic_vector(7 downto 0);    -- a , b - dane wejsciowe
        clk :in std_logic; --zegar do taktowania rejestu wyjsciowego
        op : in std_logic_vector(3 downto 0);
        nreset: in std_logic;   
        borrow : out std_logic :='0';
        u_result : out std_logic_vector(15 downto 0) -- 16 bitowe slowo wyjsciowe (max z mnozenia)
        );
end alu8bit_unsigned;



architecture behavioral of alu8bit_unsigned is
signal result_temp: std_logic_vector (15 downto 0);
signal result_temp_reg: std_logic_vector (15 downto 0);

function  divide (
    a : std_logic_vector(7 downto 0);
    b : std_logic_vector(7 downto 0))
    return std_logic_vector is

    variable a1 : std_logic_vector(7 downto 0) :=a;
    variable b1 : std_logic_vector(7 downto 0) :=b;
    variable p1 : std_logic_vector(8 downto 0):= (others => '0');
    variable i : integer:=0;
    begin
        for i in 0 to 7 loop
            p1(7 downto 1) := p1(6 downto 0);
            p1(0) := a1(7);
            a1(7 downto 1) := a1(6 downto 0);           
                p1 := p1-b1;
            if(p1(8) ='1') then --gdy p1<b1 czyli wynik p1-b1 ujemny
                a1(0) :='0';
                p1 := p1+b1;
            else
                a1(0) :='1';           
            end if;
        end loop;
    return a1;
end divide;


function  mul (
    a : std_logic_vector(7 downto 0);
    b : std_logic_vector(7 downto 0))
    return std_logic_vector is
    
    variable a1 : std_logic_vector(7 downto 0) :=a;
    variable b1 : std_logic_vector(7 downto 0) :=b;
    variable p1 : std_logic_vector(15 downto 0):= (others => '0');
    variable i : integer:=0;
    begin
        while b1>"0000000" loop
            p1 := p1+ a1;                   
            b1 := b1 - "00000001";
        end loop;
    return p1;
end mul;


begin
reg: process(clk, nreset)
    begin
    if (nreset='0')then   
        result_temp_reg<= (others =>'0');
        borrow <= '0';
    elsif (clk'event and clk ='0') then -- dane ustawiane na zboczu opadaj¹cym
        result_temp_reg <= result_temp; -- wartoœæ rejetru na wyjœcie
       
        if (op= "1001" and u_a<u_b) then --odejmowanie 
                borrow <= '1'; --konieczny bit pozyczki jesli odjemna jest mniejsza od odjemnika
            else
                borrow <= '0';
        end if;
       
    end if;
end process reg;
    
u_result <= result_temp_reg;


process(op, u_a, u_b)
    begin
        case op is
        when "0000" =>    --and
            result_temp <= "00000000" &(u_a and u_b);
        when "0001" =>    --or
            result_temp <= "00000000" &(u_a or u_b);   
       
        when "0010" =>    --xor
            result_temp <= "00000000" &(u_a xor u_b);   
           
        when "0011" =>    --not na argumencie u_a
            result_temp <= "11111111" &(not u_a);   
           
        when "0100" => --porównanie a=b
            if u_a = u_b then
            result_temp <= "1111111111111111";
            else
            result_temp <= "0000000000000000";
            end if;
           
        when "0101" => --porównanie a>b
            if u_a > u_b then
            result_temp <= "1111111111111111";
            else
            result_temp <= "0000000000000000";
            end if;
           
        when "0110" => --porównanie a<b
            if u_a < u_b then
            result_temp <= "1111111111111111";
            else
            result_temp <= "0000000000000000";
            end if;
                       
        when "1000" => --dodawanie
            result_temp <= "0000000" & (('0' & u_a) + ('0' &u_b));       
       
        when "1001" => --odejmowanie 
            if u_a>= u_b then
            result_temp <= "00000000" &(u_a - u_b);
            else
                result_temp <= "0000000" &(('1' & u_a) - u_b);
            end if;
           
        when "1010" => --dzielenie
            result_temp <=  "00000000" & divide ( u_a , u_b ); --dzielenie
           
        when "1011" => --mno¿enie
            result_temp <= mul (u_a, u_b);
       
        when others =>
            result_temp <= "0000000000000000";
    end case;   
                           
    end process;
           
end behavioral;

