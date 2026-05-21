 SELECT reltoastrelid, reltoastrelid::regclass, pg_relation_filepath( reltoastrelid::regclass ) 
  FROM   pg_class
  WHERE  relname = 'audittrail_log_line'
  AND    relkind = 'r';


SELECT attname::text
FROM   pg_attribute
WHERE  attrelid = 'audittrail_log_line'::regclass
AND    attstorage IN ('x', 'e') 


select relname, relfilenode, reltoastrelid, 
                pg_relation_filepath( reltoastrelid ) 
                from pg_class where relkind = 'r' 
                and oid = 'audittrail_log_line'::regclass;
								
								

select* from f_find_bad_toast('audittrail_log_line','id');