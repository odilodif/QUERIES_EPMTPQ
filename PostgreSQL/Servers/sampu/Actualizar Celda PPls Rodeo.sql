update prison_person SET  location_id = 7534  where prontuario in (SELECT DISTINCT pp.prontuario
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1."state" in ('draft','done') 
)
and pp."state"<>'free' 
and pp.center_id= 4272 )  

select * from prison_location WHERE id=4272