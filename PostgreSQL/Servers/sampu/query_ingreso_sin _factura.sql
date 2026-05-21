SELECT
    ingreso.ide_ingeg,
		ingreso.ide_geani,
		ingreso.fecha_ingeg,
		ingreso.numero_documento_ingeg,
    (SELECT proveedor1.nombre_tepro FROM tes_proveedor proveedor1 WHERE proveedor1.ide_tepro = ingreso.ide_tepro ) AS nombre_tepro,
		(SELECT proveedor2.ruc_tepro FROM tes_proveedor proveedor2 WHERE proveedor2.ide_tepro = ingreso.ide_tepro ) AS ruc_tepro,
		 'factura' as num_factura,
		ubicacion.detalle_boubi,
    ingreso.subtotal_ingeg, ingreso.valor_iva_ingeg,
		ingreso.total_ingeg,
    ingreso.observacion_ingeg,
    detalle.cantidad_inegd, medida.detalle_bounm,
		presentacion.detalle_bounm as detalle_bounm_presentacion,
    catalogo.cat_codigo_bocam,
		catalogo.descripcion_bocam,
    detalle.peligro_salud_inegd,
		detalle.peligro_inflamabilidad_inegd,
    detalle.peligro_reactividad_inegd,
		detalle.manejo_especial_inegd,
    detalle.marca_inegd,
		detalle.modelo_inegd,
		detalle.color_inegd,
		estado.detalle_afest,
		empleado.primer_nombre_gtemp,
		empleado.segundo_nombre_gtemp,
    empleado.apellido_paterno_gtemp,
		empleado.apellido_materno_gtemp,
		empleado.documento_identidad_gtemp,		
    detalle.fecha_vencimiento_inegd,
		detalle.costo_unitario_inegd,
		detalle.aplica_iva_inegd,
		detalle.valor_existencia_inegd,
    detalle.subtotal_inegd,
		detalle.valor_iva_inegd,
		detalle.total_inegd,
(SELECT gth_empleado1.primer_nombre_gtemp ||' ' || gth_empleado1.segundo_nombre_gtemp||' '|| gth_empleado1.apellido_paterno_gtemp ||' ' || gth_empleado1.apellido_materno_gtemp  FROM gth_empleado gth_empleado1  WHERE  gth_empleado1.ide_gtemp = 13) AS supplied_by,

(SELECT gth_empleado2.documento_identidad_gtemp  FROM gth_empleado gth_empleado2  WHERE  gth_empleado2.ide_gtemp = 13) AS cedula_supplied_by

FROM bodt_ingreso_egreso AS ingreso
LEFT JOIN bodt_ingreso_egreso_det AS detalle ON detalle.ide_ingeg = ingreso.ide_ingeg
LEFT JOIN bodt_catalogo_material AS catalogo ON detalle.ide_bocam = catalogo.ide_bocam
LEFT JOIN gth_empleado AS empleado ON empleado.ide_gtemp = ingreso.ide_gtemp
LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON ubicacion.ide_boubi = ingreso.ide_boubi
LEFT JOIN afi_estado AS estado ON estado.ide_afest = detalle.ide_afest
LEFT JOIN bodt_unidad_medida AS medida ON medida.ide_bounm = detalle.ide_bounm
LEFT JOIN bodt_unidad_medida AS presentacion ON presentacion.ide_bounm = detalle.ide_bounm_presentacion
WHERE ingreso.ide_ingeg =  2