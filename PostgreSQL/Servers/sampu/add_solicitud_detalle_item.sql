ALTER TABLE solicitud_detalle_item
ADD COLUMN ide_bounm INT8;
/**************************************************************/
SELECT  DISTINCT bodt_catalogo_material.ide_bocam, cat_codigo_bocam, descripcion_bocam, ide_bounm, ide_bounm_presentacion,  vida_util_bocam, peligro_salud_bocam, peligro_inflamabilidad_bocam, peligro_reactividad_bocam,  manejo_especial_bocam, costo_medio_unidad_inres, costo_medio_unidad_inc_iva_inres, cantidad_saldo_boinv, pmp_existencia_inres
FROM bodt_catalogo_material 
LEFT JOIN bodt_inventario_resumen ON bodt_catalogo_material.ide_bocam = bodt_inventario_resumen.ide_bocam  
LEFT JOIN bodt_bodega_inventario ON bodt_bodega_inventario.ide_bocam = bodt_catalogo_material.ide_bocam 
WHERE bodt_catalogo_material.ide_bocam IN (3362) AND ide_boubi = 2 AND bodt_inventario_resumen.ide_geani = 9 AND bodt_bodega_inventario.ide_geani = 9 