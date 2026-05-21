////////////////////////////////////PPLs Presentes en el SGP perfil Nacional ///////////////////////////////////////////
SELECT DISTINCT pp.prontuario, pp.center_id, pp.identificador,pp."name",pp.last_name
from prison_person pp 
INNER JOIN prison_move pm on  pp.id=pm.ppl_id
and pp."state"<>'free' 
ORDER BY pp.last_name ASC;
