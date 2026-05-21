SELECT *
    FROM dblink('dbname=traslation', 'SELECT usr_name,	usr_lasname,	usr_nick FROM user_login')
      AS t1(usr_name text,	usr_lasname text,	usr_nick text)
    WHERE usr_nick LIKE 'a%';
		
		
		SELECT * FROM dblink('dbname=postgres', 'select proname, prosrc from pg_proc')
  AS t1(proname name, prosrc text) WHERE proname LIKE 'bytea%';
	
	CREATE EXTENSION dblink;