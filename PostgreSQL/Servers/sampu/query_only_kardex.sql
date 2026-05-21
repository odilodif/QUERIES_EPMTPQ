
/*******************************************************************************************************************************
													KARDEX Y VALORES DEL PROMEDIO PONDERADO AND REPORT KARDEX POR ÍTEMS

**********************************************************************************************************************************/
--drop view view_only_kardex
CREATE OR REPLACE VIEW view_only_kardex 
AS

WITH param AS (
    SELECT
    9 as ide_geani,
    3810 as ide_bocam
),
inicial AS (
SELECT
 ide_geani,
 0 as ide_boubi,
 ide_bocam,
 0 as ide_ingeg,0 as ide_inegd,
 'epoch'::timestamp as fecha_ingeg,
 --DISTINCT ON (fecha_ingre) as fecha_ingeg,
 0 as ide_inttr,
 --COUNT(ide_boubi),
 SUM(cantidad_inicial_boinv) AS cantidad,
 COALESCE( SUM(cantidad_inicial_boinv*costo_inicial_inc_iva_boinv) / NULLIF(SUM(cantidad_inicial_boinv),0),0) AS pmp,
 COALESCE( SUM(cantidad_inicial_boinv)* SUM(cantidad_inicial_boinv*costo_inicial_inc_iva_boinv) / NULLIF(SUM(cantidad_inicial_boinv),0),0) as subtotal
FROM bodt_bodega_inventario
WHERE
    ide_geani = (SELECT ide_geani FROM param)
    AND ide_bocam = (SELECT ide_bocam FROM param)
GROUP BY 1, 2, 3,4, 5,6 --ide_geani, ide_bocam, fecha_ingre
),
transacciones AS (

SELECT
transaccion.ide_geani,transaccion.ide_boubi, detalle.ide_bocam, transaccion.ide_ingeg, detalle.ide_inegd, transaccion.fecha_ingeg,
detalle.ide_inttr, detalle.cantidad_inegd, detalle.costo_unitario_inc_iva_inegd, detalle.total_inegd
--*
FROM
bodt_ingreso_egreso_det as detalle
JOIN bodt_ingreso_egreso as transaccion ON detalle.ide_ingeg = transaccion.ide_ingeg
WHERE
transaccion.ide_geani = (SELECT ide_geani FROM param)
AND detalle.ide_bocam = (SELECT ide_bocam FROM param)
AND transaccion.activo_ingeg = true
ORDER BY fecha_ingeg
),
resumen AS (
SELECT * FROM inicial
UNION
SELECT * FROM transacciones
),
kardex AS (
SELECT --* from resumen
ide_geani,
ide_boubi,
ide_bocam,
ide_ingeg,
ide_inegd,
fecha_ingeg,
ide_inttr,
(SELECT cantidad FROM inicial) as inicial_cantidad,
(SELECT pmp FROM inicial) as inicial_costo,
CASE WHEN ide_inttr IN (1,3) THEN cantidad
     ELSE 0 END as ingreso_cantidad,
CASE WHEN ide_inttr IN (1,3) THEN pmp
     ELSE 0 END as ingreso_costo,
CASE WHEN ide_inttr IN (2,4) THEN cantidad
     ELSE 0 END as egreso_cantidad,
CASE WHEN ide_inttr IN (2,4) THEN pmp
     ELSE 0 END as egreso_costo,
SUM (cantidad * CASE WHEN ide_inttr IN (2,4) THEN -1 ELSE 1 END) OVER (ORDER BY ide_inegd) as saldo_cantidad,
SUM (cantidad * CASE WHEN ide_inttr IN (2) THEN -1 WHEN ide_inttr IN (0,1) THEN 1 END) OVER (ORDER BY ide_inegd) as saldo_cantidad_global,
CASE WHEN ide_inttr=0 THEN pmp
     ELSE 0 END as saldo_costo,
SUM (CASE WHEN ide_inttr IN (1) THEN cantidad  ELSE 0 END) OVER (ORDER BY ide_inegd) as ingresos_total,
SUM (CASE WHEN ide_inttr IN (2) THEN cantidad ELSE 0 END) OVER (ORDER BY ide_inegd) as egresos_total
--LAG (ide_geani,1) OVER (ORDER BY ide_inegd)
FROM resumen
),

cant_inicial_ingresos_egresos AS (
SELECT inicial_cantidad, SUM(ingreso_cantidad) AS total_ingresos	,	 ROUND(SUM(egreso_cantidad),2) as total_egresos  FROM kardex  GROUP BY inicial_cantidad
)

SELECT 'inicial' as inicial, round(inicial_cantidad,2)::TEXT AS inicial_cantidad , round(total_ingresos,2)::TEXT AS total_ingresos,  total_egresos FROM cant_inicial_ingresos_egresos
UNION ALL
SELECT '' , ' '	, 'TOTAL' , ROUND( (inicial_cantidad + total_ingresos) - ( total_egresos),2) FROM cant_inicial_ingresos_egresos

SELECT * FROM view_only_kardex