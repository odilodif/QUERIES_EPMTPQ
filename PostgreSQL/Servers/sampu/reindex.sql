SELECT *FROM information_schema.tables where table_catalog='sgp' and table_schema='public' and table_type='BASE TABLE';


/*SELECT *FROM pg_indexes where schemaname not like 'pg_%' and schemaname='public' and indexname like 'mail_message_model_index';  */
SELECT *FROM pg_indexes where schemaname not like 'pg_%' and schemaname='public' and indexname like 'mail_message_author_id_index';  

REINDEX INDEX mail_message_author_id_index;
COMMIT;

--select *from  pg_toast.pg_toast_16444;
select *from  pg_toast.pg_toast_885039 limit 1;

SELECT oid FROM pg_class WHERE relname = 'prison_person'

select  *from  pg_toast.pg_toast_885039
select *from pg_toast.pg_toast_884185;


select  *from  pg_toast.pg_toast_885039 where chunk_id ='2157768'

select reltoastrelid::regclass from pg_class where relname =
'prison_person'


SELECT * FROM prison_person limit 1

SELECT * FROM pg_stat_activity WHERE state = 'active';

SELECT * from pg_toast_884185 limit 1;--where chunk_id ='2157768'




REINDEX DATABASE sgp;