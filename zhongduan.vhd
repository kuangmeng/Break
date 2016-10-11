library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_1164.ALL;

entity zhongduan is
    Port ( clk : in STD_LOGIC;
				b : inout  STD_LOGIC;
           d : inout  STD_LOGIC;
           start : in  STD_LOGIC;--启动设备工作信号
			  check : in  STD_LOGIC;-- 中断查询信号
           mask : in  STD_LOGIC_VECTOR (7 downto 0);--屏蔽信号
           finish : in  STD_LOGIC; -- 设备准备就绪信号
           intr : inout  STD_LOGIC_VECTOR (7 downto 0);
           intp : inout  STD_LOGIC_VECTOR (7 downto 0);
           inta : in  STD_LOGIC;
           pc : out  STD_LOGIC_VECTOR (7 downto 0));
end zhongduan;

architecture Behavioral of zhongduan is

signal i: integer range 0 to 7;


begin
	process(start,finish,check,inta)
	begin
	
	if((start='1' and finish = '0') and(check='0' and inta = '0' ))then 
			b<= '1';
			d<= '0';
	end if;
	if((finish='1' and start = '1')and(check = '0' and inta = '0'))then
			d <= '1';
			b <= '0';
	end if;
	if((finish='1' and start = '1')and(check = '1' and inta = '0'))then
			for i in 0 to 7 loop
					if (mask(i) = '0')then 
						intr(i)<= '1';
					else
						intr(i)<='0';
					end if;           
			end loop;
	end if;
	if(start = '0')then
		intr <= "00000000";
	end if;
	end process;
	
	process(intr,inta)
	begin
		if((inta = '0' and start = '1')and(finish = '1' and check = '1'))then
				if (intr(7) = '1')then
					intp <= "10000000";
				elsif(intr(6) = '1')then
					intp <= "01000000";
				elsif(intr(5) = '1')then
					intp <= "00100000";
				elsif(intr(4) = '1')then
					intp <= "00010000";
				elsif(intr(3) = '1')then
					intp <= "00001000";
				elsif(intr(2) = '1')then
					intp <= "00000100";
				elsif(intr(1) = '1')then
					intp <= "00000010";
				elsif(intr(0) = '1')then
					intp <= "00000001";
				else
					intp <= "ZZZZZZZZ";
				end if;
		end if;
		
		if((finish='1' and start = '1')and(check = '1' and inta = '1'))then 
			pc <= intp;
		end if;
		if(inta = '0' and start = '0')then
			pc <= "ZZZZZZZZ";
			intp <= "00000000";
		end if;
	end process;
	
end Behavioral;

