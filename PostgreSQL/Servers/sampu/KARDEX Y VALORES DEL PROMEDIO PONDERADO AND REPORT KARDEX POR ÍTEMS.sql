
/*******************************************************************************************************************************
													KARDEX Y VALORES DEL PROMEDIO PONDERADO AND REPORT KARDEX POR ÍTEMS

**********************************************************************************************************************************/
WITH param AS (
    SELECT
    10 as ide_geani,
    6067 as ide_bocam
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
--SELECT * FROM kardex
kardex_pmp AS 
(
SELECT
ide_geani,
ide_boubi,
ide_bocam,
ide_ingeg,
ide_inegd,
fecha_ingeg,
ide_inttr,
ingreso_cantidad,

ingreso_costo,
ingresos_total,
egresos_total,
egreso_cantidad,
egreso_costo,
saldo_cantidad,

saldo_cantidad_global,
--ROUND(COALESCE((COALESCE(inicial_cantidad*inicial_costo,0) + COALESCE(SUM (CASE WHEN ide_inttr IN (0,1) THEN ingreso_cantidad *  ingreso_costo END) OVER (ORDER BY ide_inegd),0) - COALESCE(SUM (CASE WHEN ide_inttr IN (2) THEN egreso_cantidad *  egreso_costo END) OVER (ORDER BY ide_inegd),0))/ NULLIF(saldo_cantidad_global,0),0), 2) as pmp
ROUND((COALESCE(inicial_cantidad*inicial_costo,0) + COALESCE(SUM(CASE WHEN ide_inttr IN (1) THEN ingreso_cantidad * ingreso_costo ELSE 0 END) OVER (ORDER BY ide_inegd),0) - COALESCE(SUM(CASE WHEN ide_inttr IN (2) THEN egreso_cantidad * egreso_costo ELSE 0 END) OVER (ORDER BY ide_inegd),0))/ NULLIF(saldo_cantidad_global, 0), 2) as pmp
--CASE WHEN ide_inttr = 0 THEN COALESCE(inicial_cantidad*inicial_costo,0) ELSE
FROM
kardex 

),

pmp_ingresos AS (
 SELECT *
 FROM kardex_pmp
 WHERE ide_inttr IN (0,1)
)


SELECT * FROM pmp_ingresos

/*SELECT
ROW_NUMBER() OVER ( ORDER BY kardex_pmp.ide_inegd ) AS nro,
kardex_pmp.ide_geani,
kardex_pmp.ide_boubi,
ubicacion.detalle_boubi,
kardex_pmp.ide_bocam,
catalogo.cat_codigo_bocam,
catalogo.descripcion_bocam,
kardex_pmp.ide_ingeg,
kardex_pmp.ide_inegd,
kardex_pmp.fecha_ingeg,
kardex_pmp.ide_inttr,
tipo_transaccion.detalle_inttr,
kardex_pmp.ingreso_cantidad,

kardex_pmp.ingreso_costo,
kardex_pmp.ingresos_total,
kardex_pmp.egreso_cantidad,
kardex_pmp.egreso_costo,
kardex_pmp.saldo_cantidad,
kardex_pmp.pmp as pmp_tmp,
(SELECT pmp FROM pmp_ingresos WHERE pmp_ingresos.ide_inegd <= kardex_pmp.ide_inegd ORDER BY ide_inegd DESC LIMIT 1) as pmp
FROM kardex_pmp
LEFT JOIN bodt_catalogo_material AS catalogo ON catalogo.ide_bocam = kardex_pmp.ide_bocam
LEFT JOIN bodt_inventario_tipo_transaccion AS tipo_transaccion ON tipo_transaccion.ide_inttr = kardex_pmp.ide_inttr
LEFT JOIN bodt_bodega_ubicacion as ubicacion ON ubicacion.ide_boubi = kardex_pmp.ide_boubi
WHERE kardex_pmp.ide_boubi=6
ORDER BY kardex_pmp.ide_inegd */









