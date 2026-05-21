SELECT th.trasl_id,th.trasl_state_process, tdls.trasl_id, u.usr_nick 
from traslation_head th  
INNER JOIN user_login u on th.usr_id=u.usr_id 
FULL OUTER JOIN traslation_details tdls on th.trasl_id=tdls.trasl_id 
WHERE tdls.trasl_id is NULL OR th.trasl_id IS NULL ORDER BY 1 ASC

UPDATE user_login SET area_id = null WHERE usr_id=60;



select usr.usr_email from traslation_type typ
INNER JOIN user_login usr ON typ.usr_id=usr.usr_id
WHERE typ.trasl_type_id=1