  SELECT       
				          det.ide_inegd AS secuencial,      
				      		cab.ide_solicitud AS codigo_solicitud,      
				      		cab.fecha_ingeg AS fecha_egreso,      
				      		cab.hora_ingre AS hora_egreso,      
				      		cc.code AS centro_gasto,       
				      		cc.name AS nombre_centro_costo,      
				      		cab.numero_documento_ingeg AS codigo_egreso,      
				      		boubi.detalle_boubi AS nombre_bodega,      
				      		cat_mat.ide_parte AS idparte,      
				      	  cat_mat.descripcion_bocam AS nombre_item,      
				      		det.cantidad_inegd AS cantidad_entregada,      
				          det.costo_unitario_inegd AS valor_unitario,      
				          det.total_inegd AS total,      
				          ord.ide_gtemp AS codigo_tecnico,      
				          emp_tecnico.apellido_paterno_gtemp || ' ' ||  emp_tecnico.apellido_materno_gtemp  || ' ' || emp_tecnico.	primer_nombre_gtemp  || ' ' || emp_tecnico.segundo_nombre_gtemp AS nombre_tecnico,      
				      		cab.ide_gtemp AS codigo_bodeguero,      
				      		      
				      		CASE       
				            WHEN cab.id_maint_work_order IS NULL THEN 'SIN ORDEN DE TRABAJO'      
				            ELSE 'CON ORDEN DE TRABAJO'      
				          END AS estado,      
				      		sol.fecha_solicitud || ' ' || sol.hora_ingre AS fecha_solicitud,      
				          cab.id_maint_work_order           || ' - ' || ord.number_order            AS codigo_orden_trabajo,      
				      		cab.observacion_ingeg AS motivo_egreso,      
				      		cat_mat.cat_codigo_bocam AS partida_presupuestaria      
				                
				          FROM       
				          bodt_ingreso_egreso_det det      
				          LEFT JOIN bodt_ingreso_egreso cab ON cab.ide_ingeg = det.ide_ingeg      
				          LEFT JOIN maint_cost_center cc ON cab.id_maint_cost_center = cc.id      
				          LEFT JOIN bodt_bodega_ubicacion boubi ON cab.ide_boubi = boubi.ide_boubi      
				          LEFT JOIN bodt_catalogo_material cat_mat ON det.ide_bocam = cat_mat.ide_bocam      
				          LEFT JOIN gth_empleado emp_recibido ON cab.ide_gtemp_suppliedby = emp_recibido.ide_gtemp      
				          LEFT JOIN gth_empleado emp_bodeguero ON cab.ide_gtemp = emp_bodeguero.ide_gtemp      		
				      		LEFT JOIN solicitud_items sol ON sol.ide_solicitud = cab.ide_solicitud      
				      		LEFT JOIN maint_work_order ord on ord.id = sol.id_maint_work_order      
				      		LEFT JOIN gth_empleado emp_tecnico ON ord.ide_gtemp = emp_tecnico.ide_gtemp      
				      		      
				      WHERE       
				          cab.ide_inttr = 2 ;