

/********************************************/



/****************************************/

SELECT  inventario.ide_boinv, inventario.ide_bocam, catalogo.cat_codigo_bocam, catalogo.descripcion_bocam,  unidad_medida.detalle_bounm as unidad_medida, 
presentacion.detalle_bounm as presentacion, inventario.ide_boubi,   inventario.cantidad_inicial_boinv, inventario.costo_inicial_boinv,   inventario.cantidad_ingreso_boinv, inventario.costo_ingreso_boinv,  inventario.cantidad_ingreso_t_boinv, inventario.costo_ingreso_t_boinv,  inventario.cantidad_egreso_boinv, inventario.costo_egreso_boinv,  inventario.cantidad_egreso_t_boinv, inventario.costo_egreso_t_boinv,    inventario.cantidad_egreso_baja_boinv, inventario.costo_egreso_baja_boinv, inventario.cantidad_saldo_boinv, inventario.costo_saldo_boinv,  resumen.pmp_existencia_inres, ubi.detalle_boubi  
FROM   bodt_bodega_inventario AS inventario  
LEFT JOIN bodt_inventario_resumen AS resumen  ON inventario.ide_geani = resumen.ide_geani AND      inventario.ide_bocam = resumen.ide_bocam  
LEFT JOIN bodt_catalogo_material AS catalogo  ON inventario.ide_bocam = catalogo.ide_bocam  
inner join bodt_bodega_ubicacion ubi on inventario.ide_boubi=ubi.ide_boubi 
LEFT JOIN bodt_unidad_medida as unidad_medida on catalogo.ide_bounm = unidad_medida.ide_bounm  
LEFT JOIN bodt_unidad_medida as presentacion on catalogo.ide_bounm_presentacion=presentacion.ide_bounm  WHERE   inventario.ide_geani = 9 
AND inventario.ide_bocam = 8808 AND ubi.ide_boubi = 6


/*******************************/ 
SELECT * FROM bodt_catalogo_material WHERE ide_parte = 'TRA111N'; --8019 --GUA011N
SELECT * FROM bodt_catalogo_material WHERE ide_parte = 'MAS005N'; --5021  --GUA011N
SELECT * FROM bodt_catalogo_material WHERE ide_parte = 'GUA011N'; --3810  --GUA011N
SELECT * FROM bodt_catalogo_material WHERE ide_parte = 'WYP002N'; --3810  --GUA011N
SELECT * FROM bodt_catalogo_material WHERE ide_bocam = 8808 -- WYP002N
 
SELECT cantidad_saldo_boinv FROM bodt_bodega_inventario WHERE ide_bocam=8808 AND ide_boubi = 4 ;

SELECT inventario.ide_boinv, catalogo.ide_parte,    ROUND (inventario.cantidad_saldo_boinv,2) AS cantidad_saldo ,  catalogo.descripcion_bocam, (SELECT bodt_unidad_medida1.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida1 WHERE bodt_unidad_medida1.ide_bounm = catalogo.ide_bounm ) AS unidad_medida, (SELECT bodt_unidad_medida2.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida2 WHERE bodt_unidad_medida2.ide_bounm = catalogo.ide_bounm_presentacion ) AS presentacion ,ubicacion.detalle_boubi,    resumen.costo_medio_unidad_inres, inventario.ide_bocam, catalogo.cat_codigo_bocam     FROM    bodt_bodega_inventario AS inventario   LEFT JOIN bodt_inventario_resumen AS resumen ON inventario.ide_geani = resumen.ide_geani AND     inventario.ide_bocam = resumen.ide_bocam LEFT JOIN bodt_catalogo_material AS catalogo ON inventario.ide_bocam = catalogo.ide_bocam LEFT JOIN bodt_bodega_ubicacion AS ubicacion ON inventario.ide_boubi = ubicacion.ide_boubi WHERE  inventario.ide_geani = 9 AND inventario.ide_boubi = 4  AND inventario.cantidad_saldo_boinv >= 0 and inventario.ide_boubi = 3633
