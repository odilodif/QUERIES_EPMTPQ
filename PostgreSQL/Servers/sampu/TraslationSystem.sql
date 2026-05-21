/****************************************************Test move *************************************************************/
select * from prison_move where id=905500;

select id from prison_location where location_id=10744 and type ='transit'-- 4238 origen- source (center_id CDP - CDC RSCS MIXTO - TURI)  destino-destination 10744   10744

SELECT * from prison_person where prontuario='MJDHC-A-00098142'
SELECT * from prison_location WHERE id=10744
/*****************************************************************************************************
						Test for TraslatioPPLSysytem for prison_move and prison_person with center_id 	
*******************************************************************************************************/

insert into prison_move (create_uid,	create_date,	write_date,	write_uid,	last_name,	center_id,	center_to_id,	number,	sex,	print,	
location_id,	penal_code,	name,	type,	ppl_id,	crime_id,	state,	mode,	birth_date,	loc_from_id,obser_traslado,"authorization",regimen,date_retras,date)
SELECT 1770,	NOW(),	NOW(),	1770,	pp.last_name,	10744 ,	4239,	'TRASLSYS-00756',	'masculino',false,(select id from prison_location where location_id=4239 and type ='transit'),	'coip',	pp.name,	'internal',	pp.id ,	pp.crime_id,	'done',	'externo',pp.birth_date,	(select id from prison_location where location_id=10744 and type ='transit'),'Traslado por Hacinamiento',	'Autorizado por ','minimum',NOW(),NOW()
from prison_person pp  where pp.prontuario='MJDHC-A-00098142';

UPDATE prison_person SET center_id= 4239, location_id=(select id from prison_location where location_id=4239 and type ='transit') where prontuario='MJDHC-A-00098142';
/**************************************************************************************************/
SELECT * from prison_move WHERE number = 'TRASLSYS-00758'   -- TRASLYSGP
/************************************************************************************************/

/************************************ DETALLE DE TRASLADO PPLS HEAD Y DETAILS*************************************************/
SELECT prison_per_id from traslation_head th 
INNER JOIN traslation_details tdls on th.trasl_id=tdls.trasl_id
INNER JOIN prison_person pp  on  tdls.prison_per_id=pp.id
WHERE   th.trasl_id= 765  

/**************************************TEST DE CURSOR*******************************************************************/

SELECT cursor_for();
/**********************************************************************************************************/

/********************************************************************************************************
												SCRIPT FOR TEST !!!!!!!!!!!!!!!!

*********************************************************************************************************/


DO $f$
DECLARE 
 _prontuario TEXT;
 _query TEXT; 	
_usr_id_sgp INT;
_idpp INT;
_crs_id_source INT;
_crs_id_destination INT;
_trasl_type_descripcion TEXT;
_trasl_authorized_by  TEXT;
_counter bigint := 0;
BEGIN
					SELECT  user_login.usr_id_sgp
					INTO _usr_id_sgp
					FROM  traslation_head th1
					INNER JOIN user_login user_login ON th1.trasl_executed_by=user_login.usr_id
					where th1.trasl_id=766; 
					SELECT  ul1.name_complete
					INTO _trasl_authorized_by
					FROM  traslation_head th1
					INNER JOIN user_login ul1 ON th1.trasl_authorized_by=ul1.usr_id
					where th1.trasl_id=766; 
					
		_query = format( 'SELECT pp.prontuario,th.crs_id_source,th.crs_id_destination,ty.trasl_type_descripcion from traslation_head th INNER JOIN traslation_details tdls on th.trasl_id=tdls.trasl_id INNER JOIN prison_person pp  on  tdls.prison_per_id=pp.id INNER JOIN traslation_type ty ON th.trasl_type_id=ty.trasl_type_id  WHERE   th.trasl_id= %s::INTEGER', 766 );
					--RAISE NOTICE 'procesando % ', _query;
					FOR  _prontuario, _crs_id_source , _crs_id_destination, _trasl_type_descripcion IN EXECUTE _query LOOP
					_counter=_counter +1;
									RAISE NOTICE 'procesando % Y % Y % Y %' , _prontuario, _crs_id_source, _idpp,_crs_id_destination;
				
				insert into prison_move (create_uid,	create_date,	write_date,	write_uid,	last_name,	center_id,	center_to_id,	number,	sex,	print,location_id,	penal_code,	name,	type,	ppl_id,	crime_id,	state,	mode,	birth_date,	loc_from_id,obser_traslado,"authorization",regimen,date_retras,date)
