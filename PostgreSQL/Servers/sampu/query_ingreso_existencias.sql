SELECT
   ingreso.ide_ingeg, ingreso.ide_geani, ingreso.fecha_ingeg, ingreso.numero_documento_ingeg,
    proveedor.nombre_tepro, 
		proveedor.ruc_tepro, 
		factura.num_factura_adfac,
		factura_antigua.num_factura_adfac as num_factura_adfac_antigua,
    certificacion.nro_certificacion_prcer, ubicacion.detalle_boubi,
    ingreso.subtotal_ingeg, ingreso.valor_iva_ingeg, ingreso.total_ingeg,
    ingreso.observacion_ingeg,
    detalle.cantidad_inegd, medida.detalle_bounm, presentacion.detalle_bounm as detalle_bounm_presentacion,
    catalogo.cat_codigo_bocam, catalogo.descripcion_bocam,
    detalle.peligro_salud_inegd, detalle.peligro_inflamabilidad_inegd,
    detalle.peligro_reactividad_inegd, detalle.manejo_especial_inegd,
    detalle.marca_inegd, detalle.modelo_inegd, detalle.color_inegd, estado.detalle_afest,
    empleado.apellido_paterno_gtemp, empleado.apellido_materno_gtemp, empleado.primer_nombre_gtemp,
    detalle.fecha_vencimiento_inegd, detalle.costo_unitario_inegd, detalle.aplica_iva_inegd, detalle.valor_existencia_inegd,
    detalle.subtotal_inegd, detalle.valor_iva_inegd, detalle.total_inegd

FROM 			bodt_ingreso_egreso AS ingreso
JOIN 			bodt_ingreso_egreso_det AS detalle ON detalle.ide_ingeg = ingreso.ide_ingeg
LEFT JOIN bodt_catalogo_material AS catalogo ON detalle.ide_bocam = catalogo.ide_bocam
LEFT JOIN adq_factura AS factura ON factura.ide_adfac = ingreso.ide_adfac
LEFT JOIN adq_factura AS factura_antigua ON factura_antigua.ide_adfac = ingreso.ide_adfac_antigua
LEFT JOIN tes_proveedor AS proveedor ON proveedor.ide_tepro = factura.ide_tepro
LEFT JOIN gth_empleado AS empleado ON empleado.ide_gtemp = ingreso.ide_gtemp
LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON ubicacion.ide_boubi = ingreso.ide_boubi
LEFT JOIN afi_estado AS estado ON estado.ide_afest = detalle.ide_afest
LEFT JOIN bodt_unidad_medida AS medida ON medida.ide_bounm = detalle.ide_bounm
LEFT JOIN bodt_unidad_medida AS presentacion ON presentacion.ide_bounm = detalle.ide_bounm_presentacion
LEFT JOIN pre_certificacion AS certificacion ON certificacion.ide_prcer = ingreso.ide_prcer
WHERE ingreso.ide_ingeg = 8; 

 -- 456 --2