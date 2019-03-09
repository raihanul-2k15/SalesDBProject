create or replace function get_most_popular_rent
return server.rent%type
as
	max_r server.rent%type := 0;
	max_t is_using.hoursused%type := 0;
	
	cursor c is 
	select rent, sum(total) as total
	from server
	natural join (
		select serverid, sum(hoursused) as total
		from is_using
		group by serverid
	) temp1
	group by rent;
	
begin
	for rec in c loop
		if rec.total > max_t then
			max_t := rec.total;
			max_r := rec.rent;
		end if;
	end loop;
	
	return max_r;
end get_most_popular_rent;
/

create or replace function get_least_popular_rent
return server.rent%type
as
	min_r server.rent%type := 0;
	min_t is_using.hoursused%type := 99999999999999999999;
	
	cursor c is 
	select rent, sum(total) as total
	from server
	natural join (
		select serverid, sum(hoursused) as total
		from is_using
		group by serverid
	) temp1
	group by rent;
	
begin
	for rec in c loop
		if rec.total < min_t then
			min_t := rec.total;
			min_r := rec.rent;
		end if;
	end loop;
	
	return min_r;
end get_least_popular_rent;
/

