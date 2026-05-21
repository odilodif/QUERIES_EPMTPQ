/**Reporte solo para tarjetas*/
SELECT
		DATE(v.fh) fecha_operacion,
		TIME(v.fh) hora_operacion,
    v.estacion AS nombre_estacion,
  COALESCE( (SELECT lineas1.Nombre_Linea FROM busmatick.lineas lineas1 WHERE lineas1.ID = ec.codigo_linea), 'CORREDOR CENTRAL TROLEBUS') as corredor,
    v.importe,
		trf.codigo_tarifa,
		trf.nombre_tarifa,
		v.tipo_medio,		
		 CASE v.sentido
        WHEN 1 THEN 'ENTRADA'
        WHEN 2 THEN 'SALIDA'       
        ELSE 'NO-DEFINIDO' 
    END AS sentido_entrada_salida
FROM 
    rdr_pasajeros.validacion v
LEFT JOIN 
    busmatick.estaciones_config ec 
    ON v.concentrador = ec.id
INNER JOIN 		
		rdr_pasajeros.n4_tarifas trf
		 ON trf.monto =  v.importe
WHERE  v.fh BETWEEN '2026-03-25 00:00:00' AND '2026-03-25 23:59:59'
AND v.sentido = 1
AND v.tipo_medio <> 'SM_QR'
AND v.tipo_medio <> 'ABTQR'
ORDER BY fecha_operacion  DESC

/***********************/
--queries

/**********************/



SELECT * FROM  rdr_pasajeros.validacion v;
SELECT * FROM  rdr_pasajeros.qr qr;
SELECT * FROM  rdr_pasajeros.recarga rcg;
SELECT * FROM  busmatick.estaciones_config ec; 


/********************/

SELECT DATE(rcg.fh) AS fecha_operacion, TIME(rcg.fh) AS hora_operacion ,rcg.estacion, rcg.cuenta, rcg.importe, rcg.saldo
, disp.Nombre, disp.Descripcion
FROM  rdr_pasajeros.recarga rcg
INNER JOIN busmatick.estaciones_tipos_pasillo disp
ON rcg.tipo_terminal = disp.Id
ORDER BY 1 DESC



