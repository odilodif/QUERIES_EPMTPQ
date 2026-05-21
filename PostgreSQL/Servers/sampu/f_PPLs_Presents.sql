
--DROP FUNCTION f_ppls_presents_table(integer)
CREATE OR REPLACE FUNCTION f_PPLs_Presents_table(crs_id  INT DEFAULT 0)
RETURNS  TABLE ( prontuario VARCHAR,	centro VARCHAR,	identificador VARCHAR,	
name VARCHAR,	last_name VARCHAR      
)
AS $BODY$
DECLARE 		
    _crs_id int; 
		BEGIN
_crs_id=crs_id;
IF _crs_id = 0 THEN
RETURN  QUERY 
SELECT DISTINCT pp.prontuario,
 (SELECT pl.name FROM prison_location pl WHERE pl.id= pp.center_id ) as centro, pp.identificador,pp."name",pp.last_name
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1."state" in ('draft','done') 
)
and pp."state"<>'free'
ORDER BY pp.last_name ASC; 

ELSE
RETURN  QUERY 
SELECT DISTINCT pp.prontuario,
 (SELECT pl.name FROM prison_location pl WHERE pl.id= pp.center_id ) as centro, pp.identificador,pp."name",pp.last_name
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1."state" in ('draft','done') 
)
and pp."state"<>'free' 
and pp.center_id IN (_crs_id)-- CRS-COTOPAXI
ORDER BY pp.last_name ASC; 

END IF;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM f_PPLs_Presents_table (4248)  where identificador = '0804582732' ;


SELECT pp.id,	pp.name name_pp,pp.last_name,(SELECT complete_name FROM prison_location WHERE id=pp.location_id) celda,(SELECT  name FROM prison_crime where id= pp.crime_id) crime,pp.state,	(SELECT name FROM prison_location WHERE id= pp.center_id) center,		pp.prontuario,		pp.identificador,	pp.image0,		pp.regimen, ps.notes as sanctions,pd.date_in
FROM prison_person pp
LEFT JOIN prison_sanctions ps ON pp.id= ps.ppl_id
INNER JOIN prison_detention pd ON pp.id=pd.person_id
where identificador = '0804582732';


SELECT * FROM prison_detention WHERE person_id = (SELECT id from  prison_person where identificador = '0804582732' )








