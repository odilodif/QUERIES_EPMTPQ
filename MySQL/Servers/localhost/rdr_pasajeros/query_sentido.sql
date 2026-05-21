SELECT  LTRIM(RTRIM(sntd.sentido)) AS CodigoSentidoFuente,
 CASE
        WHEN UPPER(LTRIM(RTRIM(sntd.sentido))) = 1 THEN 'ENTRADA'
        WHEN UPPER(LTRIM(RTRIM(sntd.sentido))) = 2 THEN 'SALIDA'
        ELSE 'OTRO'
    END AS Descripcion,
	 sntd.fecha_max	as fecha_maxima
FROM
(
 SELECT DISTINCT v.sentido, MAX(v.fh) AS fecha_max FROM validacion v
GROUP BY v.sentido
) sntd WHERE sntd.fecha_max > '2026-05-12 15:02:02.000' 