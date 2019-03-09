set serveroutput on;

-- customers start using servers
insert into is_using(sessionid, customerid, serverid, starttime) values(50001, 1, 303, current_date - 61);
insert into is_using(sessionid, customerid, serverid, starttime) values(50002, 2, 304, current_date - 56);
insert into is_using(sessionid, customerid, serverid, starttime) values(50003, 1, 305, current_date - 30);
insert into is_using(sessionid, customerid, serverid, starttime) values(50004, 2, 306, current_date - 2);
insert into is_using(sessionid, customerid, serverid, starttime) values(50005, 3, 353, current_date - 10);
insert into is_using(sessionid, customerid, serverid, starttime) values(50006, 4, 359, current_date - 37);

-- customers get charged for using servers per hour
update is_using set hoursused = hoursused + 50 where sessionid = 50001;
update is_using set hoursused = hoursused + 50 where sessionid = 50002;
update is_using set hoursused = hoursused + 50 where sessionid = 50003;
update is_using set hoursused = hoursused + 10 where sessionid = 50004;
update is_using set hoursused = hoursused + 100 where sessionid = 50005;
update is_using set hoursused = hoursused + 149 where sessionid = 50006;

-- customers stop using servers (trigger on_session_end)
update is_using set active = 'N';

-- new customers start using servers
insert into is_using(sessionid, customerid, serverid, starttime) values(50007, 4, 303, current_date - 5);
insert into is_using(sessionid, customerid, serverid, starttime) values(50008, 3, 304, current_date - 8);
insert into is_using(sessionid, customerid, serverid, starttime) values(50009, 4, 305, current_date - 3);
insert into is_using(sessionid, customerid, serverid, starttime) values(50010, 3, 306, current_date - 10);
insert into is_using(sessionid, customerid, serverid, starttime) values(50011, 2, 353, current_date - 15);
insert into is_using(sessionid, customerid, serverid, starttime) values(50012, 1, 359, current_date - 12);

-- new customers get charged for using servers per hour
update is_using set hoursused = hoursused + 50 where sessionid = 50007;
update is_using set hoursused = hoursused + 50 where sessionid = 50008;
update is_using set hoursused = hoursused + 50 where sessionid = 50009;
update is_using set hoursused = hoursused + 10 where sessionid = 50010;
update is_using set hoursused = hoursused + 100 where sessionid = 50011;
update is_using set hoursused = hoursused + 149 where sessionid = 50012;

-- example error - trying to rent server that is already in use
insert into is_using(sessionid, customerid, serverid, starttime) values(50013, 4, 306, current_date);

-- example error - trying to charge customer for session that is already closed
update is_using set hoursused = hoursused + 10 where sessionid = 50001;

-- example error - account balance too low
update is_using set hoursused = hoursused + 50000 where sessionid = 50009;

commit;
