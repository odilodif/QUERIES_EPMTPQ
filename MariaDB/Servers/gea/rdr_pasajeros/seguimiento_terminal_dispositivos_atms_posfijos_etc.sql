SELECT estc.validadora_id as terminal,
(SELECT tp1.nombre FROM busmatick.estaciones_tipos_pasillo tp1 WHERE tp1.id = estc.Tipo_pasillo_id) as nombre_terminal,
(SELECT etconf1.nombre FROM busmatick.estaciones_config etconf1 WHERE etconf1.id = estc.estacion)  as nombre_estacion
 FROM busmatick.estaciones estc
WHERE estc.estacion = 1301
AND estc.validadora_id IN (13017019, 13017020, 13017021  ) -- 13018005




