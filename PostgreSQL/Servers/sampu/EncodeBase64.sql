select id, "name",last_name, '<img src=\"data:image/jpeg;base64,' || encode(image0, 'escape') || '\"name=\"Imagen1\" align=\"left\" width=\"86\"
height=\"99\" border=\"0\" />' as foto from prison_person ORDER BY 1 limit 10


SELECT DISTINCT pp.id, pp.name,pp.last_name,pp.identificador,'<img src=\"data:image/jpeg;base64,' || encode(image0, 'escape') || '\"name=\"Imagen1\" align=\"left\" width=\"86\"
height=\"99\" border=\"0\" />' as image_medium,' ' as prison_per_fingerprinter,pp.state,pp.prontuario , 
                (SELECT prison_location.name FROM prison_location WHERE id=pp.center_id)  AS crs_name, pp.sex
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
WHERE EXISTS (
SELECT 1 FROM prison_move pm1 
WHERE (pm1.center_id=pp.center_id or pm1.center_to_id=pp.center_id)
and pm1.ppl_id=pp.id
and pm1.state in ('draft','done') 
)
and pp.state<>'free' 
and pp.center_id= 10744  
ORDER BY pp.last_name ASC ;


