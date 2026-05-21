SELECT *
FROM (
    SELECT id, 
           LAG(id) OVER (ORDER BY id) AS previo,
           id - LAG(id) OVER (ORDER BY id) AS diferencia
    FROM maint_work_order
) sub
WHERE diferencia > 1;