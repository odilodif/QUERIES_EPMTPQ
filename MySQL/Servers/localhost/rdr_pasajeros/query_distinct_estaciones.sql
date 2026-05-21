SELECT COUNT(*) FROM validacion;

SELECT COUNT(*) FROM qr;

SELECT COUNT(*) FROM recarga;

SELECT DISTINCT estacion  FROM qr ORDER BY 1; 


SELECT COUNT(estacion), estacion  FROM qr GROUP BY estacion 

/***********************/

SELECT estqr1.estacion FROM
(
	SELECT DISTINCT UPPER(estacion) estacion FROM qr
) estqr1

INNER JOIN (

SELECT DISTINCT estns.estacion FROM busmatick.estaciones  estns
INNER JOIN    busmatick.estaciones_config estcf ON  estns.estacion = estcf.id 

)

ON estqr1.estacion = est2.estacion 

/*******************************/

SELECT 'Solo en Estaciones' AS origen, estacion AS id_problema
FROM busmatick.estaciones
WHERE estacion NOT IN (SELECT id FROM busmatick.estaciones_config)


SELECT 'Solo en Config', id
FROM busmatick.estaciones_config
WHERE id NOT IN (SELECT estacion FROM busmatick.estaciones);


/***********************/

SELECT *  FROM qr WHERE 
