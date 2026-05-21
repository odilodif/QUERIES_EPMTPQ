SELECT  estc1.validadora_id as terminal_eq_term,
estc1.pasillo as pasillo_eq_term,
COALESCE(tp1.nombre, 'SIN-NOMBRE' ) as nombre_eq_term,
COALESCE(tp1.Descripcion,'SIN-DESCRIPCION')  as descripcion_eq_term,
etconf1.id AS id_estacion_conf,
etconf1.nombre as nombre_estacion,
etconf1.codigo_linea AS codigo_linea_eq_term
FROM busmatick.estaciones estc1
LEFT JOIN busmatick.estaciones_tipos_pasillo tp1 	ON estc1.Tipo_pasillo_id = tp1.id    
LEFT JOIN busmatick.estaciones_config etconf1			ON estc1.estacion   = 	etconf1.id		
-- WHERE estc1.estacion = 1301
-- AND estc1.validadora_id = 13018007  