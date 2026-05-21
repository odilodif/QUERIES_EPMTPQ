SELECT th.trasl_id,th.trasl_date_request,th.trasl_date_approved,th.trasl_date_confirm,typ.trasl_type_descripcion,crss.name as crs_source ,crsd.name as crs_destination
,case 
when th.trasl_state_process ='start'  then 'Inicio'
when th.trasl_state_process ='sent'  then 'Enviado'
when th.trasl_state_process ='approved'  then 'Aprobado'
when th.trasl_state_process ='revision'  then 'Revision'
when th.trasl_state_process ='executed'  then 'Finalizado'
when th.trasl_state_process ='authorized'  then 'Autorizado'
else 'Sin Estado'
end as status_proces
,usr.name_complete as names_dircrs 
,
case 
when usranlyst.name_complete IS NULL  then '<p style=\"color:#FF0000\";> PENDIENTE </p> <p style=\"color:#337ab7\";> ' || (SELECT ul1.name_complete FROM user_login ul1 INNER JOIN traslation_type ttyp ON ul1.usr_id=ttyp.usr_id WHERE ttyp.trasl_type_id = th.trasl_type_id ) || '</p> '
else usranlyst.name_complete 
end  as names_analyst
, 
CASE 
WHEN usrapproved.name_complete IS NULL  then '<p style=\"color:#FF0000\";> PENDIENTE </p> <p style=\"color:#337ab7\";>'
|| (
	SELECT u.name_complete from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where da.area_id=(SELECT 
                                    case 
                                    when da.area_parent is null  then da.area_id
                                    else
                                    da.area_parent
                                    end
                                    from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where u.usr_id=(SELECT ttype.usr_id FROM traslation_type ttype WHERE ttype.trasl_type_id=th.trasl_type_id))
) || '</p> '
ELSE
usrapproved.name_complete
END AS names_approved,
CASE 
WHEN usrautorized.name_complete IS NULL  then '<p style=\"color:#FF0000\";> PENDIENTE </p> <p style=\"color:#337ab7\";>'
|| (
	SELECT u.name_complete from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where da.area_id= (SELECT darea.area_parent FROM direction_area darea
		INNER JOIN user_login ul ON darea.area_id = ul.area_id		
		WHERE darea.area_id= (	SELECT 
                                    case 
                                    when da.area_parent is null  then da.area_id
                                    else
                                    da.area_parent
                                    end
                                    from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where u.usr_id=(SELECT ttype.usr_id FROM traslation_type ttype WHERE ttype.trasl_type_id=th.trasl_type_id)))
) || '</p> '
ELSE
usrautorized.name_complete
END AS names_authorized,
CASE 
WHEN usrexecuted.name_complete IS NULL  then '<p style=\"color:#FF0000\";> PENDIENTE  </p> <p style=\"color:#337ab7\";>'
|| '</p> '
ELSE
usrexecuted.name_complete
END AS names_excecuted
from traslation_head th 
LEFT JOIN prison_location crss ON th.crs_id_source = crss.id 
LEFT JOIN prison_location crsd ON th.crs_id_destination = crsd.id 
LEFT JOIN traslation_type typ ON th.trasl_type_id = typ.trasl_type_id 
LEFT JOIN user_login usr ON th.usr_id= usr.usr_id
LEFT JOIN user_login usranlyst ON th.trasl_analyzed_by= usranlyst.usr_id
LEFT JOIN user_login usrapproved ON th.trasl_approved_by= usrapproved.usr_id  
LEFT JOIN user_login usrautorized ON th.trasl_authorized_by= usrautorized.usr_id
LEFT JOIN user_login usrexecuted ON th.trasl_executed_by= usrexecuted.usr_id  
WHERE th.trasl_state_process<>'start' ORDER BY 1 ASC;







/***************************************************************************************************************************************************/
SELECT u.name_complete from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where da.area_id= (SELECT darea.area_parent FROM direction_area darea
		INNER JOIN user_login ul ON darea.area_id = ul.area_id		
		WHERE darea.area_id= (	SELECT 
                                    case 
                                    when da.area_parent is null  then da.area_id
                                    else
                                    da.area_parent
                                    end
                                    from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where u.usr_id=(SELECT ttype.usr_id FROM traslation_type ttype WHERE ttype.trasl_type_id=4)))
		
		
		
		
		
		SELECT 
                                    case 
                                    when da.area_parent is null  then da.area_id
                                    else
                                    da.area_parent
                                    end
                                    from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where u.usr_id= 49
		
		
		
		
		SELECT darea.area_parent FROM direction_area darea
		INNER JOIN user_login ul ON darea.area_id = ul.area_id		
		WHERE darea.area_id= 6
		
		
		
		SELECT 
                                    case 
                                    when da.area_parent is null  then da.area_id
                                    else
                                    da.area_parent
                                    end
                                    from  direction_area da
		INNER JOIN 	 user_login u  on da.area_id=u.area_id
		where u.usr_id=(SELECT ttype.usr_id FROM traslation_type ttype WHERE ttype.trasl_type_id=4)
		
		
		

SELECT ttype.usr_id FROM traslation_type ttype WHERE ttype.trasl_type_id=5;


		SELECT usr.name_complete                                
    from  user_login usr
		INNER JOIN 	 traslation_head tlsh on usr.usr_id=tlsh.trasl_executed_by
		where usr.usr_id= 51;

SELECT * from traslation_head where trasl_executed_by=51































