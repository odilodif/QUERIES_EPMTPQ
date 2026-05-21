/*
DROP FUNCTION generate_report_movimientos_txt_reciprocas_ambiente_contable_y_ambiente_presupuestario(p_fechaini DATE, p_fechafin DATE,p_catalogo_cuenta VARCHAR)

*/
CREATE OR REPLACE FUNCTION generate_report_movimientos_txt_reciprocas_ambiente_contable_y_ambiente_presupuestario(  p_fechaini DATE, p_fechafin DATE,  p_catalogo_cuenta VARCHAR DEFAULT NULL)
RETURNS TABLE (
    periodo INT, -- Esperado INT
    rucentidad VARCHAR,
    cta_mayor_pagar_cobrar VARCHAR,
    flujo_deudor NUMERIC,
    flujo_acreedor NUMERIC,
    ruc VARCHAR,
    nombre_tepro VARCHAR,
    codigo_clasificador_prcla VARCHAR,
    cta_mayor_gasto_i VARCHAR,
    flujo_deudor2 NUMERIC,
    flujo_acreedor2 NUMERIC,
    nro_transaccion BIGINT,
    nro_referenci BIGINT,
    fecha_apro CHARACTER(25),
    fecha_venc CHARACTER(25)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.periodo::INT,
        a.rucentidad,
        a.cta_mayor_pagar_cobrar::VARCHAR,
        SUM(a.flujo_deudor) AS flujo_deudor,
        SUM(a.flujo_acreedor) AS flujo_acreedor,
        a.ruc,
        a.nombre_tepro::VARCHAR,
        a.codigo_clasificador_prcla,
        a.cta_mayor_gasto_i::VARCHAR,
        SUM(a.flujo_deudor2) AS flujo_deudor2,
        SUM(a.flujo_acreedor2) AS flujo_acreedor2,
        MAX(a.nro_transaccion) AS nro_transaccion,
        MAX(a.nro_referenci) AS nro_referenci,
        a.fecha_apro,
        a.fecha_venc
    FROM (
        SELECT
            mov.ide_comov,
            -- FIX: Se realiza un CAST explícito a INTEGER
            CAST(EXTRACT(MONTH FROM mov.mov_fecha_comov) AS INTEGER) AS periodo, 
            (SELECT identificacion_empr FROM sis_empresa) AS rucentidad,
            COALESCE(
                (
                    SELECT split_part(dmovi.cue_codigo_cocac, '.', 1) || '.' || split_part(dmovi.cue_codigo_cocac, '.', 2) || '.00' ), p_catalogo_cuenta||'.00'
            ) AS cta_mayor_pagar_cobrar,
            dmovi.haber_codem AS flujo_deudor,
            dmovi.debe_codem AS flujo_acreedor,
            COALESCE(
                (CASE WHEN cp.ide_geedp IS NULL THEN prov.ruc_tepro ELSE emp.ruc_emp END),
                '9999999999999'
            ) AS ruc,
            COALESCE(
                (CASE WHEN cp.ide_geedp IS NULL THEN prov.nombre_tepro ELSE emp.nombres END),
                'VARIOS CLIENTES'
            ) AS nombre_tepro,
            dmovii.codigo_clasificador_prcla,
            COALESCE(dmovi1.cue_codigo_cocac, COALESCE(dmovii.cue_codigo_cocac, '111.06.00')) AS cta_mayor_gasto_i,
            COALESCE(dmovii.devengado_prmen, 0) AS flujo_deudor2,
            COALESCE(dmovi.haber_codem, 0) AS flujo_acreedor2,
            COALESCE(CAST(comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_transaccion,
            COALESCE(CAST(comprobante_egreso_tecpo AS BIGINT), mov.ide_comov) AS nro_referenci,
            CAST(p_fechaini AS CHARACTER(25)) AS fecha_apro,
            CAST(p_fechafin AS CHARACTER(25)) AS fecha_venc
        FROM cont_movimiento mov

        LEFT JOIN tes_comprobante_pago cp ON cp.ide_tecpo = mov.ide_tecpo
        LEFT JOIN v_proveedores_subquery prov ON prov.ide_tepro = cp.ide_tepro
        LEFT JOIN v_empleados_subquery emp ON emp.ide_geedp = cp.ide_geedp
        
        JOIN (
            SELECT
                dmov.ide_comov,
                ide_gelua,
                cue_codigo_cocac,
                dmov.debe_codem,
                dmov.haber_codem
            FROM cont_detalle_movimiento dmov
            JOIN cont_catalogo_cuenta cat ON cat.ide_cocac = dmov.ide_cocac
                AND (cue_codigo_cocac LIKE p_catalogo_cuenta||'%')
            WHERE sigef_cocac = TRUE AND nivel_cocac > 4
        ) dmovi ON dmovi.ide_comov = mov.ide_comov

        LEFT JOIN v_gastos_ambiente_presupuestario dmovii ON dmovii.ide_comov = mov.ide_comov
            AND dmovii.ide_gelua = dmovi.ide_gelua
            AND dmovii.debe_codem = dmovi.debe_codem

        LEFT JOIN v_detalle_movimiento_auxiliar_111_06 dmovi1 ON dmovi1.ide_comov = mov.ide_comov
            AND dmovi1.ide_gelua = dmovi.ide_gelua

        WHERE mov.mov_fecha_comov BETWEEN p_fechaini AND p_fechafin
    ) a
    GROUP BY
        a.periodo,
        a.rucentidad,
        a.cta_mayor_pagar_cobrar,
        a.ruc,
        a.nombre_tepro,
        a.codigo_clasificador_prcla,
        a.cta_mayor_gasto_i,
        a.fecha_apro,
        a.fecha_venc;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM generate_report_movimientos_txt_reciprocas_ambiente_contable_y_ambiente_presupuestario('2025-01-01', '2025-01-31', '213.53');