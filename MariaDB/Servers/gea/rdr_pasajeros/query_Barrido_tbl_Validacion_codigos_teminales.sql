
/**********Barrido tabla Validacion para saber si los codigos de los teminales no son validacores *********************/
SELECT  
(SELECT etconf1.nombre FROM busmatick.estaciones_config etconf1 WHERE etconf1.id=estcn.estacion) as nombre_estacion,
(SELECT tp1.nombre FROM busmatick.estaciones_tipos_pasillo tp1 WHERE tp1.id = estcn.Tipo_pasillo_id) as nombre_terminal,
(SELECT  tep.Estado_Pasillo FROM busmatick.tipo_estado_pasillo tep WHERE tep.Id_Estado_Pasillo = estcn.Id_Estado_Pasillo) tipo_estado_pasillo
FROM  busmatick.estaciones estcn
WHERE estcn.validadora_id IN (SELECT DISTINCT terminal FROM  validacion)