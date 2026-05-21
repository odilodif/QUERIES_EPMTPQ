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

/**************************************/

SELECT ID as id_linea,Nombre_Linea as nombre_linea, Codigo_Linea as codigo_linea FROM lineas;

SELECT codigo_tarifa as codigo_tarf ,	nombre_tarifa as nombre_tarifa,	monto as monto_tarf,	activo as activo_tarf  FROM n4_tarifas;

/*******************************/

SELECT 
id as id_qr_rdr, 
concentrador as concentrador_qr,	
estacion as estacion_qr,	
fh as fecha_hora_qr,	
usuario as usuario_qr,	
terminal as terminal_qr,
billete as billete_qr,		
importe as importe_qr,	
tarifa as tarifa_qr,	
fh_envio as fh_envio_qr,
parada  as parada_qr,	
metodo_pago as metodo_pago_qr, 
billete_n4 as billete_n4_qr ,
fh_venta_n4 as  fh_venta_n4_qr ,
factura as factura_qr,		
estado as estado_qr 
FROM qr;




