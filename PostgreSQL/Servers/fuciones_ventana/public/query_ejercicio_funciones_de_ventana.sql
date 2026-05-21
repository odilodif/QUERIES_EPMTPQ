SELECT 
id,
nombre,
sum(puntos) as total
FROM (
SELECT 
p.id, 
p.nombre,
r.puntos, 
/*sum(r.puntos) OVER ( partition by p.id ) as total,*/
row_number() over (partition by p.id order by p.id) as ranking
FROM pilotos p 
INNER JOIN resultados r 
ON p.id = r.piloto_id
) subconsulta
WHERE ranking <= 4
GROUP BY id, nombre 
ORDER BY total DESC