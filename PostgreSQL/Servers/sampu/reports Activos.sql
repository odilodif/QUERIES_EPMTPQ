/***********************entrega************************/
SELECT
	DISTINCT emp.ide_gtemp,
	doc.ide_geani,
	emp.apellido_paterno_gtemp,
	(case when emp.apellido_materno_gtemp is null then '' else emp.apellido_materno_gtemp end) as apellido_materno_gtemp,
	emp.primer_nombre_gtemp,
	(case when emp.segundo_nombre_gtemp is null then '' else emp.segundo_nombre_gtemp end) as segundo_nombre_gtemp,
	emp.documento_identidad_gtemp,
	(select count(*) as numCust from afi_doc_detalle_custodio where activo_afdda = TRUE AND recibe_afddc = FALSE AND ide_afdoc = 785),
	cargo.detalle_gecaf,
	cargo.detalle_geare
FROM
afi_docu doc 
LEFT JOIN afi_doc_detalle_custodio cusdoc ON doc.ide_afdoc = cusdoc.ide_afdoc
	     LEFT JOIN gth_empleado emp ON emp.ide_gtemp = cusdoc.ide_gtemp
	     LEFT JOIN (select  ide_gtemp,
				detalle_gecaf,
				detalle_geare
			from 	gen_empleados_departamento_par a
				left join gen_area b on a.ide_geare = b.ide_geare
				left join gen_cargo_funcional c on a.ide_gecaf = c.ide_gecaf
			where coalesce(a.activo_geedp,false) in (true,false) and ide_geedp in (select max(ide_geedp) as ide_geedp from gen_empleados_departamento_par group by ide_gtemp )) cargo
			ON cargo.ide_gtemp = emp.ide_gtemp

WHERE
cusdoc.recibe_afddc = FALSE AND
doc.ide_afdoc = 785
ORDER BY ide_gtemp DESC;

/*******************Recibe*************************/

SELECT
	DISTINCT emp.ide_gtemp,
	doc.ide_geani,
	emp.apellido_paterno_gtemp,
	(case when emp.apellido_materno_gtemp is null then '' else emp.apellido_materno_gtemp end) as apellido_materno_gtemp,
	emp.primer_nombre_gtemp,
	(case when emp.segundo_nombre_gtemp is null then '' else emp.segundo_nombre_gtemp end) as segundo_nombre_gtemp,
	emp.documento_identidad_gtemp,
	(select count(*) as numCust from afi_doc_detalle_custodio where activo_afdda = TRUE AND recibe_afddc = TRUE AND ide_afdoc =  785),
	cargo.detalle_gecaf,
	cargo.detalle_geare
FROM
afi_docu doc 
LEFT JOIN afi_doc_detalle_custodio cusdoc ON doc.ide_afdoc = cusdoc.ide_afdoc
	     LEFT JOIN gth_empleado emp ON emp.ide_gtemp = cusdoc.ide_gtemp
	     LEFT JOIN (select  ide_gtemp,
				detalle_gecaf,
				detalle_geare
			from 	gen_empleados_departamento_par a
				left join gen_area b on a.ide_geare = b.ide_geare
				left join gen_cargo_funcional c on a.ide_gecaf = c.ide_gecaf
			where coalesce(a.activo_geedp,false) in (true,false) and ide_geedp in (select max(ide_geedp) as ide_geedp from gen_empleados_departamento_par group by ide_gtemp )) cargo
			ON cargo.ide_gtemp = emp.ide_gtemp

WHERE
cusdoc.recibe_afddc = TRUE AND
doc.ide_afdoc =  785
ORDER BY ide_gtemp DESC;
