
set verify off;
SET SERVEROUTPUT ON;

-- create table show_output_site(sl_no int, name varchar(10), id_type varchar(10), data_type varchar(10), scope_ varchar(10), value_ varchar(10));

drop table input_table_site;
create table input_table_site(input_no_s int, input_name_s varchar(1000));

-- INSERT INTO input_table_site VALUES (1, '[kw float] [id x1] [op =] [num 3.125] [sep ;] [kw double] [id f1] [par (] [kw int] [id x] [par )] [brc {] [kw double] [id z] [sep ;] [id z] [op =] [num 0.01] [sep ;]' );



-- accept x char prompt " press 1 to see previous output     press 2 for enter new token stream        "
 
accept x char prompt "Enter token stream: "

DECLARE	
	-- x char := '&x';
	input_val input_table_site.input_name_s%type := '&x';
	token_stream varchar(1000);
BEGIN	
		
	INSERT INTO input_table_site VALUES (1, input_val );
	
END;
/