SELECT _usr_id_sgp,	NOW(),	NOW(),	_usr_id_sgp,	pp.last_name,	_crs_id_source ,	_crs_id_destination,	'TRASLSYS-'||766 || '-' || _counter,	pp.sex,false,(select id from prison_location where location_id=_crs_id_destination and type ='transit'),	'coip',	pp.name,	'internal',	pp.id ,	pp.crime_id,	'done',	'externo',pp.birth_date,	(select id from prison_location where location_id=_crs_id_source and type ='transit'),_trasl_type_descripcion,	'Autorizado por' || _trasl_authorized_by,'minimum',NOW(),NOW()
from prison_person pp  where pp.prontuario=_prontuario;
UPDATE prison_person SET center_id= _crs_id_destination, location_id=(select id from prison_location where location_id=_crs_id_destination and type ='transit') where prontuario=_prontuario;	
							
					END LOOP;
END;
$f$


/******************************************************************************************
						CREACION DE FUNCION PARA SETEAR EN EL SGP
*******************************************************************************************/
--DROP FUNCTION execute_move_systra_sgp(integer)
CREATE OR REPLACE FUNCTION execute_move_systra_sgp(tras_id INT) 
RETURNS void AS $BODY$
 
DECLARE 
 _prontuario TEXT;
 _query TEXT; 	
_usr_id_sgp INT;
_idpp INT;
_crs_id_source INT;
_crs_id_destination INT;
_trasl_type_descripcion TEXT;
_trasl_authorized_by  TEXT;
_counter bigint := 0;
BEGIN
					SELECT  user_login.usr_id_sgp
					INTO _usr_id_sgp
					FROM  traslation_head th1
					INNER JOIN user_login user_login ON th1.trasl_executed_by=user_login.usr_id
					where th1.trasl_id=tras_id;
					
					SELECT  ul1.name_complete
					INTO _trasl_authorized_by
					FROM  traslation_head th2
					INNER JOIN user_login ul1 ON th2.trasl_authorized_by=ul1.usr_id
					where th2.trasl_id=tras_id; 
					
		_query = format( 'SELECT pp.prontuario,th.crs_id_source,th.crs_id_destination,ty.trasl_type_descripcion from traslation_head th INNER JOIN traslation_details tdls on th.trasl_id=tdls.trasl_id INNER JOIN prison_person pp  on  tdls.prison_per_id=pp.id INNER JOIN traslation_type ty ON th.trasl_type_id=ty.trasl_type_id  WHERE   th.trasl_id= %s::INTEGER', tras_id );
					--RAISE NOTICE 'procesando % ', _query;
					FOR  _prontuario, _crs_id_source , _crs_id_destination, _trasl_type_descripcion IN EXECUTE _query LOOP
					_counter=_counter +1;
									RAISE NOTICE 'procesando % Y % Y %' , _prontuario, _crs_id_source,_crs_id_destination;
				
				insert into prison_move (create_uid,	create_date,	write_date,	write_uid,	last_name,	center_id,	center_to_id,	number,	sex,	print,location_id,	penal_code,	name,	type,	ppl_id,	crime_id,	state,	mode,	birth_date,	loc_from_id,obser_traslado,"authorization",regimen,date_retras,date)
SELECT _usr_id_sgp,	NOW(),	NOW(),	_usr_id_sgp,	pp.last_name,	_crs_id_source ,	_crs_id_destination,	'SYSTRA-'||tras_id || '-' || _counter,	pp.sex,false,(select id from prison_location where location_id=_crs_id_destination and type ='transit'),	'coip',	pp.name,	'internal',	pp.id ,	pp.crime_id,	'done',	'externo',pp.birth_date,	(select id from prison_location where location_id=_crs_id_source and type ='transit'),_trasl_type_descripcion,	'Autorizado por' || _trasl_authorized_by,'minimum',NOW(),NOW()
from prison_person pp  where pp.prontuario=_prontuario;
UPDATE prison_person SET center_id= _crs_id_destination, location_id=(select id from prison_location where location_id=_crs_id_destination and type ='transit') where prontuario=_prontuario;	
							
					END LOOP;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100

SELECT execute_move_systra_sgp(767);









