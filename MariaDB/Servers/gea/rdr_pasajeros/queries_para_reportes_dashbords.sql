-- Tabla validacioneS SOLO HOY
/***Total pasajeros solo entradas***/
SELECT 
    COUNT(id) AS total_pasajeros_entradas
FROM validacion 
WHERE DATE(fh) = CURDATE();
AND sentido = 1


/***Total Valor recaudado***/
SELECT 
    CONCAT('$ ', SUM(importe)) AS total_recaudo 
FROM validacion
WHERE DATE(fh) = CURDATE();

/************total facturas diferentes de vacio y nulos**************/
SELECT 
    COUNT(factura) AS total_pasajeros_con_facturas   
FROM validacion 
WHERE factura IS NOT NULL 
  AND factura <> ''
	AND DATE(fh) = CURDATE();
	
/*****************************************/
-- Tipo de Medio
SELECT COUNT(id) as totales, tipo_medio 
FROM validacion GROUP BY tipo_medio ORDER BY 2 ASC;

/**************CANTIDADES POR TIPO DE MEDIO Y TOTALES ****************/
 SELECT
 tipo_medio,
 count(importe) AS CANT, 
 importe,
 (count(importe)*importe) as subtotales
FROM validacion WHERE fh >= '2026-04-01 00:00:00'
GROUP BY 1,3
UNION ALL
SELECT
' ',
' ',
'TOTALES',
sum( importe)
FROM validacion
WHERE fh >= '2026-04-01 00:00:00'

/*******************************/

SELECT *  
FROM validacion
WHERE fh >= '2026-04-01 00:00:00'
ORDER BY 4





	
	
/*****************Resumen General de los últimos 7 días************************/

SELECT 
    COUNT(id) AS total_pasajeros,
    SUM(importe) AS total_recaudo
FROM validacion
WHERE fh >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) 
  AND fh < DATE_ADD(CURDATE(), INTERVAL 1 DAY);
	
/**************************************/
	
	SELECT qrf.tipo_medio  FROM
	( SELECT 'SM_QR' AS tipo_medio,estacion,	fh,	usuario,	terminal,	billete,	importe FROM qr ) AS qrf
	LEFT JOIN ( SELECT estacion,	fh, factura,tipo_medio FROM validacion)  valid 
	 ON qrf.tipo_medio = valid.tipo_medio	
	WHERE qrf.fh >= '2026-04-01 00:00:00'
	
	WHERE qrf.factura IS NOT NULL
	
	WHERE qr.fh >= '2026-04-01 00:00:00'
	
	
	SELECT * FROM
	(SELECT 'SM_QR' AS tipo_medio,estacion,	fh,	usuario,	terminal,	billete,	importe FROM qr 
	WHERE fh >= '2026-04-01 00:00:00' ) AS qrf
	
	SELECT estacion,	fh, factura,tipo_medio FROM validacion
	WHERE fh >= '2026-04-01 00:00:00'
	
	
	
	