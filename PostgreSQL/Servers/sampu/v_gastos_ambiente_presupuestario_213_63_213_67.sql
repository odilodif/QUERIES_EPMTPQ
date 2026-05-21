--DROP VIEW v_gastos_ambiente_presupuestario_213_63_213_67
CREATE VIEW v_gastos_ambiente_presupuestario_213_63_213_67 AS
SELECT prestr.ide_comov,
	prestr.ide_gelua,
	prestr.cue_codigo_cocac,
	sum(prestr.debe_codem) as debe_codem,
	prestr.codigo_clasificador_prcla::VARCHAR,
	sum(prestr.devengado_prmen) as devengado_prmen
FROM
				( SELECT dmov.ide_comov,
						ide_gelua,
						(case
											when length(cue_codigo_cocac) > 10 then substring(cue_codigo_cocac
																																																													from 0
																																																													for 10)
											else cue_codigo_cocac
							end) as cue_codigo_cocac,
						dmov.debe_codem,
						dmov.haber_codem,
						codigo_clasificador_prcla,
						coalesce(devengado_prmen, 0) as devengado_prmen
					from cont_detalle_movimiento dmov
					join cont_catalogo_cuenta cat on cat.ide_cocac = dmov.ide_cocac
					and (cue_codigo_cocac like '111%'
										or cue_codigo_cocac like '112%'
										or cue_codigo_cocac like '125%'
										or cue_codigo_cocac like '132%'
										or cue_codigo_cocac like '133%'
										or cue_codigo_cocac like '134%')
					left join
									(select ide_codem,
											codigo_clasificador_prcla,
											sum(devengado_prmen) as devengado_prmen
										from pre_mensual pmes
										left join pre_anual panio on panio.ide_pranu = pmes.ide_pranu
										left join pre_poa poa on poa.ide_prpoa = panio.ide_prpoa
										left join pre_clasificador pcl on pcl.ide_prcla = poa.ide_prcla
										where coalesce(ide_codem, 0) > 0
										group by ide_codem,
											codigo_clasificador_prcla) pmesi on pmesi.ide_codem = dmov.ide_codem
					where codigo_clasificador_prcla is not null ) prestr
GROUP BY prestr.cue_codigo_cocac,
	prestr.ide_comov,
	prestr.ide_gelua,
	prestr.codigo_clasificador_prcla