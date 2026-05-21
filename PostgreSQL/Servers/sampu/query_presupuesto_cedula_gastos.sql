select a.*, certificado - comprometido as saldo_por_comprometer 
					 from ( 
					
					 SELECT poa.ide_prpoa,cla.ide_prcla, fecha_prcer, nro_certificacion_prcer, detalle_prcer, nro_contrato_proceso_prcer,detalle_geare as area, 
					 codigo_clasificador_prcla,descripcion_clasificador_prcla,detalle_programa,detalle_proyecto,detalle_actividad_mc,detalle_subactividad,detalle_prfuf, 
					 sum(coalesce(valor_certificado_prpoc,0)) as certificado, 
					 sum(coalesce(comprometido,0)) as comprometido  
					  FROM pre_certificacion cer 
					 join pre_poa_certificacion cerd on cerd.ide_prcer=cer.ide_prcer 
					 join pre_poa poa on poa.ide_prpoa=cerd.ide_prpoa 
					 join pre_clasificador cla on cla.ide_prcla=poa.ide_prcla 
					 join pre_fuente_financiamiento ff on ff.ide_prfuf=cerd.ide_prfuf 
					 join gen_area area on area.ide_geare=poa.ide_geare  
					 left join ( select comp.ide_prcer,compd.ide_prfuf,compd.ide_prpoa,sum(comprometido_prpot) as comprometido  
												from pre_tramite comp 
												join pre_poa_tramite compd on compd.ide_prtra=comp.ide_prtra  
												group by comp.ide_prcer,compd.ide_prfuf,compd.ide_prpoa 
					          ) comp on comp.ide_prcer=cer.ide_prcer and comp.ide_prpoa = poa.ide_prpoa and comp.ide_prfuf=ff.ide_prfuf 
					
					  left join view_ubicacion_poa upoa on upoa.ide_prfup = poa.ide_prfup   
									
					 where cer.ide_geani= poa.ide_geani
					 group by poa.ide_prpoa,cla.ide_prcla, fecha_prcer, nro_certificacion_prcer, detalle_prcer, nro_contrato_proceso_prcer,detalle_geare, 
					 codigo_clasificador_prcla,descripcion_clasificador_prcla,detalle_programa,detalle_proyecto,detalle_actividad_mc,detalle_subactividad,detalle_prfuf  
					 order by nro_certificacion_prcer, codigo_clasificador_prcla 
					 
					 ) a