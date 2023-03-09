

create or replace procedure insert_proc(var_func_t in int, sl_no in int, t_name in symbol_table.name%type,
t_id_type in symbol_table.name%type, t_data_type in symbol_table.name%type, t_scope in symbol_table.name%type, t_value in symbol_table.name%type ) is
begin
	if var_func_t = 1 then
		INSERT INTO symbol_table@site1 (sl_no,name, id_type, data_type, scope_)
		VALUES (sl_no, t_name, t_id_type, t_data_type, 'global');
		commit;
	elsif var_func_t =0 then
		INSERT INTO symbol_table@site1 (sl_no, name, id_type, data_type, scope_, value_)
		VALUES (sl_no, t_name, t_id_type, t_data_type, t_scope, t_value);
		commit;
	end if;	
	
end insert_proc;
/


-- dbms_output.put_line(t_name);
-- dbms_output.put_line(t_id_type);
-- dbms_output.put_line(t_data_type);
-- dbms_output.put_line(t_scope);	
-- dbms_output.put_line(t_value);