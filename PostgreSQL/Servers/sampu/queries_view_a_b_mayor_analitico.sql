--DROP VIEW  view_subconsult_tbl_a -- subconsult_tbl_A_cont_movimiento_y_tablas_relacionadas    
CREATE OR REPLACE VIEW view_subconsult_tbl_a
AS

SELECT 
            ide_comov,
            mov_fecha_comov,
            detalle_comov,
            detalle_cotim AS tipo_movimiento,
            detalle_conac AS asiento_tipo,
            nro_comprobante_comov,
            detalle_gemes,
            CASE 
                WHEN activo_comov = false THEN 'NO MAYORIZADO' 
                ELSE 'MAYORIZADO' 
            END AS estado
        FROM cont_movimiento a
        LEFT JOIN gen_mes b ON b.ide_gemes = a.ide_gemes
        LEFT JOIN cont_tipo_movimiento tm ON tm.ide_cotim = a.ide_cotim
        LEFT JOIN cont_nombre_asiento_contable nac ON nac.ide_conac = a.ide_conac


/********************************** VIEW TBL B *****************************/

 -- DROP view view_subconsulta_tbl_b 
             
 CREATE OR REPLACE VIEW view_subconsulta_tbl_b
 
 AS
       SELECT DISTINCT
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
						a.ide_tetic							
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

	
	