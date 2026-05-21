SELECT usr.usr_id, usr.usr_id_sgp, usr.name_complete,usr.usr_nick,typ.trasl_type_descripcion,prfl.prfle_description, pl."name"	as crs,	dir.area_desription,	usr.usr_email, usr.usr_state FROM user_login usr
INNER JOIN profile prfl ON usr.prfle_id=prfl.prfle_id
INNER JOIN  traslation_type typ ON usr.trasl_type_id=typ.trasl_type_id
INNER JOIN prison_location pl ON usr.crs_id = pl.id
LEFT JOIN direction_area dir ON usr.area_id = dir.area_id WHERE usr.usr_state='t'
AND usr.usr_id_sgp=2058

SELECT menu_description_id, menu_description_description FROM menu_objects WHERE menu_description_state='t' ORDER BY 1;