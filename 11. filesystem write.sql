set serveroutput on;

select count(*) as records from is_using;

declare
	f utl_file.file_type;
	cursor c is
		select *
		from is_using
		where active = 'N'
			and current_date - starttime > interval '30' day;
	counter integer := 0;
begin
	f := utl_file.fopen(
		'DIGITAL_SEA',
		'old_session_data.csv',
		'A'
	);
	
	if not utl_file.is_open(f) then
		raise_application_error(
			-20000,
			'File could not be opened. Export unsuccessful.'
		);
	end if;
	
	for rec in c loop
		utl_file.put_line(
			f,
			rec.sessionid || ',' ||
			rec.customerid || ',' ||
			rec.serverid || ',' ||
			rec.starttime || ',' ||
			rec.hoursused || ',' ||
			rec.bill || ',' ||
			rec.active
		);
		
		delete
		from is_using
		where sessionid = rec.sessionid;
		
		counter := counter + 1;
	end loop;
	utl_file.fclose(f);
	
	commit;
	DBMS_output.put_line(counter || ' records exported to file');
end;
/

select count(*) as records from is_using;
