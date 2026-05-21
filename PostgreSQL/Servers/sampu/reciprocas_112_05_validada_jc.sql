WITH base_movimiento AS (
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
    WHERE mov.mov_fecha_comov BETWEEN '2025-12-01' AND '2025-12-30'  
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
    -- [ESCENARIO 1]: DEVENGADO
    SELECT 
        b.periodo, 
				b.rucEntidad,
        '112.05.00' AS cta_mayor_pagar_cobrar,
        dmov.debe_codem AS flujo_deudor,
        0 AS flujo_acreedor,
        b.ruc, 
				b.nombre_tepro,
         ' ' AS codigo_clasificador_prcla,
        '111.06.00 ' AS cta_mayor_gasto_i,
        0 AS flujo_deudor2,
        COALESCE( dmov.debe_codem, 0) AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac   
    WHERE cat.cue_codigo_cocac LIKE '112.05%' 
    AND dmov.debe_codem <> 0 

    UNION ALL

    -- [ESCENARIO 2]: COBRO
    SELECT 
        b.periodo, b.rucEntidad,
        '112.05.00' AS cta_mayor_pagar_cobrar,
        0 AS flujo_deudor,
        dmov.haber_codem AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        ' ' AS codigo_clasificador_prcla,
        COALESCE( SUBSTRING( c.cue_codigo_cocac FROM 1 FOR 6 ) || '.00', '111.06.00') AS cta_mayor_gasto_i,
        COALESCE(pre.cobrado_prmen, dmov.haber_codem) AS flujo_deudor2,
        0 AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    -- OPTIMIZACIÓN: Buscamos SOLO UNA contraparte (Bancos)
    LEFT JOIN LATERAL (
        SELECT cc_c.cue_codigo_cocac
        FROM cont_detalle_movimiento dm_c
        JOIN cont_catalogo_cuenta cc_c ON cc_c.ide_cocac = dm_c.ide_cocac
        WHERE dm_c.ide_comov = dmov.ide_comov 
          AND dm_c.ide_codem != dmov.ide_codem
          AND (cc_c.cue_codigo_cocac LIKE '111.06%')
        LIMIT 1
    ) c ON TRUE
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov.ide_codem
    WHERE cat.cue_codigo_cocac LIKE '112.05%' 
      AND dmov.haber_codem <> 0 
			
			
) final
GROUP BY periodo, rucEntidad, cta_mayor_pagar_cobrar, ruc, nombre_tepro, 
         codigo_clasificador_prcla, cta_mayor_gasto_i, fecha_apro, fecha_venc
--ORDER BY periodo ASC, nro_transaccion ASC;