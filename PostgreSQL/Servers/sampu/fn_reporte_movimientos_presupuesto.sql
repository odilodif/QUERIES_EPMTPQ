/*-- DROP FUNCTION "public".fn_reporte_movimientos_presupuesto(date,date, VARCHAR,VARCHAR,VARCHAR,VARCHAR );
CREATE OR REPLACE FUNCTION fn_reporte_movimientos_presupuesto( p_fechaini DATE,  p_fechafin DATE, p_cta_mayor_pagar_cobrar VARCHAR, p_codigo_clasificador_prcla VARCHAR, p_cta_mayor_gasto_i VARCHAR, p_tercer_digito VARCHAR )
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
            EXTRACT(MONTH FROM mov.mov_fecha_comov)::INT AS periodo_num,
            emp_sis.identificacion_empr AS rucEntidad_val,
            '9999999999999'::VARCHAR AS ruc_val,           
						'VARIOS CLIENTES'::VARCHAR AS  nombre_tepro_val,
            COALESCE(CAST(cp.comprobante_egreso_tecpo AS BIGINT), mov.ide_comov::BIGINT) AS nro_transaccion_val
        FROM cont_movimiento mov
        CROSS JOIN (SELECT identificacion_empr FROM sis_empresa LIMIT 1) emp_sis
        LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
        LEFT JOIN (
            -- Aquí calificamos el origen para evitar ambigüedad interna
            SELECT tprov.ide_tepro, 
                   COALESCE(tprov.ruc_representante_tepro, tprov.ruc_tepro) AS ruc_tepro, 
                   SUBSTRING(tprov.nombre_tepro FROM 1 FOR 30) AS nombre_tepro_sub
            FROM tes_proveedor tprov
        ) prov ON prov.ide_tepro = cp.ide_tepro
        LEFT JOIN (
            SELECT par.ide_geedp, 
                   SUBSTRING(gem.APELLIDO_PATERNO_GTEMP || ' ' || COALESCE(gem.APELLIDO_MATERNO_GTEMP,'') || ' ' || gem.PRIMER_NOMBRE_GTEMP, 1, 30) AS nombres,
                   gem.DOCUMENTO_IDENTIDAD_GTEMP AS ruc_emp
            FROM GEN_EMPLEADOS_DEPARTAMENTO_PAR par
            JOIN GTH_EMPLEADO gem ON par.ide_gtemp = gem.ide_gtemp
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
        f.periodo,
        f.rucEntidad,
        f.cta_mayor_pagar_cobrar,
        SUM(f.flujo_deudor)::NUMERIC,
        SUM(f.flujo_acreedor)::NUMERIC,
        f.ruc,
        f.nombre_tepro,
        f.codigo_clasificador_prcla,
        f.cta_mayor_gasto_i,
        SUM(f.flujo_deudor2)::NUMERIC,
        SUM(f.flujo_acreedor2)::NUMERIC,
        MAX(f.nro_transaccion),
        MAX(f.nro_transaccion),
        CAST(p_fechaini AS CHARACTER(25)) AS fecha_apro,
        CAST(p_fechafin AS CHARACTER(25)) AS fecha_venc
    FROM (
        -- [ESCENARIO 1]: DEVENGADO
        SELECT 
            b.periodo_num AS periodo, 
            b.rucEntidad_val AS rucEntidad,
            p_cta_mayor_pagar_cobrar::VARCHAR AS cta_mayor_pagar_cobrar,
            dmov.debe_codem AS flujo_deudor,
            0::NUMERIC AS flujo_acreedor,
            b.ruc_val AS ruc, 
            b.nombre_tepro_val AS nombre_tepro,
            COALESCE(pre.codigo_clasificador_prcla,p_codigo_clasificador_prcla)::VARCHAR AS codigo_clasificador_prcla, 
            --COALESCE(cat_contra.cue_codigo_cocac, p_cta_mayor_gasto_i)::VARCHAR AS cta_mayor_gasto_i,
						--COALESCE((SELECT split_part(cat_contra.cue_codigo_cocac,'.',1)||'.'||split_part(cat_contra.cue_codigo_cocac,'.',2)||p_tercer_digito), p_cta_mayor_gasto_i)::VARCHAR AS cta_mayor_gasto_i,
						SUBSTRING(cat_contra.cue_codigo_cocac FROM 1 FOR 9)::VARCHAR AS cta_mayor_gasto_i,
            0::NUMERIC AS flujo_deudor2,
            COALESCE(pre.devengado_prmen, dmov.debe_codem) AS flujo_acreedor2,
            b.nro_transaccion_val AS nro_transaccion
        FROM base_movimiento b
        JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
        JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
        LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov AND dmov_c.ide_codem != dmov.ide_codem
        LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
        LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov_c.ide_codem
       WHERE cat.cue_codigo_cocac LIKE   SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
      AND dmov.debe_codem <> 0 
      AND (cat_contra.cue_codigo_cocac LIKE  SUBSTRING(p_cta_mayor_gasto_i FROM 1 FOR 6)||'%' OR cat_contra.cue_codigo_cocac IS NULL)

        UNION ALL

        -- [ESCENARIO 2]: COBRO
        SELECT 
            b.periodo_num, b.rucEntidad_val,
            p_cta_mayor_pagar_cobrar::VARCHAR,
            0::NUMERIC,
            dmov.haber_codem,
            b.ruc_val, 
						b.nombre_tepro_val,
            ' '::VARCHAR,            
            '111.06.00'::VARCHAR AS cta_mayor_gasto_i,
						COALESCE(pre.cobrado_prmen, dmov.haber_codem),
            0::NUMERIC,
            b.nro_transaccion_val
        FROM base_movimiento b
        JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
        JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
        LEFT JOIN cont_detalle_movimiento dmov_c ON dmov_c.ide_comov = b.ide_comov AND dmov_c.ide_codem != dmov.ide_codem
        LEFT JOIN cont_catalogo_cuenta cat_contra ON cat_contra.ide_cocac = dmov_c.ide_cocac
        LEFT JOIN presupuesto_data pre ON pre.ide_codem = dmov.ide_codem
       WHERE cat.cue_codigo_cocac LIKE SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
					AND dmov.haber_codem <> 0 
				AND (cat_contra.cue_codigo_cocac LIKE '111.06%' 
					OR cat_contra.cue_codigo_cocac LIKE '212.03%' 
					
					)
    ) f
    GROUP BY f.periodo, f.rucEntidad, f.cta_mayor_pagar_cobrar, f.ruc, f.nombre_tepro, 
             f.codigo_clasificador_prcla, f.cta_mayor_gasto_i
    ORDER BY f.periodo ASC, f.codigo_clasificador_prcla DESC;
END;
$$ LANGUAGE plpgsql;*/

