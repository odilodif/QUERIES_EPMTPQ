DROP FUNCTION  "public"."fn_reporte_reciprocas_presupuesto_113_17_00__625_04_02" (date, date, varchar, varchar, varchar, varchar);
--DROP FUNCTION  "public"."fn_rprt_reciprocas_pres_113_17_00__6250404__6250202" (date, date, varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION "public"."fn_rprt_reciprocas_pres_113_17_00__6250404__6250202"(
    p_fechaini DATE, 
    p_fechafin DATE, 
    p_cta_mayor_pagar_cobrar VARCHAR, 
    p_codigo_clasificador_prcla VARCHAR, 
    p_cta_mayor_gasto_i VARCHAR, 
    p_tercer_digito VARCHAR -- Este parámetro puede usarse para filtros adicionales si es necesario
)
RETURNS TABLE (
    res_periodo INT,
    res_ruc_entidad VARCHAR,
    res_cta_mayor_pagar_cobrar VARCHAR,
    res_flujo_deudor NUMERIC,
    res_flujo_acreedor NUMERIC,
    res_ruc VARCHAR,
    res_nombre_tepro VARCHAR,
    res_codigo_clasificador_prcla VARCHAR,
    res_cta_mayor_gasto_i VARCHAR,
    res_flujo_deudor2 NUMERIC,
    res_flujo_acreedor2 NUMERIC,
    res_nro_transaccion BIGINT,
    res_nro_referenci BIGINT,
    res_fecha_apro CHARACTER(25),
    res_fecha_venc CHARACTER(25)
) AS $$
BEGIN
    RETURN QUERY
   WITH base_movimiento AS (
    SELECT 
        mov.ide_comov,
        mov.mov_fecha_comov,
        EXTRACT(MONTH FROM mov.mov_fecha_comov)::INT AS periodo,
        emp_sis.identificacion_empr AS rucEntidad,       
				'9999999999999'::VARCHAR AS ruc,       
				'VARIOS CLIENTES'::VARCHAR AS nombre_tepro,
        COALESCE(CAST(cp.comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_transaccion
    FROM cont_movimiento mov
    CROSS JOIN (SELECT identificacion_empr FROM sis_empresa LIMIT 1) emp_sis
    LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
    LEFT JOIN (
        SELECT ide_tepro, COALESCE(ruc_representante_tepro, ruc_tepro) AS ruc_stepro, 
               SUBSTRING(nombre_tepro FROM 1 FOR 30) AS nombre_tepro 
        FROM tes_proveedor
    ) prov ON prov.ide_tepro = cp.ide_tepro
    WHERE mov.mov_fecha_comov BETWEEN p_fechaini AND p_fechafin    
),
presupuesto_data AS (
    SELECT 
        pmes.ide_codem,
        pcl.codigo_clasificador_prcla
    FROM pre_mensual pmes
    JOIN pre_anual panio ON panio.ide_pranu = pmes.ide_pranu
    JOIN pre_clasificador pcl ON pcl.ide_prcla = panio.ide_prcla
)


SELECT 
    periodo,
    rucEntidad,
    cta_mayor_pagar_cobrar::VARCHAR,
    SUM(flujo_deudor) AS flujo_deudor,
    SUM(flujo_acreedor) AS flujo_acreedor,
    ruc,
    nombre_tepro,
    codigo_clasificador_prcla::VARCHAR,
    cta_mayor_gasto_i::VARCHAR,
    SUM(flujo_deudor2) AS flujo_deudor2,
    SUM(flujo_acreedor2) AS flujo_acreedor2,
    MAX(nro_transaccion) AS nro_transaccion,
    MAX(nro_transaccion) AS nro_referenci,
     CAST(p_fechaini AS CHARACTER(25)) AS fecha_apro,
   CAST(p_fechafin AS CHARACTER(25)) AS fecha_venc
FROM (
    -- [ESCENARIO 1]: DEVENGADO (PARTIMOS DEL INGRESO 625)
    -- Eliminamos el JOIN a dmov_act para evitar duplicados si hay varias 113.17
    SELECT 
        b.periodo, 
				b.rucEntidad,
        p_cta_mayor_pagar_cobrar::VARCHAR AS cta_mayor_pagar_cobrar,
        dmov_ing.haber_codem AS flujo_deudor, 
        0 AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        COALESCE(pre.codigo_clasificador_prcla, '17.04.04') AS codigo_clasificador_prcla, 
        SUBSTRING(cat_ing.cue_codigo_cocac FROM 1 FOR 9) AS cta_mayor_gasto_i,
        0 AS flujo_deudor2,
        dmov_ing.haber_codem AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov_ing ON dmov_ing.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat_ing ON cat_ing.ide_cocac = dmov_ing.ide_cocac
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov_ing.ide_codem
    WHERE (cat_ing.cue_codigo_cocac LIKE '625.04%' OR  cat_ing.cue_codigo_cocac LIKE '625.02%')
      AND dmov_ing.haber_codem <> 0
      -- Validamos que el asiento tenga una 113.17 sin traer sus filas
      AND EXISTS (
          SELECT 1 
          FROM cont_detalle_movimiento dm_check
          JOIN cont_catalogo_cuenta cat_check ON cat_check.ide_cocac = dm_check.ide_cocac
          WHERE dm_check.ide_comov = b.ide_comov 
            AND cat_check.cue_codigo_cocac LIKE '113.17%'
      )	
			
    UNION ALL

    -- [ESCENARIO 2]: RECAUDACIÓN / COBRO (PARTIMOS DE LA 113.17)
    SELECT 
        b.periodo, 
				b.rucEntidad,
        p_cta_mayor_pagar_cobrar::VARCHAR AS cta_mayor_pagar_cobrar,
        0 AS flujo_deudor,
        dmov.haber_codem AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        ' ' AS codigo_clasificador_prcla,
        -- Buscamos el origen del dinero (Bancos o Fondos) sin duplicar la fila principal
        COALESCE((
            SELECT '111.06.00'
            FROM cont_detalle_movimiento dm_c
            JOIN cont_catalogo_cuenta cc_c ON cc_c.ide_cocac = dm_c.ide_cocac
            WHERE dm_c.ide_comov = dmov.ide_comov 
              AND (cc_c.cue_codigo_cocac LIKE '111.06%' OR cc_c.cue_codigo_cocac LIKE '212.03%')
            LIMIT 1
        ), '111.06.00') AS cta_mayor_gasto_i,
        dmov.haber_codem AS flujo_deudor2,
        0 AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    WHERE cat.cue_codigo_cocac LIKE '113.17%' 
      AND dmov.haber_codem <> 0
      -- Validamos que el asiento sea de cobro (que tenga cuenta de caja/banco o pasivo de terceros)
      AND EXISTS (
          SELECT 1 
          FROM cont_detalle_movimiento dm_check2
          JOIN cont_catalogo_cuenta cat_check2 ON cat_check2.ide_cocac = dm_check2.ide_cocac
          WHERE dm_check2.ide_comov = b.ide_comov 
            AND (cat_check2.cue_codigo_cocac LIKE '111.06%' OR cat_check2.cue_codigo_cocac LIKE '212.03%')
      )			
			
) final
GROUP BY periodo, rucEntidad, cta_mayor_pagar_cobrar, ruc, nombre_tepro, 
         codigo_clasificador_prcla, cta_mayor_gasto_i, fecha_apro, fecha_venc;



END;
$$ LANGUAGE plpgsql;


--SELECT * FROM "public"."fn_rprt_reciprocas_pres_113_17_00__6250404__6250202"('2025-11-01', '2025-11-30', '113.17.00','17.02.02','625.04.00','.99');


	