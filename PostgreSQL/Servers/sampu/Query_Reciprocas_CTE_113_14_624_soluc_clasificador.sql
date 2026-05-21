WITH base_movimiento AS (
    -- CTE: Buffer de Cabecera, Entidades y RUCs reales
		--DROP VIEW base_movimiento
		--CREATE VIEW base_movimiento AS
    SELECT 
        mov.ide_comov,
        mov.mov_fecha_comov,
        EXTRACT(MONTH FROM mov.mov_fecha_comov) AS periodo,
        emp_sis.identificacion_empr AS rucEntidad,
        COALESCE(prov.ruc_tepro, emp.ruc_emp, '9999999999999') AS ruc,
				--'9999999999999' AS ruc,
        COALESCE(prov.nombre_tepro, emp.nombres, 'VARIOS CLIENTES') AS nombre_tepro,
				--'VARIOS CLIENTES' AS nombre_tepro,
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
    -- CTE: Extracción de Vectores Presupuestarios (Devengado/Cobrado)
		--CREATE VIEW presupuesto_data AS
    SELECT 
        pmes.ide_codem,
        pcl.codigo_clasificador_prcla,
        pmes.devengado_prmen,
        pmes.cobrado_prmen
    FROM pre_mensual pmes
    JOIN pre_anual panio ON panio.ide_pranu = pmes.ide_pranu
    JOIN pre_clasificador pcl ON pcl.ide_prcla = panio.ide_prcla
)

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


    -- [ESCENARIO 1]: DEVENGADO (REPORTE RECIPROCAS)
    -- Buscamos el ingreso en la contraparte (624.03.99)
    SELECT 
        b.periodo, b.rucEntidad,
        '113.13.00' AS cta_mayor_pagar_cobrar,
        dmov.debe_codem AS flujo_deudor,
        0 AS flujo_acreedor,
        b.ruc, 
				b.nombre_tepro,
        -- Clasificador sugerido para esta cuenta de ingresos
        COALESCE(pre.codigo_clasificador_prcla, '13.00.00') AS codigo_clasificador_prcla, 
        COALESCE(	SUBSTRING(cat_contra.cue_codigo_cocac FROM 1 FOR 9), '623.01.00')::VARCHAR AS cta_mayor_gasto_i,
        0 AS flujo_deudor2,
        COALESCE(pre.devengado_prmen, dmov.debe_codem) AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    -- Buscamos la contraparte del movimiento
    LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov AND dmov_c.ide_codem != dmov.ide_codem
    LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
    -- Join con presupuesto en la cuenta de ingreso (624)
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov_c.ide_codem
    WHERE cat.cue_codigo_cocac LIKE '113.13%' 
      AND dmov.debe_codem <> 0 
      AND (cat_contra.cue_codigo_cocac LIKE '623.01%' OR cat_contra.cue_codigo_cocac IS NULL)

    UNION ALL

    -- [ESCENARIO 2]: COBRO (LIQUIDACIÓN EN BANCOS)
    -- Buscamos la cancelación de la 113.14 contra Bancos (111.06)
    SELECT 		
        b.periodo, 
				b.rucEntidad,
        '113.13.00' AS cta_mayor_pagar_cobrar,
        0 AS flujo_deudor,
        dmov.haber_codem AS flujo_acreedor,
        b.ruc, 
				b.nombre_tepro,
        ' ' AS codigo_clasificador_prcla,
        COALESCE(cat_contra.cue_codigo_cocac, ' ') AS cta_mayor_gasto_i,
				--COALESCE((SELECT split_part(cat_contra.cue_codigo_cocac,'.',1)||'.'||split_part(cat_contra.cue_codigo_cocac,'.',2)||'.00'), '111.06.00')::VARCHAR AS cta_mayor_gasto_i,
				--'111.06.00' AS cta_mayor_gasto_i,
        COALESCE(pre.cobrado_prmen, dmov.haber_codem) AS flujo_deudor2,
        0 AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov AND dmov_c.ide_codem != dmov.ide_codem
    LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
    -- En el cobro, el presupuesto está atado a la línea de la 113 que se acredita
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov.ide_codem
    WHERE cat.cue_codigo_cocac LIKE '113.13%' 
      AND dmov.haber_codem <> 0 
    AND (cat_contra.cue_codigo_cocac LIKE '111.06%' 
				--OR cat_contra.cue_codigo_cocac LIKE '212.03%' 
				)
			
			
			
) final
GROUP BY periodo, rucEntidad, cta_mayor_pagar_cobrar, ruc, nombre_tepro, 
         codigo_clasificador_prcla, cta_mayor_gasto_i, fecha_apro, fecha_venc
ORDER BY periodo ASC, codigo_clasificador_prcla DESC;