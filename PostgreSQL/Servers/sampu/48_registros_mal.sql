select a.fecha_ingeg 
as fecha_egreso,       
a.ide_ingeg as codigo_egreso,       
a.numero_documento_ingeg as numero_documento,       
a.ide_solicitud as codigo_solicitud,       
a.id_maint_work_order as egreso_orden_trabajo,       
b.id_maint_work_order as solicitud_orden_trabajo,
(SELECT  bodt_bodega_ubicacion1.detalle_boubi FROM bodt_bodega_ubicacion bodt_bodega_ubicacion1  WHERE bodt_bodega_ubicacion1.ide_boubi =  a.ide_boubi) bodega,

(SELECT primer_nombre_gtemp ||' '	|| segundo_nombre_gtemp ||' '	|| 	apellido_paterno_gtemp||' '	||  apellido_materno_gtemp FROM gth_empleado WHERE ide_gtemp =  a.ide_gtemp ) as responsable,

(SELECT primer_nombre_gtemp ||' '	|| 	segundo_nombre_gtemp ||' '	|| 	apellido_paterno_gtemp||' '	||  apellido_materno_gtemp FROM gth_empleado WHERE ide_gtemp =  a.ide_gtemp_solicitante ) as solicitante,

a.subtotal_ingeg,
a.valor_iva_ingeg,
a.total_ingeg,
a.usuario_ingre  as usuario       
from bodt_ingreso_egreso a                
inner join solicitud_items b on a.ide_solicitud = b.ide_solicitud            
where a.id_maint_work_order!= b.id_maint_work_order;
ORDER BY a.ide_solicitud 
 
 
 
 /***********************SIMPLE *****************/
select 
a.fecha_ingeg as fecha_egreso,      
a.ide_ingeg as codigo_egreso,      
a.numero_documento_ingeg as numero_documento_egreso,     
a.ide_solicitud as codigo_solicitud,    
a.id_maint_work_order as "orden_trabajo en el egreso (correcto)",      
b.id_maint_work_order as "orden_trabajo en la solictud(Incorrecto)"           
from bodt_ingreso_egreso a                
inner join solicitud_items b on a.ide_solicitud = b.ide_solicitud           
 where a.id_maint_work_order!= b.id_maint_work_order
 ORDER BY a.ide_solicitud 
 
 /**************UPDATE Y SELECT ***************/
 
 UPDATE solicitud_items si
SET id_maint_work_order = a.id_maint_work_order
FROM bodt_ingreso_egreso a
WHERE a.ide_solicitud = si.ide_solicitud
AND a.id_maint_work_order != si.id_maint_work_order;


/*********************************************/
SELECT 
  trim(split_part(split_part(sql_audi, '***', 1), '*', 2)) AS campo1,
	trim(split_part(split_part(sql_audi, '***', 1), '*', 24)) AS campo6,
  trim(split_part(split_part(sql_audi, '***', 1), '*', 3)) AS campo2,
  trim(split_part(split_part(sql_audi, '***', 1), '*', 4)) AS campo3,
  trim(split_part(split_part(sql_audi, '***', 1), '*', 5)) AS campo4,
  trim(split_part(split_part(sql_audi, '***', 1), '*', 6)) AS campo5,	
	split_part(sql_audi, '***', 2) AS sentencia_update 
