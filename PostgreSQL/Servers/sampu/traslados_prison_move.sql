SELECT th.trasl_id,	prison_location.name as crs_source,crsd.name as crs_destination
		,	ty.trasl_type_descripcion,th.trasl_date_request,u.usr_name,u.usr_lasname,th.trasl_descripcion,th.trasl_path,
		case
when th.trasl_state_process ='start'  then 'Inicio'
when th.trasl_state_process ='sent'  then 'Enviado'
when th.trasl_state_process ='approved'  then 'Aprobado'
when th.trasl_state_process ='revision'  then 'Revision'
when th.trasl_state_process ='executed'  then 'Finalizado'
when th.trasl_state_process ='authorized'  then 'Autorizado'
else 'Sin Estado'
end as trasl_state_process
		/*,pp.id,pp.identificador,pp.name,pp.last_name,pp.id,	pp.sex,	pp.prontuario,	pp.state*/
		from traslation_head  th
		INNER JOIN prison_location   on th.crs_id_source=prison_location.id
		INNER JOIN prison_location crsd  on th.crs_id_destination=crsd.id
    INNER JOIN  traslation_type ty on th.trasl_type_id=ty.trasl_type_id
		INNER JOIN  user_login u    on  th.usr_id=u.usr_id
		/*INNER JOIN  traslation_details tdls    on  th.trasl_id=tdls.trasl_id
		INNER JOIN prison_person pp  on  tdls.prison_per_id=pp.id*/
	WHERE   th.trasl_id=717;(SELECT max(trasl_id) FROM traslation_head WHERE trasl_state = 't' and crs_id_source=4262 ) and th.trasl_state='t';


SELECT * FROM traslation_head WHERE trasl_id = 717
SELECT * from traslation_details where trasl_id=727
SELECT * FROM traslation_head WHERE crs_id_source = 4262 --4254	
			
			
			
			
			