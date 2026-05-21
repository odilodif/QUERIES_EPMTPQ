select distinct a.ide_fafac,
                secuencial_fafac/*,
                ruc_comercial_recli,
                razon_social_recli,base_aprobada_fafac,
                valor_iva_fafac,total_fafac, coalesce(valor_cobro,0) as abono,
                estado_f, observacion || ' - ' || coalesce(cliente_pago,' ') as observacion,
                fecha_transaccion_fafac,coalesce(fecha_cobro_facob, fecha_pago_fafac) as fecha_cobro_facob,
                detalle_bogrm,td.detalle_tetid as tipo, coalesce(nro_documento,'') || ' - ' || coalesce(cod_autorizacion,'') as  nro_comp_caja,
                autorizada_sri_fafac as autorizada*/
from ( 
select ide_fafac,secuencial_fafac,ruc_comercial_recli,razon_social_recli,base_aprobada_fafac,valor_iva_fafac,
              (base_aprobada_fafac+valor_iva_fafac) as total_fafac,factura_fisica_fafac,fecha_transaccion_fafac,  detalle_bogrm,fecha_pago_fafac,b.ide_bogrm,c.ide_tetid,autorizada_sri_fafac, coalesce(documento_bancario_fafac,' ') || ' - ' || coalesce(observacion_fafac,' ') as observacion, c.ide_coest, detalle_coest as estado_f
    from fac_datos_factura a, bodt_grupo_material b, fac_factura c, rec_clientes d, cont_estado e
    where a.ide_bogrm = b.ide_bogrm and a.ide_fadaf=c.ide_fadaf and c.ide_recli = d.ide_recli and c.ide_coest=e.ide_coest  	) a
left join tes_tipo_documento td on td.ide_tetid=a.ide_tetid

join (

select ide_fafac,fecha_cobro_facob, sum(coalesce(valor_cobro_facob,0)+coalesce(valor_cobro_iva_facob,0)) as valor_cobro, string_agg(cliente_pago_facob, ', ') as cliente_pago,
                 string_agg(cast(nro_documento_facob as character(25)), ', ') as nro_documento, string_agg(cast(cod_autorizacion_facob as character(25)), ', ') as cod_autorizacion
                          from fac_cobro where ide_facob not in (select ide_facob from cont_factura_asiento where ide_facob>0) 
													and ide_fafac>0 group by ide_fafac,fecha_cobro_facob
													
													
													) fc on fc.ide_fafac = a.ide_fafac
													
--                     where
										-- (
-- 										 (
-- 										 a.ide_tetid=4 
-- 										 and 
-- 										 coalesce(autorizada_sri_fafac,false)=true)
-- 										or (a.ide_tetid=3))  
 -- 										and a.ide_coest in (16,24,30)
--                       and a.ide_bogrm=4 
-- 											and 
-- 											fc.fecha_cobro_facob between '2025-03-18' and '2025-03-18'  
-- 											and coalesce(valor_cobro,0) > 0  
-- 											and 
-- 											extract(year from fecha_transaccion_fafac)  >= 2025 
											order by secuencial_fafac
