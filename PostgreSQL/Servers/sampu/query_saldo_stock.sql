SELECT * FROM bodt_catalogo_material WHERE descripcion_bocam ILIKE  '%VALVULA ELECTRONEUMATICA DE SUSPENSION DELANTERA%'

SELECT cantidad_saldo_boinv, * FROM bodt_bodega_inventario WHERE ide_bocam IN ( 370, 1636, 4746 )AND ide_boubi = 2 AND ide_geani = 9


370
1636
4746


SELECT
    ingreso.ide_ingeg, ingreso.ide_geani, ingreso.fecha_ingeg, ingreso.numero_documento_ingeg,
    proveedor.nombre_tepro, proveedor.ruc_tepro, factura.num_factura_adfac,
    certificacion.nro_certificacion_prcer, ubicacion.detalle_boubi,
    ingreso.subtotal_ingeg, ingreso.valor_iva_ingeg, ingreso.total_ingeg,
    ingreso.observacion_ingeg,
    detalle.cantidad_inegd, medida.detalle_bounm, presentacion.detalle_bounm as detalle_bounm_presentacion,
    catalogo.cat_codigo_bocam, catalogo.descripcion_bocam,
    detalle.peligro_salud_inegd, detalle.peligro_inflamabilidad_inegd,
    detalle.peligro_reactividad_inegd, detalle.manejo_especial_inegd,
    detalle.marca_inegd, detalle.modelo_inegd, detalle.color_inegd, estado.detalle_afest,
    empleado.apellido_paterno_gtemp, empleado.apellido_materno_gtemp, empleado.primer_nombre_gtemp, empleado.segundo_nombre_gtemp,
		empleado.documento_identidad_gtemp,
    jefe.apellido_paterno_gtemp as apellido_paterno_jefe, jefe.apellido_materno_gtemp as apellido_materno_jefe, jefe.primer_nombre_gtemp as primer_nombre_jefe,
    solicitante.apellido_paterno_gtemp as apellido_paterno_solicitante, solicitante.apellido_materno_gtemp as apellido_materno_solicitante, solicitante.primer_nombre_gtemp as primer_nombre_solicitante, solicitante.segundo_nombre_gtemp as sugundo_nombre_solicitante,
    detalle.fecha_vencimiento_inegd, detalle.costo_unitario_inegd, detalle.valor_existencia_inegd, detalle.costo_unitario_inc_iva_inegd,detalle.aplica_iva_inegd,
    detalle.subtotal_inegd,
		detalle.valor_iva_inegd, detalle.total_inegd,
		(SELECT bodt_bodega_inventario1.cantidad_saldo_boinv from bodt_bodega_inventario bodt_bodega_inventario1 
WHERE  bodt_bodega_inventario1.ide_bocam  = detalle.ide_bocam  AND bodt_bodega_inventario1.ide_geani=ingreso.ide_geani AND  bodt_bodega_inventario1.ide_boubi = ingreso.ide_boubi) AS stock,
     CASE WHEN ordenTrabajo.id_type_work_order=1 THEN
        	( SELECT 'CODIGO: ' || maint_work_order1.id  || ' NRO-ORDEN-TRAB: ' || COALESCE (maint_work_order1.number_order,0) || '  FECHA OT: ' || maint_work_order1.start_date   FROM  maint_work_order maint_work_order1 WHERE maint_work_order1.id = ingreso.id_maint_work_order  )
     ELSE
            ( SELECT 'CODIGO: ' || maint_work_order1.id  || '  FECHA OT: ' || maint_work_order1.start_date   FROM  maint_work_order maint_work_order1 WHERE maint_work_order1.id = ingreso.id_maint_work_order  )
        END
 AS aswork_order,
	 (SELECT ' CODIGO: ' || maint_cost_center1.code || ' NOMBRE: ' || maint_cost_center1.name || ' PLACA: ' || COALESCE (maint_cost_center1.plate,' ') ||' CHASIS: ' ||	COALESCE (maint_cost_center1.chassis_code,' ')  FROM maint_cost_center maint_cost_center1  WHERE maint_cost_center1.id = ingreso.id_maint_cost_center )  AS center_cost,
ingreso.url_ing_egr,
 (SELECT solicitud_items1.observacion FROM solicitud_items solicitud_items1 WHERE solicitud_items1.ide_solicitud = ingreso.ide_solicitud ) AS observaciones_sol 
FROM bodt_ingreso_egreso AS ingreso
LEFT JOIN bodt_ingreso_egreso_det AS detalle ON detalle.ide_ingeg = ingreso.ide_ingeg
LEFT JOIN bodt_catalogo_material AS catalogo ON detalle.ide_bocam = catalogo.ide_bocam
LEFT JOIN adq_factura AS factura ON factura.ide_adfac = ingreso.ide_adfac
LEFT JOIN tes_proveedor AS proveedor ON proveedor.ide_tepro = factura.ide_tepro
LEFT JOIN gth_empleado AS empleado ON empleado.ide_gtemp = ingreso.ide_gtemp
LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON ubicacion.ide_boubi = ingreso.ide_boubi
LEFT JOIN afi_estado AS estado ON estado.ide_afest = detalle.ide_afest
LEFT JOIN bodt_unidad_medida AS medida ON medida.ide_bounm = detalle.ide_bounm
LEFT JOIN bodt_unidad_medida AS presentacion ON presentacion.ide_bounm = detalle.ide_bounm_presentacion
LEFT JOIN pre_certificacion AS certificacion ON certificacion.ide_prcer = ingreso.ide_prcer
LEFT JOIN gth_empleado AS jefe ON jefe.ide_gtemp = ingreso.ide_gtemp_jefe_solicitante
LEFT JOIN gth_empleado AS solicitante ON solicitante.ide_gtemp = ingreso.ide_gtemp_solicitante
LEFT JOIN maint_work_order as ordenTrabajo on ordenTrabajo.id=ingreso.id_maint_work_order
WHERE ingreso.ide_ingeg = 1655


(SELECT bodt_bodega_inventario1.cantidad_saldo_boinv from bodt_bodega_inventario bodt_bodega_inventario1 
WHERE  bodt_bodega_inventario1.ide_bocam  = 2867 AND bodt_bodega_inventario1.ide_geani=9 AND  bodt_bodega_inventario1.ide_boubi = 2)