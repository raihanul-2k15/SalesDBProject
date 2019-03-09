set serveroutput on;

-- apply 10% discount on $100 servers
begin
	apply_discount_on_rent(100, 10);
end;
/

-- get customers' most favorite rent
select get_most_popular_rent() from dual;

-- get customers' least favorite rent
select get_least_popular_rent() from dual;
