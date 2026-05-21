SELECT * FROM prison_person WHERE id=328218;


SELECT * FROM prison_crime WHERE name= 'TIPO VALIDAR'; -- 139 TIPO

SELECT * FROM res_users WHERE id = 1957;
SELECT * FROM res_users WHERE id = 1726;


SELECT * FROM prison_crime WHERE id = 1778;
SELECT * FROM prison_crime WHERE id = 3789;


SELECT * FROM prison_person WHERE prontuario='MJDHC-A-00257714';

SELECT * FROM prison_person WHERE prontuario='MJDHC-A-00321798';


SELECT * FROM prison_detention where id= 327270;

SELECT * FROM prison_detention where person_id= 328218;

SELECT * FROM prison_crime_type WHERE id in (139);


SHOW config_file;




SHOW data_directory;



select format('%s/%s', 
    current_setting('data_directory'),
    current_setting('log_directory'));
		
		
		
		
Configiracion en el archivo postgresql.conf
		
		log_statement = 'all'
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
logging_collector = on
log_min_error_statement = error


sudo /etc/init.d/postgresql restart



