SELECT  
DISTINCT bodt_catalogo_material.ide_bocam,  
bodt_catalogo_material.ide_parte ,
cat_codigo_bocam, 
descripcion_bocam, 
costo_medio_unidad_inres 
FROM bodt_catalogo_material 
LEFT JOIN bodt_inventario_resumen ON bodt_catalogo_material.ide_bocam = bodt_inventario_resumen.ide_bocam 
WHERE  ide_geani=9;


/*******************/

SELECT inventario.ide_boinv, catalogo.ide_parte,     inventario.cantidad_saldo_boinv ,  catalogo.descripcion_bocam, (SELECT bodt_unidad_medida1.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida1 WHERE bodt_unidad_medida1.ide_bounm = catalogo.ide_bounm ) AS unidad_medida, (SELECT bodt_unidad_medida2.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida2 WHERE bodt_unidad_medida2.ide_bounm = catalogo.ide_bounm_presentacion ) AS presentacion ,ubicacion.detalle_boubi,    resumen.costo_medio_unidad_inres, inventario.ide_bocam, catalogo.cat_codigo_bocam     
FROM    bodt_bodega_inventario AS inventario   
LEFT JOIN bodt_inventario_resumen AS resumen ON inventario.ide_geani = resumen.ide_geani AND     inventario.ide_bocam = resumen.ide_bocam 
LEFT JOIN bodt_catalogo_material AS catalogo ON inventario.ide_bocam = catalogo.ide_bocam LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON inventario.ide_boubi = ubicacion.ide_boubi WHERE  inventario.ide_geani = 9 AND inventario.ide_boubi = 8  AND inventario.cantidad_saldo_boinv >= 0 


/*************************************/

SELECT inventario.ide_boinv, catalogo.ide_parte,     
inventario.cantidad_saldo_boinv ,  
catalogo.descripcion_bocam, (SELECT bodt_unidad_medida1.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida1 WHERE bodt_unidad_medida1.ide_bounm = catalogo.ide_bounm ) AS unidad_medida, (SELECT bodt_unidad_medida2.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida2 WHERE bodt_unidad_medida2.ide_bounm = catalogo.ide_bounm_presentacion ) AS presentacion ,ubicacion.detalle_boubi,    resumen.costo_medio_unidad_inres, inventario.ide_bocam, catalogo.cat_codigo_bocam     
FROM    bodt_bodega_inventario AS inventario   
LEFT JOIN bodt_inventario_resumen AS resumen ON inventario.ide_geani = resumen.ide_geani AND     inventario.ide_bocam = resumen.ide_bocam 
LEFT JOIN bodt_catalogo_material AS catalogo ON inventario.ide_bocam = catalogo.ide_bocam 
LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON inventario.ide_boubi = ubicacion.ide_boubi WHERE  inventario.ide_geani = 9 AND inventario.ide_boubi = 8  AND inventario.cantidad_saldo_boinv >= 0 


