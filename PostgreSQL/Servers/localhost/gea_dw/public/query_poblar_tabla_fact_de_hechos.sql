INSERT INTO FACT_VENTAS_ANALITICA (    
    id_tiempo ,
    id_qr ,
    id_estacion_dw ,
    id_linea ,
    id_descrp_tarf ,
    id_hora ,
    id_est_typ_pasillo ,
    id_dispositivo ,
    id_paradas ,
    id_estacion ,
    id_terminales ,
    id_importe_tarf ,
    id_estaciones_config ,
    cantidad_ventas, 
    importe_total
)
SELECT      
  t.id_tiempo, 
    qr.id_qr, 
    mtrx.id_estacion_dw, 
    li.id_linea, 
    tarf.id_descrp_tarf, 
    h.id_hora, 
		tp1.id_est_typ_pasillo,
		disp.id_dispositivo,
		prds.id_paradas,
		est.id_estacion,
		trm.id_terminales,
		itarf.id_importe_tarf,			
		estconf.id_estaciones_config,		
    1 AS cantidad_ventas, 
    qr.importe_qr AS importe_total  
FROM qr_dw qr
-- 1. Relaciones Temporales
INNER JOIN DIM_TIEMPO t ON t.fecha = qr.fecha_hora_qr::date
INNER JOIN DIM_HORA h ON h.id_hora = to_char(qr.fecha_hora_qr, 'HH24MISS')::int

LEFT JOIN estaciones est 		ON qr.estacion_qr = est.nombre_estacion
LEFT JOIN paradas prds 			ON qr.estacion_qr = prds.nombre_parada
LEFT JOIN terminales trm 		ON qr.estacion_qr = trm.nombre_terminal
INNER JOIN descripcion_tarifas  destrf ON qr.tarifa_qr = destrf.codigo_tarf

-- 4. Relación con Tipos de Pasillo (detalle técnico de la dimensión)
LEFT JOIN matriz_estacion_config   mtrx ON qr.terminal_qr::INTEGER = mtrx.validadora_id
LEFT JOIN estaciones_config  estconf   	ON mtrx.estacion_mtrx_conf   = estconf.id_busmatick
LEFT JOIN linea  li        							ON estconf.codigo_linea_busmatick = li.id_linea
LEFT JOIN estaciones_tipos_pasillo tp1 ON mtrx.tipo_pasillo_id = tp1.id_busmatick_typpasll

-- 5. Relación con Tarifas
LEFT JOIN descripcion_tarifas tarf ON tarf.codigo_tarf = qr.tarifa_qr
LEFT JOIN importe_tarifa itarf  ON  qr.importe_qr =  itarf.id_importe_tarf
LEFT JOIN  dipositivo disp ON qr.usuario_qr = disp.descripcion_disptv
	
/****************************************************/	
	
/*************************************************/	
	


/*
SELECT *
FROM QR_DW qr
WHERE NOT EXISTS (
    SELECT 1 
    FROM ESTACION est 
    WHERE est.validadora_id = qr.terminal_qr::INTEGER
);
*/

SELECT qr.estacion_qr FROM qr_dw qr
LEFT JOIN matriz_estacion_config   mtrx ON qr.terminal_qr::INTEGER = mtrx.validadora_id
LEFT JOIN estaciones_config  estconf   	ON mtrx.estacion_mtrx_conf   = estconf.id_busmatick
LEFT JOIN linea  li        							ON estconf.codigo_linea_busmatick = li.id_linea
WHERE qr.estacion_qr = 'El Recreo'

SELECT * FROM qr_dw;
/*************************/
SELECT 
qr.terminal_qr,
(
	
	SELECT etp1.descripcion_busmatick FROM estaciones_tipos_pasillo etp1 
	WHERE etp1.id_busmatick_typpasll = 	(SELECT mtx1.tipo_pasillo_id FROM matriz_estacion_config mtx1 WHERE mtx1.validadora_id = qr.terminal_qr::INTEGER)
	
)
 FROM qr_dw qr
 WHERE qr.estacion_qr = 'El Recreo'
 
 /***********************/
 
 










		
		