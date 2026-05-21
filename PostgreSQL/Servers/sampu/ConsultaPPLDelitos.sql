SELECT DISTINCT pp.prontuario, pl."name", pc."name" as delito,pp."name" as nombres,pp.last_name as apellidos
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
INNER JOIN prison_location pl on pp.center_id=pl.id
INNER JOIN prison_detention pd ON pp.id=pd.person_id
INNER JOIN prison_crime pc on pd.crime=pc.id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1."state" in ('draft','done') 
)
and pp."state"<>'free' 
--and pp.center_id= 4248 -- CRS-COTOPAXI
ORDER BY 2 ASC 