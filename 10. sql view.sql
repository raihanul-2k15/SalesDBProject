create or replace view customer_summary
as (
	select name, 
	       extract(year from current_date) - extract(year from birthdate) as age,
	       balance,
		   currently_using
	from customer
	join (
		select customerid, balance, currently_using
		from account
		join (
			select customerid, count(serverid) as currently_using
			from is_using
			where active = 'Y'
			group by customerid
		) temp1
		on account.ownerid = temp1. customerid
	) temp2
	on customer.customerid = temp2.customerid
)
with read only;

select * from customer_summary;