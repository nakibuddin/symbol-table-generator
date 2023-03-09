set verify off;
SET SERVEROUTPUT ON; 
-- accept x char prompt "Enter token stream: "

select * from money where id=0;--works like exactly 02.c 

-- drop table symbol_table@site1;
delete from symbol_table@site1;
-- delete from symbol_table;
-- create table symbol_table@site1(sl_no int, name varchar(10), id_type varchar(10), data_type varchar(10), scope_ varchar(10), value_ varchar(10));

@"C:\Users\ASUS\Desktop\4-1\Lab\04 Distributed Database Lab\project\search_row_func_server.sql";

@"C:\Users\ASUS\Desktop\4-1\Lab\04 Distributed Database Lab\project\insert_proc_server.sql";

declare
	type char_arr is table of char(1) index by pls_integer;
	-- l_str varchar2(1000) := '[id z1] [id z1] [id z1]'; --why this line give error?
	-- l_str varchar2(1000) := '[kw float] [id x1] [op =] [id f1]';
	-- l_str varchar2(1000) := '[kw float] [id z] [op =] [num 0.01] [kw double] [id f1] [par (] [kw int] [id k] [op =] [num 5.5]';
	
	-- l_str varchar2(1000) := '[kw float] [id x1] [op =] [num 3.125] [sep ;] [kw double] [id f1] [par (] [kw int] [id x] [par )] [brc {] [kw double] [id z] [sep ;] [id z] [op =] [num 0.01] [sep ;] [kw return] [id z] [kw int] [id x1] [sep ;] [sep ;] [brc }] [kw int] [id main] [par (] [kw void] [par )] [brc {] [kw int] [id n1] [sep ;] [kw float] [id x1] [op =] [num 7.4] [sep ;] [kw double] [id z] [sep ;] [id n1] [op =] [num 25] [sep ;] [id z] [op =] [id f1] [par (] [id n1] [par )] [sep ;] [id f1] [par (] [par )] [sep ;]';
	
	-- l_str varchar2(1000) := '[kw float] [id x1] [op =] [num 3.125] [sep ;] [kw double] [id f1] [par (] [kw int] [id x] [par )] [brc {] [kw double] [id z] [sep ;] [id z] [op =] [num 0.01] [sep ;] [kw return] [id z] [sep ;] [brc }] [kw int] [id main] [par (] [kw void] [par )] [brc {] [kw int] [id n1] [sep ;] [kw double] [id z] [sep ;] [id n1] [op =] [num 25] [sep ;] [id z] [op =] [id f1] [par (] [id n1] [par )] [sep ;] [id f1] [par (] [par )] [sep ;]';		
	
	l_str varchar2(1000) ;
	
	ch_ar_empty char_arr;	
	ch_ar char_arr;
	ch_ar2 char_arr;
	ch_ar3 char_arr;
	ch_ar4 char_arr;
	ch_ar5 char_arr;
	
	lex varchar(15); sl_no int :=1;	t_name varchar(15);
	t_id_type varchar(15); t_data_type varchar(15);
	t_scope varchar(15):= 'null'; t_value varchar(10);
	
	j int := 1 ;
	k int := 1 ;
	z int := 0;
	y int := 0;
	t1 int := 0;	
 -- t for track
	var_func_t int :=1;
	
