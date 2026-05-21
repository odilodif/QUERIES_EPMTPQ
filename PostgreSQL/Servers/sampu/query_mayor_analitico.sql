 select distinct ide_comov,ide_codem,mov_fecha_comov,tipo_movimiento,RUC,PROVEEDOR,detalle_comov,asiento_tipo,nro_comprobante_comov, cue_codigo_cocac,cue_descripcion_cocac,debe_codem,haber_codem,  sum(debe_codem-haber_codem) OVER (PARTITION BY cue_codigo_cocac ORDER BY mov_fecha_comov) AS saldo   ,detalle_gemes,fecha_ejecucion_prmen,devengado_prmen,cobrado_prmen,pagado_prmen,estado  
 
 
 from ( 
					 select a.ide_comov,b.ide_codem,mov_fecha_comov,RUC,PROVEEDOR,tipo_movimiento,detalle_comov,asiento_tipo,nro_comprobante_comov, cue_codigo_cocac,cue_descripcion_cocac,debe_codem,haber_codem,detalle_gemes,fecha_ejecucion_prmen,devengado_prmen,cobrado_prmen,pagado_prmen,estado 
					 
					 from ( 	 
												select ide_comov,mov_fecha_comov,detalle_comov,detalle_cotim as tipo_movimiento,detalle_conac as asiento_tipo,				nro_comprobante_comov,detalle_gemes, 	 (case when activo_comov = false then 'NO MAYORIZADO' else 'MAYORIZADO' end) as estado 	 FROM 			cont_movimiento a   left join gen_mes b on b.ide_gemes = a.ide_gemes   left join cont_tipo_movimiento tm on tm.ide_cotim=a.ide_cotim   left join cont_nombre_asiento_contable nac on nac.ide_conac=a.ide_conac 


						) a 
						
					left join ( 
						select coalesce(pro_det_mov.nombre_tepro, x.nombre_tepro, m.razon_social_recli) as PROVEEDOR, coalesce(pro_det_mov.ruc_tepro, x.						ruc_tepro, m.ruc_comercial_recli) as RUC, a.ide_comov,a.ide_codem,debe_codem,haber_codem,cue_codigo_cocac,cue_descripcion_cocac,b.ide_cocac  	 ,fecha_ejecucion_prmen,devengado_prmen,cobrado_prmen,pagado_prmen 	 
						from cont_detalle_movimiento a 	 left join cont_catalogo_cuenta b on b.ide_cocac = a.ide_cocac   left join tes_proveedor pro_det_mov on pro_det_mov.ide_tepro = a.ide_tepro   left join cont_movimiento y on a.ide_comov=y.ide_comov      left join tes_comprobante_pago z on y.ide_tecpo=z.ide_tecpo     left join tes_proveedor x on z.ide_tepro=x.ide_tepro   left join cont_factura_asiento n on y.ide_comov=n.ide_comov   left join fac_factura l on n.ide_fafac=l.ide_fafac  left join rec_clientes m on l.ide_recli=m.ide_recli  	 left join (select ide_codem,fecha_ejecucion_prmen,sum(coalesce(devengado_prmen,0)) as devengado_prmen 	   ,sum(coalesce(cobrado_prmen,0)) as cobrado_prmen,sum(coalesce(pagado_prmen,0)) as pagado_prmen 	   from pre_mensual m  left join pre_anual a on a.ide_pranu=m.ide_pranu where ide_codem is not null  group by ide_codem,fecha_ejecucion_prmen) ejc on ejc.ide_codem=a.ide_codem 

					) b on a.ide_comov = b.ide_comov where mov_fecha_comov between '2025-01-01' and '2025-06-08' and ide_cocac IN (5456) order by cue_codigo_cocac,mov_fecha_comov,nro_comprobante_comov  


) mayor  
 
 order by mov_fecha_comov 
 
 
 /*****************************************************************************************************/
 /*   			Query Mayor analitico */
 /*****************************************************************************************************/
 
 SELECT DISTINCT 
    ide_comov,
    ide_codem,
    mov_fecha_comov,
    tipo_movimiento,
		ide_tepro,
    RUC,
    PROVEEDOR,
    detalle_comov,
    asiento_tipo,
    nro_comprobante_comov,
    cue_codigo_cocac,
    cue_descripcion_cocac,
    debe_codem,
    haber_codem,
		(debe_codem-haber_codem) as saldoxlinea,
    SUM(debe_codem - haber_codem) OVER (
        PARTITION BY cue_codigo_cocac 
        ORDER BY mov_fecha_comov
    ) AS saldo,
    detalle_gemes,
    fecha_ejecucion_prmen,
    devengado_prmen,
    cobrado_prmen,
    pagado_prmen,
    estado
		
FROM (
    SELECT 
        a.ide_comov,
        b.ide_codem,
        mov_fecha_comov,
        RUC,
        PROVEEDOR,
        tipo_movimiento,
        detalle_comov,
        asiento_tipo,
        nro_comprobante_comov,
        cue_codigo_cocac,
        cue_descripcion_cocac,
        debe_codem,
        haber_codem,
        detalle_gemes,
        fecha_ejecucion_prmen,
        devengado_prmen,
        cobrado_prmen,
        pagado_prmen,
        estado,
				ide_tepro
    FROM (
        -- Subconsulta A: cont_movimiento y tablas relacionadas
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
    ) a
    LEFT JOIN (
        -- Subconsulta B: cont_detalle_movimiento y uniones para proveedor, cliente, y presupuesto
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

    ) b ON a.ide_comov = b.ide_comov
    WHERE 
        mov_fecha_comov BETWEEN '2025-01-01' AND '2025-06-08'
      AND ide_cocac IN (5249,4663)
				--AND ide_tepro IN (2170)
    ORDER BY 
        cue_codigo_cocac,
        mov_fecha_comov,
        nro_comprobante_comov
) mayor  --WHERE ruc = '1768164650001'
ORDER BY 
    mov_fecha_comov;
