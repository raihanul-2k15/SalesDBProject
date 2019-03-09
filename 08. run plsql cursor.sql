set serveroutput on;

-- List all customers who have negative balance
declare
	cursor c is select name, accountno, balance from customer c join account a on c.customerid = a.ownerid where a.balance < 0;
	c_name customer.name%type;
	a_accno account.accountno%type;
	a_blnc account.balance%type;
begin
	DBMS_output.put_line('The following users have negative account balance: ');
	open c;
	loop
		fetch c into c_name, a_accno, a_blnc;
		exit when c%notfound;
		
		DBMS_output.put_line(
		'Name: ' ||
		c_name ||
		', Account number: ' ||
		a_accno ||
		', Balance: ' ||
		a_blnc
	);
	end loop;
	close c;
end;
/