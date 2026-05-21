SELECT ingdet.ide_inegd, ide_bocam,	ingdet.ide_ingeg,	ingdet.ide_inttr,	ingdet.ide_addef,	ingdet.ide_afest,	ingdet.costo_unitario_inegd,	ingdet.subtotal_inegd,	ingdet.valor_iva_inegd,	ingdet.cantidad_inegd,	ingdet.aplica_iva_inegd,	ingdet.total_inegd,	ingdet.usuario_ingre,	ingdet.fecha_ingre,	ingdet.hora_ingre,	ingdet.usuario_actua,	ingdet.fecha_actua,	ingdet.hora_actua,	ingdet.marca_inegd,	ingdet.modelo_inegd,	ingdet.color_inegd,	ingdet.fecha_vencimiento_inegd,	ingdet.peligro_salud_inegd,	ingdet.peligro_inflamabilidad_inegd,	ingdet.peligro_reactividad_inegd,	ingdet.manejo_especial_inegd,	ingdet.saldo_disponible_inegd,	ingdet.ide_bounm,	ingdet.ide_bounm_presentacion,	ingdet.costo_unitario_inc_iva_inegd,	ingdet.valor_existencia_inegd  FROM bodt_ingreso_egreso ing, bodt_ingreso_egreso_det ingdet 
WHERE ing.ide_ingeg = ingdet.ide_ingeg 
AND ingdet.ide_inttr IN (1,3);



SELECT  SUM( cantidad_inegd) AS subtotal 
FROM bodt_ingreso_egreso ing, bodt_ingreso_egreso_det ingdet 
WHERE ing.ide_ingeg = ingdet.ide_ingeg 
AND ingdet.ide_inttr IN (1,3);





/************************************************************************************/
SELECT ingdet.ide_inegd, ide_bocam,	ingdet.ide_ingeg,	ingdet.ide_inttr,	ingdet.ide_addef,	ingdet.ide_afest,	ingdet.costo_unitario_inegd,	ingdet.subtotal_inegd,	ingdet.valor_iva_inegd,	ingdet.cantidad_inegd,	ingdet.aplica_iva_inegd,	ingdet.total_inegd,	ingdet.usuario_ingre,	ingdet.fecha_ingre,	ingdet.hora_ingre,	ingdet.usuario_actua,	ingdet.fecha_actua,	ingdet.hora_actua,	ingdet.marca_inegd,	ingdet.modelo_inegd,	ingdet.color_inegd,	ingdet.fecha_vencimiento_inegd,	ingdet.peligro_salud_inegd,	ingdet.peligro_inflamabilidad_inegd,	ingdet.peligro_reactividad_inegd,	ingdet.manejo_especial_inegd,	ingdet.saldo_disponible_inegd,	ingdet.ide_bounm,	ingdet.ide_bounm_presentacion,	ingdet.costo_unitario_inc_iva_inegd,	ingdet.valor_existencia_inegd  FROM bodt_ingreso_egreso ing, bodt_ingreso_egreso_det ingdet 
WHERE ing.ide_ingeg = ingdet.ide_ingeg 
AND ingdet.ide_inttr 



SELECT  SUM( cantidad_inegd) AS subtotal 
FROM bodt_ingreso_egreso ing, bodt_ingreso_egreso_det ingdet 
WHERE ing.ide_ingeg = ingdet.ide_ingeg 
AND ingdet.ide_inttr IN (2,4,6);

/***************************Opción 1: Usando SUM con CASE WHEN***********************************/

SELECT 
    SUM(CASE WHEN ingdet.ide_inttr IN (1,3) THEN cantidad_inegd ELSE 0 END) -
    SUM(CASE WHEN ingdet.ide_inttr IN (2,4,6) THEN cantidad_inegd ELSE 0 END) 
    AS resultado
FROM bodt_ingreso_egreso ing
JOIN bodt_ingreso_egreso_det ingdet ON ing.ide_ingeg = ingdet.ide_ingeg;


/*************************Opción 2: Usando Subconsultas**********************/

SELECT 
    (SELECT SUM(cantidad_inegd) 
     FROM bodt_ingreso_egreso ing
     JOIN bodt_ingreso_egreso_det ingdet ON ing.ide_ingeg = ingdet.ide_ingeg
     WHERE ingdet.ide_inttr IN (1,3)) 
    -
    (SELECT SUM(cantidad_inegd) 
     FROM bodt_ingreso_egreso ing
     JOIN bodt_ingreso_egreso_det ingdet ON ing.ide_ingeg = ingdet.ide_ingeg
     WHERE ingdet.ide_inttr IN (2,4,6))
    AS resultado;


/*****************************Opción 3: Usando WITH (Common Table Expressions - CTE)************************************/
WITH ingresos AS (
    SELECT SUM(cantidad_inegd) AS subtotal 
    FROM bodt_ingreso_egreso ing
    JOIN bodt_ingreso_egreso_det ingdet ON ing.ide_ingeg = ingdet.ide_ingeg
    WHERE ingdet.ide_inttr IN (1,3)
),
egresos AS (
    SELECT SUM(cantidad_inegd) AS subtotal 
    FROM bodt_ingreso_egreso ing
    JOIN bodt_ingreso_egreso_det ingdet ON ing.ide_ingeg = ingdet.ide_ingeg
    WHERE ingdet.ide_inttr IN (2,4,6)
)
SELECT ingresos.subtotal - egresos.subtotal AS resultado
FROM ingresos, egresos;

