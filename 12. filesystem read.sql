set serveroutput on;

select count(*) as records from is_using;

declare
	f 				utl_file.file_type;
	f2 				utl_file.file_type;
	line 			varchar(1000);
	counter			integer := 0;
	i_sessionid 	is_using.sessionid%type;
	i_customerid 	is_using.customerid%type;
	i_serverid 		is_using.serverid%type;
	i_starttime 	is_using.starttime%type;
	i_hoursused 	is_using.hoursused%type;
	i_bill 			is_using.bill%type;
	i_active 		is_using.active%type;
begin
	f := utl_file.fopen(
		'DIGITAL_SEA',
		'old_session_data.csv',
		'R'
	);
	
	if not utl_file.is_open(f) then
		raise_application_error(
			-20000,
			'File could not be opened. Import unsuccessful'
		);
	end if;
	
	utl_file.get_line(f, line, 1000);
	loop
		begin
			utl_file.get_line(f, line, 1000);
			
			if line is null then
				exit;
			end if;
			
			i_sessionid	 := regexp_substr(line, '[^,]+', 1, 1);
			i_customerid := regexp_substr(line, '[^,]+', 1, 2);
			i_serverid 	 := regexp_substr(line, '[^,]+', 1, 3);
			i_starttime  := regexp_substr(line, '[^,]+', 1, 4);
			i_hoursused  := regexp_substr(line, '[^,]+', 1, 5);
			i_bill 		 := regexp_substr(line, '[^,]+', 1, 6);
			i_active 	 := regexp_substr(line, '[^,]+', 1, 7);
			
			insert
			into is_using
			values (
				i_sessionid,
				i_customerid,
				i_serverid,
				i_starttime,
				i_hoursused,
				i_bill,
				i_active
			);
			
			counter := counter + 1;
		exception
			when no_data_found then
				exit;
		end;
	end loop;
	utl_file.fclose(f);
	
	-- clear file after successful import
	f2 := utl_file.fopen(
		'DIGITAL_SEA',
		'old_session_data.csv',
		'W'
	);
	utl_file.put_line(f2, 'sessionid,customerid,serverid,starttime,hoursused,bill,active');
	utl_file.fclose(f2);
	
	commit;
	DBMS_output.put_line(counter || ' records imported from file');
end;
/

select count(*) as records from is_using;
