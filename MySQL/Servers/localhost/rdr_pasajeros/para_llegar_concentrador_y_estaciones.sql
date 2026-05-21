SELECT * FROM qr
WHERE concentrador =  13025400


SELECT est.validadora_id as terminal, tp.nombre ,estconf.nombre 
FROM  busmatick.estaciones_config estconf
INNER JOIN  busmatick.estaciones est ON  estconf.id = est.estacion
INNER JOIN  busmatick.estaciones_tipos_pasillo tp ON est.tipo_pasillo_id = tp.id
WHERE /* est.estacion = 1302 
AND */ tp.id = 2
 AND estconf.nombre = 'Estación Labrador'

