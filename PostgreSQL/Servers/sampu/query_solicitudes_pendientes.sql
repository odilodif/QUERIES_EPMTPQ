/**********************SOLICITUDES PENDIENTES *********************/


SELECT 
scab.ide_solicitud as codigo_solicitud,
(SELECT catmat1.ide_parte FROM bodt_catalogo_material catmat1 WHERE catmat1.ide_bocam = sdet.ide_bocam) as ide_parte,
(SELECT catmat2.descripcion_bocam FROM bodt_catalogo_material catmat2 WHERE catmat2.ide_bocam = sdet.ide_bocam) as descripcion_bocam,
scab.estado_solicitud,
scab.fecha_solicitud,
(SELECT emp2.primer_nombre_gtemp || ' ' || emp2.apellido_paterno_gtemp FROM gth_empleado emp2 WHERE emp2.ide_gtemp = scab.ide_gtemp_solicitante)  as empleado_solicitante,
(SELECT bodubi1.detalle_boubi FROM bodt_bodega_ubicacion bodubi1 WHERE bodubi1.ide_boubi= scab.ide_boubi ) as bodega,
(SELECT emp1.primer_nombre_gtemp || ' ' || emp1.apellido_paterno_gtemp FROM gth_empleado emp1 WHERE emp1.ide_gtemp = scab.ide_gtemp_aprobador) AS empleado_aprobador, 
scab.aprobacion_aprobador,
scab.observacion,
(SELECT emp3.primer_nombre_gtemp || ' ' || emp3.apellido_paterno_gtemp FROM gth_empleado emp3 WHERE emp3.ide_gtemp = scab.ide_gtemp_despachador) empleado_despachador,
scab.id_maint_work_order as codigo_orden_trabajo,
(SELECT mwo1.description FROM maint_work_order mwo1 WHERE mwo1.id = scab.id_maint_work_order) as orden_trabajo,
 (SELECT mcc1.name  FROM maint_cost_center mcc1 WHERE mcc1.id = scab.id_maint_cost_center) as centro_costo ,
(SELECT emp3.primer_nombre_gtemp || ' ' || emp3.apellido_paterno_gtemp FROM gth_empleado emp3 WHERE emp3.ide_gtemp = scab.id_gtemp_persona_retira) as persona_retira ,
sdet.cantidad_solicitada,
sdet.cantidad_disponible as cantidad_en_inventario,
sdet.cantidad_reservada as "cant.reservada",
sdet.cantidad_disponible_real as cantidad_disponible,
sdet.observacion as observacion_detalle
FROM solicitud_items scab
INNER JOIN solicitud_detalle_item sdet ON scab.ide_solicitud = sdet.ide_solicitud
WHERE scab.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO', 'RECHAZADA BODEGA' ) 
and scab.ide_boubi = 4
AND sdet.ide_bocam= 8019 --9819 --2840



SELECT * from bodt_ingreso_egreso_det WHERE ide_bocam is null;



/********************Test*************************/
SELECT  scab.ide_solicitud as "NÚMERO DE SOLICITUD" , scab.fecha_solicitud    , scab.estado_solicitud     , (SELECT catmat1.ide_parte FROM bodt_catalogo_material catmat1 WHERE catmat1.ide_bocam = sdet.ide_bocam) as ide_parte, (SELECT catmat2.descripcion_bocam FROM bodt_catalogo_material catmat2 WHERE catmat2.ide_bocam = sdet.ide_bocam) as descripcion_bocam,  (SELECT emp2.primer_nombre_gtemp || ' ' || emp2.apellido_paterno_gtemp FROM gth_empleado emp2 WHERE emp2.ide_gtemp = scab.ide_gtemp_solicitante)  as empleado_solicitante    , (SELECT emp1.primer_nombre_gtemp || ' ' || emp1.apellido_paterno_gtemp FROM gth_empleado emp1 WHERE emp1.ide_gtemp = scab.ide_gtemp_aprobador) AS empleado_aprobador      , (SELECT emp3.primer_nombre_gtemp || ' ' || emp3.apellido_paterno_gtemp FROM gth_empleado emp3 WHERE emp3.ide_gtemp = scab.ide_gtemp_despachador) empleado_despachador,  (SELECT emp4.primer_nombre_gtemp || ' ' || emp4.apellido_paterno_gtemp FROM gth_empleado emp4 WHERE emp4.ide_gtemp = scab.id_gtemp_persona_retira) as persona_retira , (SELECT bodubi1.detalle_boubi FROM bodt_bodega_ubicacion bodubi1 WHERE bodubi1.ide_boubi= scab.ide_boubi ) as bodega     , scab.aprobacion_aprobador , scab.observacion, scab.id_maint_work_order as "Nro. Orden de trabajo ERP", (SELECT mwo1.description FROM maint_work_order mwo1 WHERE mwo1.id = scab.id_maint_work_order) as orden_trabajo , (SELECT mwo2.number_order_api FROM maint_work_order mwo2 WHERE mwo2.id   = scab.id_maint_work_order ) as "Nro. Orden de trabajo sistema", (SELECT mcc1.name  FROM maint_cost_center mcc1 WHERE mcc1.id = scab.id_maint_cost_center) as centro_costo , sdet.cantidad_solicitada as "cant.solicitada", sdet.cantidad_disponible as "cant.inventario", sdet.cantidad_reservada as "cant.reservada" , sdet.cantidad_disponible_real as "cant.disponible", sdet.observacion as observacion_detalle 
FROM solicitud_items scab 
INNER JOIN solicitud_detalle_item sdet ON scab.ide_solicitud = sdet.ide_solicitud 
WHERE scab.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO', 'RECHAZADA BODEGA' )  ORDER BY 1   




