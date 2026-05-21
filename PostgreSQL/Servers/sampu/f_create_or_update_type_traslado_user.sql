/*****************************PRUEBAS**************************************/
SELECT typu.trasl_type_id  FROM   trasl_type_user_login_saved typu  INNER JOIN user_login usr  on  typu.usr_id = usr.usr_id 
 WHERE typu.usr_id=  (SELECT usr_id FROM user_login WHERE usr_id_sgp=2061 ) AND typu.state='t'

/************************************PRUEBAS**********************************/


SELECT * from trasl_type_user_login_saved WHERE usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= 2061) AND trasl_type_id=6



/****************************************FUNCION*************************************************/
DROP FUNCTION f_create_or_update_trasl_type_user_login_saved (int, INT, CHAR);

CREATE OR REPLACE FUNCTION f_create_or_update_trasl_type_user_login_saved( trasl_type_id INT, idusr_sgp INT, status bool )
RETURNS BOOLEAN AS 
$body$
DECLARE
_usr_id INT;
_trasl_type_user_id INT;
BEGIN
IF EXISTS (SELECT 1 from trasl_type_user_login_saved trasl_u_sved WHERE trasl_u_sved.usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= $2) AND trasl_u_sved.trasl_type_id=$1 ) 
THEN
	_trasl_type_user_id=(SELECT trasl_usr.trasl_type_user_id  from trasl_type_user_login_saved trasl_usr  WHERE trasl_usr.usr_id=(SELECT u.usr_id  from user_login u  WHERE u.usr_id_sgp= $2) AND trasl_usr.trasl_type_id= $1);
	
	UPDATE trasl_type_user_login_saved SET state= $3 WHERE trasl_type_user_id =_trasl_type_user_id;	
	RETURN TRUE;	
ELSE 
	_usr_id=(SELECT u2.usr_id from user_login u2  WHERE u2.usr_id_sgp= $2);
	
	INSERT INTO trasl_type_user_login_saved (	usr_id,	trasl_type_id,	"state") VALUES (_usr_id, $1, 't');
	RETURN TRUE;
END IF;
END;
$body$
LANGUAGE plpgsql VOLATILE


/************************************VALIDACIONES******************************************/


SELECT f_create_or_update_trasl_type_user_login_saved(7,2061,FALSE);


