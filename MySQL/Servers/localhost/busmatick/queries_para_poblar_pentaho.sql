
/*************qr*****************/
SELECT 
qr.id as id_qr_rdr, 
qr.concentrador as concentrador_qr,	
qr.estacion as estacion_qr,	
qr.fh as fecha_hora_qr,	
qr.usuario as usuario_qr,	
qr.terminal as terminal_qr,
qr.billete as billete_qr,		
qr.importe as importe_qr,	
qr.tarifa as tarifa_qr,	
qr.fh_envio as fh_envio_qr,
qr.parada  as parada_qr,	
qr.metodo_pago as metodo_pago_qr, 
qr.billete_n4 as billete_n4_qr ,
qr.fh_venta_n4 as  fh_venta_n4_qr ,
qr.factura as factura_qr,		
qr.estado as estado_qr,
(SELECT mtx1.tipo_pasillo_id FROM busmatick.estaciones mtx1 WHERE mtx1.validadora_id = qr.terminal ) as id_tipo_pasillo_id 
FROM qr qr;


 SELECT 
qr.terminal  ,
 	(SELECT mtx1.tipo_pasillo_id FROM busmatick.estaciones mtx1 WHERE mtx1.validadora_id = qr.terminal ) as id_tipo_pasillo_id
 FROM qr qr
 WHERE qr.estacion = 'El Recreo'

/************ESTACIONES_CONFIG***************/

SELECT id as id_busmatick,	nombre as nombre_busmatick,	codigo_linea as codigo_linea_busmatick FROM estaciones_config 


/*********estaciones_tipos_pasillo**********/
select id as id_busmatick_typpasll, 	nombre as nombre_bustatick, 	descripcion as descripcion_busmatick, 	posicion_grafico  from estaciones_tipos_pasillo


/**********************/
