SELECT *from prison_move_massive where id=135

select * from prison_move WHERE ppl_id =( select id from prison_person where last_name = 'CAZ VILLA' )

SELECT * FROM prison_person WHERE prontuario = 'MJDHC-A-00211481' 4281 - 7817   //10882 ->10883
SELECT * FROM prison_person WHERE prontuario = 'MJDHC-A-00211587'
SELECT * from prison_move WHERE id = 905622;
SELECT * from prison_move WHERE id = 905621;
SELECT * from prison_location where id=10882

******************************************************************************************************************************************
UPDATE prison_move SET center_id=4281, location_id=10883, state='done'  WHERE ppl_id=280771;
SELECT * from prison_person WHERE id=280771;
select * from prison_move WHERE ppl_id =280771 order by 1 DESC
**********************************************************************************************************************************************
INSERT INTO prison_move (
last_name,	center_id,	center_to_id,	number,	sex,	print,	location_id,	penal_code,	name,	type,	
ppl_id,	crime_id,state,	mode,	birth_date,	loc_from_id,	"authorization",	verified_name,has_search,certificado_medico,
obser_traslado,tiene_apremio,	exists_ppl,	to_confidence,date
)
VALUES('CHASI CHANGO'	,4281,	10882,		'SNAI-TE-00042989',	'hombre',	'f'	,10883,	'coip',	'LUIS IVAN',	'internal',	
280771,1778,'done','interno',	'1990-06-21',	7817	,'DEPURACIÓN SGP MEMORANDOS  SNAI-SNAI-2021-0250-M y SNAI-SNAI-2021-0354-M',	'LUIS IVAN','f','f',
1,'f',	'f','f','2021-11-18 18:34:02'
)