SELECT *
FROM (
    SELECT
        v.id AS idVal,
        v.concentrador,
        TRIM(v.estacion) AS EstacionNombre,
        UPPER(TRIM(v.estacion)) AS EstacionNormalizada,
        CONCAT('Estación ', TRIM(v.estacion)) AS Descripcion,
        v.fh,

        ROW_NUMBER() OVER (
            PARTITION BY TRIM(v.estacion)
            ORDER BY v.fh DESC,
                     v.id DESC,
                     v.concentrador DESC
        ) AS rn

    FROM validacion v
) t
WHERE rn = 1
ORDER BY idVal;