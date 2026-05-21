SELECT  estc1.validadora_id as terminal,
estc1.pasillo,
tp1.nombre,
tp1.Descripcion,
etconf1.id,
etconf1.nombre as nombre_estacion,
etconf1.codigo_linea
FROM busmatick.estaciones estc1
INNER JOIN busmatick.estaciones_tipos_pasillo tp1 	ON estc1.Tipo_pasillo_id = tp1.id    	-- tp1.id = estc.Tipo_pasillo_id
INNER JOIN busmatick.estaciones_config etconf1			ON estc1.estacion   = 	etconf1.id		-- etconf1.id = estc.estacion
WHERE estc1.estacion = 1301
AND estc1.validadora_id = 13018007
