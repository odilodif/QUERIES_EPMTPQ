select pg_size_pretty( pg_relation_size( 'audittrail_log_line' ) );
select relname, relfilenode, reltoastrelid from pg_class where relkind = 'r' and oid = 'audittrail_log_line'::regclass;

select relname, relfilenode, reltoastrelid, 
                pg_relation_filepath( reltoastrelid ) 
                from pg_class where relkind = 'r' 
                and oid = 'audittrail_log_line'::regclass;
                
								
								select * from f_find_bad_toast( 'audittrail_log_line', 'id' );


select /*log	log_id	field_id	old_value	new_value_text	old_value_text	new_value	field_description*/ from audittrail_log_line;

select 	old_value from audittrail_log_line;