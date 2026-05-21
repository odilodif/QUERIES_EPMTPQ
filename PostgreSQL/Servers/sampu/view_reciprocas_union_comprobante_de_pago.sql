SELECT 
    periodo,
    rucEntidad,
    cta_mayor_pagar_cobrar,
    SUM(flujo_deudor)   AS flujo_deudor,
    SUM(flujo_acreedor) AS flujo_acreedor,
    ruc,
    nombre_tepro,
    codigo_clasificador_prcla,
    cta_mayor_gasto_i,
    SUM(flujo_deudor2)   AS flujo_deudor2,
    SUM(flujo_acreedor2) AS flujo_acreedor2,
    MAX(nro_transaccion) AS nro_transaccion,
    MAX(nro_referenci)   AS nro_referenci,
    fecha_apro,
    fecha_venc 
FROM (
    
    SELECT mov.ide_comov,
        EXTRACT(MONTH FROM mov.mov_fecha_comov) AS periodo,
        (SELECT identificacion_empr FROM sis_empresa) AS rucEntidad,
        COALESCE(
            ( SELECT split_part(dmovi.cue_codigo_cocac, '.', 1) || '.' || split_part(dmovi.cue_codigo_cocac, '.', 2) || '.00'  ), '213.53.00'
        ) AS cta_mayor_pagar_cobrar,
        dmovi.haber_codem AS flujo_deudor,
        dmovi.debe_codem AS flujo_acreedor,
        COALESCE(
            (CASE WHEN cp.ide_geedp IS NULL THEN prov.ruc_tepro ELSE emp.ruc_emp END),
            '9999999999999'
        ) AS ruc,
        COALESCE(
            (CASE WHEN cp.ide_geedp IS NULL THEN prov.nombre_tepro ELSE emp.NOMBRES END),
            'VARIOS CLIENTES'
        ) AS nombre_tepro,
        dmovii.codigo_clasificador_prcla,
        COALESCE(dmovi1.cue_codigo_cocac, COALESCE(dmovii.cue_codigo_cocac, '111.06.00')) AS cta_mayor_gasto_i,
        COALESCE(dmovii.devengado_prmen, 0) AS flujo_deudor2,
        COALESCE(dmovi.haber_codem, 0) AS flujo_acreedor2,
        COALESCE(CAST(comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_transaccion,
        COALESCE(CAST(comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_referenci,
        CAST('2025-01-01' AS CHARACTER(25)) AS fecha_apro,
        CAST('2025-01-31' AS CHARACTER(25)) AS fecha_venc  
    FROM cont_movimiento mov 
    
    -- JOIN 1: Comprobantes de pago
    LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo 
    
    -- JOIN 2: Proveedores (Subquery)
    LEFT JOIN v_proveedores_subquery prov ON prov.ide_tepro = cp.ide_tepro  
    
    -- JOIN 3: Empleados (Subquery)
    LEFT JOIN v_empleados_subquery emp ON emp.ide_geedp = cp.ide_geedp   
    
    -- JOIN 4: Detalle Movimiento I (Cuentas 213.53%)
     JOIN (
						SELECT 
								dmov.ide_comov,
								ide_gelua, 
								cue_codigo_cocac, 
								dmov.debe_codem, 
								dmov.haber_codem    
						FROM cont_detalle_movimiento dmov    
						JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac AND (cue_codigo_cocac LIKE '213.53%')    
						WHERE sigef_cocac = TRUE AND nivel_cocac > 4
				
    ) dmovi ON dmovi.ide_comov = mov.ide_comov 
    
    -- JOIN 5: Detalle Movimiento II (Cuentas de Gasto y Presupuesto)
   LEFT JOIN  v_gastos_ambiente_presupuestario  dmovii on dmovii.ide_comov=mov.ide_comov and dmovii.ide_gelua=dmovi.ide_gelua and dmovii.debe_codem=dmovi.debe_codem   
    
    -- JOIN 6: Detalle Movimiento Auxiliar (111.06%)
    LEFT JOIN  v_detalle_movimiento_auxiliar_111_06 dmovi1 ON dmovi1.ide_comov = mov.ide_comov AND dmovi1.ide_gelua = dmovi.ide_gelua  
    WHERE mov.mov_fecha_comov BETWEEN '2025-01-01' AND '2025-01-31'
		
		
) a 
GROUP BY 
    periodo,
    rucEntidad,
    cta_mayor_pagar_cobrar,
    ruc,
    nombre_tepro,
    codigo_clasificador_prcla,
    cta_mayor_gasto_i,
    fecha_apro,
    fecha_venc;