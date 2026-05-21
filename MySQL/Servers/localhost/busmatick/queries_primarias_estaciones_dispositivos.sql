SELECT * FROM estaciones_config;  -- estaciones
SELECT *  FROM  estaciones estc1; -- resultado de la configuracion de estaciones y dispositivos
SELECT * FROM estaciones_tipos_pasillo  tp1; -- tabla de los dispositivos


SELECT estc1.validadora_id as terminal  FROM  estaciones estc1
LEFT JOIN estaciones_tipos_pasillo tp1 	ON estc1.Tipo_pasillo_id = tp1.id 
LEFT JOIN estaciones_config etconf1			ON estc1.estacion   = 	etconf1.id	
