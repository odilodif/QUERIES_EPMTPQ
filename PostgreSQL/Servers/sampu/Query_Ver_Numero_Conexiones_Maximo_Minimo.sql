SELECT COUNT(*) from pg_stat_activity;

select min_val, max_val from pg_settings where name='max_connections';

SELECT pid ,datname ,usename ,application_name ,client_hostname ,client_port ,backend_start ,query_start ,query from pg_stat_activity;


select * from pg_stat_activity where client_addr = '192.168.1.33';