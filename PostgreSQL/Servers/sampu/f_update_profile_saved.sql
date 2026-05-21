CREATE OR REPLACE FUNCTION f_update_profile_saved( idmenu INT, idusr_sgp INT )
RETURNS BOOLEAN AS 
$body$
DECLARE
_usr_id INT;
prflsavedid INT;
BEGIN
	IF EXISTS (SELECT 1 from profile_saved WHERE usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp) AND menu_description_id= idmenu ) THEN

	prflsavedid=(SELECT prfl_saved_id from profile_saved WHERE usr_id=(SELECT usr_id from user_login  WHERE usr_id_sgp= idusr_sgp) AND menu_description_id= idmenu);
	UPDATE profile_saved SET prfl_saved_state= 'f' WHERE prfl_saved_id = prflsavedid;	
	RETURN TRUE;
	ELSE 	
		RETURN FALSE;
	END IF;
END;
$body$
LANGUAGE plpgsql VOLATILE

SELECT f_update_profile_saved(2,2061);