begin	
	for i in (select * from input_table_site@site1) loop		
		if i.input_no_s = 1 then
			l_str := i.input_name_s;
			exit;
		end if;				
	end loop;
	
	ch_ar3(1) :='a';
	for i in 1 .. length(l_str)	loop						
		ch_ar(i) := substr( l_str, i, 1 );
	end loop;	
	
	for i in 1 .. ch_ar.count	loop					
		ch_ar2 := ch_ar_empty;
		j :=1;
		while k<=ch_ar.count and ch_ar(k)!=']' loop
			ch_ar2(j) := ch_ar(k);
			j := j+1;						
			k := k+1;		
		end loop;
		ch_ar4 := ch_ar3;
		ch_ar3 := ch_ar2;		
		
		lex :='';
		if ch_ar2(2)='i' and ch_ar2(3)='d' then
			for x in 5..ch_ar2.last loop
				lex := concat( lex, ch_ar2(x));
			end loop;
		
			y := search_row2(lex,t_scope,z);									
			-- dbms_output.put_line(lex|| '  ' || z);
			
			
			
			if y != 0  then
				-- if found in symbol_table
				if k >= ch_ar.count then
					exit;		
				else
					k := k+2;			
				end if;
				
				ch_ar2 := ch_ar_empty;
				j :=1;
				while k<=ch_ar.count and ch_ar(k)!=']' loop
					ch_ar2(j) := ch_ar(k);
					j := j+1;						
					k := k+1;		
				end loop;
				ch_ar3 := ch_ar2;
				
				j:=1;
				while ch_ar2(j) !=' ' loop
					j:=j+1;
				end loop;
				j:=j+1;
				
				lex :='';
				for x in j..ch_ar2.last loop
					lex := concat( lex, ch_ar2(x));
				end loop;				
				
				if lex = '=' then
					if k >= ch_ar.count then
						exit;		
					else
						k := k+2;			
					end if;
					
					ch_ar2 := ch_ar_empty;
					j :=1;
					while k<=ch_ar.count and ch_ar(k)!=']' loop
						ch_ar2(j) := ch_ar(k);
						j := j+1;						
						k := k+1;		
					end loop;
					ch_ar3 := ch_ar2;
					
					if ch_ar2(2)='n' and ch_ar2(3)='u' and ch_ar2(4)='m' then
						-- j:=1;
						-- while ch_ar2(j) !=' ' loop
							-- j:=j+1;
						-- end loop;
						-- j:=j+1;
						
						lex :='';
						for x in 6..ch_ar2.last loop
							lex := concat( lex, ch_ar2(x));
						end loop;
						-- dbms_output.put_line('lex =' ||lex);
						update symbol_table@site1 set value_= lex  where sl_no=z;
					end if;
				end if;									
			end if;
			
			
			
			
			
			
			
			
			
			if y=0 then
				-- dbms_output.put_line('no rows found');
				t_name := lex;
				
				if k >= ch_ar.count then
					exit;		
				else
					k := k+2;			
				end if;
				
				ch_ar2 := ch_ar_empty;
				j :=1;
				while k<=ch_ar.count and ch_ar(k)!=']' loop
					ch_ar2(j) := ch_ar(k);
					j := j+1;						
					k := k+1;		
				end loop;
				ch_ar3 := ch_ar2;
				
				j:=1;
				while ch_ar2(j) !=' ' loop
					j:=j+1;
				end loop;
				j:=j+1;
				
				lex :='';
				for x in j..ch_ar2.last loop
					lex := concat( lex, ch_ar2(x));
				end loop;				
				
				if lex = '(' then
					t1 := 1;
					t_scope := t_name;
					t_id_type := 'function';
					
					-- for i in ch_ar4.first..ch_ar4.last loop
						-- dbms_output.put( ch_ar4(i) );	
					-- end loop;
					-- dbms_output.put_line('');
	
					j:=1;
					while ch_ar4(j) !=' ' loop
						j:=j+1;
					end loop;
					j:=j+1;
					
					t_data_type :='';
					for x in j..ch_ar4.last loop
						t_data_type := concat( t_data_type, ch_ar4(x));
					end loop;
					
					var_func_t := 1;
					insert_proc(var_func_t, sl_no, t_name, t_id_type, t_data_type, t_scope, t_value);
										
					sl_no := sl_no +1;
				else
					if t1 = 0 then
						t_scope := 'global';					
					end if;
										
					t_id_type := 'var';
					
					j:=1;
					while ch_ar4(j) !=' ' loop
						j:=j+1;
					end loop;
					j:=j+1;
					
					t_data_type :='';
					for x in j..ch_ar4.last loop
						t_data_type := concat( t_data_type, ch_ar4(x));
					end loop;
					
					t_value := '';
					if lex = '=' then
						
						if k >= ch_ar.count then
							exit;		
						else
							k := k+2;			
						end if;
						
						ch_ar2 := ch_ar_empty;
						j :=1;
						while k<=ch_ar.count and ch_ar(k)!=']' loop
							ch_ar2(j) := ch_ar(k);
							j := j+1;						
							k := k+1;		
						end loop;
						ch_ar3 := ch_ar2;
						
						j:=1;
						while ch_ar2(j) !=' ' loop
							j:=j+1;
						end loop;
						j:=j+1;
						
						lex :='';
						for x in j..ch_ar2.last loop
							lex := concat( lex, ch_ar2(x));
						end loop;
						t_value := lex;											
					end if;					
					
					var_func_t := 0;
					insert_proc(var_func_t, sl_no, t_name, t_id_type, t_data_type, t_scope, t_value);
							
					sl_no := sl_no +1;
				end if;
			end if;
		end if;
		
		
		
		
		
		
		
		if k >= ch_ar.count then
			exit;		
		else
			k := k+2;			
		end if;
	end loop;
	
	-- for i in ch_ar2.first..ch_ar2.last loop
		-- dbms_output.put( ch_ar2(i) );	
	-- end loop;
	-- dbms_output.put_line('');	
	-- dbms_output.put_line(k);	
end;
/

-- select * from symbol_table; 

commit;



























 