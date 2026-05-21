SELECT 
    dmov_ing.ide_codem,
    b.periodo, 
    b.rucEntidad,
    '113.17.00' AS cta_mayor_pagar_cobrar,
    dmov_ing.haber_codem AS flujo_deudor, 
    0 AS flujo_acreedor,
    b.ruc, 
    b.nombre_tepro,
    COALESCE(pre.codigo_clasificador_prcla, '17.04.04') AS codigo_clasificador_prcla, 
    SUBSTRING(cat_ing.cue_codigo_cocac FROM 1 FOR 9) AS cta_mayor_gasto_i,
    0 AS flujo_deudor2,
    dmov_ing.haber_codem AS flujo_acreedor2,
    b.nro_transaccion
FROM base_movimiento b
-- Unimos solo las líneas de INGRESO que queremos reportar
JOIN cont_detalle_movimiento dmov_ing ON dmov_ing.ide_comov = b.ide_comov
JOIN cont_catalogo_cuenta cat_ing ON cat_ing.ide_cocac = dmov_ing.ide_cocac
LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov_ing.ide_codem
WHERE cat_ing.cue_codigo_cocac LIKE '625.04%' 
  AND dmov_ing.haber_codem <> 0
  -- Esta es la clave: Filtramos que el asiento contenga la 113.17 sin duplicar filas
  AND EXISTS (
      SELECT 1 
      FROM cont_detalle_movimiento sub_dmov
      JOIN cont_catalogo_cuenta sub_cat ON sub_cat.ide_cocac = sub_dmov.ide_cocac
      WHERE sub_dmov.ide_comov = b.ide_comov 
        AND sub_cat.cue_codigo_cocac LIKE '113.17%'
  )
  AND b.ide_comov = 13186;