SELECT 
    det.ide_inegd AS secuencial,--//1
		cab.numero_documento_ingeg AS codigo_egreso, --//2
		cab.fecha_ingeg AS fecha_egreso,--//3
		cab.hora_ingre AS hora_egreso,--//4
		coalesce (cc.code, '  ') || '  ' || COALESCE( cc.name, '  ') || '  ' || COALESCE (cc.plate, ' ' ) || '  ' || COALESCE(cc.chassis_code, ' ') AS centro_costo, --//5
		cab.ide_solicitud AS codigo_solicitud,--//6		
		boubi.detalle_boubi AS nombre_bodega,--//7
		cat_mat.ide_parte AS idparte,--//8
	  cat_mat.descripcion_bocam AS nombre_item,--//9
		(SELECT bodt_unidad_medida1.detalle_bounm FROM bodt_unidad_medida bodt_unidad_medida1 WHERE bodt_unidad_medida1.ide_bounm = det.ide_bounm ) as unidad_de_medida,--//10a
		det.cantidad_inegd AS cantidad_entregada,--//10b
    det.costo_unitario_inegd AS valor_unitario,--//11
    det.total_inegd AS total,--//12
    (SELECT gth_empleado3.apellido_paterno_gtemp || ' ' ||gth_empleado3.apellido_materno_gtemp || ' ' ||gth_empleado3.primer_nombre_gtemp || ' ' || gth_empleado3.segundo_nombre_gtemp 
FROM  gth_empleado gth_empleado3 
WHERE gth_empleado3.ide_gtemp = ord.ide_gtemp) AS solicitante,--//13 --de solicitudes //empleado Solicitante		
		 ( SELECT  sis_usuario1.nick_usua  FROM  sis_usuario sis_usuario1 WHERE sis_usuario1.ide_gtemp = cab.ide_gtemp) AS bodeguero_despacho,--//14		
		CASE 
      WHEN cab.id_maint_work_order IS NULL THEN 'SIN ORDEN DE TRABAJO'
      ELSE 'CON ORDEN DE TRABAJO'
    END AS estado,--//15
		sol.fecha_solicitud || ' ' || sol.hora_ingre AS fecha_solicitud,--//16
		cat_mat.cat_codigo_bocam AS partida_presupuestaria,--//17
   COALESCE (cab.id_maint_work_order,0) AS codigo_orden_trabajo,--//18
	 COALESCE	(cab.observacion_ingeg, ' SIN MOTIVO' ) AS motivo_egreso,--//19		
		 (SELECT gth_empleado1.apellido_paterno_gtemp || ' ' ||gth_empleado1.apellido_materno_gtemp || ' ' ||gth_empleado1.primer_nombre_gtemp || ' ' || gth_empleado1.segundo_nombre_gtemp FROM  gth_empleado gth_empleado1 WHERE gth_empleado1.ide_gtemp = sol.id_gtemp_persona_retira  )   AS persona_quien_retira,
		COALESCE (emp_tecnico.apellido_paterno_gtemp || ' ' ||  emp_tecnico.apellido_materno_gtemp  || ' ' || emp_tecnico.primer_nombre_gtemp  || ' ' || emp_tecnico.segundo_nombre_gtemp, 'SIN RECEPCION TECNICA' ) AS recepcion_tecnica,--//21		 
		 (SELECT gth_empleado2.apellido_paterno_gtemp || ' ' ||gth_empleado2.apellido_materno_gtemp || ' ' ||gth_empleado2.primer_nombre_gtemp || ' ' || gth_empleado2.segundo_nombre_gtemp 
FROM  gth_empleado gth_empleado2 
WHERE gth_empleado2.ide_gtemp =  sol.ide_gtemp_aprobador ) as  persona_que_autoriza , --persona que autoriza // sale de  aprobacion_solicitud  --//22
		COALESCE( ord.description, 'SIN OBSERVACIONES' ) as  obs_orden_de_trabajo,--23
		COALESCE( sol.observacion, 'SIN OBSERVACIONES' ) as obs_solicitud--//24
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
		
		
		--Aifnar centro de costo sale vacio 
		--unir centros de costos
		