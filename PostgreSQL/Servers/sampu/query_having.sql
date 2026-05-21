SELECT
transaccion.ide_geani,transaccion.ide_boubi, detalle.ide_bocam, transaccion.ide_ingeg, detalle.ide_inegd, transaccion.fecha_ingeg,
detalle.ide_inttr, detalle.cantidad_inegd, detalle.costo_unitario_inc_iva_inegd, detalle.total_inegd
--*
FROM
bodt_ingreso_egreso_det as detalle
JOIN bodt_ingreso_egreso as transaccion ON detalle.ide_ingeg = transaccion.ide_ingeg
WHERE
transaccion.ide_geani = 9
AND detalle.ide_bocam = 9819
AND transaccion.activo_ingeg = true
ORDER BY fecha_ingeg

/*/*************************************************/
SELECT ide_bocam, count(ide_bocam) FROM bodt_inventario_resumen
GROUP BY 1 HAVING count(ide_bocam) > 1


/*********************************/

SELECT * FROM bodt_inventario_resumen WHERE ide_bocam=9819 ORDER BY ide_inres;

SELECT * FROM bodt_catalogo_material WHERE ide_bocam=9819;