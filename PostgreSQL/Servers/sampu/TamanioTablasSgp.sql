SELECT sum(pg_column_size(devices)) FROM devices WHERE country = 'US';
SELECT sum(pg_column_size(prison_person)) FROM prison_person WHERE identificador = '0952469559';
 

SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_total_relation_size(C.oid)) AS "total_size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
    AND C.relkind <> 'i'
    AND nspname !~ '^pg_toast'
  ORDER BY pg_total_relation_size(C.oid) DESC
  LIMIT 20;

 
SELECT * from prison_person WHERE prontuario = 'MJDHC-A-00140741'

SELECT count(id) from prison_person where STATE <> 'free';


SELECT * from audittrail_log_line limit 1
SELECT  * from audittrail_log LIMIT 1

SELECT * from res_users WHERE id = 613
SELECT * FROM prison_person WHERE last_name like '%GOMEZ MORALES%'


SELECT * FROM audittrail_log LIMIT 100;



SELECT oid FROM pg_database WHERE datname = current_database();

SELECT relfilenode, reltoastrelid FROM pg_class WHERE relname = 'prison_person';
SELECT relname, relfilenode FROM pg_class WHERE oid = 885042;

SELECT * FROM  ir_model WHERE id= (159);
SELECT * FROM audittrail_rule limit 1;

SELECT * FROM audittrail_log  WHERE id < (SELECT max(id) FROM audittrail_log )  ORDER BY 1 DESC LIMIT 100;