drop FUNCTION f_only_update_trasl_type_user_login_saved(int, int);

CREATE OR REPLACE FUNCTION f_only_update_trasl_type_user_login_saved( trasl_type_id INT, idusr_sgp INT )
RETURNS BOOLEAN AS 
$body$
DECLARE
_usr_id INT;
_trasl_type_user_id INT;
BEGIN
	IF EXISTS (SELECT 1 from trasl_type_user_login_saved typu1 WHERE typu1.usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp) AND typu1.trasl_type_id= $1 ) THEN
	_trasl_type_user_id=(SELECT typu.trasl_type_user_id  from trasl_type_user_login_saved typu WHERE typu.usr_id=(SELECT u.usr_id from user_login u  WHERE u.usr_id_sgp= idusr_sgp) AND typu.trasl_type_id= $1);
	UPDATE trasl_type_user_login_saved SET "state"= FALSE WHERE trasl_type_user_id = _trasl_type_user_id;	
	RETURN TRUE;
	ELSE 	
		RETURN FALSE;
	END IF;
END;
$body$
LANGUAGE plpgsql VOLATILE

SELECT f_only_update_trasl_type_user_login_saved(6,2061);