SELECT pp.id, pp.image0,pp.identificador, pp.name, pp.last_name, pc.name delito, pl."name" center, 'Externo' AS traslado, pd.years, pd."month", pd.days,
pp."state",ps.name AS santion,pd.date_in
FROM prison_person ppINNER JOIN prison_crime pc ON pp.crime_id = pc.id
INNER JOIN prison_location pl ON pp.center_id=pl.id
INNER JOIN prison_detention pd ON pp.id= pd.person_id
INNER JOIN prison_sanctions ps ON pp.id=ps.ppl_id
WHERE pp.identificador = '1002258067';






SELECT  pd.date_in, CASE  WHEN pd.years is null THEN CAST(0 AS integer) ELSE pd.years  END as years, CASE  WHEN pd.month is null THEN CAST(0 AS integer) ELSE pd.month  END as month , CASE  WHEN pd.days is null THEN CAST(0 AS integer) ELSE pd.days  END as days, pp.prontuario,pp.name, pp.last_name,pd.number ,pl.name as center_name, pl.id as crs_id  
from prison_detention pd
INNER JOIN prison_person pp ON pd.person_id=pp.id
INNER JOIN prison_location pl ON pp.center_id=pl.id
WHERE  pp.state<>'free' AND pl.name NOT like 'UNIDAD%' AND pl.name NOT like 'UAT%' AND pl.name NOT like 'UAT%'   AND pl.name NOT like 'MEDIDAS%'  AND pl.name NOT like 'CC%' AND pp.state='sentenciado' and pd.state ='sentenced'  ORDER BY 5; 












