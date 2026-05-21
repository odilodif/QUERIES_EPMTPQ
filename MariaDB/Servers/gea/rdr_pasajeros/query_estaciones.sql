SELECT DISTINCT  estacion as nombre_estacion FROM(
		SELECT qr.estacion, 
CASE 
        WHEN qr.estacion LIKE '%RECREO%'   THEN 'ESTACION'
        WHEN qr.estacion LIKE '%Morán Valverde%' THEN 'ESTACION'     
        WHEN qr.estacion LIKE '%LABRADOR%' THEN 'ESTACION'
    END AS categoria_lugar
FROM 	qr qr HAVING categoria_lugar IS NOT NULL

) estaciones

