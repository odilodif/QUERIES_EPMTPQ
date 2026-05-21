-- Movimientos línea por línea
SELECT
    a.ide_comov,
    b.ide_codem,
    a.mov_fecha_comov,
    a.tipo_movimiento,
    b.RUC,
    b.PROVEEDOR,
    a.detalle_comov,
    a.asiento_tipo,
    a.nro_comprobante_comov,
    b.cue_codigo_cocac,
    b.cue_descripcion_cocac,
    b.debe_codem,
    b.haber_codem,
    SUM(b.debe_codem - b.haber_codem) OVER (
        PARTITION BY b.cue_codigo_cocac, b.RUC
        ORDER BY a.mov_fecha_comov, a.nro_comprobante_comov, a.ide_comov
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS saldo,
    a.detalle_gemes,
    b.fecha_ejecucion_prmen,
    b.devengado_prmen,
    b.cobrado_prmen,
    b.pagado_prmen,
    a.estado,    
    false as es_total -- marca de que no es fila total
FROM view_subconsult_tbl_a a
LEFT JOIN view_subconsulta_tbl_b b ON a.ide_comov = b.ide_comov
WHERE
    a.mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-29'
    AND b.ide_cocac IN (4663, 5249)
    AND b.ruc IN ('1721057204')

UNION ALL

-- Fila de totales por cue_codigo_cocac y RUC
SELECT
    NULL::integer as ide_comov,
    NULL::integer as ide_codem,
    NULL::date as mov_fecha_comov,
    NULL::text as tipo_movimiento,
    RUC,
    PROVEEDOR,
    'TOTAL CUENTA ' || cue_codigo_cocac as detalle_comov,
    NULL::text as asiento_tipo,
    NULL::text as nro_comprobante_comov,
    cue_codigo_cocac,
    cue_descripcion_cocac,
    SUM(debe_codem),
    SUM(haber_codem),
    SUM(debe_codem - haber_codem),
    NULL::text as detalle_gemes,
    NULL::date as fecha_ejecucion_prmen,
    NULL::numeric as devengado_prmen,
    NULL::numeric as cobrado_prmen,
    NULL::numeric as pagado_prmen,
    NULL::text as estado,    
    true as es_total -- marca de fila total
FROM view_subconsulta_tbl_b b
LEFT JOIN view_subconsult_tbl_a a ON a.ide_comov = b.ide_comov
WHERE
    a.mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-29'
    AND b.ide_cocac IN (4663, 5249)
    AND b.ruc IN ('1721057204')
GROUP BY cue_codigo_cocac, cue_descripcion_cocac, RUC, PROVEEDOR

ORDER BY
    cue_codigo_cocac,
    es_total, -- muestra primero los detalles, luego el total
    mov_fecha_comov NULLS LAST,
    nro_comprobante_comov NULLS LAST,
    ide_comov NULLS LAST;
