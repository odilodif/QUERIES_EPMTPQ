/*/SELECT DISTINCT a.ide_comov, b.ide_codem, a.mov_fecha_comov, a.tipo_movimiento, b.RUC, b.PROVEEDOR, a.detalle_comov, a.asiento_tipo, a.nro_comprobante_comov, b.cue_codigo_cocac, b.cue_descripcion_cocac, b.debe_codem, b.haber_codem, SUM(b.debe_codem - b.haber_codem) OVER (PARTITION BY b.cue_codigo_cocac ORDER BY a.mov_fecha_comov) AS saldo, a.detalle_gemes, b.fecha_ejecucion_prmen, b.devengado_prmen, b.cobrado_prmen, b.pagado_prmen, a.estado, b.ide_tepro FROM view_subconsult_tbl_a a LEFT JOIN view_subconsulta_tbl_b b ON a.ide_comov = b.ide_comov  where mov_fecha_comov between '2025-01-01' and '2025-06-29' AND b.ide_cocac IN (4663,5249) AND b.ruc IN ('1721057204')ORDER BY b.cue_codigo_cocac, a.mov_fecha_comov, a.nro_comprobante_comov*/

/**********************************************************************/

SELECT DISTINCT
    a.ide_comov,
    b.ide_codem,
    a.mov_fecha_comov,
    a.tipo_movimiento,
    b.ruc,
    b.proveedor,
    a.detalle_comov,
    a.asiento_tipo,
    a.nro_comprobante_comov,
    b.cue_codigo_cocac,
    b.cue_descripcion_cocac,
    b.debe_codem,
    b.haber_codem,    
		-- Saldo acumulado como C1 + A2 - B2
   /* SUM(debe_codem - haber_codem) OVER (
        PARTITION BY b.cue_codigo_cocac, b.ruc
        ORDER BY a.mov_fecha_comov, a.nro_comprobante_comov, a.ide_comov
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS saldo,*/
		 SUM(b.debe_codem - b.haber_codem) OVER (PARTITION BY b.cue_codigo_cocac ORDER BY a.mov_fecha_comov) AS saldo,
    a.detalle_gemes,
    b.fecha_ejecucion_prmen,
    b.devengado_prmen,
    b.cobrado_prmen,
    b.pagado_prmen,
    a.estado   
FROM view_subconsult_tbl_a a
LEFT JOIN view_subconsulta_tbl_b b ON a.ide_comov = b.ide_comov
WHERE
    mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-29'
    AND b.ide_cocac IN (4663, 5249)
    AND b.ruc IN ('1721057204')
ORDER BY
    b.cue_codigo_cocac, a.mov_fecha_comov, a.nro_comprobante_comov, a.ide_comov;
