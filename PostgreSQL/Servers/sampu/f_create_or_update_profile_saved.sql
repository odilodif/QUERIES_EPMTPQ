CREATE OR REPLACE FUNCTION f_create_or_update_profile_saved( idmenu INT, idusr_sgp INT, status CHAR )
RETURNS BOOLEAN AS 
$body$
DECLARE
_usr_id INT;
prflsavedid INT;
BEGIN
IF EXISTS (SELECT 1 from profile_saved WHERE usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp) AND menu_description_id= idmenu ) THEN
	prflsavedid=(SELECT prfl_saved_id from profile_saved WHERE usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp) AND menu_description_id= idmenu);
	UPDATE profile_saved SET prfl_saved_state= status WHERE prfl_saved_id =prflsavedid;	
	RETURN TRUE;	
ELSE 
	_usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp);
	INSERT INTO profile_saved (usr_id,	menu_description_id,	prfl_saved_state) VALUES (_usr_id, idmenu, 't');
	RETURN TRUE;
END IF;
END;
$body$
LANGUAGE plpgsql VOLATILE

SELECT f_create_or_update_profile_saved(1,2061,'f');

DROP FUNCTION f_create_or_update_profile_saved(integer,integer,integer,char);








