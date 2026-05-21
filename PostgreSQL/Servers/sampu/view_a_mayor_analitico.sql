CREATE VIEW tbl_cont_detalle_movimiento_uniones_proveedor_cliente_presupuesto_b
AS
SELECT 
            COALESCE(pro_det_mov.nombre_tepro, x.nombre_tepro, m.razon_social_recli) AS PROVEEDOR,
            COALESCE(pro_det_mov.ruc_tepro, x.ruc_tepro, m.ruc_comercial_recli) AS RUC,
            a.ide_comov,
            a.ide_codem,
            debe_codem,
            haber_codem,
            cue_codigo_cocac,
            cue_descripcion_cocac,
            b.ide_cocac,
            fecha_ejecucion_prmen,
            devengado_prmen,
            cobrado_prmen,
            pagado_prmen,
						x.ide_tepro
        FROM cont_detalle_movimiento a
        LEFT JOIN cont_catalogo_cuenta b ON b.ide_cocac = a.ide_cocac
        LEFT JOIN tes_proveedor pro_det_mov ON pro_det_mov.ide_tepro = a.ide_tepro
        LEFT JOIN cont_movimiento y ON a.ide_comov = y.ide_comov
        LEFT JOIN tes_comprobante_pago z ON y.ide_tecpo = z.ide_tecpo
        LEFT JOIN tes_proveedor x ON z.ide_tepro = x.ide_tepro
        LEFT JOIN cont_factura_asiento n ON y.ide_comov = n.ide_comov
        LEFT JOIN fac_factura l ON n.ide_fafac = l.ide_fafac
        LEFT JOIN rec_clientes m ON l.ide_recli=m.ide_recli
        LEFT JOIN (
            -- Subconsulta de ejecución presupuestaria
            SELECT 
                ide_codem,
                fecha_ejecucion_prmen,
                SUM(COALESCE(devengado_prmen, 0)) AS devengado_prmen,
                SUM(COALESCE(cobrado_prmen, 0)) AS cobrado_prmen,
                SUM(COALESCE(pagado_prmen, 0)) AS pagado_prmen
            FROM pre_mensual m
            LEFT JOIN pre_anual a ON a.ide_pranu = m.ide_pranu
            WHERE ide_codem IS NOT NULL
            GROUP BY ide_codem, fecha_ejecucion_prmen
        ) ejc ON ejc.ide_codem = a.ide_codem
				
				
				
				
/*****************************************************/


SELECT * FROM tbl_cont_detalle_movimiento_uniones_proveedor_cliente_presupuesto_b;