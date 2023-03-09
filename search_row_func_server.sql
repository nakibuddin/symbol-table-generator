


create or replace function search_row2 ( x in symbol_table.name%type, t_scope in symbol_table.name%type, z out int) return int is
y int;
begin
	-- 1 means found in symbol table
	-- 0 means not found in symbol table	
	y:=2;
	z:=0;
	
	for i in (select * from symbol_table@site1) loop
		-- dbms_output.put_line('x='||x||'  and i.name='||i.name);
		if i.name = x then
			if i.id_type='function' then
				-- dbms_output.put_line('-----------found: match with name and function in table');
				return 1;
			elsif i.scope_ = t_scope then
				z := i.sl_no;			
				-- dbms_output.put_line('----found: match with name, variable and scope');
				return 1;
			end if;			
		end if;				
	end loop;
	
	-- dbms_output.put_line('------------------------second loop start');
	for i in (select * from symbol_table@site1) loop
		-- dbms_output.put_line('x='||x||'  and i.name='||i.name);
		if i.name = x and i.scope_ ='global' then			
			-- dbms_output.put_line('----not found: match with name, variable and scope is global');
			return 0;			
		end if;				
	end loop;
	-- dbms_output.put_line('------------------------------ y=2');
	if y = 2 then		
		return 0;
	end if;
	-- dbms_output.put_line(y);
end search_row2;
/
