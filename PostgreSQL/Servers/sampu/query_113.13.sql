


--select  dmovi3.ide_comov AS "dmovi3.ide_comov", mov.ide_comov AS " mov.ide_comov",  dmovi3.ide_gelua AS "dmovi3.ide_gelua" , dmovi.ide_gelua as "dmovi.ide_gelua"

select  dmovi3.ide_comov AS "dmovi3.ide_comov", mov.ide_comov AS " mov.ide_comov",  dmovi3.ide_gelua AS "dmovi3.ide_gelua" , dmovi.ide_gelua as "dmovi.ide_gelua"
			/*extract(month from mov.mov_fecha_comov) as periodo,
         (select identificacion_empr from sis_empresa) as rucEntidad, 
					coalesce( (select split_part(dmovi.cue_codigo_cocac,'.',1)||'.'||split_part(dmovi.cue_codigo_cocac,'.',2)||'.00'),'113.13.00') as cta_mayor_pagar_cobrar,
            dmovi.debe_codem as flujo_deudor,
            dmovi.haber_codem as flujo_acreedor,
            coalesce((case when cp.ide_geedp is null then prov.ruc_tepro else emp.ruc_emp end),'9999999999999') as ruc,
            coalesce((case when cp.ide_geedp is null then prov.nombre_tepro else emp.NOMBRES end),'VARIOS CLIENTES') as nombre_tepro,
            (case when coalesce(devengado_prmen,0) >0 then dmovi.codigo_clasificador_prcla else ''  end) as codigo_clasificador_prcla,
            (case when coalesce(devengado_prmen,0)>0 then coalesce(dmovi3.cue_codigo_cocac,coalesce(dmovii.cue_codigo_cocac,'111.06.00')) else '623.01.00' end) as cta_mayor_gasto_i,
            coalesce(dmovii.haber_codem,coalesce(dmovi.haber_codem,0)) as flujo_deudor2,
            coalesce(devengado_prmen,0) as flujo_acreedor2, coalesce(cast(comprobante_egreso_tecpo as bigint),mov.ide_comov) as nro_transaccion,
            coalesce(cast(comprobante_egreso_tecpo as bigint),mov.ide_comov) as nro_referenci,
            cast('2025-11-01' as character(25)) as fecha_apro,
            cast('2025-11-30' as character(25)) as fecha_venc*/
						
     from cont_movimiento mov
     left join tes_comprobante_pago cp on cp.ide_tecpo=mov.ide_tecpo    
     join
         ( select dmov.ide_comov,
                 ide_gelua,
                 cue_codigo_cocac,
                 dmov.debe_codem,
                 dmov.haber_codem,
                 codigo_clasificador_prcla,
                 devengado_prmen
								from cont_detalle_movimiento dmov
								join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac
								and  cue_codigo_cocac like '113.13%'
								left join
													(
															select ide_codem, pcl.codigo_clasificador_prcla, sum(cobrado_prmen) as devengado_prmen
															 from pre_mensual pmes
															 left join pre_anual panio on panio.ide_pranu=pmes.ide_pranu
															 left join pre_clasificador pcl on pcl.ide_prcla=panio.ide_prcla
															 where coalesce(ide_codem,0)>0
															 group by ide_codem, pcl.codigo_clasificador_prcla
																		
													) pmesi on pmesi.ide_codem=dmov.ide_codem	where sigef_cocac=true and nivel_cocac>=4							
							
							 ) dmovi on dmovi.ide_comov=mov.ide_comov
     left join
         ( 
				 
					 select dmov.ide_comov, ide_gelua,
									 (case when length(cue_codigo_cocac)>10 then substring(cue_codigo_cocac from 0 for 10) else cue_codigo_cocac end) as cue_codigo_cocac
						from cont_detalle_movimiento dmov
						join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac
						and (cue_codigo_cocac like '113.13%')
						where coalesce(debe_codem,0)>0
						
					) dmovi3 on dmovi3.ide_comov=mov.ide_comov and dmovi3.ide_gelua=dmovi.ide_gelua
					
     left join
						 (
						 
						 select dmov.ide_comov,
										 ide_gelua,
										 cue_codigo_cocac,
										 dmov.debe_codem,
										 dmov.haber_codem
							from cont_detalle_movimiento dmov
							join cont_catalogo_cuenta cat on cat.ide_cocac=dmov.ide_cocac and (cue_codigo_cocac like '623%')
							
					) dmovii on dmovii.ide_comov=mov.ide_comov and dmovii.ide_gelua=dmovi.ide_gelua
					
										
					where mov.mov_fecha_comov between '2025-11-01' and '2025-11-30' 
					AND mov.ide_comov = 12812;
			



					
					
					
					
					
					
					