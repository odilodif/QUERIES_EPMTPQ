SELECT
    MAX(id) AS idVal,
    MAX(concentrador) AS concentrador,
    TRIM(estacion) AS EstacionNombre,
    UPPER(TRIM(estacion)) AS EstacionNormalizada,
    CONCAT('Estación ', TRIM(estacion)) AS Descripcion
FROM validacion

WHERE
      id >  ${ULTIMO_IDVAL_ESTACION}
   OR (id = ${ULTIMO_IDVAL_ESTACION} AND concentrador > ${ULTIMO_CONCENTRADOR_ESTACION})
   OR (id = ${ULTIMO_IDVAL_ESTACION} AND concentrador = ${ULTIMO_CONCENTRADOR_ESTACION} AND fh > '${ULTIMA_FH_ESTACION}')

GROUP BY TRIM(estacion)
ORDER BY TRIM(estacion);




/***************************/


SELECT
    MAX(id) AS idVal,
    MAX(concentrador) AS concentrador,
    TRIM(estacion) AS EstacionNombre,
    UPPER(TRIM(estacion)) AS EstacionNormalizada,
    CONCAT('Estación ', TRIM(estacion)) AS Descripcion
FROM validacion
WHERE
      id > 29582
   OR (id = 29582 AND concentrador > 12001600)
   OR (id = 29582 AND concentrador = 12001600 AND fh > '2026-05-06 21:35:39.000')
GROUP BY TRIM(estacion)
ORDER BY TRIM(estacion);


/******************/


SELECT DISTINCT TRIM(estacion) AS EstacionNombre,
    UPPER(TRIM(estacion)) AS EstacionNormalizada,
    CONCAT('Estación ', TRIM(estacion)) AS Descripcion FROM validacion
		/*****************************/
		
		
		SELECT 
    ROW_NUMBER() OVER (ORDER BY TRIM(EstacionNombre)) AS IdEstacion,
    EstacionNombre,
    EstacionNormalizada,
    Descripcion
FROM (
    SELECT DISTINCT 
        TRIM(estacion) AS EstacionNombre,
        UPPER(TRIM(estacion)) AS EstacionNormalizada,
        CONCAT('Estación ', TRIM(estacion)) AS Descripcion
    FROM validacion
) t;