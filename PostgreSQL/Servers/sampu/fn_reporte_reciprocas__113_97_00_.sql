-- DROP FUNCTION  "public"."fn_reporte_reciprocas__113_97_00__625_22_01__625_24_99" (date, date, varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION  "public"."fn_reporte_reciprocas__113_97_00_"( p_fechaini DATE,  p_fechafin DATE, p_cta_mayor_pagar_cobrar VARCHAR, p_codigo_clasificador_prcla VARCHAR, p_cta_mayor_gasto_i VARCHAR, p_tercer_digito VARCHAR )
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
				'9999999999999' AS ruc,       
				'VARIOS CLIENTES' AS nombre_tepro,
        COALESCE(CAST(cp.comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_transaccion
    FROM cont_movimiento mov
    CROSS JOIN (SELECT identificacion_empr FROM sis_empresa LIMIT 1) emp_sis
    LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
    LEFT JOIN (
        SELECT ide_tepro, COALESCE(ruc_representante_tepro, ruc_tepro) AS ruc_Stepro, 
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
    WHERE mov.mov_fecha_comov BETWEEN p_fechaini AND p_fechafin   
),
presupuesto_data AS (
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
    SUM(flujo_deudor)::NUMERIC AS flujo_deudor,
    SUM(flujo_acreedor)::NUMERIC AS flujo_acreedor,
    ruc::VARCHAR,
    nombre_tepro::VARCHAR,
    codigo_clasificador_prcla::VARCHAR,
    cta_mayor_gasto_i::VARCHAR,
    SUM(flujo_deudor2)::NUMERIC AS flujo_deudor2,
    SUM(flujo_acreedor2)::NUMERIC AS flujo_acreedor2,
    MAX(nro_transaccion) AS nro_transaccion,
    MAX(nro_transaccion) AS nro_referenci,
    CAST(p_fechaini AS CHARACTER(25)) AS fecha_apro,
   CAST(p_fechafin AS CHARACTER(25)) AS fecha_venc
FROM (
    -- [ESCENARIO 1]: DEVENGADO
   SELECT 
        b.periodo, 
				b.rucEntidad,
        p_cta_mayor_pagar_cobrar::VARCHAR AS cta_mayor_pagar_cobrar,
        dmov.debe_codem AS flujo_deudor,
        0 AS flujo_acreedor,
        b.ruc, b.nombre_tepro,
        COALESCE(pre.codigo_clasificador_prcla, p_codigo_clasificador_prcla) AS codigo_clasificador_prcla, 
        COALESCE(SUBSTRING(c.cue_codigo_cocac FROM 1 FOR 9)  , '124.97.07')::VARCHAR AS cta_mayor_gasto_i,
        0 AS flujo_deudor2,
        COALESCE(pre.devengado_prmen, dmov.debe_codem) AS flujo_acreedor2,
        b.nro_transaccion
    FROM base_movimiento b
    JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
    JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
    -- OPTIMIZACIÓN: Buscamos SOLO UNA contraparte por cada línea de dmov
    LEFT JOIN LATERAL (
        SELECT dm_c.ide_codem, cc_c.cue_codigo_cocac
        FROM cont_detalle_movimiento dm_c
        JOIN cont_catalogo_cuenta cc_c ON cc_c.ide_cocac = dm_c.ide_cocac
        WHERE dm_c.ide_comov = dmov.ide_comov 
          AND dm_c.ide_codem != dmov.ide_codem
          AND (cc_c.cue_codigo_cocac LIKE '124.97%'  )
        ORDER BY dm_c.haber_codem DESC -- Elegimos la contraparte con mayor valor
        LIMIT 1
    ) c ON TRUE
    LEFT JOIN presupuesto_data pre ON pre.ide_codem = c.ide_codem
    WHERE cat.cue_codigo_cocac LIKE  SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
      AND dmov.debe_codem <> 0 

    UNION ALL

    -- [ESCENARIO 2]: COBRO
    SELECT 
        b.periodo, b.rucEntidad,
        p_cta_mayor_pagar_cobrar::VARCHAR,
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
    WHERE cat.cue_codigo_cocac LIKE SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
      AND dmov.haber_codem <> 0 
) final
GROUP BY periodo, rucEntidad, cta_mayor_pagar_cobrar, ruc, nombre_tepro, 
         codigo_clasificador_prcla, cta_mayor_gasto_i, fecha_apro, fecha_venc;
				 
END;
$$ LANGUAGE plpgsql;	


SELECT * FROM fn_reporte_reciprocas__113_97_00__625_22_01__625_24_99('2025-11-01', '2025-11-30', '113.17.00','17.04.04','00.00.00','00.00');


			 
