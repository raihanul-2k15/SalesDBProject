create or replace trigger on_hourly_usage
before update
of hoursused
on is_using
for each row
declare
	h_usage integer;
	calc_bill account.balance%type;
	s_rent server.rent%type;
	c_name customer.name%type;
	session_ended exception;
begin
	if :new.active != 'Y' then
		raise session_ended;
	end if;

	h_usage := :new.hoursused - :old.hoursused;
	
	select rent into s_rent
	from server
	where serverid = :new.serverid;
	
	calc_bill := h_usage * s_rent / (24 * 30);
	
	update account
	set balance = balance - calc_bill
	where ownerid = :old.customerid;
	
	:new.bill := :new.bill + calc_bill;
	
	select name into c_name
	from customer
	where customerid = :old.customerid;
	
	DBMS_output.put_line(
		'Customer ' ||
		c_name ||
		' has been chanrged $' ||
		calc_bill
	);
exception
	when session_ended then
	raise_application_error(
		-20000,
		'Session has ended.'
	);
	when others then
	raise_application_error(
		-20000,
		'Account balance too low.'
	);
end;
/

create or replace trigger on_session_start
before insert
on is_using
for each row
declare
	avl server.Available%type;
	c_name customer.name%type;
	s_rent server.rent%type;
begin
	-- if new session really starting
	if :new.active = 'Y' then
		select available into avl
		from server
		where serverid = :new.serverid;
		
		if avl != 'Y' then
			raise_application_error(
				-20000,
				'Server ' ||
				:new.serverid ||
				' is not available.'
			);
		end if;
		
		select name into c_name
		from customer
		where customerid = :new.customerid;
		
		select rent into s_rent
		from server
		where serverid = :new.serverid;
		
		update server
		set available = 'N'
		where serverid = :new.serverid;
		
		DBMS_output.put_line(
			'Customer ' ||
			c_name ||
			' has started using server ' ||
			:new.serverid ||
			' of monthly rent $' ||
			s_rent
		);
	end if;
	-- else simply insert data
end;
/

create or replace trigger on_session_end
after update
of active
on is_using
for each row
begin
	if :old.active = 'N' and :new.active = 'Y' then
		raise_application_error(
			-20000,
			'Cannot resume a session. Start a new session instead'
		);
	end if;

	if :old.active = 'Y' and :new.active = 'N' then
		update server
		set available = 'Y'
		where serverid = :new.serverid;
		
		DBMS_output.put_line(
			'Server ' ||
			:new.serverid ||
			' is now available for use. '
		);
	end if;
end;
/
