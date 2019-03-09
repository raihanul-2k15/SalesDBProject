set serveroutput on;

/* set 25% discount on least used servers bsaed on ren
   to get customers' attention */
begin
	apply_discount_on_rent(get_least_popular_rent(), 25);
end;
/

-- simple array example
declare
	type namearray is varray(4) of customer.name%type;
	a_name namearray := namearray();
	all_str varchar(500);
begin
	for counter in 1..4 loop
		a_name.extend();
		select name into a_name(counter)
		from customer
		where customerid = counter;
	end loop;

	all_str := 'Names of all customer: ';
	for counter in 1..4 loop
		all_str := all_str|| a_name(counter) || ', ';
	end loop;

	DBMS_output.put_line(all_str);
	DBMS_output.put_line('Total customers: ' || a_name.count());
end;
/

/* another array example
   increase employees' salary if their service is satisfactory */
declare
	type TidarrayT is varray(100) of employee.employeeid%type;
	success integer;
	counter integer;
	updateCounter integer := 0;
	id_arr TidarrayT;
begin
	select distinct employeeid bulk collect into id_arr
	from serviced_by;
	
	for counter in 1..id_arr.count() loop
		select count(success) into success
		from serviced_by
		where employeeid = id_arr(counter) and success='Y';
		
		if success >= 4 then
			update employee
			set salary = salary * 1.01
			where employeeid = id_arr(counter);
			
			updateCounter := updateCounter + 1;
		end if;
	end loop;
	
	if updateCounter = 0 then
		DBMS_output.put_line('No Salary updated');
	else
		DBMS_output.put_line(updateCounter || ' employees salary has been increased by 1%');
	end if;
end;
/