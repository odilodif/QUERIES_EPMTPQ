SELECT DISTINCT
    b.RUC,
    b.PROVEEDOR,
    b.cue_codigo_cocac,
    b.cue_descripcion_cocac,
    SUM(b.debe_codem) AS debe,
    SUM(b.haber_codem) AS haber,
    SUM(b.debe_codem - b.haber_codem) AS saldo
FROM view_subconsult_tbl_a a
LEFT JOIN view_subconsulta_tbl_b b ON a.ide_comov = b.ide_comov
WHERE
    a.mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-29'
    AND b.ide_cocac IN (4663, 5249)
    AND b.ruc IN ('1719384081', '1721057204')
GROUP BY
    b.RUC,
    b.PROVEEDOR,
    b.cue_codigo_cocac,
    b.cue_descripcion_cocac
ORDER BY
    b.cue_codigo_cocac;


