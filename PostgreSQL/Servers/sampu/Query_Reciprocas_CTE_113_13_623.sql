WITH base_movimiento AS (
    -- CTE para centralizar datos de cabecera, proveedores y empleados en una Commun Table Expresion
		
		/*CREATE VIEW v_base_movimiento 
		AS*/
		
    SELECT 
        mov.ide_comov,
        mov.mov_fecha_comov,
        EXTRACT(MONTH FROM mov.mov_fecha_comov) AS periodo,
        emp_sis.identificacion_empr AS rucEntidad,
        COALESCE(cp.ide_tepro, cp.ide_geedp) as link_id,
        COALESCE(prov.ruc_tepro, emp.ruc_emp, '9999999999999') AS ruc,
        COALESCE(prov.nombre_tepro, emp.nombres, 'VARIOS CLIENTES') AS nombre_tepro,
        COALESCE(CAST(cp.comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_transaccion
    FROM cont_movimiento mov
    CROSS JOIN (SELECT identificacion_empr FROM sis_empresa LIMIT 1) emp_sis
    LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
    LEFT JOIN (
        SELECT ide_tepro, COALESCE(ruc_representante_tepro, ruc_tepro) AS ruc_tepro, 
               SUBSTRING(nombre_tepro FROM 1 FOR 30) AS nombre_tepro 
        FROM tes_proveedor
    ) prov ON prov.ide_tepro = cp.ide_tepro
    LEFT JOIN (
        SELECT par.ide_geedp, 
               SUBSTRING(APELLIDO_PATERNO_GTEMP || ' ' || COALESCE(APELLIDO_MATERNO_GTEMP,'') || ' ' || PRIMER_NOMBRE_GTEMP, 1, 30) AS nombres,
               DOCUMENTO_IDENTIDAD_GTEMP AS ruc_emp
        FROM GEN_EMPLEADOS_DEPARTAMENTO_PAR par
        JOIN GTH_EMPLEADO emp ON par.ide_gtemp = emp.ide_gtemp
    ) emp ON emp.ide_geedp = cp.ide_geedp
    WHERE mov.mov_fecha_comov BETWEEN '2025-11-01' AND '2025-11-30'
),

presupuesto_data AS (
    -- CTE para obtener la ejecución presupuestaria (Partida y Valor Cobrado)
		
		/*CREATE VIEW v_presupuesto_data
		as*/
    SELECT 
        pmes.ide_codem,
        pcl.codigo_clasificador_prcla,
        SUM(pmes.cobrado_prmen) AS valor_presupuesto
    FROM pre_mensual pmes
    JOIN pre_anual panio ON panio.ide_pranu = pmes.ide_pranu
    JOIN pre_clasificador pcl ON pcl.ide_prcla = panio.ide_prcla WHERE pmes.ide_codem = 
    GROUP BY pmes.ide_codem, pcl.codigo_clasificador_prcla
)

/*BEGIN Main***/
SELECT 
    periodo,
    rucEntidad,
    cta_mayor_pagar_cobrar,
    SUM(flujo_deudor) AS flujo_deudor,
    SUM(flujo_acreedor) AS flujo_acreedor,
    ruc,
    nombre_tepro,
    codigo_clasificador_prcla,
    cta_mayor_gasto_i,
    SUM(flujo_deudor2) AS flujo_deudor2,
    SUM(flujo_acreedor2) AS flujo_acreedor2,
    MAX(nro_transaccion) AS nro_transaccion,
    MAX(nro_transaccion) AS nro_referenci,
    '2025-11-01' AS fecha_apro,
    '2025-11-30' AS fecha_venc
FROM (
    -- 1. REGISTRO DEL DEVENGADO (Relación 113.13 vs 623.xx + Presupuesto)
    -- Tal como el reporte 253 (TCP 12701)
    SELECT 
        b.periodo, b.rucEntidad,
        '113.13.00' AS cta_mayor_pagar_cobrar,
        dmov.debe_codem AS flujo_deudor,
        0 AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        pre.codigo_clasificador_prcla,
        cat_contra.cue_codigo_cocac AS cta_mayor_gasto_i,
        0 AS flujo_deudor2,
        COALESCE(pre.valor_presupuesto, dmov.debe_codem) AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    -- Buscamos la contraparte 623 en el mismo asiento
    LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov 
         AND dmov_c.ide_codem != dmov.ide_codem
    LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov.ide_codem
    WHERE cat.cue_codigo_cocac LIKE '113.13%' 
      AND dmov.debe_codem > 0 
      AND (cat_contra.cue_codigo_cocac LIKE '623%' OR cat_contra.cue_codigo_cocac IS NULL)

    UNION ALL

    -- 2. REGISTRO DEL COBRO (Relación 113.13 vs 111.06)
    -- Tal como el reporte 252 (TCP 12812)
    SELECT 
        b.periodo, b.rucEntidad,
        '113.13.00' AS cta_mayor_pagar_cobrar,
        0 AS flujo_deudor,
        dmov.haber_codem AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        '' AS codigo_clasificador_prcla, -- En el cobro usualmente no se repite la partida
        cat_contra.cue_codigo_cocac AS cta_mayor_gasto_i,
        dmov.haber_codem AS flujo_deudor2, -- El dinero que entra al banco
        0 AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    -- Buscamos la contraparte 111 (Bancos) en el mismo asiento
    LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov 
         AND dmov_c.ide_codem != dmov.ide_codem
    LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
    WHERE cat.cue_codigo_cocac LIKE '113.13%' 
      AND dmov.haber_codem > 0 
      AND cat_contra.cue_codigo_cocac LIKE '111.06%'
			
			
) final /*END Main***/
GROUP BY periodo, rucEntidad, cta_mayor_pagar_cobrar, ruc, nombre_tepro, 
         codigo_clasificador_prcla, cta_mayor_gasto_i, fecha_apro, fecha_venc
ORDER BY nro_transaccion, cta_mayor_gasto_i;