conn sys/sys as sysdba

grant execute on utl_file to public;

create or replace directory DIGITAL_SEA as 'C:\Users\raihanul\Desktop\db project\filesystem';

grant read, write on directory DIGITAL_SEA to public;