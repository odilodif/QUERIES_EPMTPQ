SELECT 1 from profile_saved WHERE usr_id=(SELECT usr_id FROM user_login WHERE usr_id_sgp=1770) AND menu_description_id=2;

/*////////////////////////////////////////////////////CREATE FUNCTION SETTINGS-USER ///////////////////////////////*/
CREATE OR REPLACE FUNCTION f_create_update_settings_user ("_user" text, "_passw" text, "_namecplte" text)
  RETURNS "pg_catalog"."bool" AS $BODY$
DECLARE resutl_boolean BOOLEAN;
declare                   -- declare some variables
_idsgp INT;
_crs_sgp INT;
_email_sgp text;

 BEGIN
 
 IF EXISTS (SELECT 1 FROM user_login usr WHERE usr.usr_nick= _user ) THEN		
				/*	RAISE NOTICE ' PROCESANDO  %', _user || _user ;		*/	
					SELECT u.id, u.center_id,par.email
				  INTO 	_idsgp, _crs_sgp, _email_sgp
					from res_users  u
				  INNER JOIN prison_location l  on u.center_id=l."id"
				  INNER JOIN res_partner par on   u.partner_id =par."id"
				  WHERE u."login"= _user;						
					UPDATE user_login SET 
					usr_id_sgp=_idsgp,
					crs_id=_crs_sgp,
					usr_email=_email_sgp,
					name_complete=_namecplte,
				  usr_password= _passw	
					WHERE usr_nick= _user;
					RETURN TRUE;				
		ELSE
				insert INTO user_login(usr_id_sgp,crs_id,usr_nick,usr_password,usr_email,name_complete,usr_state) 
				SELECT u.id, u.center_id, _user , _passw ,par.email,_namecplte,'t'				
				from res_users  u
				INNER JOIN prison_location l  on u.center_id=l."id"
				INNER JOIN res_partner par on   u.partner_id =par."id"
				WHERE u."login"= _user;
		
        RETURN TRUE;				
	  END IF; 
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100