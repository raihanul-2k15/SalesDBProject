create or replace procedure apply_discount_on_rent
(currentRent in server.rent%type,
percent in number)
as
begin
	update server
	set rent = rent - rent * (percent / 100)
	where rent = currentRent;
	
	DBMS_output.put_line(
		'Discount applied on ' ||
		sql%rowcount ||
		' servers.'
	);
end apply_discount_on_rent;
/