CREATE OR REPLACE FUNCTION fn_reporte_movimientos_presupuesto(
    p_fechaini DATE,  
    p_fechafin DATE, 
    p_cta_mayor_pagar_cobrar VARCHAR, 
    p_codigo_clasificador_prcla VARCHAR, 
    p_cta_mayor_gasto_i VARCHAR, 
    p_tercer_digito VARCHAR 
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
            --COALESCE(prov.ruc_tepro, emp.ruc_emp, '9999999999999')::VARCHAR AS ruc,
						'9999999999999'::VARCHAR AS ruc,					 
            --COALESCE(prov.nombre_tepro, emp.nombres, 'VARIOS CLIENTES')::VARCHAR AS nombre_tepro,
						'VARIOS CLIENTES'::VARCHAR AS nombre_tepro,
            COALESCE(CAST(cp.comprobante_egreso_tecpo AS BIGINT), mov.ide_comov::BIGINT) AS nro_transaccion
        FROM cont_movimiento mov
        CROSS JOIN (SELECT identificacion_empr FROM sis_empresa LIMIT 1) emp_sis
        LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
        LEFT JOIN (
            SELECT ide_tepro, 
                   COALESCE(ruc_representante_tepro, ruc_tepro) AS ruc_tepro, 
                   SUBSTRING(nombre_tepro FROM 1 FOR 30) AS nombre_tepro 
            FROM tes_proveedor
        ) prov ON prov.ide_tepro = cp.ide_tepro
        LEFT JOIN (
            SELECT par.ide_geedp, 
                   SUBSTRING(gem.APELLIDO_PATERNO_GTEMP || ' ' || COALESCE(gem.APELLIDO_MATERNO_GTEMP,'') || ' ' || gem.PRIMER_NOMBRE_GTEMP, 1, 30) AS nombres,
                   gem.DOCUMENTO_IDENTIDAD_GTEMP AS ruc_emp
            FROM GEN_EMPLEADOS_DEPARTAMENTO_PAR par
            JOIN GTH_EMPLEADO gem ON par.ide_gtemp = gem.ide_gtemp
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
        f.periodo,
        f.rucEntidad,
        f.cta_mayor_pagar_cobrar,
        SUM(f.flujo_deudor)::NUMERIC,
        SUM(f.flujo_acreedor)::NUMERIC,
        f.ruc,
        f.nombre_tepro,
        f.codigo_clasificador_prcla,
        f.cta_mayor_gasto_i,
        SUM(f.flujo_deudor2)::NUMERIC,
        SUM(f.flujo_acreedor2)::NUMERIC,
        MAX(f.nro_transaccion),
        MAX(f.nro_transaccion),
        CAST(p_fechaini AS CHARACTER(25)),
        CAST(p_fechafin AS CHARACTER(25))
    FROM (
        -- [ESCENARIO 1]: DEVENGADO (Buscamos la cuenta de gasto/presupuesto)
        SELECT 
            b.periodo, 
            b.rucEntidad,
            p_cta_mayor_pagar_cobrar::VARCHAR AS cta_mayor_pagar_cobrar,
            dmov.debe_codem AS flujo_deudor,
            0::NUMERIC AS flujo_acreedor,
            b.ruc, 
            b.nombre_tepro,
            COALESCE(pre.codigo_clasificador_prcla, p_codigo_clasificador_prcla)::VARCHAR AS codigo_clasificador_prcla,
            SUBSTRING(contra.cue_codigo_cocac FROM 1 FOR 9)::VARCHAR AS cta_mayor_gasto_i,
            0::NUMERIC AS flujo_deudor2,
            COALESCE(pre.devengado_prmen, dmov.debe_codem) AS flujo_acreedor2,
            b.nro_transaccion
        FROM base_movimiento b
        JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
        JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
        -- OPTIMIZACIÓN ANTIDUPLICADOS: Buscamos solo UNA contraparte de gasto
        LEFT JOIN LATERAL (
            SELECT cc_c.cue_codigo_cocac, dm_c.ide_codem
            FROM cont_detalle_movimiento dm_c
            JOIN cont_catalogo_cuenta cc_c ON cc_c.ide_cocac = dm_c.ide_cocac
            WHERE dm_c.ide_comov = b.ide_comov 
              AND dm_c.ide_codem != dmov.ide_codem
              AND (cc_c.cue_codigo_cocac LIKE SUBSTRING(p_cta_mayor_gasto_i FROM 1 FOR 6)||'%' OR p_cta_mayor_gasto_i IS NULL)
            LIMIT 1
        ) contra ON TRUE
        LEFT JOIN presupuesto_data pre ON pre.ide_codem = contra.ide_codem
        WHERE cat.cue_codigo_cocac LIKE SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
          AND dmov.debe_codem <> 0 

        UNION ALL

        -- [ESCENARIO 2]: COBRO (Buscamos la cuenta de Banco/Caja)
        SELECT 
            b.periodo, 
            b.rucEntidad,
            p_cta_mayor_pagar_cobrar::VARCHAR,
            0::NUMERIC,
            dmov.haber_codem,
            b.ruc, 
            b.nombre_tepro,
            ' '::VARCHAR,            
             '111.06.00'::VARCHAR AS cta_mayor_gasto_i,
            COALESCE(pre_c.cobrado_prmen, dmov.haber_codem),
            0::NUMERIC,
            b.nro_transaccion
        FROM base_movimiento b
        JOIN cont_detalle_movimiento dmov ON dmov.ide_comov = b.ide_comov
        JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
        -- OPTIMIZACIÓN ANTIDUPLICADOS: Buscamos solo UNA contraparte de Tesorería (Bancos)
        LEFT JOIN LATERAL (
            SELECT cc_b.cue_codigo_cocac
            FROM cont_detalle_movimiento dm_b
            JOIN cont_catalogo_cuenta cc_b ON cc_b.ide_cocac = dm_b.ide_cocac
            WHERE dm_b.ide_comov = b.ide_comov 
              AND dm_b.ide_codem != dmov.ide_codem
              AND (cc_b.cue_codigo_cocac LIKE '111.06%' OR cc_b.cue_codigo_cocac LIKE '212.03%')
            LIMIT 1
        ) contra_b ON TRUE
        LEFT JOIN presupuesto_data pre_c ON pre_c.ide_codem = dmov.ide_codem
        WHERE cat.cue_codigo_cocac LIKE SUBSTRING(p_cta_mayor_pagar_cobrar FROM 1 FOR 6)||'%' 
          AND dmov.haber_codem <> 0 
    ) f
    GROUP BY 
        f.periodo, f.rucEntidad, f.cta_mayor_pagar_cobrar, f.ruc, f.nombre_tepro, 
        f.codigo_clasificador_prcla, f.cta_mayor_gasto_i
    ORDER BY f.periodo ASC, f.codigo_clasificador_prcla DESC;
END;
$$ LANGUAGE plpgsql;


/*******************************************/


SELECT * FROM fn_reporte_movimientos_presupuesto('2025-12-01', '2025-12-31', '113.14.00','14.03.99','624.03.99','.99' );




SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.13.00','13.01.03','623.01.03','.03');

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-12-01', '2025-12-31', '113.14.00','14.03.99','624.03.99','.99' );

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.17.00','17.00.00','625.04.00','.04');
SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.17.00','17.00.00','625.02.00','.04');

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.18.00','18.00.00','626.01.00','.04');



SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.19.00','19.00.00 ','625.24.00','.99');

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.19.00','19.00.00 ','625.22.00','.99');



SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.28.00','28.00.00','626.21.00','.00');

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.97.00','97.00.00','124.00.00','.00');

SELECT * FROM fn_reporte_movimientos_presupuesto('2025-11-01', '2025-11-30', '113.98.00','98.00.00','124.00.00','.00');