FROM sis_auditoria 
WHERE fecha_audi BETWEEN '2025-04-09 00:00:00' AND '2025-08-18 23:59:59'
  AND tabla_audi = 'solicitud_items'
  AND trim(split_part(sql_audi, '*', 2)) IN (
	/*'IDE_SOLICITUD = 76',
	'IDE_SOLICITUD = 80',*/
	'IDE_SOLICITUD = 8166'--,
  /*'IDE_SOLICITUD = 91',
  'IDE_SOLICITUD = 100',
  'IDE_SOLICITUD = 123',
  'IDE_SOLICITUD = 2137',
  'IDE_SOLICITUD = 255',
  'IDE_SOLICITUD = 311',
  'IDE_SOLICITUD = 327',
  'IDE_SOLICITUD = 382',
  'IDE_SOLICITUD = 426',
  'IDE_SOLICITUD = 428',
  'IDE_SOLICITUD = 1387',
  'IDE_SOLICITUD = 2163',
  'IDE_SOLICITUD = 758',
  'IDE_SOLICITUD = 769',
  'IDE_SOLICITUD = 796',
  'IDE_SOLICITUD = 807',
  'IDE_SOLICITUD = 1821',
  'IDE_SOLICITUD = 842',
  'IDE_SOLICITUD = 1822',
  'IDE_SOLICITUD = 916',
  'IDE_SOLICITUD = 2168',
  'IDE_SOLICITUD = 956',
  'IDE_SOLICITUD = 957',
  'IDE_SOLICITUD = 964',
  'IDE_SOLICITUD = 1084',
  'IDE_SOLICITUD = 1101',
  'IDE_SOLICITUD = 1219',
  'IDE_SOLICITUD = 3310',
  'IDE_SOLICITUD = 3030',
  'IDE_SOLICITUD = 3389',
  'IDE_SOLICITUD = 2565',
  'IDE_SOLICITUD = 3313',
  'IDE_SOLICITUD = 3045',
  'IDE_SOLICITUD = 2817',
  'IDE_SOLICITUD = 3498',
  'IDE_SOLICITUD = 3527',
  'IDE_SOLICITUD = 3553',
  'IDE_SOLICITUD = 4147',
  'IDE_SOLICITUD = 4343',
  'IDE_SOLICITUD = 5430',
  'IDE_SOLICITUD = 5808',
  'IDE_SOLICITUD = 5434',
  'IDE_SOLICITUD = 5491',
  'IDE_SOLICITUD = 5569',
  'IDE_SOLICITUD = 5882'*/
);


 UPDATE solicitud_items SET  IDE_SOLICITUD=88, ESTADO_SOLICITUD='APROBADA', FECHA_SOLICITUD='2025-04-09', IDE_GTEMP_SOLICITANTE=407, IDE_BOUBI=5, IDE_GEANI=9, IDE_GTEMP_APROBADOR=109, APROBACION_APROBADOR=true, OBSERVACION='Fuga de aire valvula de desfogue (cambio de filtro por saturación)', RECHAZO_APROBADOR=false, APROBACION_BODEGA=NULL, RECHAZO_BODEGA=NULL, TIPO='NORMAL', USUARIO_ACTUA='lquiña', FECHA_ACTUA='2025-04-09', HORA_ACTUA='09:56:59', IDE_GTEMP_DESPACHADOR=NULL, FECHA_APROBACION='2025-04-09', FECHA_DESPACHO=NULL, ID_MAINT_WORK_ORDER=108, ID_MAINT_COST_CENTER=319, ID_GTEMP_PERSONA_RETIRA=407 WHERE ide_solicitud=88 
 /************************/

 UPDATE solicitud_items SET  IDE_SOLICITUD=88, ESTADO_SOLICITUD='DESPACHADO', FECHA_SOLICITUD='2025-04-09', IDE_GTEMP_SOLICITANTE=407, IDE_BOUBI=5, IDE_GEANI=9, IDE_GTEMP_APROBADOR=109, APROBACION_APROBADOR=true, OBSERVACION='Fuga de aire valvula de desfogue (cambio de filtro por saturación)', RECHAZO_APROBADOR=false, APROBACION_BODEGA=true, RECHAZO_BODEGA=false, TIPO='NORMAL', USUARIO_ACTUA='lquiña', FECHA_ACTUA='2025-04-09', HORA_ACTUA='09:56:59', IDE_GTEMP_DESPACHADOR=305, FECHA_APROBACION='2025-04-09', FECHA_DESPACHO='2025-04-09', ID_MAINT_WORK_ORDER=113, ID_MAINT_COST_CENTER=313, ID_GTEMP_PERSONA_RETIRA=407 WHERE ide_solicitud=88 
 
 
 
  UPDATE solicitud_items SET  IDE_SOLICITUD=8166, ESTADO_SOLICITUD='APROBADA BODEGA', FECHA_SOLICITUD='2025-08-17', IDE_GTEMP_SOLICITANTE=62, IDE_BOUBI=8, IDE_GEANI=9, IDE_GTEMP_APROBADOR=62, APROBACION_APROBADOR=true, OBSERVACION='PARA REALIZAR SEGUIMIENTO DEL CODIGO = CAJ093R', RECHAZO_APROBADOR=false, APROBACION_BODEGA=true, RECHAZO_BODEGA=false, TIPO='NORMAL', USUARIO_ACTUA='devuser', FECHA_ACTUA='2025-08-17', HORA_ACTUA='16:38:48', IDE_GTEMP_DESPACHADOR=62, FECHA_APROBACION='2025-08-17', FECHA_DESPACHO='2025-08-17', ID_MAINT_WORK_ORDER=4253, ID_MAINT_COST_CENTER=4, ID_GTEMP_PERSONA_RETIRA=1749, IP_REMOTE='127.0.0.1', URL_MAKED='http://localhost:8080/sampu/index.jsf', ID_MAINT_ASSIGNED_AREA=NULL WHERE ide_solicitud=8166 