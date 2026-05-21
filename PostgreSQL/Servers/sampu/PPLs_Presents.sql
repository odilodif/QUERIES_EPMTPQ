SELECT DISTINCT pp.prontuario,
CASE 
	WHEN pp.image0 IS NULL THEN
		'SIN FOTO'
	ELSE
		'CON FOTO'
END AS imagen, (SELECT pl.name FROM prison_location pl WHERE pl.id= pp.center_id ) as centro, pp.identificador,pp."name",pp.last_name
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1."state" in ('draft','done') 
)
and pp."state"<>'free' 
and pp.center_id IN (4282)-- CRS-COTOPAXI
ORDER BY pp.last_name ASC;  



--pp.center_id= 10744  --4248 




/*SELECT pm1."state" FROM prison_move pm1 
WHERE (pm1.center_id= 10744 or pm1.center_to_id=10744)  and "state" = 'free' 
and pm1."state" in ('draft','done') 
and pm1."state" <>'free'

and pm1.ppl_id=161321*/



