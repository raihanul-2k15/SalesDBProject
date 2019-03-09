-- List all customer and their account balance
select c.name, a.accountno, a.balance
from customer c
join account a
on c.customerid = a.ownerid;

-- Find all servers Lee is/was using
select serverid, os, ram, storage
from server
where serverid in (
	select serverid
	from is_using
	where customerid in (
		select customerid
		from customer
		where name like '%Lee%'
	)
);

-- Compute current income rate of company
select sum(rent) as Current_Income_Rate
from server
natural join is_using
where active = 'Y';

-- Compute current salary expense rate of company
select sum(salary) as Total_Salary
from Employee;

-- example union - list members of company
select name, birthdate, 'Customer' as type
from customer
union
select name, birthdate, 'Employee' as type
from employee;

