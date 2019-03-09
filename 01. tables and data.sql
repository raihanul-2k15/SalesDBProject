drop trigger on_session_end;
drop trigger on_session_start;
drop trigger on_hourly_usage;

drop function get_least_popular_rent;
drop function get_most_popular_rent;

drop procedure apply_discount_on_rent;

drop view customer_summary;

drop table serviced_by;
drop table is_using;
drop table Server;
drop table Account;
drop table Employee;
drop table Customer;

create table Customer(
    CustomerID integer,
    Name varchar(20) not null,
	BirthDate date,
	Address varchar(255),
    primary key(CustomerID)
);
	
create table Account(
	AccountNo integer,
	DateCreated date not null,
	Balance number(10,5) default 0.00 check(Balance >= -50.00),
	OwnerID integer,
	primary key(AccountNo),
	foreign key(OwnerID) references Customer(CustomerID)
);

create table Employee(
	EmployeeID integer,
	Name varchar(20) not null,
	BirthDate date,
	Salary number(5) default 0 check(Salary >= 0),
	primary key(EmployeeID)
);

create table Server (
	ServerID integer,
	OS varchar(10) not null,
	RAM number(2) not null check(RAM >= 1),
	Storage number(4) not null check(Storage >= 10),
	Rent number(3) not null check(Rent >= 5),
	Available char(1) default 'Y' check(Available in ('Y', 'N')),
	MonitorID integer,
	primary key(ServerID),
	foreign key(MonitorID) references Employee(EmployeeID)
);

create table is_using(
	SessionID integer,
	CustomerID integer,
	ServerID integer,
	StartTIme timestamp not null,
	HoursUsed integer default 0,
	Bill number(10,5) default 0.00 check(Bill >= 0.00),
	Active char(1) default 'Y' check(Active in ('Y', 'N')),
	primary key(SessionID),
	foreign key(CustomerID) references Customer(CustomerID),
	foreign key(ServerID) references Server(ServerID)
);

create table serviced_by(
	ServiceID integer,
	CustomerID integer,
	EmployeeID integer,
	ServiceType varchar(30),
	ServiceDate  date not null,
	Success varchar(1) not null check(Success in('Y', 'N')),
	primary key(ServiceID),
	foreign key(CustomerID) references Customer(CustomerID),
	foreign key(EmployeeID) references  Employee(EmployeeID)
);

insert into Customer values(1, 'Lee Sin', '9-SEP-1984', 'Nowhere');
insert into Customer values(2, 'Master Yi', '1-FEB-2000', 'Somewhere');
insert into Customer values(3, 'Yasuo', '15-AUG-1997', 'Everywhere');
insert into Customer values(4, 'Fiora', '16-DEC-1971', 'Anywhere');

insert into Account values(101, current_date - 62, 20.25, 1);
insert into Account values(105, current_date - 97, 200, 2);
insert into Account values(117, current_date - 35, 30.56, 3);
insert into Account values(125, current_date - 365, -6.25, 4);

insert into Employee values(1, 'Fizz', '25-MAR-1990', 90000);
insert into Employee values(3, 'Twitch', '29-AUG-1995', 95000);
insert into Employee values(4, 'Xayah', '12-JUL-1998', 50000);
insert into Employee values(7, 'Jinx', '10-OCT-1988', 70000);

insert into Server values(303, 'Ubuntu 14', 1, 20, 5, 'Y', 1);
insert into Server values(304, 'Ubuntu 14', 2, 10, 5, 'Y', 1);
insert into Server values(305, 'Ubuntu 14', 1, 20, 5, 'Y', 1);
insert into Server values(306, 'Mac OS', 2, 40, 10, 'Y', 7);
insert into Server values(307, 'Mac OS', 4, 18, 10, 'Y', 7);
insert into Server values(338, 'Ubuntu 16', 8, 256, 50, 'Y', 1);
insert into Server values(353, 'Linux', 32, 512, 100, 'Y', 7);
insert into Server values(359, 'Linux', 64, 512, 150, 'Y', 7);
insert into Server values(335, 'Debian', 4, 50, 80, 'Y', 4);
insert into Server values(331, 'Win Server', 4, 50, 75, 'Y', 7);
insert into Server values(333, 'Win Server', 2, 110, 75, 'Y', 7);

insert into serviced_by values(501, 2, 4, 'Technical Issue', current_date - 460, 'Y');
insert into serviced_by values(502, 1, 7, 'Balance Topup', current_date - 220, 'Y');
insert into serviced_by values(503, 1, 4, 'Technical Issue', current_date - 28, 'N');
insert into serviced_by values(504, 2, 7, 'Balance Topup', current_date - 123, 'Y');
insert into serviced_by values(505, 1, 7, 'Balance Topup', current_date - 35, 'Y');
insert into serviced_by values(506, 2, 7, 'Networking Issue', current_date - 30, 'Y');
insert into serviced_by values(507, 3, 7, 'Networking Issue', current_date - 0, 'Y');

commit;
