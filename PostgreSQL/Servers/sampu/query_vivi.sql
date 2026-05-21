select ide_prpoa, tipo_cedula, periodo, detalle_geani, tipo_gestion, 
cod_prog, detalle_programa,
cod_pry, 
detalle_proyecto, cod_prod_mc, 
detalle_producto_mc,  codigo_obra, obra, cod_act, detalle_actividad_mc,
cod_prod, detalle_producto, detalle_actividad, codigo_subactividad, 
detalle_subactividad, area, codigo_fuente_prfuf,  fuente, tipo_gasto,
grupo_gasto, codigo_clasificador_prcla, descripcion_clasificador_prcla, 
presupuesto_inicial_prpoa,
reforma_prpoa, presupuesto_codificado_prpoa,   certificado, liquidado,
(presupuesto_codificado_prpoa - certificado) as saldo_certificar, 
comprometido, liberado, (certificado - comprometido) as saldo_comprometido,  
devengado,
(comprometido - devengado) as saldo_por_devengar, pagado, 
(devengado - pagado) as saldo_por_pagar,  
credito_iva, activo  
from( 
	select  a.ide_prpoa, 1 as tipo_cedula, cast(extract(month from DATE '2025-03-17') as int) as periodo, 
	cast(extract(year from DATE  '2025-03-17') as int) as detalle_geani,    
	detalle_prtge as tipo_gestion, 
	cod_prog, detalle_programa,cod_pry,detalle_proyecto, cod_prod_mc, detalle_producto_mc,codigo_obra,obra, 
	cod_act,detalle_actividad_mc, cod_prod,detalle_producto,detalle_actividad,codigo_subactividad,detalle_subactividad,
	detalle_geare as area,codigo_fuente_prfuf, detalle_prfuf as fuente ,   tipo_gasto,grupo_gasto,codigo_clasificador_prcla, 
	descripcion_clasificador_prcla,     
	coalesce(codificado,0.00) as presupuesto_inicial_prpoa,    
	coalesce(reforma, 0.00) as reforma_prpoa,    
	(coalesce(codificado,0.00) + coalesce(reforma,0.00)) as presupuesto_codificado_prpoa,   
	coalesce(certificado,0.00) as certificado,   
	coalesce(liquidado,0.00) as liquidado,   
	(coalesce(codificado,0.00) + coalesce(reforma,0.00))-coalesce(certificado,0.00) as saldo_certificar,
	coalesce(comprometido,0.00) as comprometido,   
	coalesce(liberado,0.00) as liberado,  
	(coalesce(certificado,0.00)-coalesce(comprometido,0.00)) as saldo_comprometido,    
	coalesce(devengado,0.00) as devengado,    
	(coalesce(comprometido,0.00)-coalesce(devengado,0.00)) as saldo_por_devengar,
	coalesce(pagado,0.00) as pagado,   
	(coalesce(devengado,0.00)-coalesce(pagado,0.00)) as saldo_por_pagar,   
	cast(coalesce(ivc.valor_iva,0.00) as numeric(8,2)) as credito_iva, a.activo_prpoa as activo   
	from pre_poa a     
	left join pre_tipo_gestion tg on tg.ide_prtge = a.ide_prtge   
	left join (SELECT pc.ide_prcla, pc.codigo_clasificador_prcla, pc.descripcion_clasificador_prcla,   			
			   pc2.codigo_clasificador_prcla || ' ' || pc2.descripcion_clasificador_prcla as grupo_gasto,   			
			   pc3.codigo_clasificador_prcla || ' ' || pc3.descripcion_clasificador_prcla as tipo_gasto   			
FROM public.pre_clasificador pc   			
left join pre_clasificador pc1 on pc1.ide_prcla=pc.pre_ide_prcla   			
left join pre_clasificador pc2 on pc2.ide_prcla=pc1.pre_ide_prcla   			
left join pre_clasificador pc3 on pc3.ide_prcla=pc2.pre_ide_prcla) pc on pc.ide_prcla = a.ide_prcla 
left join gen_area area on a.ide_geare=area.ide_geare     
left join ( select a.ide_prfup,codigo_subactividad,detalle_subactividad,codigo_actividad || ' '|| detalle_actividad as detalle_actividad, codigo_producto || ' '||detalle_producto as detalle_producto, cod_prod, producto,    cod_act,codigo_actividad_mc || ' '||detalle_actividad_mc as detalle_actividad_mc, actividad_mc , cod_prod_mc, codigo_producto_mc || ' '||detalle_producto_mc as detalle_producto_mc, producto_mc,codigo_obra,obra, codigo_proyecto || ' '|| detalle_proyecto as detalle_proyecto, cod_pry, proyecto, codigo_programa || ' '||detalle_programa as detalle_programa, programa, cod_prog  
				from (select a.ide_prfup,codigo_subactividad,detalle_subactividad,subactividad,codigo_actividad,detalle_actividad,actividad,codigo_producto,cod_prod,detalle_producto,producto,  codigo_actividad_mc,cod_act,detalle_actividad_mc,actividad_mc,codigo_producto_mc,cod_prod_mc,detalle_producto_mc,producto_mc,codigo_obra, detalle_obra_prfup as obra,  coalesce(pry1.codigo_proyecto,pry2.codigo_proyecto) as codigo_proyecto,  coalesce(pry1.cod_pry,pry2.cod_pry) as cod_pry,   coalesce(pry1.detalle_proyecto,pry2.detalle_proyecto) as detalle_proyecto,   coalesce(pry1.proyecto,pry2.proyecto) as proyecto,  coalesce(pry1.codigo_programa,pry2.codigo_programa) as codigo_programa,  coalesce(pry1.detalle_programa,pry2.detalle_programa) as detalle_programa,  coalesce(pry1.programa,pry2.programa) as programa, coalesce(pry1.cod_prog,pry2.cod_prog) as cod_prog 
					  from   (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_subactividad,  detalle_prfup as detalle_subactividad, detalle_prnfp as subactividad 
							  from pre_funcion_programa a, pre_nivel_funcion_programa b   where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =7) a   left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_actividad,  detalle_prfup as detalle_actividad, detalle_prnfp as actividad 
							  from pre_funcion_programa a, pre_nivel_funcion_programa b   where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =6) b on a.pre_ide_prfup = b.ide_prfup  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_producto,  detalle_prfup as detalle_producto, detalle_prnfp as producto, codigo_pry_prd_prfup as cod_prod 
							  from pre_funcion_programa a, pre_nivel_funcion_programa b   where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =5) c on b.pre_ide_prfup = c.ide_prfup  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_actividad_mc,codigo_pry_prd_prfup as cod_act,  detalle_prfup as detalle_actividad_mc,detalle_prnfp as actividad_mc,detalle_obra_prfup,case when length(codigo_obra_prfup) > 0 then codigo_obra_prfup else '' end as codigo_obra  
							  from pre_funcion_programa a, pre_nivel_funcion_programa b   where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =4) d on c.pre_ide_prfup = d.ide_prfup   left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_producto_mc,codigo_pry_prd_prfup as cod_prod_mc,  detalle_prfup as detalle_producto_mc,detalle_prnfp as producto_mc 
							  from pre_funcion_programa a, pre_nivel_funcion_programa b   where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =3 ) e on d.pre_ide_prfup = e.ide_prfup   left join (select pr.ide_prfup, pr.pre_ide_prfup, codigo_proyecto,     detalle_proyecto,proyecto, cod_pry,cod_prog,codigo_programa, detalle_programa,programa  	  
							  from (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_proyecto,  	    detalle_prfup as detalle_proyecto,detalle_prnfp as proyecto, codigo_pry_prd_prfup as cod_pry   	    
									from pre_funcion_programa a, pre_nivel_funcion_programa b   	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =2) pr  	  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_programa, codigo_pry_prd_prfup as cod_prog,  	    detalle_prfup as detalle_programa,detalle_prnfp as programa 
									from pre_funcion_programa a, pre_nivel_funcion_programa b   	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =1) g on pr.pre_ide_prfup = g.ide_prfup) pry1 on c.pre_ide_prfup = pry1.ide_prfup   left join (select pr.ide_prfup, pr.pre_ide_prfup, codigo_proyecto,     detalle_proyecto,proyecto, cod_pry,cod_prog,codigo_programa, detalle_programa,programa  	  
									from (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_proyecto,  	    detalle_prfup as detalle_proyecto,detalle_prnfp as proyecto, codigo_pry_prd_prfup as cod_pry   	    
										  from pre_funcion_programa a, pre_nivel_funcion_programa b   	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =2) pr  	  left join (select ide_prfup ,pre_ide_prfup,codigo_prfup as codigo_programa, codigo_pry_prd_prfup as cod_prog,  	    detalle_prfup as detalle_programa,detalle_prnfp as programa 
										  from pre_funcion_programa a, pre_nivel_funcion_programa b   	    where a.ide_prnfp = b.ide_prnfp and b.nivel_prnfp =1) g on pr.pre_ide_prfup = g.ide_prfup) pry2 on e.pre_ide_prfup = pry2.ide_prfup  ) a ) f  on a.ide_prfup = f.ide_prfup    left join (select sum(valor_financiamiento_prpof) as codificado, ide_prpoa, pf.ide_prfuf,codigo_fuente_prfuf,detalle_prfuf 
										  from pre_poa_financiamiento  pf       join pre_fuente_financiamiento ff on ff.ide_prfuf=pf.ide_prfuf      group by ide_prpoa, pf.ide_prfuf,codigo_fuente_prfuf,detalle_prfuf) pf on a.ide_prpoa = pf.ide_prpoa      left join (select sum(valor_reformado_prprf) as reforma, ide_prpoa, ide_prfuf 
										  from pre_poa_reforma_fuente  rf     where fecha_prprf between '2025-01-01' and  '2025-03-17' group by ide_prpoa,ide_prfuf) rf on a.ide_prpoa = rf.ide_prpoa and pf.ide_prfuf=rf.ide_prfuf     left join ( select sum(coalesce(dlc.valor_certificado_prdcl,dc.valor_certificado_prpoc)) as certificado,dc.ide_prpoa,dc.ide_prfuf 
										  from pre_certificacion c   	join pre_poa_certificacion dc on dc.ide_prcer=c.ide_prcer  	left join (select lc.ide_prcer,lc.fecha_prlce,dlc.ide_prpoa,dlc.ide_prfuf,valor_certificado_prdcl,valor_liquidado_prdcl   			
																																			   from pre_liquida_certificacion lc  			join pre_detalle_liquida_certif dlc on dlc.ide_prlce=lc.ide_prlce  			where fecha_prlce > '2025-03-17') dlc on dlc.ide_prcer=c.ide_prcer and dlc.ide_prpoa=dc.ide_prpoa and dlc.ide_prfuf=dc.ide_prfuf	  	where fecha_prcer between '2025-01-01' and '2025-03-17'  	group by dc.ide_prpoa,dc.ide_prfuf ) h on a.ide_prpoa = h.ide_prpoa and pf.ide_prfuf=h.ide_prfuf   left join (select sum(dc.valor_liquidado_prdcl) as liquidado, dc.ide_prpoa, dc.ide_prfuf 
																																			   from pre_detalle_liquida_certif dc, pre_liquida_certificacion c where c.ide_prlce=dc.ide_prlce and fecha_prlce between '2025-01-01' and  '2025-03-17' group by dc.ide_prpoa,dc.ide_prfuf) lq on a.ide_prpoa = lq.ide_prpoa and pf.ide_prfuf=lq.ide_prfuf   left join ( select sum(coalesce(dlc.valor_comprometido_prdlc,dc.comprometido_prpot)) as comprometido,dc.ide_prpoa,dc.ide_prfuf  	
																																			   from pre_tramite c   	left join pre_poa_tramite dc on dc.ide_prtra=c.ide_prtra  	left join (select lc.ide_prtra,lc.fecha_prlic,dlc.ide_prpoa,dlc.ide_prfuf,valor_comprometido_prdlc,valor_liberado_prdlc    			
																																			   from pre_libera_compromiso lc   			join pre_detalle_libera_compro dlc on dlc.ide_prlic=lc.ide_prlic   			where fecha_prlic > '2025-03-17') dlc on dlc.ide_prtra=c.ide_prtra and dlc.ide_prpoa=dc.ide_prpoa and dlc.ide_prfuf=dc.ide_prfuf	  	where fecha_tramite_prtra between '2025-01-01' and '2025-03-17'  	group by dc.ide_prpoa,dc.ide_prfuf ) i on a.ide_prpoa = i.ide_prpoa and pf.ide_prfuf=i.ide_prfuf   left join (select sum(dc.valor_liberado_prdlc) as liberado,dc.ide_prpoa,dc.ide_prfuf from pre_detalle_libera_compro dc, pre_libera_compromiso c where c.ide_prlic=dc.ide_prlic and fecha_prlic between '2025-01-01' and  '2025-03-17' group by dc.ide_prpoa,dc.ide_prfuf ) lb on a.ide_prpoa = lb.ide_prpoa and pf.ide_prfuf=lb.ide_prfuf    left join (select distinct sum(devengado_prmen) as devengado, ide_prpoa, pm.ide_prfuf 
																																			   from pre_mensual pm join pre_anual pa on pa.ide_pranu=pm.ide_pranu     where ide_prpoa>0 and abs(devengado_prmen)>0 and fecha_ejecucion_prmen between '2025-01-01' and  '2025-03-17' group by ide_prpoa,pm.ide_prfuf) dv on a.ide_prpoa = dv.ide_prpoa and pf.ide_prfuf=dv.ide_prfuf    left join (select distinct sum(pagado_prmen) as pagado, ide_prpoa, pm.ide_prfuf 
																																			   from pre_mensual pm join pre_anual pa on pa.ide_pranu=pm.ide_pranu     where ide_prpoa>0 and abs(pagado_prmen)>0 and fecha_ejecucion_prmen between '2025-01-01' and  '2025-03-17' group by ide_prpoa,pm.ide_prfuf) pg on a.ide_prpoa = pg.ide_prpoa and pf.ide_prfuf=pg.ide_prfuf   left join (select distinct cast(sum(valor_iva) as numeric(8,2)) as valor_iva, ide_prpoa,pm.ide_prfuf    
																																			   from pre_mensual pm    join pre_anual pa on pa.ide_pranu=pm.ide_pranu    join (select ide_tecpo,sum(coalesce(valor_iva_adfac,0)) as valor_iva 
																																			   from adq_factura afac where afac.ide_srsuc=1 group by ide_tecpo) afac on afac.ide_tecpo=pm.ide_tecpo  where ide_prpoa>0 and fecha_ejecucion_prmen between '2025-01-01' and  '2025-03-17' group by ide_prpoa,pm.ide_prfuf) ivc on a.ide_prpoa = ivc.ide_prpoa and pf.ide_prfuf=ivc.ide_prfuf    where a.ide_geani = (select ide_geani from gen_anio where detalle_geani = cast(extract(year from DATE '2025-03-17') as varchar)) ) ejec   order by ide_prpoa,periodo, detalle_geani,detalle_programa,cod_pry,detalle_proyecto,cod_prod,detalle_producto,codigo_subactividad,detalle_subactividad,codigo_fuente_prfuf, fuente,   codigo_clasificador_prcla, descripcion_clasificador_prcla