SELECT  COALESCE(cc.code, '  ') || '  ' || COALESCE(cc.name, '  ') || '  ' || COALESCE(cc.plate, ' ') || '  ' || COALESCE(cc.chassis_code, ' ')  FROM maint_cost_center cc WHERE cc.id = scab.id_maint_cost_center 


/***************************/


 SELECT scab.ide_solicitud as "NÚMERO DE SOLICITUD" , scab.fecha_solicitud , scab.estado_solicitud , (SELECT catmat1.ide_parte FROM bodt_catalogo_material catmat1 WHERE catmat1.ide_bocam = sdet.ide_bocam) as ide_parte, (SELECT catmat2.descripcion_bocam FROM bodt_catalogo_material catmat2 WHERE catmat2.ide_bocam = sdet.ide_bocam) as descripcion_bocam, (SELECT emp2.primer_nombre_gtemp || ' ' || emp2.apellido_paterno_gtemp FROM gth_empleado emp2 WHERE emp2.ide_gtemp = scab.ide_gtemp_solicitante) as empleado_solicitante , (SELECT emp1.primer_nombre_gtemp || ' ' || emp1.apellido_paterno_gtemp FROM gth_empleado emp1 WHERE emp1.ide_gtemp = scab.ide_gtemp_aprobador) AS empleado_aprobador , (SELECT emp3.primer_nombre_gtemp || ' ' || emp3.apellido_paterno_gtemp FROM gth_empleado emp3 WHERE emp3.ide_gtemp = scab.ide_gtemp_despachador) empleado_despachador, (SELECT emp4.primer_nombre_gtemp || ' ' || emp4.apellido_paterno_gtemp FROM gth_empleado emp4 WHERE emp4.ide_gtemp = scab.id_gtemp_persona_retira) as persona_retira , (SELECT bodubi1.detalle_boubi FROM bodt_bodega_ubicacion bodubi1 WHERE bodubi1.ide_boubi= scab.ide_boubi ) as bodega , scab.aprobacion_aprobador , scab.observacion as "OBSERVACIÓN SOLICITUD", scab.id_maint_work_order as "Nro. Orden de trabajo ERP", (SELECT mwo1.description FROM maint_work_order mwo1 WHERE mwo1.id = scab.id_maint_work_order) as orden_trabajo , (SELECT mwo2.number_order_api FROM maint_work_order mwo2 WHERE mwo2.id = scab.id_maint_work_order ) as "Nro. Orden de trabajo sistema", (SELECT mcc1.name FROM maint_cost_center mcc1 WHERE mcc1.id = scab.id_maint_cost_center) as centro_costo , sdet.cantidad_solicitada as "cant.solicitada", sdet.cantidad_disponible as "cant.inventario", sdet.cantidad_reservada as "cant.reservada" , sdet.cantidad_disponible_real as "cant.disponible", sdet.observacion as observacion_detalle FROM solicitud_items scab INNER JOIN solicitud_detalle_item sdet ON scab.ide_solicitud = sdet.ide_solicitud WHERE scab.estado_solicitud NOT IN ('RECHAZADA','DESPACHADO', 'RECHAZADA BODEGA' ) ORDER BY 1
